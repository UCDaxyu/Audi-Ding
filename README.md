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

The figure above is the periodogram after taking the short time fourier transfrom(STFT). This plot visualizes both how the power of the signal is distributed over the frequency spectrum and how the that power shifts across time. We can see that the majority of the signal is contained in frequencies less than 4.5khz.

## Test 3: Filter Banks and Filter Bank Responses
<p align="center">
  <img src="/Images/py_BandPass_FilterBank.png" width= "800" height ="400" />
</p>
Once we have the STFT of our signals, we want to reduce the amount of data we have while also emphasizing the critical frequencies common to human voices. To do this, we utilize a set of triangular filter banks linearly spaced out on the mel frequency scale. This scale helps emphasize lower frequencies where the majority of human voices tend to fall under. The mel scale can be defined as such:

<p align="center">
  <img src="/Images/melscale.png" width= "200" height ="100" /><br>
</p>


<p align="center">
  <img src="/Images/py_FilterBanks_SPKR1.png" width= "800" height ="400" /><br>
</p>
Here we plot the resulting filter banks for every time frame of speaker 1. 


## Test 4: Finding the MFCC Coefficients
<p align="center">
  <img src="/Images/py_MFCC_SPKR1T.png" width= "800" height ="400" />
</p>
With all filter banks calculated, we can now find the Mel Frequency Cepstral Coeefficients(MFCCs) by summing the values in each filter bank and taking the natural log. To seperate the coefficients, we apply a discrete consine transform to the sums. The above figure is an example color plot of the MFCC values for speaker 1. We can see how they change over time.

## Test 5 & 6: Vector Quantization 
<p align="center">
  <img src="/Images/py_Clusters1.png" width= "800" height ="400" />
</p>

## Test 5 & 6: Vector Quantization
For vector quantization the LBG algorithm was used. First we found a the centroid of all data points with in a given set and then we split the centroid in two according to a splitting coefficient (1+epsilon) and (1-epsilon). Next each point within the set was clustered around the nearest centroid through the euclidean distance formula. The total distortion was found by summing the distortion of each point to its closest centroid. Each time centroids were split they were repositioned to ensure they were in an area that would cause the least amount of distortion. Once the centroids were repositioned to a sufficeintly good area they would split again. This process continued until the desired amount of centroids was found. From our testing 8 to 16 centroids seemed to optimize our results. 

<p align="center">
  <img src="/Images/py_ColorClusters1.png" width= "800" height ="400" />
</p>

<p align="center">
  <img src="/Images/py_ScatterComparison.png" width= "800" height ="400" />
</p>



<p align="center">
  <img src="/Images/Clustering.gif" width= "400" height ="400" />
</p>
This figure demonstrates the clustering algorithm step by step.

## Test 7-9: Full Test And Demonstration
For the full test demonstration we first sampled the 11 training samples and 11 test samples provided to us. The test cases matched very well with the training cases.
It was noted; however, that originally there were only 8 test sets and 11 training sets. It was noted that speakers 9,10,11 did not match well with any of the other 8 speakers. For this reason it was necessary to establish a threshold for distortion. Because our distortion calculations always resulted in 'an answer' we had to say that beyond a certain distortion level (both relative and absolute) we could not guarntee a good match.

Further testing was performed by recording our own voices for multiple training and test sets. All of our own recorded samples matched well. 

In order to test the robustness of our program we applied white gaussian noise to our signal with various different signal to noise ratios. This is displayed for speaker one and it is seen that there is a decending liklihood of match as the signal to noise ratio lowers.

The robustness of our design is further tested through the use of band notch filters removing certain frequencies throughout our signal. For our implementation we used scipy.signal.iirnotch as well as the iirnotch() for matlab.

Further testing is in progress using outside resources to verify the rate of accuracy for our system. Currently our system has 100% for all tested signals including those distorted in the signal-to-noise region of 25-50dB.

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



#### Step 1 ####
define the number of test files you want to run 
initiate loop for number of test files stored in central location (runs in ascending order)
read the .wav files
remove 'stereo' signals if present by selecting first in the array
pre-emphasize the signals https://haythamfayek.com/2016/04/21/speech-processing-for-machine-learning.html
#### Step 2 ####
Find the windowed frames using MELFB_own() function which takes an input of data (.wav files)
#### Step 3 ####
Find magnitudes and power spectral densities using the MAGPOW function which takes input of the windowed frames previously found
Apply noise to signal if desired based on signal to noise ratio
#### Step 4 ####
Find the melBanks and associated bank of pandpass triangles using melBanks() formula which takes input of power spectrum density previously found
myBanksT = {} # Dictionary of banks for test signals
#### Step 5 ####
define number of desired mfcc coefficeints 
find mfcc's using dct() formula with input of melBanks found in preceeding step
whiten() your mfcc coefficients if you desire to try and improve accuracy
#### Step 6 ####
find the codebook and clustered points using Cent_Finder Function which takes input of mfcc's found in preceeding step
#### Step 7 #### 
use codebooks and clustered points to match signals to training values and determine accuracy




