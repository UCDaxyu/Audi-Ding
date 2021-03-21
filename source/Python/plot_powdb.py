# -*- coding: utf-8 -*-
"""plot_POWdB.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1XpURPiDl23QUXYyBPoIl9R6Je7-Kyofs
"""

def plot_POWdB(POWdB,t,fs):
  X = np.linspace(0,np.shape(POWdB)[0],5)
  Xlab = np.linspace(0,max(t),5)
  Y = np.linspace(0,np.shape(POWdB)[1],5)
  Ylab = np.linspace(0,f_samp/2,5)
  fig1, axs1 = plt.subplots(nrows=1,ncols=1,figsize=[10,5])
  c = axs1.pcolor(np.transpose(POWdB))
  axs1.set_title('Periodogram\nUsing My Own Power Spectral Density', weight='bold',fontsize=20,color='black')
  axs1.set_xticks(X)
  axs1.set_xticklabels(Xlab)
  axs1.set_yticks(Y)
  axs1.set_yticklabels(Ylab)
  plt.xticks(fontsize=15)
  plt.yticks(fontsize=15)
  axs1.set_ylabel('Frequency\n(Hertz)',weight='bold',size=15)
  axs1.set_xlabel('Time\n(Seconds)',weight='bold',size=15)
  fig1.colorbar(c , ax = axs1)