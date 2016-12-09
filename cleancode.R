#get JSON
install.packages("RJSONIO",  repos='http://cran.us.r-project.org')

install.packages("tm",  repos='http://cran.us.r-project.org')
library(RJSONIO)

library(tm)
setwd("/usr/local/share/newspapers/raw")


news = fromJSON("http://chroniclingamerica.loc.gov/newspapers.json")  
news1 = news$newspapers 



#Loop for removing punctuation & single word
let = letters[-c(1,9)] 
let1 = paste0(let, "\\s+")
let = paste0("\\s+", let1)  # get the single lowercase letters with one or many whitespaces before and after

LET = LETTERS[-c(1,9)]
LET1 = paste0(LET, "\\s+")
LET = paste0("\\s+", LET1)  # get the single uppercase letters with one or many whitespaces before and after

original = c("/usr/local/share/newspapers/raw")
target = c("/usr/local/share/newspapers/cleaned")

ff = 0
doc = 0
read = 0
name = 0
for (i in 1:length(news1))
{
  setwd(original)
  ff[i] = file.path(original, news1[[i]]["title"]) #go to each foler to loop the files 
  filesNum = length(dir(ff[i]))-1  #don't want to include metadata file. 
  setwd(target)   #set dir to the cleaned newspaper folder
  dir.create(news1[[i]]["title"])  #Name the folder using the title
  setwd(paste(target, news1[[i]]["title"], sep = "/"))
  for(j in 1:filesNum)
  {
    doc = tm_map(Corpus(DirSource(ff[i], mode = "text", encoding = "UTF-8"), 
                        readerControl = list(language = "lat")), removePunctuation)
    doc = tm_map(doc, stripWhitespace)
    doc = tm_map(doc, removeWords,let)
    doc = tm_map(doc, removeWords,LET)
    name[j] = list.files(paste(original,news1[[i]]["title"], sep = "/"))[j]  #give names from the original folder to new texts
    writeLines(as.character(doc[[j]]), name[j])
  }
}
