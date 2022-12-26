setwd("C:/Users/anuc/OneDrive - Indiana University/stat comp/final")
#List of libraries required
library(readr)
library(Matrix)
library(RSpectra)

#Step 1 : Data retrieval 
#Retrieving the data of case and the year in which judgement was made 
#Convert it to matrix form

case_year_data <- read.csv("data_year.csv", stringsAsFactors = FALSE)
case_year_data <- matrix(unlist(case_year_data), ncol = 2)

#Extracting the data with the case citations

all_citations <- readLines('allcites.txt')
Citation_judgement<- strsplit(all_citations, " ")
Citation_data<- t(sapply(Citation_judgement, as.numeric))
sparse_matrx_row_idx <- Citation_data[,1]
sparse_matrx_col_idx <- Citation_data[,2]
dim_matrix <- nrow(case_year_data)
matrix_val<-rep(1,length(sparse_matrx_row_idx))

#Step-2
#Determining the complete relations between all cases in matrix form

A_network <- sparseMatrix(i=sparse_matrx_row_idx,j=sparse_matrx_col_idx,dims=c(dim_matrix,dim_matrix),x=matrix_val)


#Step-3
#Extracting the data for the required cases


roe<-AH_Score(case_year_data,25347,1973,A_network,29) 
#25347 is Case ID for Roe Vs Wade and decision was made in 1973
brown<-AH_Score(case_year_data,21109,1954,A_network,29)
#21109 is the Case ID for Brown Vs Board of Education and decision was made in 1954

#Step-4
#Plotting the data to compare with the publication

plot(roe$i,roe$Aut_case,type = "l", lty = 1,xlab="Years after decision",ylab="Authority score",ylim=c(-0.01,0.065))
lines(brown$i,brown$Aut_case,lty=2)
legend(10,0.02,c("Roe Vs Wade (1973)","Brown vs Board of Education(1954)"),lty=c(1,2))

