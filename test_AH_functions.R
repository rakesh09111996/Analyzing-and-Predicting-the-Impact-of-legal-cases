

library(testthat)
library(Matrix)
library(RSpectra)
import::here(year_determined, Aut_hub_score, AH_Score,
             .from = 'Function_AH.R')

context("Authority and Hub score")

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

#Determining the complete relations between all cases in matrix form

A_network <- sparseMatrix(i=sparse_matrx_row_idx,j=sparse_matrx_col_idx,dims=c(dim_matrix,dim_matrix),x=matrix_val)

#-----tests-----#

test_that("Year_determined_function", {
  yr_ntwrk<- year_determined(A_network,case_year_data,1996)
  
  #checking whether the size of matrix exactly matches with the highest 
  #case number of the respective year
  expect_equal(nrow(yr_ntwrk), 29861)
  expect_equal(ncol(yr_ntwrk), 29861)
  #checking whether the relations of the network are valid by randomly 
  #checking 2 values
  #with respect to the allcites.txt, case number 19355 cites 19354 so in the 
  #matrix we expect a value of 1 to indicate there is a relation between.
  #Where as 19352 is not cited by 19356 so we expect 0
  expect_equal((yr_ntwrk[19355,19354]) , 1)
  expect_equal((yr_ntwrk[19356,19352]) , 0)
  
})




#to test that authority and hub score is calculated for all the cases
test_that("length of scores list", {
  expect_equal(nrow(Aut_hub_score(A_network)), nrow(A_network))
})

#verifying the computed score with the ones in the publication 
#Table.1 specifically (Akron vs Akron Center for Reproductive Health)
#case number: 27633

#We also see if the sum of the squares of the Authority and hub scores equal to 1
test_that("Scores Aut", {
  A_score<-(Aut_hub_score(A_network))
  A_score_akron<-A_score[27633,1]
  expect_equal(A_score_akron, 0.009)
  expect_equal(round(sum((A_score[,1])^2),digits=1),1)
})
test_that("Hub score", {
  h_score<-(Aut_hub_score(A_network))
  h_score_AKron<-h_score[27633,2]
  expect_equal(h_score_AKron, 0.026)
  expect_equal(round(sum((h_score[,2])^2),digits=1),1)
})

# verifying the results/outcomes of the execution function by comparing it with
# the values in the publication
# we also check whether year we are looking at is correct
test_that("execution function", {
  AH_execution<-AH_Score(case_year_data,25347,1973,A_network,29)
  expect_equal(AH_execution[30,1], 0.059)
  expect_equal(AH_execution[30,2], 0.058)
  expect_equal(AH_execution[30,4], 2002)
})


#got 3 warnings while running but it was associated with the version of R I used
#all tests passed