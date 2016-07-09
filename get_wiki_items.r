get_wiki_items <- function(urls, baseurl = "https://en.wikipedia.org", rowstokeep,
                           outputheaders = NULL) {
  library(rvest)
  library(dplyr)
  library(stringr)
  library(tidyr)
  
  loopnum = 0
  
  urls <- ifelse(str_detect(urls, "^http"),urls,paste0(baseurl, urls))
  rowstokeep <- paste0("(",paste(rowstokeep,collapse = ")|("),")")
  for(thisurl in urls) {
    pagehtml <- read_html(thisurl)
    pagetitle <- pagehtml %>% 
      html_node("body h1#firstHeading") %>% 
      html_text()
    print(thisurl)
    print(pagetitle)
    thistable <- pagehtml %>%  
      html_node("body table.infobox") %>% 
      html_table(fill=T)
    names(thistable) <- c("param","content")
    
    
    thistable <- thistable %>% 
      mutate(keep = str_detect(param, rowstokeep)) %>% 
      filter(keep==TRUE)
    
    if(is.null(outputheaders)) {
      outputheaders <- paste0("col", seq(1,length(unique(thistable$param))))
    }
    
    thistable <- thistable %>% 
      select(-keep) %>% 
      mutate(param = outputheaders,
             nazev = pagetitle) %>%
      spread(param,content)
    if(loopnum == 0) {
      finaltable <- thistable
    } else {
      finaltable <- bind_rows(finaltable, tablehtml)
    }
    loopnum <- loopnum + 1
    print(paste(loopnum, "out of", length(urls)))
  }
  return(finaltable)
}