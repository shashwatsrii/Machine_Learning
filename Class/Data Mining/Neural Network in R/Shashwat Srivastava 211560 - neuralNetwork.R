###############################################################
#                                                             #
#            Neural Network for Classification                #
#                                                             #
###############################################################
#                                                             #
# Credit: Dr.Prashant Singh Rana                             #
# Email : psrana@gmail.com                                    #
# Web   : www.psrana.com                                      #
#                                                             #
###############################################################
#                                                             #
# Train and Test Neural Network for Classification            #
#                                                             #
# This script do the following:                               #
# 1. Load the Data                                            #
# 2. Partition the data into Train/Test set                   #
# 3. Train the Decision Tree Model                            #
# 4. Test                                                     #
# 5. Evaluate on : Accuracy.                                  # 
# 6. Finally Saving the results.                              #
#                                                             #
###############################################################


#--------------------------------------------------------------
# Step 0: Start; Getting the starting time
#--------------------------------------------------------------
cat("\nSTART\n")
startTime = proc.time()[3]
startTime



#--------------------------------------------------------------
# Step 1: Include Library
#--------------------------------------------------------------
cat("\nStep 1: Library Inclusion")
library(nnet)
library(hmeasure)



#--------------------------------------------------------------
# Step 2: Variable Declaration
#--------------------------------------------------------------
cat("\nStep 2: Variable Declaration")
modelName <- "neuralNetwork"
modelName

InputDataFileName="brestCancer.csv"
InputDataFileName

training = 50      # Defining Training Percentage; Testing = 100 - Training



#--------------------------------------------------------------
# Step 3: Data Loading
#--------------------------------------------------------------
cat("\nStep 3: Data Loading")
dataset <- read.csv(InputDataFileName)      # Read the datafile
dataset <- dataset[sample(nrow(dataset)),]  # Shuffle the data row wise.

head(dataset)   # Show Top 6 records
nrow(dataset)   # Show number of records
names(dataset)  # Show fields names or columns names



#--------------------------------------------------------------
# Step 4: Count total number of observations/rows.
#--------------------------------------------------------------
cat("\nStep 4: Counting dataset")
totalDataset <- nrow(dataset)
totalDataset



#--------------------------------------------------------------
# Step 5: Choose Target variable
#--------------------------------------------------------------
cat("\nStep 5: Choose Target Variable")
target  <- names(dataset)[10]   # i.e. Cancer
target



#--------------------------------------------------------------
# Step 6: Choose inputs Variables
#--------------------------------------------------------------
cat("\nStep 6: Choose Inputs Variable")
inputs <- setdiff(names(dataset),target)
inputs
length(inputs)

#Feature Selection
#n=4
#inputs <-sample(inputs, n)



#--------------------------------------------------------------
# Step 7: Select Training Data Set
#--------------------------------------------------------------
cat("\nStep 7: Select training dataset")
trainDataset <- dataset[1:(totalDataset * training/100),c(inputs, target)]
head(trainDataset)    # Show Top 6 records
nrow(trainDataset)    # Show number of train Dataset



#--------------------------------------------------------------
# Step 8: Select Testing Data Set
#--------------------------------------------------------------
cat("\nStep 8: Select testing dataset")
testDataset <- dataset[(totalDataset * training/100):totalDataset,c(inputs, target)]
head(testDataset)
nrow(testDataset)




#--------------------------------------------------------------
# Step 9: Model Building (Training)
#--------------------------------------------------------------
cat("\nStep 9: Model Building -> ", modelName)
formula <- as.formula(paste(target, "~", paste(c(inputs), collapse = "+")))
formula

model   <- nnet(formula, trainDataset, size=10, linout=TRUE, skip=TRUE, MaxNWts=10000, trace=FALSE, maxit=100)
model




#--------------------------------------------------------------
# Step 10: Prediction (Testing)
#--------------------------------------------------------------
cat("\nStep 10: Prediction using -> ", modelName)
Predicted <- as.numeric(round(predict(model, testDataset)))
head(Predicted)
PredictedProb <- predict(model, testDataset)
head(PredictedProb)


#--------------------------------------------------------------
# Step 11: Extracting Actual
#--------------------------------------------------------------
cat("\nStep 11: Extracting Actual")
Actual <- as.double(unlist(testDataset[target]))
head(Actual)



#--------------------------------------------------------------
# Step 12: Model Evaluation
#--------------------------------------------------------------
cat("\nStep 12: Model Evaluation")

# Step 12.1: Confusion Matrix
ConfusionMatrix <- misclassCounts(Predicted,Actual)$conf.matrix
ConfusionMatrix


# Step 12.2: Evaluations Parameters
# AUC, ERR, Sen, Spec, Pre,Recall, TPR, FPR, etc 
EvaluationsParameters <- round(HMeasure(Actual,PredictedProb)$metrics,3)
EvaluationsParameters


# Step 12.3: Accuracy
accuracy <- round(mean(Actual==Predicted) *100,2)
accuracy


# Step 12.4: Total Time
totalTime = proc.time()[3] - startTime
totalTime



# Step 12.5: Plotting
# ROC and ROCH Curve
png(filename=paste(modelName,"-01-ROCPlot.png",sep=''))
plotROC(HMeasure(Actual,PredictedProb),which=1)
dev.off()

# H Measure Curve
png(filename=paste(modelName,"-02-HMeasure.png",sep=''))
plotROC(HMeasure(Actual,PredictedProb),which=2)
dev.off()

# AUC Curve
png(filename=paste(modelName,"-03-AUC.png",sep=''))
plotROC(HMeasure(Actual,PredictedProb),which=3)
dev.off()

# SmoothScoreDistribution Curve
png(filename=paste(modelName,"-04-SmoothScoreDistribution.png",sep=''))
plotROC(HMeasure(Actual,PredictedProb),which=4)
dev.off()


# Step 12.5: Save evaluation resut 
EvaluationsParameters$Accuracy <- accuracy
EvaluationsParameters$TotalTime <- totalTime
rownames(EvaluationsParameters)=modelName
EvaluationsParameters



#--------------------------------------------------------------
# Step 13: Writing to file
#--------------------------------------------------------------
cat("\nStep 13: Writing to file")

# Step 13.1: Writing to file (evaluation result)
write.csv(EvaluationsParameters, file=paste(modelName,"-Evaluation-Result.csv",sep=''), row.names=TRUE)

# Step 13.2: Writing to file (Actual and Predicted)
write.csv(data.frame(Actual,Predicted), file=paste(modelName,"-ActualPredicted-Result.csv",sep=''), row.names=FALSE)



#--------------------------------------------------------------
# Step 14: Saving the Model
#--------------------------------------------------------------
cat("\nStep 14: Saving the Model ->",modelName)
save.image(file=paste(modelName,"-Model.RData",sep=''))


cat("\nDone")
cat("\nTotal Time Taken: ", totalTime," sec")


#--------------------------------------------------------------
#                           END 
#--------------------------------------------------------------



