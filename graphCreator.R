library(igraph)
library(stringi)
library(tidyr)

#------------------------------
#Create Edgelist from Hashtags
#------------------------------
elist <- c()
ht <- read.csv("ht_unsort_bike.csv", stringsAsFactors = FALSE, header = T, fileEncoding = "UTF-8")
matrix <- as.matrix(ht[-1])
#nrow(matrix)
for(i in 1:nrow(matrix)){
  temp <- na.omit(as.character(matrix[i,]))
  #if necessary; check matrix for "NA"
  #temp <- temp[-which(temp == "NA")]
  if(length(temp)>1){
    elist <- c(elist, combn(temp,2))
  }
}

#-----------------
#Export Edge List
#-----------------
elist_m <- as.matrix(elist)
write.csv(elist_m, "edgelist_bike.csv", fileEncoding = "UTF-8", row.names=F)

#---------------
#Load Edge List
#---------------
imp_matrix <- as.matrix(read.csv("edgelist_bike.csv", sep = ";"))
elist_imp <- as.character(imp_matrix)
elist <- c(elist, elist_imp)

#---------------------
#Create Basic Networks
#---------------------
graph2 <- igraph::graph(edges=elist, directed=F)
graph2 <- igraph::simplify(graph2)

#Degree
dgr <- as.matrix(igraph::degree(graph2))
plot(dgr, type="l")

#Subgraph
graph3 <- igraph::induced.subgraph(graph2, which(dgr>80))
plot(graph3,type="l")
