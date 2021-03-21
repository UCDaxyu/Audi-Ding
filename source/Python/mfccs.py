# -*- coding: utf-8 -*-
"""mfccs.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1x6C0E3MHxD4TGIQb-40bghs6OQjNSsaj
"""

def find_mfccs(myBanks,num_ceps):
  mfccs = {}
  for signal in range(len(myBanks)):
    mfccs[signal] = dct(myBanks[signal], type=2, axis=1, norm='ortho')[:, 1 : (num_ceps + 1)] # Keep 2-13
    mfccs[signal] = whiten(mfccs[signal]) 
  return(mfccs)