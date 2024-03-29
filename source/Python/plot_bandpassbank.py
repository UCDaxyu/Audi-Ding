# -*- coding: utf-8 -*-
"""plot_BandPassBank.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/14WuGXEeN7KE3QASYJJHaPlCcczG3iXcZ
"""

def plot_BandPassBank(band_pass,freq):
  fig, ax1 = plt.subplots(nrows=1,ncols=1,figsize=[10,5])
  for FB in range(len(band_pass)):
    ax1.plot(freq,band_pass[FB],label='Filter'+str(FB))
  ax1.set_title('Band Pass Filter Bank\nMel Scale', weight='bold',fontsize=20,color='black')
  ax1.set_xlabel('Frequency \n Hertz',fontsize=15)
  ax1.set_ylabel('Magnitude',fontsize=15)
  ax1.grid()
  ax1.legend(bbox_to_anchor=(1.05, 1), loc=2)