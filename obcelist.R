library(xml2)
cislaobci <- c("546097", "582433")
testurl <- "http://volby.cz/pls/kv2014/vysledky_obce_okres?datumvoleb=20141010&nuts=CZ0203"
xx <- read_xml(testurl)
xml_ns(xx)
# str(xx)
xx <- xml_ns_strip(xx)
xml_find_all(xx, ".//VYSLEDEK/VOLEBNI_STRANA")
yy <- as_list(xx)
# str(yy)
zz <- unlist(yy)


library(httr)
library(XML)
response = POST(testurl)

xml_record = content(response, "parsed", type="text/xml", encoding = "ISO8859-2")
tree <- xmlTreeParse(xml_record)
path = ".//VYSLEDKY_OBCE_OKRES"
xml_extract = tree[[path]]
xpathSApply(xml_extract, "//OBEC", xmlGetAttr, "KODZASTUP")

library(XML2R)
df <- XML2R(testurl, "//VYSLEDKY_OBCE_OKRES")
