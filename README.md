Project Overview:
We aim to compute “hub” and “authority” scores for nodes(cases) in a network and apply them to a  network of Supreme Court opinions based of “The Authority of Supreme Court Precedent” Social Networks (2008), Fowler and Jeon.


Functions used:
We used 3 functions to achieve our final output, which was to recreate the graphs which indicates the changes in Authority score for 2 prominent cases Roe vs Wade and 
Brown vs Board of Education.                                                                                                                                                                                                                                                                                                                                    
Function 1: year_determined-> Takes in the total network matrix (in which element  Aij is 1 if case i cites case j and if not 0). This function also takes in the year and case id information, in the form of a vector which has 2 columns, where one is case ID and other one is the year in which the decision was made for that particular case.
Function 2: Aut_hub_score-> Simply computes the HUb and Authority score for a given A matrix, whether it be for the whole network for all the given years, or for a particular subset of it for a given year we are interested in. This function only has one parameter, which is the network matrix (A)                                    
Function 3: AH_Score-> Is the function that we have created for the final execution. For a given case, this function will compute the hub and authority scores for each year for "x" number of years after its decision was passed. The function takes in the total network matrix, the ID number for the case we are interested in, the year in which the case decision was made, dataset  with all the case IDs and the year in which the decision were made and finally for how many number of years do we want to extract the score for. The output is a dataframe, with 4 columns, i.e Authority score, Hub score, number of years passed and actual year that the scores correspond to.
Data source: We obtained all the raw data from "https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/XMBQL6"                                          
This is the replication data for  “The Authority of Supreme Court Precedent” Social Networks, (2008), Fowler and Jeon                                                      
2 set of files required to execute the functions that we wrote are "allcites.txt" and "data_year.csv", the first one has all the relationships betweens the case, i.e column 1 has a list of cases and column 2 corresponds to the cases that are cited by the ones in column 1. The csv file has 2 columns, one for the case ID and second for the year in which the case decision was made.


