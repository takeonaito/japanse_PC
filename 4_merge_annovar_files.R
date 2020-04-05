library(data.table)
library(readr)
library(tidyverse)



annova1 <- data.frame()
for (i in 1:22){
  file_name <- paste0('/mnt/share6/FOR_Takeo/Japanese_PC/annotation/annotated_file/chr',
                      i,'.hg19_multianno.txt')
tmp_data <- fread(file_name) %>% 
  dplyr::select(Chr,Start,Ref,Alt,Func.refGene,Gene.refGene,Func.knownGene,Gene.knownGene)


annova1 <- rbind(annova1,tmp_data)
}


annova1 %>% 
  write_tsv('/mnt/share6/FOR_Takeo/Japanese_PC/annotation/annovar_anote_file.txt')





