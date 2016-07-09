library(rvest)
library(tibble)

wikilist <- read_html("https://cs.wikipedia.org/wiki/Seznam_obc%C3%AD_v_%C4%8Cesku") %>% 
  html_nodes("body td.navbox-list a")

seznamobci <- data_frame(
  "name" = html_text(wikilist),
  "url" = html_attr(wikilist, "href")
)

source("get_wiki_items.r")

# Set parameters: what to pick out and how to name columns
paramstokeep <- c("^starost", "LAU", "^kraj","^okres", "primátor\\(ka\\)","NUTS 5", "^přednost")
outputheaders <- c("kodobce","kraj","okres","starosta")

# Test on one URL
testtable <- get_wiki_items("https://cs.wikipedia.org/wiki/Šlapanice (okres Kladno)",
                          rowstokeep=paramstokeep, baseurl = "https://cs.wikipedia.org",
                          outputheaders = outputheaders) %>% 
  separate(kodobce,into = c("kodobcelau","kodobce"),sep=" ")
head(testtable)

# undebug(get_wiki_items)
# debug(get_wiki_items)

# Run for all - takes a LOOONG time
# starostovezwiki <- get_wiki_items(seznamobci$url, paramstokeep, outputheaders=outputheaders,
#                           baseurl = "https://cs.wikipedia.org") %>% 
#   separate(kodobce,into = c("kodobcelau","kodobce"),sep=" ")


# Write
library(readr)
# write_csv(starostovezwiki, "data-output/starostovezwiki.csv")
