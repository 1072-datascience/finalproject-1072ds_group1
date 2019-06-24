# Graduate Admission

### Groups Member
* 李柏彥, 107753033
* 劉上銓, 105703030
* 黃子恒, 105703031
* 陳則明, 105703053

### Goal
預測來自印度的 UCLA 研究所申請者被錄取的機率

### Demo 
<!--
You should provide an example commend to reproduce your result
```R
Rscript code/your_script.R --input data/training --output results/performance.tsv
```
-->

* Online visualization Shiny.io 
Here is our demo website link.
[Website](https://zihengh1.shinyapps.io/graduate_admissions/)

## Folder organization and its related information

### docs
* [Presentation](./docs/Group1_presentation.pptx)
* Any related document for the final project
  * [Proposal](./docs/proposal.pdf) -- describe more about the data and visualization
  * [Proposal2](./docs/proposal2.pdf) -- describe text mining process
  * [Proposal3](./docs/proposal3.pdf) -- describe cluster process

### data
* Source : [Kaggle DataSet](https://www.kaggle.com/mohansacharya/graduate-admissions)
* Input format : .csv
* Any preprocessing?
  * Data Normalization
  * Separate into 2 different parts to classify

### code
* Which model do you use?
1. For regression
  * Random Forest Regressor
  * Linear Regression
  * Decision Tree Regressor
  * SVR
  * Ridge Regression
2. For classification
  * SVM
  * Random Forest
  * Decision Tree
  * Gaussian Naive Bayes


<!-- * What is a null model for comparison? -->
* How do your perform evaluation? ie. Cross-validation, or extra separated data
  * split data into 2 part (training 0.7 and testing 0.3)   

### results
* Which metric do you use 
1. For regression
  * RMSE
  * MAE
  * R-square
2. For classification
  * accuracy
  * precision
  * recall
  * f1-score
<!-- * Is your improvement significant?
* What is the challenge part of your project?
  * processing
-->

## Reference
<!--
* Code/implementation which you include/reference (__You should indicate in your presentation if you use code for others. Otherwise, cheating will result in 0 score for final project.__) -->
* Packages you use
  * shiny, ggplot2, corrplot, leaflet, DT, dplyr, ggradar, sklearn, pandas, numpy, matplotlib 
<!-- * Related publications -->


