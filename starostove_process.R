library(readr)
library(readxl)
library(dplyr)
library(tidyr)

# read in registr zastupitelů + rename columns for easy joining
regzast <- read_excel("data-input/kvrk.xlsx") %>%
  rename(kodobce = KODZASTUP, name1 = JMENO, surname = PRIJMENI) %>%
  filter(MANDAT == 1)

# read in registr stran + rename columns for easy joining
regstran <- read_excel("data-input/kvros.xlsx") %>% rename(kodobce = KODZASTUP)

# Process names - clear out degrees, split, arrange, handle multi-word surnames
library(stringr)
starostove <- read_csv("starostovezwiki.csv") %>% select(nazev, kodobce, starosta) %>% 
  mutate(jmenostarosty = str_replace_all(starosta,"M[BP]A",""),
         jmenostarosty = str_replace_all(jmenostarosty,"[PT][h]{1}[\\.]?[D]{1}\\.?",""),
         jmenostarosty = str_replace_all(jmenostarosty,"[C][\\.]?[Sc]+[\\.]?",""),
         jmenostarosty = str_replace_all(jmenostarosty, ",",""),
         jmenostarosty = str_replace(jmenostarosty,
                                     "L\\.?L\\.?M\\.?",""),
         jmenostarosty = str_replace_all(jmenostarosty, ",",""),
         jmenostarosty = str_replace_all(jmenostarosty,
                                     "(^[:alpha:]*\\.[:space:])([:alpha:]*\\.[:space:]){0,}([:alpha:]*\\.[:space:]){0,}",""),
         jmenostarosty = str_replace_all(jmenostarosty, ",",""),
         jmenostarosty = str_replace_all(jmenostarosty,"[\\[\\/].*?[\\]\\/]",""),
         jmenostarosty = str_replace_all(jmenostarosty,"\\(.*?\\)$",""),
         jmenostarosty = str_replace_all(jmenostarosty,"[,]{0,1}[:space:]{0,1}[:alpha:]{1,10}\\.$",""), 
         jmenostarosty = str_replace_all(jmenostarosty,"od[:space:].+$",""),
         jmenostarosty = str_replace_all(jmenostarosty,"[:space:][,]?Di[Ss]",""),
         jmenostarosty = str_replace_all(jmenostarosty,"et Mgr\\.",""),
         jmenostarosty = str_replace_all(jmenostarosty,"[Ii]ng[\\.]?[:space:]?[aA]rch[\\.]?[:space:]?",""),
         jmenostarosty = str_replace_all(jmenostarosty,"^[ingmgrINGMGR]{3}[:space:]",""),
         jmenostarosty = str_replace_all(jmenostarosty, ",",""),
         jmenostarosty = str_trim(jmenostarosty)) %>% 
  separate(jmenostarosty, into = c("name1","name2", "name3"), sep = " ",
           extra = "drop", remove = F, fill = "left") # split names

# Check how many names people have (aid for creating regex)
starostove$namecount <- sapply(strsplit(starostove$jmenostarosty, " "), length)
table(starostove$namecount)

# Manual fixes where names fell into the wrong columns
starostove <- starostove %>%
  mutate(name1 = ifelse(is.na(name1), name2, name1),
         name2 = ifelse(name2 == name1, NA, name2),
         name3 = ifelse(kodobce == 597961, name2, name3),
         name2 = ifelse(kodobce == 597961, NA, name2),
         name1 = ifelse(kodobce == 584452, name2, name1),
         name2 = ifelse(kodobce == 584452, NA, name2))

# Merge female multiple-word names into one to enable joining
starostove <- starostove %>% 
  mutate(surname = ifelse((str_sub(name3,-1)=="á" & !is.na(name2)),
                          paste(name2,name3), name3))

# Join with registr zastupitelu
st_regzast <- left_join(starostove, regzast)

# Check where one name matched multiple items in the registr
st_regzast <- st_regzast %>% left_join(st_regzast %>% group_by(kodobce) %>%
                   summarise(multimatch = n()) %>%
                   mutate(multimatch = (multimatch > 1)))

## It seems there are 44 places with 2 council members of the same name

# Join with registr stran
st_komplet <- left_join(st_regzast, regstran)

# Write
write_csv(st_komplet, "data-output/starostove_komplet.csv")