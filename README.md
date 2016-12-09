# Newspaper

##search_result.R:  This is a project related with web-scraping the newspaper information. First, define a function seach_process which can scraping the text contents of each seach result on http://chroniclingamerica.loc.gov/search/pages/results/?state=&date1=1789&date2=1922&x=0&y=0&dateFilterType=yearRange&rows=20&searchType=basic&proxtext=
The function has two arguments: object is the term you want to search for. var_searchStartRange_int is the page you want to start to scrape.
The text files you scraped will be saved into local filesystem.

Then the process will be the data mining. First, go into each files in the filesystem, extract the lccn, date from the file name and then use the information to go to the correponding JSON metadata to extract place_of_publication, start_year and end_year. Then save all of information into a local dataframe. 

##cleancode.R
This script is used for data-cleaning the downloaded newspapers and then saving the cleaned texts into a new target folder.
