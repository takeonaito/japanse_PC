# read result and freq file
myres <- fread('/mnt/share6/FOR_Takeo/Japanese_PC/result/japanese_pc_binary.PC_80.glm.logistic')
colnames(myres) <- make.names(colnames(myres))

freq <- fread('/mnt/share6/FOR_Takeo/Japanese_PC/result/frequency.afreq')
colnames(freq) <- make.names(colnames(freq))

# read annotation file
anotation <- fread('/mnt/share6/FOR_Takeo/Japanese_PC/annotation/annovar_anote_file.txt')


## merge 3 files
myres1 <- myres %>% 
  left_join(freq,by = "ID")  %>% 
  dplyr::select(-X.CHROM.y,-REF.y,-ALT.y) %>% 
  dplyr::rename(Chr = X.CHROM.x,Ref = REF.x, Alt = ALT.x,
                case_num_analysi = OBS_CT.x, num_for_freq = OBS_CT.y) %>% 
  mutate(num_for_freq = num_for_freq/2)


myres2 <- myres1 %>% 
  left_join(anotation,by = c("Chr" = "Chr","POS" = "Start",
                             "Ref" = "Alt", "Alt"= "Ref"))




### make vector of candidate genes

c_genes <- c("FGF21", "HINT1", "IRF5","TNPO3","THEMIS","PTPRK","AHR")

## confirm all genes are exist in anotation
a_genes <- anotation %>% 
  distinct(Gene.refGene) %>% 
  separate_rows(Gene.refGene,sep = ";") %>% 
  distinct(Gene.refGene)


intersect(a_genes$Gene.refGene,c_genes) ## confirm all genes are exist.


## extract variants in candidate genes from result

c_res <- myres2 %>% 
  separate_rows(Gene.refGene) %>% 
  filter(Gene.refGene %in% c_genes)

c_res %>% 
  write_xlsx("/mnt/share6/FOR_Takeo/Japanese_PC/result/for_talin_PC_logistic.xlsx")



# read linear result 
myres <- fread('/mnt/share6/FOR_Takeo/Japanese_PC/result/japanese_pc.NormalPC.glm.linear')
colnames(myres) <- make.names(colnames(myres))


## merge 3 files
## merge 3 files
myres1 <- myres %>% 
  left_join(freq,by = "ID")  %>% 
  dplyr::select(-X.CHROM.y,-REF.y,-ALT.y) %>% 
  dplyr::rename(Chr = X.CHROM.x,Ref = REF.x, Alt = ALT.x,
                case_num_analysi = OBS_CT.x, num_for_freq = OBS_CT.y) %>% 
  mutate(num_for_freq = num_for_freq/2)

myres2 <- myres1 %>% 
  left_join(anotation,by = c("Chr" = "Chr","POS" = "Start",
                             "Ref" = "Alt", "Alt"= "Ref"))


## extract variants in candidate genes from result

c_res <- myres2 %>% 
  separate_rows(Gene.refGene) %>% 
  filter(Gene.refGene %in% c_genes)

c_res %>% 
  write_xlsx('/mnt/share6/FOR_Takeo/Japanese_PC/result/for_talin_PC_linear.xlsx')
