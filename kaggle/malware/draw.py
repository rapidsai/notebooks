import pandas as pd
import seaborn as sns


def pie_chart(data,tags,title=None,transpose=False,figsize=(16,8)):
    sns.set()
    dic = {}
    values = set()
    for i in data:
        for k in i:
            values.add(k)
    values = list(values)
    for i,tag in zip(data,tags):
        dic[tag] = [i.get(k,0) for k in values]
    df = pd.DataFrame(dic, index=values)
    if transpose:
        df = df.transpose()
    df.plot(kind='pie', subplots=True, figsize=figsize,title=title)

