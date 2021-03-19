## Team: Audi-Ding
#### Authors: Nick Newcomb,  Alex Yu 

<p align="center">
  <img src="/Images/NickBioPic.jpg" width= "400" height ="533" />
  <img src="/Images/AlexBioPic.jpg" width= "400" height ="533" />
</p>
##### Responsibilities:
We worked together throughout all aspects of this project and aided eachother along the way. Alex was predominantly responsible for writing the code in MATLAB while Nick was predominantly responsible for writing the code in Python. This is not to say that either was written exclusively and throughout this project we have relied **heavily** on eachother when we got stuck at different parts.
##### This serves as the report for our speaker recognition project.
___
# Speaker Recognition

## Abstract
This project is used to develop a method to recognize different speakers. A given test signal is compared against a set of training signals in order to determine which signal exhibits the most similar features. Our system uses has shown to be relatively resilient to noise variations and minor changes in speakers. Specifically our system correctly identified signals with 100% accuracy for signal to noise ratios ranging from 25 to 50 as well as being able to identify a given speaker saying the same word differently. For our system we used 25mS frames that ehbited 60% overlap, a 20-filter bandpass fiter-bank, 8 centroids for training signals, and 13 mfcc coefficients (ignoring the first coefficient).

## Introduction
Our project can be simplified into two major categories each consisting of a few major steps. 
### Category 1
The continuous time signals (recorded audio .wav files) are framed into blocked chunks. These frames are determined by specifying the desired size of the frame in mS and specifying the amount of desired overlap. While we experimented with many values we decided to run our final program with frames of 25mS and 60% overlap. Afer the frames are generated a window is applied to taper each side of the frame. For our project we found that the Hamming window seemed to function well. Next we found the fast fourier transform of our windowed signals and combined with a bandpass filterbank using triangle bandpass filters. The bandpass filters used the mel-frequency spectrum and then were used to complete the cepstrum (go back to the time domain).

After developing the MFCC's for each speaker we developed codebooks for each speaker for comparison. In order to develop a codebook we used LBG method, however; similar methods such as k-means can be used as well. Specifically, we first found the centroid for all points within a speakers data set by finding the mean across all dimensions (determined by number of MFCC's). The centroid was then split and the new centroids were reposistioned to optimal locations where they then split again. This process would continue until the desired number of optimal centroids was obtained. For our project we found that 8 centroids was optimal. 

### Category 2
The steps followed for category 1 were followed; however, following the completion of the steps the MFCC's of the test signal were compared to each codebook from the training set. Distortion between the test signal and the training signal was found by finding the Euclidean distance between each data point and it's nearest centroid. The sum of these distances was identified and the training signal with the least distortion was evaluated as the most likely candidate to be a match. 

In order to ensure there are not false positives we impleneted a requirement that the next closest training signal be at least 15% worse than the best represented signal. Additionally we implemented an absolute distortion requirement such that the total distortion must be less than 2.5. 

## Principles of Speaker Recognition
- 

## Test 1: Listening to the Data
After listening to the data that was provided (updated) on 3/14/2021 we established ground truth data by listening to the files provided. It was established that the data tracked in a diagnol pattern. Training Speaker 1 corresponded to Test Speaker 1, 2 to 2, 3 to 3, etc.


| Training Speaker | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |
|------------------|---|---|---|---|---|---|---|---|---|----|----|
| Test Speaker     | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |

## Test 2: Looking at the Data
<p align="center">
  <figure>
    <img src="/Images/py_Speaker1_Data.png" width= "800" height ="400" />
    <figcaption>Figure 1.</figcaption>
  </figure>
</p>
Here we can see an example plot of voice signal for speaker 1. We normalized the amplitudes to a max amplitude of 1 for every signal to normalize the signal.
Signals s9 - s11 contain stereo data. In these cases we only kept the first instance when reading in the file. 


## Test 2: Periodograms of the STFT
<p align="center">
  <img src="/Images/py_Periodogram_SPKR1_STFT.png" width= "800" height ="400" />
  <img src="/Images/py_Periodogram_SPKR1_myfunction.png" width= "800" height ="400" />
</p>

<p align="center">
  <img src="/Images/py_PSD_own.png" width= "800" height ="400" />
  <figcaption>Caption goes here</figcaption>
</p>

The sampling frequency was found to be 12.5 khz for every signal. This means that a 256 sample long frame is 20.5 ms long. The reccomended frame length, N, is anywhere from 20ms to 30 ms. We went ahead with N = 312, which equates to a 25 ms frame length. The frames are chosen to overlap by 60%. 

