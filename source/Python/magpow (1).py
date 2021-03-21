# -*- coding: utf-8 -*-
"""MAGPOW.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1eD25aL2MYYy-l5_0WsTPdTBY3YoPgco5
"""

def MAGPOW(Windowed_Frames,num_FFT=512):
  # Find the magnitude of the one sided FFT
  # Real valued signal so symmetry can be used to find other side
  # Power is 1/number of samples *the square of the signal 
  MAG = {}
  POW = {}
  POWdB = {}
  for signal in range(len(Windowed_Frames)):
    MAG[signal] = np.abs(np.fft.rfft(Windowed_Frames[signal], num_FFT))  # Magnitude of the FFT
    POW[signal] = ((1.0 / num_FFT) * ((MAG[signal]) ** 2))  # Power Spectrum
    POWdB[signal] = 10*np.log10(POW[signal])
  return(MAG,POW,POWdB)