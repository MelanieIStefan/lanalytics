## order_time.R
## takes timing data created with parsequizzes.R
## computes order in which questions were answered and absolute time taken
## Written by MI Stefan

library(RColorBrewer)
library(xlsx)

## Variables
# give number of quizzes we are interested in 
lowestQuiz = 4
highestQuiz = 32
# path to file that contains time stamps
timesfile = "2013_output/times.csv"
# Quiz questions to ignore (e.g. because of a fault at data collection)
ignoreQuestions = c('Q5q6', 'Q6q2','Q6q11','Q8q3','Q8q4','Q10q5')


# read in time data
times <- read.csv(file=timesfile,sep=",",stringsAsFactors=FALSE)

# data frames that will hold orders of questions and times to answer each
timesToAnswerMin <- as.data.frame(times[,'id'])
timesToAnswerSec <- as.data.frame(times[,'id'])
orders <- as.data.frame(times[,'id'])

# list question numbers to consider 
questionNumbers <- colnames(times)

# per quiz
for (i in lowestQuiz:highestQuiz){
     # get indices of relevant columns by finding pattern Q<quiz number>q
     indices = grep(paste("Q",i,"q",sep=""),questionNumbers)
     currentQuiz = times[ ,indices]
     
     # replace time stamp with NA for questions defined in the "to ignore" list earlier
     currentQuiz[,intersect(names(currentQuiz),ignoreQuestions)] <- NA
     
     # will store times for this quiz
     quizTimeTakenMin <- currentQuiz
     quizTimeTakenMin[,] <- NA
     
     quizTimeTakenSec <- currentQuiz
     quizTimeTakenSec[,] <- NA
     
     # will store orders for this quiz
     quizOrders <- data.frame()
     
     # go through each student
     
     for (j in 1:nrow(currentQuiz)){
         absoluteTimes = currentQuiz[j, ]
         absoluteTimes <- strptime(absoluteTimes, "%Y-%m-%d %H:%M:%S")
                  
         # determine order, e.g. if the first entry in questionOrder is 3, 
         # this means question 3 was answered first
         questionOrder=order(absoluteTimes)
         
        # determine time to answer each question (in minutes and in seconds)
        column_names<-list()
        
        for (k in 2:length(questionOrder)){
        this <- questionOrder[k]
        previous <- questionOrder[k-1]
        timeTakenMin=as.numeric(difftime(absoluteTimes[this], absoluteTimes[previous], units="mins"))          
        quizTimeTakenMin[j,this] <- format(round(timeTakenMin,0),)
        timeTakenSec=as.numeric(difftime(absoluteTimes[this], absoluteTimes[previous], units="secs"))          
        quizTimeTakenSec[j,this] <- format(round(timeTakenSec,0),)
        column_names = c(column_names, paste('Q',i,'_',(k-1),'th',sep=""))                    
        }
        column_names = c(column_names, paste('Q',i,'_',(k),'th',sep=""))
        
        quizOrders <- rbind(quizOrders, questionOrder)
        colnames(quizOrders) <- column_names 
     }
     # add to master list of orders
     orders <- cbind(orders,quizOrders)
     timesToAnswerMin <- cbind(timesToAnswerMin,quizTimeTakenMin)
     timesToAnswerSec <- cbind(timesToAnswerSec,quizTimeTakenSec)
     
     # add to master list of question times
     
     
}

colnames(orders)[1] = "id"
colnames(timesToAnswerMin)[1] = "id"
colnames(timesToAnswerSec)[1] = "id"

# plot order on a heatmap
png("2013_output/order.png")
hmcol<-brewer.pal(11,"RdBu")
image(t(orders[,2:ncol(orders)]),col=hmcol,xlab="quiz",ylab="student",main="Question Order",xaxt="n",yaxt="n")
dev.off()

# save data frames
save(orders,file="2013_output/orders.Rda")
save(timesToAnswerSec,file="2013_output/timesToAnswerSec.Rda")
save(timesToAnswerMin,file="2013_output/timesToAnswerMin.Rda")

### save three tables to .xlsx files
write.xlsx(orders,file = "2013_output/orders.xlsx", col.names = TRUE,row.names = FALSE,showNA = TRUE)
write.xlsx(timesToAnswerMin,file = "2013_output/timesToAnswerMin.xlsx", col.names = TRUE,row.names = FALSE,showNA = TRUE)
write.xlsx(timesToAnswerSec,file = "2013_output/timesToAnswerSec.xlsx", col.names = TRUE,row.names = FALSE,showNA = TRUE)