The figure above is the periodogram after taking the short time fourier transfrom(STFT). This plot visualizes both how the power of the signal is distributed over the frequency spectrum and how the that power shifts across time. We can see that the majority of the signal is contained in frequencies less than 4.5khz.

## Test 3: Filter Banks and Filter Bank Responses
<p align="center">
  <img src="/Images/py_BandPass_FilterBank.png" width= "800" height ="400" />
</p>
![Bandpass Filterbanks](https://github.com/UCDaxyu/Audi-Ding/Images/py_BandPass_FilterBank.png)

Once we have the STFT of our signals, we want to reduce the amount of data we have while also emphasizing the critical frequencies common to human voices. To do this, we utilize a set of triangular filter banks linearly linearly spaced out on the **mel frequency scale**. The mel scale can be defined as such:

<p align="center">
  <img src="/Images/melscale.png" width= "200" height ="100" />
</p>
The scale by centering our filterbanks on the melscale we naturally emphasize lower frequencies where the majority of human voices tend to fall under while demphasizing higher frequency ranges.

<p align="center">
  <img src="/Images/Mat_Spectrogram.png" width= "800" height ="400" />
</p>
In this section, we compare the spectrograms of speaker 1 before and after the filterbanks are applied. On the left is a plot of a normal spectrogram. On the right is the resulting spectrogram when our spectrum has been quantized by 20 filter banks. Quantizing the spectrum helps to reduce the dimensionality of our 


## Test 4: Finding the MFCC Coefficients
<p align="center">
  <img src="/Images/py_MFCC_SPKR1T.png" width= "800" height ="400" />
</p>
With all filter banks calculated, we can now find the Mel Frequency Cepstral Coeefficients(MFCCs) by summing the values in each filter bank and taking the natural log. To seperate the coefficients, we apply a discrete consine transform to the sums. The above figure is an example color plot of the MFCC values for speaker 1. We can see how they change over time.

## Test 5 & 6: Vector Quantization 
<p align="center">
  <img src="/Images/py_Clusters1.png" width= "800" height ="400" />
</p>


We used the LBG algorithm for vector quantization. 

1. First, we found a the centroid of all data points with in a given set and 
2. Then, we split the centroid in two according to a splitting coefficient (1+epsilon) and (1-epsilon). 
3. Next, each point within the set was clustered around the nearest centroid through the euclidean distance formula. 
4. The total distortion was found by summing the distortion of each point to its closest centroid. 
5. We compare this new distortion to the distortion of the old postions with the following rule:
  1. If the difference in distortion relative to the new distortion is greater than 1% go back to step 3
  2. If the difference is less than 1%, we assume we have found optimal cluster configurations
6. Go back to step 2 until we have the desired number of clusters

The choice of clusters is up to us. The current design limits our number of clusters to powers of 2. The number of clusters needs to provide enough specificity so as to unique identify each speaker but also be broad enough to reduce the risk of overfitting our data. From our testing 8 to 16 centroids seemed to optimize our results. The rest of tests will utilize 8 clusters to relieve any issue of overfitting our model to the training data while still providing good performance.


<p align="center">
  <img src="/Images/py_ColorClusters1.png" width= "800" height ="400" />
</p>

<p align="center">
  <img src="/Images/py_ScatterComparison.png" width= "800" height ="400" />
</p>



<p align="center">
  <img src="/Images/Clustering2.gif" width= "400" height ="400" />
</p>
Understanding the clustering algorithm was a major challenge for our team. As a way to demonstrate our understanding, we created this animation detailing the steps to cluster and generate a codebook for a given speaker. The function to make this animation is provided in the Matlab folder. We hope this will be a good visual demonstrations for other DSP students.

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

## Test 8: Applying Notch Filters 
<p align="center">
  <img src="/Images/Mat_notches.png" width= "800" height ="400" />
</p>
Adding noise was the first way to test for robustness. Another way to test the robustness  is too retest the testing data with frequency bands removed. From the spectrograms in test 3, we saw very distinct frequencies show up for all speakers. We can apply a notch filter like the ones shown above to remove some of those critical frequencies and see if we can still get a match. The base frequency for voiced sounds starts roughly at 300 hz while many voiced sounds are found in the 1khz range. 
For fun, we centered the notch frequencies with the peak of each filter bank to produce the most disturbance in our model. 

The effects of notch filters were surprisingly weaker than anticipated. 
## Running The Python Code

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

https://colab.research.google.com/drive/1DL-dh1zrQkTrhxCcWg_n2OzGf3Q1I6zW#revisionId=0B-_tvbV2KtsVVS9MVmxHRXBid0dlZlVpbUh3UmFjeEhXZVM0PQ&scrollTo=f8Vz9-WWEHi-&uniqifier=1




