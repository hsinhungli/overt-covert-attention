This repository contains data described in the manuscript

HH Li, J Pan, M Carrasco (2021) Different computations underlie overt and covert spatial attention. Nature Human Behaviour

It also contains functions for simulating the behavioral responses, fitting the models and visualizing the model fits.

## Folders

### Data: This folder contains data that are included in the presaccadic time window being analyzed.
### Saccade condition in Expeirment 2 are 3 are combined as they represent three levels of location uncertainty
### mdata: The folder where results of model fits of individual subjects are saved. The files include best-fitted parameters stored in estX.
### plotdata: Behavioral performance simulated by the best-fit parameters. These results are saved for plotting group-averaged model fits
### Simulate_Neural_Response: The code used to simualte population neural response and predict behavioral performacne (d'). 
The code is adpated from the following two papers:
JH Reynolds, DJ Heeger (2009) The normalization model of attention - Neuron
HH Li, M Carrasco, DJ Heeger (2015) Deconstructing interocular suppression: Attention and divisive normalization - PLoS Comput Biol

###UpConv: To simulate population neural response, the code requires upConv functions from Eero Simoncelli's steerable pyramid toolbox matlabPyrTools
This fold contains some pre-complied files. If the files don't work, try download the updated version
https://github.com/LabForComputationalVision/matlabPyrTools/

## functions
### fitModel_singleTrial: the functions for fitting models to the data
### runModel_singleTrial: the function that estimates d prime and model's negative loglikelihood based on the input free parameters
### plot_modeFit_individual: this script plots individual data and model fits saccade conditions in Experient 2 and 3 (low, medium and high uncertainty)
### plot_modeFit_group: if model fits of individual subjects are saved in floder 'plotdata', this script can be used to plot group-averaged data and model fit
