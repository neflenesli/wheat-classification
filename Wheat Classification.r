
wheat <- read.csv("wheat.csv", header = T)
wheat

options(repr.matrix.max.rows=600, repr.matrix.max.cols=200)
is.na(wheat) 
#There are no missing values

summary(wheat)
#The magnitudes and ranges of each column are quite different. Area column has 
#range ~10 whereas compactness column has range ~0.1

library(caret)
train_rows <- createDataPartition(y = wheat$type, p = 0.8, list = F)
training <- wheat[train_rows, ]
testing <- wheat[-train_rows, ]
trctrl <- trainControl(method = "repeatedcv", number=10, repeats = 3)
svm_linear <- train(type ~ ., data = training, method = "svmLinear", trControl = trctrl, preProcess = c("center","scale"))
svm_linear

testing_pred <- predict(svm_linear, newdata = testing)
confusionMatrix(testing_pred, testing$type)
#There's only one false prediction out of 68 rows of data and the accuracy 
#is 97%. The model is pretty accurate in associating 7 attributes with wheat type
#and predicting the wheat type correctly

#classifications on unknown data
unknown <- read.csv("wheat-unknown.csv", header = T)
pred <- predict(svm_linear, newdata = unknown)
print("The predictions for the unknown wheat seeds are as follows, with 91.5% accuracy:")
pred
