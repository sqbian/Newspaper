# Newspaper

##search_result.R:  
This is a project related with web-scraping the newspaper information. First, define a function seach_process which can scraping the text contents of each seach result on http://chroniclingamerica.loc.gov/search/pages/results/?state=&date1=1789&date2=1922&x=0&y=0&dateFilterType=yearRange&rows=20&searchType=basic&proxtext=
The function has two arguments: object is the term you want to search for. var_searchStartRange_int is the page you want to start to scrape.
The text files you scraped will be saved into local filesystem.

Then the process will be the data mining. First, go into each files in the filesystem, extract the lccn, date from the file name and then use the information to go to the correponding JSON metadata to extract place_of_publication, start_year and end_year. Then save all of information into a local dataframe. 

##cleancode.R
This script is used for data-cleaning the downloaded newspapers and then saving the cleaned texts into a new target folder.

##newspaperscrape_old.R
This is an old way to srape the newspaper before using search_result.R. This process is scrapping all the newspaper texts from JSON and save them to the local filesystem for the aim of researching. First, I gained the information about how many newspaper titles. Then I wrote the functions to enter into each newspaper title link to get the number of issues and the number of sequences under each issue. Each sequence is one piece of newspaper. Therefore, we can get all the newspaper texts by looping all of the sequences, scrapping the texts and saving them to the local filesystem.
This old way is very inefficient so I gave up this and implemented search_result.R, which is more efficient and useful. 
