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
# Our Project

[![Speaker Recognition Presentation](https://img.youtube.com/vi/KjJYcQYxU4I/0.jpg)](https://www.youtube.com/watch?v=KjJYcQYxU4I) 

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

## Test 1: Listening to the Data
After listening to the data that was provided (updated) on 3/14/2021 we established ground truth data by listening to the files provided. It was established that the data tracked in a diagnol pattern. Training Speaker 1 corresponded to Test Speaker 1, 2 to 2, 3 to 3, etc.


| Training Speaker | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |
|------------------|---|---|---|---|---|---|---|---|---|----|----|
| Test Speaker     | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |

## Test 2: Looking at the Data
<p align="center">
    <img src="/Images/py_Speaker1_Data.png" width= "800" height ="400" />
</p>


The first step in this sequence is to gather your desired audio signals. For our testing we gathered 11 training .wav files and broke them down into their time, sample rate and data point components. Using this information we broke our continuous speech signal down into framed blocks that were 25mS long each having a 60% overlap.

One thing that gave us some issues at first was analyzing stereo signals. In order to compare signals appropriately we evaluated whether a signal was stereophonic or monophonic and ensured we only took a monophonic component of each signal. Our original data set identified 3 signals as stereo signals.


## Test 2: Periodograms of the STFT
<p align="center">
  <img src="/Images/py_Periodogram_SPKR1_STFT.png" width= "800" height ="400" />
  <img src="/Images/py_Periodogram_SPKR1_myfunction.png" width= "800" height ="400" />
</p>


<p align="center">
  <img src="/Images/py_PSD_own.png" width= "800" height ="400" />
</p>

The sampling frequency was found to be 12.5 khz for every signal. This means that a 256 sample long frame is 20.5 ms long. The reccomended frame length, N, is anywhere from 20ms to 30 ms. We went ahead with N = 312, which equates to a 25 ms frame length. The frames are chosen to overlap by 60%. 

The figure above is the periodogram after taking the short time fourier transfrom(STFT). This plot visualizes both how the power of the signal is distributed over the frequency spectrum and how the that power shifts across time. We can see that the majority of the signal is contained in frequencies less than 4.5khz.


## Test 3: Filter Banks and Filter Bank Responses

<p align="center">
   <img src="/Images/py_BandPass_FilterBank.png") />
</p>

Once we have the STFT of our signals, we want to reduce the amount of data we have while also emphasizing the critical frequencies common to human voices. To do this, we utilize a set of triangular filter banks linearly linearly spaced out on the **mel frequency scale**. The mel scale can be defined as such:

<p align="center">
  <img src="/Images/melscale.png" width= "200" height ="100" />
</p>
The scale by centering our filterbanks on the melscale we naturally emphasize lower frequencies where the majority of human voices tend to fall under while de-emphasizing higher frequency ranges.


<p align="center">
  <img src="/Images/Spectrogram.gif" width= "800" height ="400" />
</p>
We apply the filterbanks to our STFT. To motivate this, we can observe the FFT of each time frame from the spectrogram. With the fft, we have much higher resolution in our spectrum than we arguably need. Going through each time frame in this animation, we can see major changes that occur that are masked by alot of "noise". Therefore, we apply the filterbanks as a dimensionality reduction technique to better focus our data.

<p align="center">
  <img src="/Images/Mat_Spectrogram.png" width= "800" height ="400" />
</p>

So lets compare the spectrograms of speaker 1 before and after the filterbanks are applied. The left side is a plot of the normal spectrogram. On the right is the resulting spectrogram when our spectrum has been quantized by 20 filter banks. Quantizing the spectrum reduced the representation of our signal to simply 12 points per frame as opposed to the 512 fft points. This is all done while sitll preserving the general shape of each speaker's frequency spectrum across time.



## Test 4: Finding the MFCC Coefficients
<p align="center">
  <img src="/Images/py_MFCC_SPKR1T.png" width= "800" height ="400" />
</p>
With all filter banks calculated, we can now find the Mel Frequency Cepstral Coeefficients(MFCCs) by summing the values in each filter bank and taking the natural log. To seperate the coefficients, we apply a discrete consine transform to the sums. The above figure is an example color plot of the MFCC values for speaker 1. We can see how they change over time.

## Test 5 & 6: Vector Quantization 

We used the LBG algorithm for vector quantization. 

1. First, we found a the centroid of all data points with in a given set and 
2. Then, we split the centroid in two according to a splitting coefficient (1+epsilon) and (1-epsilon). 
3. Next, each point within the set was clustered around the nearest centroid through the euclidean distance formula. 
4. The total distortion was found by summing the distortion of each point to its closest centroid. 
5. We compare this new distortion to the distortion of the old positions with the following rule:
  1. If the difference in distortion relative to the new distortion is greater than 1% go back to step 3
  2. If the difference is less than 1%, we assume we have found optimal cluster configurations
6. Go back to step 2 until we have the desired number of clusters

The choice of clusters is up to us. The current design limits our number of clusters to powers of 2. The number of clusters needs to provide enough specificity so as to unique identify each speaker but also be broad enough to reduce the risk of overfitting our data. From our testing 8 to 16 centroids seemed to optimize our results. The rest of tests will utilize 8 clusters to relieve any issue of overfitting our model to the training data while still providing good performance.


<p align="center">
  <img src="/Images/pretty_clusters.png" width= "800" height ="400" />
</p>


<p align="center">
  <img src="/Images/Clustering.gif" width= "400" height ="400" />
</p>
Understanding the clustering algorithm was a major challenge for our team. As a way to demonstrate our understanding, we created this animation detailing the steps to cluster and generate a codebook for a given speaker. The animation steps through the process of splitting the clusters and repositioning the centroids to the center of each new cluster. 

Please note that the drawn lines indicate cluster regions **only if your data is exactly two dimensional.** They are not representative of clusters in higher dimensions like our MFCCs(12 dimensions). But we still believe this provides a useful visual demonstration that explains what is happening. The function to make this animation is provided in the Matlab folder.

## Test 7-9: Full Test And Demonstration
For the full test demonstration we first sampled the 11 training samples and 11 test samples provided to us. The test cases matched very well with the training cases and are shown in the figure below. It is imortant to note that although we were originally comparing the exact same signals against eachother there was still distortion. This was because we calculated distortion by finding the Euclidian distance between each point and its nearest cenetroid.

<p align="center">
  <img src="/Images/py_Test_Evaluation.png" width= "800" height ="400" />
</p>

<p align="center">
  <img src="/Images/py_og_results.png" />
</p>


It was noted; however, that originally there were only 8 test sets and 11 training sets. Speakers 9,10,11 did not match well with any of the other 8 speakers. For this reason it was necessary to establish a threshold for distortion. Because our distortion calculations always resulted in 'an answer' we had to say that beyond a certain distortion level (both relative and absolute) we could not guarntee a good match.


<p align="center">
  <img src="/Images/cant_tell_8_11.png" width= "800" height ="400" />
</p>

<p align="center">
  <img src="/Images/cant_tell_8_11_text.png"  />
</p>

Here you can see our program correctly identified 8 of the test speakers and for the remaining three identified there was very little confidence between trainers. We found the marginal similarity between a speaker and trainer by finding the trainer with the lowest total distortion and comparing it with the trainer with the next least distortion. Speakers 9-11 had between 0-3% margin. For tests we set a minimum margin of 20%.

Further testing was performed by recording our own voices for multiple training and test sets. All of our own recorded samples matched well. 

In order to test the robustness of our program we applied white gaussian noise to our signal with various different signal to noise ratios. This is displayed for speaker one and it is seen that there is a decending liklihood of match as the signal to noise ratio lowers.


<p align="center">
  <img src="/Images/py_noisy_signals.png"/><br>
</p>

<p align="center">
  <img src="/Images/noisy_results.png"/><br>
</p>

<p align="center">
  <img src="/Images/noisy_text_results.png"  width= "800" height ="100"/><br>
</p>

The plot’s you see above include SNR’s of 40,25,15, and 5 respectively. For each, our program correctly identified the trainer-speaker combo; however, for the SNR of 5 our program failed to identify the trainer with a sufficiently higher relative confidence. This is clearly illustrated through our color map. As you can see for the fourth column the relative difference between trainer 1, 7, and 9 is very low.

The robustness of our design is further tested through the use of band notch filters removing certain frequencies throughout our signal. For our implementation we used scipy.signal.iirnotch as well as the iirnotch() for matlab.

## Test 9: Using Other Data Sets

<p align="center">
  <img src="/Images/Mat_free_spoken_results.png" width= "800" height ="400" />
</p>
With the success in our recognition model on the provided data, we wanted to extend our model to other datasets found online. The [Free-Spoken-Digit Dataset](https://github.com/Jakobovski/free-spoken-digit-dataset) was chosen for its similarity to our original data set. There are 6 speakers each saying 'zero' 50 times. The documentation indicates that the first five samples are the test set and the other 45 are for the test set. We adopt this in our analysis of the data as well.  

The distortion matrix above shows the results of our model. The test files are referenced in the horizontal axis and the training models are on the vertical axis. Looking at the data, we can see that the first five test columns have the least relative distortion when compared to the first 45 training models and high relative distortion for the remaining 180 models. This same trend is seen for the next 5 test samples anf 45 training models and so on. This is 100% consistent with the ground truth. Every test sample has been correctly identified by the correct speaker and every training model is closely identifies with their original speaker. 

## Test 8: Applying Notch Filters 
<p align="center">
  <img src="/Images/Mat_notches.png" width= "800" height ="400" />
</p>
Adding noise was the first way to test for robustness. Another way to test the robustness  is to retest the data with frequency bands removed. From the spectrograms in test 3, we saw very distinct frequencies show up for all speakers. We can apply a notch filter like the ones shown above to remove some of those critical frequencies and see if we can still get a match. We applied one of these filters to the STFT and noted the changes in relative distortion. Testing each filter, we found that our model continued to consistently identify the speaker with our set distortion margin on 20% or higher.  

<p align="center">
  <img src="/Images/Mat_free_spoken_results_notched.png" width= "800" height ="400" />
</p>
With our model throuroughly withstanding a single notch, we thought it would be fun to test the effects of applying every notch filter at the same time. The plot above is the same free-spoken dataset with 13 notch filters applied. We can see along a few columns that the classfications begin to break down. Namely, test samples 16-20 begin to strongly match with a secondary speaker. To a lesser degree, we can see that test samples  6-10 also begin matching with a secondary speaker as well. That being said, it's still amazing to see the majority of the classfications holding strong.


## Running The Python Code

#### Step 1 ####
Define the number of test files you want to run
initiate loop for number of test files stored in central location (runs in ascending order)
read the .wav files
remove 'stereo' signals if present by selecting first in the array
pre-emphasize the signals 
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

https://colab.research.google.com/drive/1qBeKrqYebtBMqKyBH-P6t9xjwLoUgOK8?usp=sharing


## Running the Matlab Code
All of the scripts immediately found in the Matlab folder are ready to run. The primary script is Main.m that asks for the path to your test and training data in seperate folders. Secondary helper files are found in the functions folder.


## References

[1] L.R. Rabiner and B.H. Juang, Fundamentals of Speech Recognition, Prentice-Hall, Englewood Cliffs, N.J., 1993.

[2] L.R Rabiner and R.W. Schafer, Digital Processing of Speech Signals, Prentice-Hall, Englewood Cliffs, N.J., 1978.

[3] S.B. Davis and P. Mermelstein, “Comparison of parametric representations for monosyllabic word recognition in continuously spoken sentences”, IEEE Transactions on Acoustics, 
Speech, Signal Processing, Vol. ASSP-28, No. 4, August 1980.

[4] Y. Linde, A. Buzo & R. Gray, “An algorithm for vector quantizer design”, IEEE Transactions on Communications, Vol. 28, pp.84-95, 1980.

[5] S. Furui, “Speaker independent isolated word recognition using dynamic features of speech spectrum”, IEEE Transactions on Acoustic, Speech, Signal Processing, Vol. ASSP-34, No. 1, pp. 52-59, February 1986.

[6] S. Furui, “An overview of speaker recognition technology”, ESCA Workshop on Automatic Speaker Recognition, Identification and Verification, pp. 1-9, 1994.

[7] F.K. Song, A.E. Rosenberg and B.H. Juang, “A vector quantisation approach to speaker recognition”, AT&T Technical Journal, Vol. 66-2, pp. 14-26, March 1987.

[8]Frequently Asked Questions WWW site, http://svr-www.eng.cam.ac.uk/comp.speech/

[9] Speech Processing for Machine Learning: Filter banks, Mel-Frequency Cepstral Coefficients (MFCCs) and What's In-Between WWW site (https://haythamfayek.com/2016/04/21/speech-processing-for-machine-learning.html)


