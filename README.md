## Team: Audi-Ding
___
# Speaker Recognition

## Introduction
- 

## Principles of Speaker Recognition
- 

## Test 1: Listening to the Data
After listening to the data that was provided (updated) on 3/14/2021 we established ground truth data by listening to the files provided. It was established that the data tracked in a diagnol pattern. Training Speaker 1 corresponded to Test Speaker 1, 2 to 2, 3 to 3, etc.


| Training Speaker | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |
|------------------|---|---|---|---|---|---|---|---|---|----|----|
| Test Speaker     | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |

## Test 2: Looking at the Data
<p align="center">
  <img src="/Images/py_Speaker1_Data.png" width= "800" height ="400" />
</p>
Here we can see an example plot of voice signal for speaker 1. We normalized the amplitudes to a max amplitude of 1 for every signal to normalize the signal.
Signals s9 - s11 contain stereo data. In these cases we only kept the first instance when reading in the file. 


## Test 2: Periodograms of the STFT
<p align="center">
  <img src="/Images/py_Periodogram_SPKR1_STFT.png" width= "800" height ="400" />
  <img src="/Images/py_Periodogram_SPKR1_myfunction.png" width= "800" height ="400" />
</p>
The sampling frequency was found to be 12.5 khz for every signal. This means that a 256 sample long frame is 20.5 ms long. The reccomended frame length, N, is anywhere from 20ms to 30 ms. We went ahead with N = 312, which equates to a 25 ms frame length. The frames are chosen to overlap by 60%. 


## Test 3: Filter Banks and Filter Bank Responses
<p align="center">
  <img src="/Images/py_BandPass_FilterBank.png" width= "800" height ="400" />
</p>
<p align="center">
  <img src="/Images/py_FilterBanks_SPKR1.png" width= "800" height ="400" /><br>
</p>


## Test 4: Finding the MFCC Coefficients
<p align="center">
  <img src="/Images/py_MFCC_SPKR1T.png" width= "800" height ="400" />
</p>


## Test 4: Finding the MFCC Coefficients
<p align="center">
  <img src="/Images/py_Clusters1.png" width= "800" height ="400" />
</p>

## Test 5 & 6: Vector Quantization
<p align="center">
  <img src="/Images/py_ColorClusters1.png" width= "800" height ="400" />
</p>

<p align="center">
  <img src="/Images/py_ScatterComparison.png" width= "800" height ="400" />
</p>

## Test 7-9: Full Test And Demonstration
<p align="center">
  <img src="/Images/py_Test_Evaluation.png" width= "800" height ="400" />
  <img src="/Images/py_Test_Evaluation1_Normalized.png" width= "800" height ="400" /><br>
</p>


<p align="center">
  <img src="/Images/py_NoiseAdded.png" width= "800" height ="400" />
</p>

<p align="center">
  <img src="/Images/py_noisy_signals_sloppy.png" width= "800" height ="400" /><br>
</p>

<p align="center">
  <img src="/Images/py_SNR_50_25.png" width= "800" height ="400" /><br>
</p>







