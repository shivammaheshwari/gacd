xtest = read.table(paste0(getwd(),'/UCI\ HAR\ Dataset/test/X_test.txt'))
xtrain = read.table(paste0(getwd(),'/UCI\ HAR\ Dataset/train/X_train.txt'))

ytest = read.table(paste0(getwd(),'/UCI\ HAR\ Dataset/test/y_test.txt'))
ytrain = read.table(paste0(getwd(),'/UCI\ HAR\ Dataset/train/y_train.txt'))

subtest = read.table(paste0(getwd(),'/UCI\ HAR\ Dataset/test/subject_test.txt'))
subtrain = read.table(paste0(getwd(),'/UCI\ HAR\ Dataset/train/subject_train.txt'))

## Merging 

xfinal = rbind(xtest,xtrain)
yfinal = rbind(ytest,ytrain)
subfinal = rbind(subtest,subtrain)


## Extract colnames

cols = read.table(paste0(getwd(),'/UCI\ HAR\ Dataset/features.txt'))
cols = cols[[2]]

colnames(xfinal) = cols

## Extract mean and sd only

meansdcols = cols[grepl('mean()',cols,fixed=T) | grepl('std()',cols,fixed=T)]
meansdcols = as.character(meansdcols)

xfinalnew = xfinal[,meansdcols]

## Activity labelling

colnames(yfinal) = c('activitycode')
colnames(subfinal) = c('subject')


xfinalnew = cbind(xfinalnew,yfinal)
xfinalnew = cbind(xfinalnew,subfinal)

activitylabels = read.table(paste0(getwd(),'/UCI\ HAR\ Dataset/activity_labels.txt'))
colnames(activitylabels) = c('activitycode','activityname')

xfinalnew = merge(xfinalnew,activitylabels)
xfinalnew = xfinalnew[,-which(colnames(xfinalnew) %in% c('activitycode'))]

final = aggregate(xfinalnew[,-which(colnames(xfinalnew) %in% c('subject','activityname'))],xfinalnew[,c('subject','activityname')],FUN=mean)

colnames(final)[3:length(colnames(final))] = paste(colnames(final)[3:length(colnames(final))],'mean',sep='_')


