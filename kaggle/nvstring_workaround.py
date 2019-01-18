import pandas as pd
import cudf as gd
import numpy as np
from collections import OrderedDict,Counter
import re
from librmm_cffi import librmm
import nvstrings
from cudf_workaround import cudf_groupby_aggs,drop_duplicates

def on_gpu(words,func,dtype=np.int32):
    res = librmm.device_array(words.size(), dtype=dtype)
    cmd = 'words.%s(res.device_ctypes_pointer.value)'%(func)
    eval(cmd)
    return res

def get_unique_tokens(words,words_hash=None):
    df = gd.DataFrame()
    df['hash'] = on_gpu(words,'hash') if words_hash is None else words_hash
    df['ID'] = np.arange(words.size()).astype(np.int32)
    df = drop_duplicates(df,by='hash',keep='first')
    rows = df['ID'].to_array()#.astype(np.int32)
    res = words.sublist(rows.tolist()) 
    del df
    return res

def get_token_counts(words,words_hash=None):
    df = gd.DataFrame()
    df['hash'] = on_gpu(words,'hash') if words_hash is None else words_hash
    df['ID'] = np.arange(words.size()).astype(np.int32)
    dg = df.groupby('hash').agg({'hash':'count'})
    df = drop_duplicates(df,by='hash',keep='first')
    df = df.merge(dg,on=['hash'],how='left')
    rows = df['ID'].to_array()#.astype(np.int32)
    res = words.sublist(rows.tolist()).to_host()
    #res = pd.DataFrame({'tokens':res,'count':df['count_hash'].to_array()})
    res = dict(zip(res,df['count_hash'].to_array().tolist()))
    #del df
    return Counter(res)

def is_in(w1,w2):
    if isinstance(w1,nvstrings.nvstrings):
        w1 = get_token_counts(w1)
        w2 = get_token_counts(w2)
    res = 0
    for i in w1:
        if w1[i]>0 and w2[i]>0:
            res += w1[i]
    return res*1.0/sum([j for i,j in w1.items()])
 
