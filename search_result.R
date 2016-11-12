library(XML)
setwd("C:/Users/bian0553/Desktop/newspaper")

# define an output path for the Text files 
var_textOutputFilePath_character = "/Users/bian0553/Desktop/newspaper/search_result"

#read lines error preventing
catch_txt = function(URL) {
  strURLCont = tryCatch(readLines(URL, warn = FALSE), error = function(e){})
  strURLCont 
}

##parse error preventing
catch_parse = function(URL) {
  strURLCont = tryCatch(htmlParse(URL), error = function(e){})
  strURLCont 
}


#function for waiting 
getpage  = function(URL) {
  time = 0
  status = catch_txt(URL)
  count = as.numeric(length(status))
  while((class(status) == "NULL") && (time < 6)){
    Sys.sleep(5)
    status = catch_txt(URL)
    time = time + 1
  }
  catch_txt(URL)
}

##function for waiting until it works
getParse  = function(URL) {
  time = 0
  status = catch_parse(URL)
  count = as.numeric(length(status))
  while(class(status) == "NULL"){
    Sys.sleep(5)
    status = catch_parse(URL)
  }
  catch_parse(URL)
}



search_process = function(object,var_searchStartRange_int){
  # define the URL for the search
  var_searchURL_character <- "http://chroniclingamerica.loc.gov/search/pages/results/?state=&date1=1789&date2=1922&x=0&y=0&dateFilterType=yearRange&rows=20&searchType=basic&proxtext="
  # define the URL for the search
  var_searchURL_character <- paste(var_searchURL_character, object, sep="")
  getdoc <- getParse(var_searchURL_character)  
  # define an end to the page range for the search
  getpageno <- lapply(getdoc['//span[@class="pagination"]'],xmlValue) 
  getpageno <- unlist(getpageno)[1]
  var_searchEndRange_int = max(as.numeric(unlist(strsplit(getpageno," "))),na.rm = TRUE) 
  for (var_page_int in var_searchStartRange_int:var_searchEndRange_int) {
    # define the URL for the search
    var_iterationSearchUrl_character <- paste(var_searchURL_character, paste0('&page=',var_page_int), sep="")
    getdoc <- getParse(var_iterationSearchUrl_character)
    getid <- lapply(getdoc['//input[@name ="id"]'],xmlAttrs)
    getlink <- unname(sapply(1:length(getid),function(i)getid[[i]]['value']))
    base = 'http://chroniclingamerica.loc.gov'
    for (i in 1:length(getlink)){
      text = paste0(paste0(base,getlink[i]),'ocr.txt')
      filename = unlist(strsplit(getlink[i],'/'))
      filename = filename[filename!='lccn'&filename!='']
      filename = do.call(paste,as.list(filename))
      filename = paste(var_textOutputFilePath_character,gsub(" ","_",filename),sep = "/")
      content = getpage(text)
      if(class(content) != "NULL"){
        write.table(content, row.names = FALSE, col.names = FALSE,quote = FALSE, file = filename)
      }
    }
    print(var_page_int)
  }
}


search_process("creativeness",1)


##Construct a form showing metadat
#get the file names under the searched result folder
files = list.files(var_textOutputFilePath_character)

checkerror = function(metadata, object){
  if (length(metadata$object) == 0){
    
  }
}

#input files
create_form = function(files){
  n = length(files)
  #create an empty dataframe
  df <- data.frame(Filename = character(n), Name = character(n),Place = character(n), Date = character(n), stringsAsFactors = FALSE)
  for (i in 1:n){
    #get lccn number
    df$Filename[i] = files[i]
    lccn = unlist(strsplit(files[i],'_'))[1]
    df$Date[i] = unlist(strsplit(files[i],'_'))[2]
    metadata = fromJSON(paste0(paste0('http://chroniclingamerica.loc.gov/lccn/',lccn),'.json'))
    if(length(metadata$place_of_publication) == 0){
      df$Place[i] = NA
    }else{df$Place[i] = metadata$place_of_publication}
    
    if(length(metadata$name) == 0){
      df$Name[i] = NA
    }else{df$Name[i] = metadata$name}
    
    if(length(metadata$start_year) == 0){
      df$Start_year[i] = NA
    }else{df$Start_year[i] = metadata$start_year}
    
    if(length(metadata$end_year) == 0){
      df$End_year[i] = NA
    }else{df$End_year[i] = metadata$end_year}
  }
  df
}


form = create_form(files)


write.csv(form,file = 'metadata_search.csv')




