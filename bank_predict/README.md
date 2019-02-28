
# 「二分类算法」提供银行精准营销解决方案 | 练习赛
> ref: [kesci](https://www.kesci.com/home/competition/5c234c6626ba91002bfdfdd3/content)

### 引入数据 & 标签化


```python
import pandas as pd
df = pd.DataFrame(pd.read_csv('~/PycharmProjects/bank/train_set.csv',sep=',',header=0))
# columns = df.columns.values
# trainX = df.iloc[0:, 1:-1]
trainX = df.iloc[:, 1:-1]  # 去除ID, y
trainX = trainX.drop(['day','month'], axis=1)
trainY = df['y']

testDf = pd.DataFrame(pd.read_csv('~/PycharmProjects/bank/test_set.csv',sep=',',header=0))
testX = testDf.iloc[:, 1:]
testID = testDf.iloc[:, 0]
testX = testX.drop(['day','month'],axis=1)

def labelize(columns):
    for col in columns:
        listUniq = trainX.loc[:,col].unique()
        for j in range(len(listUniq)):
            trainX.loc[:,col] = trainX.loc[:,col].apply(lambda x:j if x==listUniq[j] else x)
            testX.loc[:,col] = testX.loc[:,col].apply(lambda x:j if x==listUniq[j] else x)


labelize(['job','marital', 'education','default','housing','loan','poutcome','contact'])
```

### 用线性回归模型


```python
from sklearn import linear_model
regr = linear_model.LinearRegression()
regr.fit(trainX, trainY)

a, b = regr.coef_, regr.intercept_
testY = regr.predict(testX)

regr_y = pd.DataFrame(testY, columns=['pred'])
regr_y.insert(0,'ID',testID)
regr_y.set_index('ID',inplace=True)
```

### 用决策树模型


```python
from sklearn import tree
clf = tree.DecisionTreeClassifier()
clf = clf.fit(trainX, trainY)
testY = clf.predict(testX)
tree_y = pd.DataFrame(testY, columns=['pred'])
tree_y.insert(0,'ID',testID)
tree_y.set_index('ID',inplace=True)
```

### 两个模型取均值


```python
avg_y = pd.DataFrame(testID, columns=['ID'])
avg_y.insert(1,'pred',-1.)
avg_y.set_index('ID',inplace=True)

for i in range(avg_y.index.size):
    avg_y.iloc[i]['pred'] = (regr_y.iloc[i]['pred'] + tree_y.iloc[i]['pred']) * 0.5

avg_y.to_csv('~/PycharmProjects/bank/test_res.csv')
```
