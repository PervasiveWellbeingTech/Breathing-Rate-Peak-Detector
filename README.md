# Breathing-Rate-Peak-Detector

## Process
Import the experiment data from the bioharness onto the computer. Divide the "Breathing" file (containing the breathing waveform data) previously imported into multiple files based on the number of trials conducted. Edit the Ginput_Findpeaks code to input the correct pilot and trial number as well as the right number of datapoints. After running the code, a graph will appear - on this graph, select the start point and the end point for the data you would like to process with the cursor. After selecting these points, another graph will appear showing the selected data and the processed data. This graph will be saved as a .tiff file automatically, and the data will be saved as *.mat file. Then use the br_data_boxlplot_rg.m code appropriately to plot.


## Dependencies
Relies on Matlab2019b and uses standard packages. Both the  FindPeaks code and the tight subplot code need to be in the same folder to be able to plot the graphs.
