rm(list = ls())
setwd("~/Documents/CMEEProject/code")
require(dplyr)
require(ggplot2)

# read the data
Data <- read.csv("../data/growth_rate_data.csv")
# length(unique(Data$Temp))
# max(Data$Temp)

# # check the data in each citation and standardize the species name
# data.cit <- split(Data, Data$Citation)
# # 1
# data.cit1 <- data.cit[[1]]
# 
# cit.spe <- unique(data.cit1$Species)
# spe.df1 <- subset(data.cit1, data.cit1$Species == cit.spe[2])
# spe.df1$Species = "Enterobacter"
# spe.df1 <- subset(data.cit1, data.cit1$Species == cit.spe[2])
# unique(spe.df1$Species)
# 
# data.cit1 <- data.cit[[1]]
# unique(data.cit1$Temp)
# unique(data.cit1$Species)
# unique(data.cit1$Medium)
# unique(data.cit1$Rep)
# unique(data.cit1$PopBio_unts)
# unique(data.cit1$n)




# insert ID column
Data$ID <- paste0(Data$Rep,"_",Data$Species,"_",Data$Temp,"_",Data$Medium,"_",Data$Citation)
length(unique(Data$ID))

# delete problematic data sets (checking species)
spe <- unique(Data$Species) # prob: c(105, 61, 60, 55, 51, 46, 41, 32)
for (i in c(105, 61, 60, 55, 51, 46, 41, 32)) {
  Data <- subset(Data, Data$Species != spe[i])
}
length(unique(Data$ID))

# delete duplicate rows
Data <- Data %>% dplyr::distinct(n,Time, PopBio, Temp, Time_units, PopBio_unts, Species, Medium, Rep, Citation,id,ID)
length(unique(Data$ID))

# delete the data set with negative population size
neg.df <- subset(Data, Data$PopBio < 0)
neg.id <- unique(neg.df$ID)
for (i in 1:length(neg.id)) {
  Data <- subset(Data, Data$ID != neg.id[i])
}
length(unique(Data$ID))

# log the population
Data <- Data[Data$PopBio > 0, ]
Data$logN <- log(Data$PopBio)
length(unique(Data$id))

# plot
for (i in 1:length(unique(Data$id))){
  idname <- unique(Data$id)[i]
  data <- subset(Data, Data$id == idname)
  Data[Data$id == idname, ]$n <- nrow(data)

  # # plot by each ID
  # FileName <- paste('../results/RawDataPlot/plot_ID_',i)
  # png(file = FileName)
  # print(
  #   ggplot(data, aes(x = Time, y = logN)) +
  #     geom_point(size = 3) +
  #     labs(x = "Time (Hours)", y = "logarithum of Population size")
  # )
  # graphics.off()
}

# delete data set has less than 5 points
Data <- Data[Data$n >= 5,]
length(unique(Data$ID))

# # add taxonomy information
# spe <- unique(Data$Species)
# taxo.df <- data.frame(genus = c("Chryseobacterium", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
#                       family =c("Weeksellaceae", ""),
#                       order = c("Flavobacteriales", ""),
#                       class = c("Flavobacteriia", ""),
#                       phylum= c("Bacteroidetes", ""),
#                       domain= c("Bacteria", ""))
# neg.df <- c(1,)
# for (i in 1:length(spe)) {
#   dat <- subset(Data, Data$Species == spe[i])
#   if (i ) {
#     dat$gram = "positive"
#   } else {
#     dat$gram = "negative" 
#   }
#   dat$genus <- genus.df[i]
#   dat$family <- fam.df[i]
#   dat$object <- obj.df[i]
# }
####################################
# test.id <- subset(Data, Data$id == 643)
# cit <- test.id$Citation
# test.cit <- subset(Data, Data$Citation == cit)
# unique(test.cit$Citation)
# unique(test.cit$id)
# length(unique(test.cit$id))
# length(unique(Data$id))

# save pop
write.csv(Data, "../data/pop.csv")
