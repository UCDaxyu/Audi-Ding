# -*- coding: utf-8 -*-
"""melBanks.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1IZc-0ESlaov3GC516DwQsT8bpKlcDnmH
"""

def melBanks(POW, num_filt, f_samp, num_FFT=512, Low_Freq=0):
  High_Freq = f_samp/2
  melMin = 1127*np.log(1+Low_Freq/700)
  melMax = 1127*np.log(1+High_Freq/700)
  mel_points = np.linspace(melMin,melMax,num_filt+2) # K+2 because the start and end points are excluded. Spacing refers to the mel points (hz to mels)
  hz_points = 700*(np.exp(mel_points/1125)-1)  # Convert Mel to Hz
  bank_index = np.floor((num_FFT + 1)*hz_points/f_samp) 
  filt_bank = np.zeros((num_filt, int(np.floor(num_FFT/2+1)))) # Sets up a zero matrix (number of cols will be == number of banks == num_filt length of col will be numFFT/2+1
  filter_banks = {}
  for signal in POW:
    for filter in range(1, num_filt + 1):
      # Set up the key points for the triangle (start, center, end)
      filt_start = int(bank_index[filter - 1])  # Left side of triangle
      filt_center = int(bank_index[filter])  # Peak of triangle   
      filt_end = int(bank_index[filter + 1]) # Right Side of triangle
      # fill in the important points for the triangle
      for point in range(filt_start, filt_center):
          filt_bank[filter - 1, point] = 2*(point - bank_index[filter - 1]) / (bank_index[filter] - bank_index[filter - 1])
      for point in range(filt_center, filt_end):
          filt_bank[filter - 1, point] = 2*(bank_index[filter + 1] - point) / (bank_index[filter + 1] - bank_index[filter])

      filter_banks[signal] = np.dot(POW[signal], filt_bank.T)
      filter_banks[signal] = np.where(filter_banks[signal] == 0, np.finfo(float).eps, filter_banks[signal])  # Numerical Stability
      filter_banks[signal] = np.log(filter_banks[signal]) 
      #filter_banks[signal] = 20 * np.log10(filter_banks[signal])  # dB
  return(filt_bank,filter_banks)