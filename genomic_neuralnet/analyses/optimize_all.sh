#!/bin/bash
source $(which virtualenvwrapper.sh)
workon genomic_sel

# Array of species.
#declare -a SPECIES=(arabidopsis wheat pig maize loblolly)

# Array of species.
declare -a SPECIES=(arabidopsis wheat maize) # Start easy.

echo '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
echo "Beginning Optimization. Time is: $(date)"
echo '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'

# Loop over every optimization function for every species and trait.
# This will populate csv files which store the output of the optimizations.
for file in $( ls optimize*.py ) ; do
    for species in ${SPECIES[@]} ; do
        for trait in $(python $file --species $species --list ) ; do
            echo '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
            echo "INFO: About to train ${file} - ${species} - ${trait}"
            echo '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'

            echo $file | grep 'nn.py' > /dev/null
            if [ $? -eq 0 ] ; then
                # Train neural nets on GPU.
                sleep 10 # Give the GPU time to release memory.
                python $file --species $species --trait $trait --gpu
                sleep 10 # Give the GPU time to release memory.
            else 
                # Train others in normal mode.
                python $file --species $species --trait $trait
            fi

            echo '####################################################'
            echo "Training File Completed. Time is $(date)"
            echo '####################################################'
        done
    done
done
