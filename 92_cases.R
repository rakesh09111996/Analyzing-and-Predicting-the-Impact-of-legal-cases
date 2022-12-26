setwd("C:/Users/anuc/OneDrive - Indiana University/stat comp/final")
library(readr)
library(Matrix)
library(RSpectra)

#Retrieving the data of case and the year in which judgement has been given and converting it into matrix form 

case_year_data <- read.csv("data_year.csv", stringsAsFactors = FALSE)
case_year_data <- matrix(unlist(case_year_data), ncol = 2)

#Retrieving the data from file which says the list of relations between cases and converting it into matrix form
all_citations <- readLines('allcites.txt')
Citation_judgement<- strsplit(all_citations, " ")
Citation_data<- as.data.frame(t(sapply(Citation_judgement, as.numeric)))
new_data <- Citation_data[which( Citation_data$V2 == 25347) , ]
list_case<-new_data$V1
list_case_92<-append(list_case,25347) #List of all cases that cited Roe vs Wade

case_92=Citation_data[Citation_data$V1 %in% list_case_92 & Citation_data$V2 %in% list_case_92, ]

sparse_matrx_row_idx <- case_92[,1]
sparse_matrx_col_idx <- case_92[,2]
dim_matrix <- nrow(case_year_data)
matrix_val<-rep(1,length(sparse_matrx_row_idx))

final_A_mat_92 <- sparseMatrix(i=sparse_matrx_row_idx,j=sparse_matrx_col_idx,dims=c(dim_matrix,dim_matrix),x=matrix_val)

aut__hub_score_92<-Aut_hub_score(final_A_mat_92)


list_cases=c(25347,27633,28354,29003,29459) 
#These are the 5 highly related important cases that was referred in Table 1 of 
#the publication, so here we are computing and thus verifying the Hub and 
#Authority score for these 5 cases in the 92 case network
#We could use list_case_92 as well to extract the hub and authority score for all

hub_aut_5<-data.frame()
for (case_ID in list_cases){
  hub_score<-aut__hub_score_92[case_ID,2]
  aut_score<-aut__hub_score_92[case_ID,1]
  hub_aut_5<-rbind(hub_aut_5,data.frame(case_ID,aut_score,hub_score))
}


#We use list_case_92 as well to extract the hub and authority score for all
#This also helps us to verify by summing the squares of the Authority scores 
#to see if it is normalized to 1

hub_aut_92<-data.frame()
for (case_ID in list_case_92){
  hub_score<-aut__hub_score_92[case_ID,2]
  aut_score<-aut__hub_score_92[case_ID,1]
  hub_aut_92<-rbind(hub_aut_92,data.frame(case_ID,aut_score,hub_score))
}

sum_Aut<-sum((hub_aut_92$aut_score)^2)
#0.999493

sum_hub<-sum((hub_aut_92$hub_score)^2)
#0.999881
