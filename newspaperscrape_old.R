#get JSON
install.packages("RJSONIO",  repos='http://cran.us.r-project.org')
install.packages("tm",  repos='http://cran.us.r-project.org')
library(RJSONIO)
#library(httr)
library(tm)
setwd("/usr/local/share/newspapers/raw")


news = fromJSON("http://chroniclingamerica.loc.gov/newspapers.json")  
news1 = news$newspapers

#function for catch the error
catch = function(URL) {
  strURLCont = tryCatch(fromJSON(URL), error = function(e){})
  strURLCont 
}

catch_txt = function(URL) {
  strURLCont = tryCatch(readLines(URL, warn = FALSE), error = function(e){})
  strURLCont 
}

catch_same = function(title){
  tryCatch(dir.create(title), warning = function(w){})
}

#function for waiting 
getpage  = function(URL) {
  time = 0
  #status = http_status(GET(URL))  
  status = catch(URL)
  #while ((!identical(status$category,"success")) & (time < 6)){
  while ((length(status)==0) & (time < 6)){
    Sys.sleep(30)
    #status = http_status(GET(URL))
    status = catch(URL)
    time = time + 1
  }
  fromJSON(URL)
}


getURL  = function(URL) {
  time = 0
  #status = http_status(GET(URL))  
  status = catch(URL)
  #while ((!identical(status$category,"success")) & (time < 5)){
  while ((length(status)==0) & (time < 5)){
    Sys.sleep(30)
    #status = http_status(GET(URL))
    status = catch(URL)
    time = time + 1
  }
  URL
}


#loop of url and title for each newspaper 
url = 0
eachIssue = 0
eachSeq = 0
title = 0
txt = 0
call = 0
fail = 0
fail2 = 0
for (i in 1:length(news1)){

  url[i] = news1[[i]]["url"]   #get each url under each title
  title[i] = news1[[i]]["title"]   #get each title
  dir = catch_same(title[i])
  if(length(dir) == 0){
    dir.create(paste(title[i],news1[[i]]["lccn"], sep = "_"))
    setwd(paste("/usr/local/share/newspapers/raw",paste(title[i],news1[[i]]["lccn"], sep = "_"), sep = "/"))
  }else{
    setwd(paste("C:/Users/bian0553/Desktop/newspaper", title[i], sep = "/"))
    }
  writeLines(toJSON(getpage(news1[[i]]["url"])), "metadata.JSON")  #write the metadata page to a file "metadata.JSON"
  issueNum = length(getpage(news1[[i]]["url"])$issues) #To know how many issues in each title
  print(issueNum)  #show how many issues in this title 
  for(j in 1:issueNum)
  {
    eachIssue[j] = getpage(url[i])$issues[[j]]["url"] #get into each url under each issue
    if(length(catch(getURL(eachIssue[j])))>0)
    {
      seqNum = length(getpage(eachIssue[j])$pages) #To know how many sequences in each issue
      for(k in 1:seqNum )
      {
        eachSeq[k] = getpage(eachIssue[j])$pages[[k]]$url  #get into each url under each sequence (get the txt website)
        if(length(catch(getURL(eachSeq[k]))) > 0 & length(catch_txt(fromJSON(getURL(eachSeq[k]))$text) > 0)){
          txt = readLines(getpage(eachSeq[k])$text, warn = FALSE)  #get text from the website
          call[k] = paste(getpage(eachSeq[k])$issue["date_issued"], getpage(eachSeq[k])$sequence, sep = "_") #name the text
          write.table(news1[[i]]["state"], file = call[k],row.names = FALSE, col.names = FALSE,quote = FALSE) #add state to the text content
          write.table(txt, row.names = FALSE, col.names = FALSE,quote = FALSE, file = call[k], append = TRUE)
        }
        else{
          fail2 = fail2 + 1
          write.table(paste(fail2, i, j, k, sep = ";"), file = "fail_txt", append = TRUE)  
        }
      }
    }
    else { 
      fail = fail + 1 
      write.table(paste(fail, i, j, sep = ";"), file = "fail_issue", append = TRUE)
    } 
  
    print(j)     #show how many sequences in each issue  
  }
  setwd(original)
}




