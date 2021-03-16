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


<p align="center">
  <img src="/Images/py_Periodogram_SPKR1_STFT.png" width= "800" height ="400" />
  <img src="/Images/py_Periodogram_SPKR1_myfunction.png" width= "800" height ="400" />
</p>


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











