from __future__ import print_function

from genomic_neuralnet.config import SINGLE_CORE_BACKEND, JOBLIB_BACKEND
from genomic_neuralnet.methods import get_net_prediction
from genomic_neuralnet.analyses import run_optimization, HIDDEN, WEIGHT_DECAY, EPOCHS, BATCH_SIZE

from genomic_neuralnet.util import get_is_on_gpu, get_should_plot, get_is_time_stats 

def main():
    params = { 'hidden': HIDDEN 
             , 'weight_decay': WEIGHT_DECAY 
             , 'epochs': (EPOCHS,)
             }

    backend = JOBLIB_BACKEND
    if get_is_on_gpu() or get_should_plot() or get_is_time_stats():
        backend = SINGLE_CORE_BACKEND

    run_optimization(get_net_prediction, params, 'optimal_wdnn.shelf', 'NWD', backend=backend, retry_nans=True)

if __name__ == '__main__':
    main()

