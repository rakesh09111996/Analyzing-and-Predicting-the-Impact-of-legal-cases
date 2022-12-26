#List of libraries required
library(readr)
library(Matrix)
library(RSpectra)

#Once we have the complete network matrix,  we extract the matrix for each 
#terminal year using the function below (year_determined)

#Extracting the A matrix for each year

#Parameters
#Case_year: Data with case number and year the decision was made
#Final_A_mat: A network matrix that includes the relation with each case until
#2002. Element A[i.j] is 1 if case i has cited case j, else 0.
#year_need: Year for which we want to subset the A matrix for

year_determined<-function(Final_A_mat,case_year,year_need) {
  list_cases_idx<- which(case_year[,2]==year_need)
  final_mat_idx <- max(list_cases_idx)
  return(Final_A_mat[1:final_mat_idx,1:final_mat_idx])
}


#The following function computes the hub and authority score
#we compute the eigen vector for A*A(transpose) which would ultimately give the
#hub score and similar method can be applied to A(transpose)*A to compute the 
#authority score

#Parameters:
#A_mat_subset: Subset of the final A matrix, which has the relationships till
# 2002, we subset it for each year we are interested in



Aut_hub_score<-function(A_mat_subset){
  aut_hub_score<-data.frame()
  a<-rep(1,times=ncol(A_mat_subset))
  h<-rep(1, times = ncol(A_mat_subset))
  AtA_aut <-t(A_mat_subset)%*%(A_mat_subset)
  AAt_hub <-A_mat_subset%*%t(A_mat_subset)
  #gives us the largest eigen values and
  #eigen vectors in the case of a sparse matrix
  ei_aut<-eigs(AtA_aut,k=1,which = "LM")
  ei_hub<-eigs(AAt_hub,k=1,which = "LM")
  aut_score<-abs(round((ei_aut$vector),digits=3))
  hub_score<-abs(round((ei_hub$vector),digits=3))
  
  aut_hub_score<-rbind(aut_hub_score,data.frame(aut_score,hub_score))
  return(aut_hub_score)
}

#Execution function that extract the hub and authority score for the case we are
#interested in, for the required number of years after decision

#Parameters used:
#Case_year: Data with case number and year the decision was made
#Case_num: The case number we are interested in (case id)
#Decision_year: The year in which aforementioned case decision was made
#Final_A_mat: A network matrix that includes the relation with each case until
#2002. Element A[i.j] is 1 if case i has cited case j, else 0.
#n_years: Number of years we want to reproduce data for



AH_Score <-function (case_year,case_num,decision_year,Final_A_mat,n_years) {
  list_ha<-data.frame()
  for (i in 0:n_years){
    years<-(decision_year+i)
    A_subset<-year_determined(Final_A_mat,case_year,years)
    Aut_hub_score_all<-Aut_hub_score(A_subset)
    #extracting hub and authority score for a given case
    hub_case<-Aut_hub_score_all[case_num,2]
    Aut_case<-Aut_hub_score_all[case_num,1]
    #year wise hub and authority score for a given case
    list_ha<-rbind(list_ha,data.frame(hub_case,Aut_case,i,years))
  }
  return(list_ha)
}