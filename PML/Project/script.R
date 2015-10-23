library(caret)
setwd(".\\PML\\Project")
fileName = "pml-training.csv"
url = "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
if (!file.exists(fileName)) { download.file(url, fileName) }
actDF = read.csv(fileName)

# data slicing
set.seed(123)
inTrain = createDataPartition(actDF$classe, p = 0.6, list = FALSE)
train = actDF[inTrain, ]
inTest = createDataPartition(actDF[-inTrain, ]$classe, p = 0.5, list = FALSE)
test = actDF[-inTrain, ][inTest, ]
valid = actDF[-inTrain, ][-inTest, ]

# drop NA variants
na = integer()
for (i in 1:ncol(train)) {
        ratio = sum(is.na(train[, i])) / nrow(train) 
        if (ratio > 0.5) { na = c(na, i) }
}
train = train[, -c(na)]

# drop empty variants
empty = integer()
for (i in 1:ncol(train)) {
        ratio = sum(train[, i] == "") / nrow(train) 
        if (ratio > 0.50) { empty = c(empty, i) }
}
train = train[, -c(empty)]

# pick accelerometer measurements
forearm = grep("_forearm", names(train))
belt = grep("_belt", names(train))
dumbbell = grep("_dumbbell", names(train))
arm = grep("_arm", names(train))
train = cbind(train[, arm], train[, forearm], train[, belt], train[, dumbbell], classe = train[, "classe"])

# train model
fit.rf    = train(train$classe ~ ., data = train, method = "rf",    preProcess = c("pca", "BoxCox"), trControl = trainControl(method = "cv"))

# predict on test
pred.rf = predict(fit.rf, test)

# confusion matrix on test
cmx.rf = confusionMatrix(pred.rf, test$classe)

# predict on validation
pred.valid.rf = predict(fit.rf, valid)

# confusion matrix on validation
cmx.valid.rf = confusionMatrix(pred.valid.rf, valid$classe)

# plots
summary(train)
table(train$classe)
x = subset(train, select = c(
        roll_arm,      pitch_arm,      yaw_arm,      total_accel_arm,
        roll_forearm,  pitch_forearm,  yaw_forearm,  total_accel_forearm,
        roll_belt,     pitch_belt,     yaw_belt,     total_accel_belt,
        roll_dumbbell, pitch_dumbbell, yaw_dumbbell, total_accel_dumbbell,
        classe))
attach(x)
featurePlot(x[, c("roll_arm", "pitch_arm", "yaw_arm", "total_accel_arm" )], classe, plot = "pairs")
featurePlot(x[, c("roll_forearm", "pitch_forearm", "yaw_forearm", "total_accel_forearm" )], classe, plot = "pairs")
featurePlot(x[, c("roll_belt", "pitch_belt", "yaw_belt", "total_accel_belt" )], classe, plot = "pairs")
featurePlot(x[, c("roll_dumbbell", "pitch_dumbbell", "yaw_dumbbell", "total_accel_dumbbell" )], classe, plot = "pairs")

featurePlot(x[, c("roll_arm", "roll_forearm", "roll_belt", "roll_dumbbell" )], classe, plot = "pairs")
featurePlot(x[, c("pitch_arm", "pitch_forearm", "pitch_belt", "pitch_dumbbell" )], classe, plot = "pairs")
featurePlot(x[, c("yaw_arm", "yaw_forearm", "yaw_belt", "yaw_dumbbell" )], classe, plot = "pairs")
featurePlot(x[, c("total_accel_arm", "total_accel_forearm", "total_accel_belt", "total_accel_dumbbell" )], classe, plot = "pairs")

qplot(scale(roll_arm), col = classe, geom = "density")
qplot(scale(roll_belt), col = classe, geom = "density")
qplot(scale(roll_forearm), col = classe, geom = "density")
qplot(scale(roll_dumbbell), col = classe, geom = "density")
qplot(scale(pitch_arm), col = classe, geom = "density")
qplot(scale(pitch_belt), col = classe, geom = "density")
qplot(scale(pitch_forearm), col = classe, geom = "density")
qplot(scale(pitch_dumbbell), col = classe, geom = "density")
qplot(scale(yaw_arm), col = classe, geom = "density")
qplot(scale(yaw_belt), col = classe, geom = "density")
qplot(scale(yaw_forearm), col = classe, geom = "density")
qplot(scale(yaw_dumbbell), col = classe, geom = "density")
qplot(scale(total_accel_arm), col = classe, geom = "density")
qplot(scale(total_accel_belt), col = classe, geom = "density")
qplot(scale(total_accel_forearm), col = classe, geom = "density")
qplot(scale(total_accel_dumbbell), col = classe, geom = "density")
detach(x)