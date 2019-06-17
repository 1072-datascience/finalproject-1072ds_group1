import pandas as pd
import numpy as np
import sys
## data preprocessing
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler

## regression model
from sklearn.ensemble import RandomForestRegressor

def random_forest(train_X, train_y, test_X):
    model = RandomForestRegressor(n_estimators = 100, random_state = 42)
    model.fit(train_X, train_y)
    predict = model.predict(test_X)
    train_predict = model.predict(train_X)
    print(predict)

def benben(gre = 316.47, toelf = 107.19, university = 3, sop = 3.37, lor = 3.48, cgpa = 8.58, research = 0):
	return np.array([[gre,toelf,university,sop,lor,cgpa,research]])


raw_data = pd.read_csv("/Users/sam/Desktop/UCLA_admissions/colgateDemo/script/Admission_Predict_Ver1.1.csv")
raw_data.set_index('Serial No.', inplace=True)
raw_data.index.name = "No"
raw_data = raw_data.rename(columns = {'Chance of Admit ': 'Chance', \
                                      'GRE Score': 'GRE', \
                                      'TOEFL Score': 'TOEFL', \
                                      'University Rating': 'Rating', \
                                     })
# print(raw_data.head())
Y = raw_data["Chance"].values
X = raw_data.drop(["Chance"],axis=1)
scaler_X = MinMaxScaler(feature_range = (0, 1))
scale_X = scaler_X.fit_transform(X.copy())
input_gre = sys.argv[1]
input_toefl = sys.argv[2]
input_university = sys.argv[3]
input_sop = sys.argv[4]
input_lor = sys.argv[5]
input_cgpa = sys.argv[6]
input_research = sys.argv[7]
test_X = benben(input_gre,input_toefl,input_university,input_sop,input_lor,input_cgpa,input_research)
test_scale_X = scaler_X.transform(test_X.copy())
random_forest(scale_X, Y, test_scale_X)

















