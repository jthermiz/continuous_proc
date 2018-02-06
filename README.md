# Continuous Processing Library
A set of functions for processing continuous data. These functions operate on data structure which contains continuous multi-channel time series and associated meta data. The structure has the following fields:

- D.data = channels x samples of continuous data
- D.time = 1 x samples of time stamps
- D.idx = 1 x channels of channel numbers
- D.imp = 1 x channels of impedances values
- D.fs = scalar sample rate

## Installation
Download this library and add the folder along with the sub-folders to your Matlab path.

## Function Descriptions

`analytical_amp` : Computes the analytical amplitude of the signals 
`cont_filt` : Performs high, low, band-pass or band-stop filtering using forward-backward 6th order Butterworth filter
`cont_kwd` : Loads a kwd file into the continuous data structure
`cs_simple` : Selects subset of channels
`grab_data3`: Import_data helper function
`import_data` : Imports a list of chosen RHD files into a continuous structure
`my_Decimate` : Decimates signals
`read_Intan_RHD2000_file` : read a single RHD file and return a continuous structure
`time_select` : Selects a sub-set of data by on a time window





