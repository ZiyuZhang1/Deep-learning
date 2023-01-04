rm(list = ls())
 

library(tidyverse)
library(ggplot2)
library(ggpubr)
library(broom)
library(AICcmodavg)

##Insert path to directory DiffDock_RMSDs
#setwd("C:/Users/lines/OneDrive - Danmarks Tekniske Universitet/Master/Deep Learning/Project/DiffDock_RMSDs")

information_rmsd_10 <- read_delim("information_rmsdDiffDock10.tab", col_names = TRUE)
information_rmsd_10_long <- read_delim("information_rmsdDiffDock10_long.tab", col_names = TRUE)
information_rmsd_40 <- read_delim("information_rmsdDiffDock40.tab", col_names = TRUE)
information_rmsd_40_long <- read_delim("information_rmsdDiffDock40_long.tab", col_names = TRUE)

information_rmsd <- merge(information_rmsd_10, information_rmsd_10_long, by = c("rank", "pdb_name"), all = FALSE)
information_rmsd <- merge(information_rmsd, information_rmsd_40, by = c("rank", "pdb_name"), all = FALSE)
information_rmsd <- merge(information_rmsd, information_rmsd_40_long, by = c("rank", "pdb_name"), all = FALSE)

information_rmsd_long_rmsd <- information_rmsd %>% pivot_longer(cols = starts_with("rmsd"),
                                      names_to = "rmsd_type",
                                      values_to = "rmsd")



information_rmsd_long_confidence <- information_rmsd %>% pivot_longer(cols = starts_with("confidence"),
                                                           names_to = "confidence_type",
                                                           values_to = "confidence_score")
#information_rmsd_long <- merge(information_rmsd_long_rmsd, information_rmsd_long_confidence, by = c("rank", "pdb_name"))

pdb_names_list = information_rmsd_long_rmsd %>% 
  count(pdb_name) %>%
  select(!n) %>% 
  as.vector()

pdb_names = pdb_names_list[[1]]


information_rmsd_long_rmsd %>% filter(rank == 1) %>% 
  ggplot(mapping = aes(x = rmsd,
                       y = as.factor(rmsd_type))) +
  geom_boxplot(fill = "brown2") + 
  coord_flip() + 
  labs(x = "RMSD",
       y = "Model Parameter Settings",
       title = "DiffDock Evaluation Divided on a Selection of Parameter Settings",
       subtitle = "Based on Rank 1 Results")


information_rmsd_long_rmsd %>% #filter(rank == 1) %>% 
  ggplot(mapping = aes(x = rmsd,
                       y = as.factor(rmsd_type))) +
  geom_boxplot(fill = "brown2") + 
  coord_flip() + 
  labs(x = "RMSD",
       y = "Model Parameter Settings",
       title = "DiffDock Evaluation Divided on a Selection of Parameter Settings",
       subtitle = "Based on all ranks")






###Calculate top-1 and top-5 RMSD < 2 Å %

#10 short
top_1_conf_10_short <- information_rmsd_long_rmsd %>% filter(rmsd_type == "rmsd_DiffDock10")#, rank == 1)

good_rmsd_10_short <- top_1_conf_10_short %>% filter(rmsd < 2) %>% count()

good_rmsd_10_short

summary(top_1_conf_10_short)

#good_rmsd_10_short / length(pdb_names) * 100
good_rmsd_10_short / 1890 * 100


#10 long
top_1_conf_10_long <- information_rmsd_long_rmsd %>% filter(rmsd_type == "rmsd_DiffDock10_long")#, rank == 1)

good_rmsd_10_long <- top_1_conf_10_long %>% filter(rmsd < 2) %>% count()

good_rmsd_10_long

summary(top_1_conf_10_long)

#good_rmsd_10_long / length(pdb_names) * 100
good_rmsd_10_long / 7560 * 100


#40 short
top_1_conf_40_short <- information_rmsd_long_rmsd %>% filter(rmsd_type == "rmsd_DiffDock40")#, rank == 1)

good_rmsd_40_short <- top_1_conf_40_short %>% filter(rmsd < 2) %>% count()

good_rmsd_40_short

summary(top_1_conf_40_short)

#good_rmsd_40_short / length(pdb_names) * 100
good_rmsd_40_short / 1890 * 100


#40 long
top_1_conf_40_long <- information_rmsd_long_rmsd %>% filter(rmsd_type == "rmsd_DiffDock40_long")#, rank == 1)

