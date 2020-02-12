import sys, os 

sys.path.append('/usr/local/lib/python3.6/site-packages/')
os.environ['NUMBAPRO_NVVM'] = '/usr/local/cuda/nvvm/lib64/libnvvm.so'
os.environ['NUMBAPRO_LIBDEVICE'] = '/usr/local/cuda/nvvm/libdevice/'

import pynvml

pynvml.nvmlInit()
handle = pynvml.nvmlDeviceGetHandleByIndex(0)
device_name = pynvml.nvmlDeviceGetName(handle)

if (device_name == b'Tesla T4') or (device_name == b'Tesla P100-PCIE-16GB') or (device_name == b'Tesla P4'):
  print('***********************************************************************')
  print('Woo! Your instance has the right kind of GPU, a '+ str(device_name)[1:]+'!')
  print('***********************************************************************')
  print()
else:
  raise Exception("""
    Unfortunately Colab didn't give you a T4, P4, or P100 GPU.
    
    Make sure you've configured Colab to request a GPU instance type.
    
    If you get a K80 GPU, try Runtime -> Reset all runtimes...
  """)