good_rmsd_40_long <- top_1_conf_40_long %>% filter(rmsd < 2) %>% count()

good_rmsd_40_long

summary(top_1_conf_40_long)

#good_rmsd_40_long / length(pdb_names) * 100
good_rmsd_40_long / 7560 * 100





#Performance Evaluation Based on Top-40 Ranked\nPredictions For a Selection of Proteins
information_rmsd_40 %>% filter(pdb_name %in% c("8DG6", "7Z2J", "8DUC", "7MAP", "7OF8",
                                               #"5ST6", "5ST9",
                                               "5SU1", "7FMZ", "7FL0", "7FO1", "7FPK")) %>% 
  ggplot(mapping = aes(x = rmsd_DiffDock40,
                       y = as.factor(pdb_name))) +
  geom_boxplot(fill = "grey45") + 
  coord_flip() + 
  labs(x = "RMSD",
       y = "PDB ID") +
  theme_minimal() +
  theme(text = element_text(size = 18))



#Correlation Between Confidence Score\nand RMSD of Top-1 Ranked Predictions"
information_rmsd_40 %>% filter(rank == 1) %>% 
  ggplot(mapping = aes(
                       x = confidence_scoreDiffDock40,
                       y = rmsd_DiffDock40)) +
  geom_point(fill = "grey45") + 
  geom_smooth(method = "lm", , colour="black") +
  #stat_cor(method = "pearson", label.x = 3, label.y = 30) +
  labs(x = "Confidence score",
       y = "RMSD") +
  theme_minimal() +
  theme(text = element_text(size = 18))



































#boxplot; group by rank (1-40)
information_rmsd %>% ggplot(mapping = aes(x = rmsd_DiffDock10,
                                          y = as.factor(rank),
                                       fill = as.factor(rank))) +
  geom_violin() +
  stat_summary(fun = "mean") +
  #geom_boxplot() +
  coord_flip() +
  theme(legend.position = "none") + 
  labs(x = "RMSD",
         y = "Rank (ordered by confidence score)")


#boxplot; group by pdb name
information_rmsd %>% 
  filter(!pdb_name %in% c("5ST6", "7Q2K", "7Q2V"),
         pdb_name %in% c(pdb_names[1:10], pdb_names[175:189])) %>% 
  ggplot(mapping = aes(x = rmsd,
                       y = as.factor(pdb_name))) +
                       #fill = as.factor(pdb_name))) +
  geom_boxplot(fill = "brown2") +
  #coord_flip() +
  theme_minimal() +
  theme(legend.position = "none",
        text = element_text(size=24)) +
  labs(x = "RMSD",
       y = "Protein (PDB ID)",
       title = "Root Mean Sqaured Deviation Between\nActual and Predicted Ligand Poses",
       subtitle = "Based on top-40 confidence scored ligand poses for each protein",
       caption = "Model evaluation of DiffDock")



#scatterplot by confidence score
information_rmsd %>% ggplot(mapping = aes(x = confidence_score,
                                          y = rmsd)) +
  geom_point() + 
  geom_smooth(method = "lm") +
  stat_cor(method = "pearson", label.x = 7, label.y = 0)



#scatterplot by confidence score
information_rmsd %>% # filter(rank == 1) %>% 
  ggplot(mapping = aes(x = confidence_score,
                                          y = rmsd)) +
  geom_point() + 
  geom_smooth(method = "lm") +
  stat_cor(method = "pearson", label.x = 7, label.y = 0.1)





###Calculate top-1 and top-5 RMSD < 2 Å %

top_1_conf <- information_rmsd %>% filter(rank == 3)

good_rmsd <- top_1_conf %>% filter(rmsd < 2) %>% count()

summary(top_1_conf)

good_rmsd / length(pdb_names)



top_5_conf <- information_rmsd %>% filter(rank %in% c(1,2,3,4,5))

good_rmsd <- top_5_conf %>% filter(rmsd < 2) %>% count()

summary(top_5_conf)

good_rmsd / (length(pdb_names) * 5)


information_rmsd %>% group_by(pdb_name) %>% filter()



information_rmsd$pdb_name <- as.factor(information_rmsd$pdb_name)
min_rmsds <- do.call(rbind, lapply(split(information_rmsd, information_rmsd$pdb_name), function(x) {return(x[which.min(x$rmsd),])}))

rmsds_test <- min_rmsds %>% filter(rmsd < 2) %>% count()

rmsds_test / length(pdb_names)
