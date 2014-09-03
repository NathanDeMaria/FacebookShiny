# To run:

- Make sure you have the packages listed below installed.
- Follow the instructions for putting files in a <code>~/data/</code> folder. You need to find/add AFFIN-111.txt and secrets.csv
- In RStudio, open <code>~/app/server.R</code>, <code>~/app/global.R</code>, or <code>~/app/ui.R</code> and click "Run App".  Alternatively, set the working directory to <code>~/app/</code> and run <code>library(shiny); runApp()</code>

# Packages used:
- shiny
- shinyIncubator (from rstudio's GitHub)
- ggvis
- RJSONIO
- lubridate
- stringr
- data.table
- httr
- igraph

# data folder
For "sentiment" portion:

Download AFFIN-111.txt from http://www2.imm.dtu.dk/pubdb/views/publication_details.php?id=6010
Place in <code>~/data/</code>
You can use a different library if you want to. Right now, the format it looks for is .tsv.
The first column is a word and second is the score for that word. See below for sample.
```
abandon	-2
abandoned	-2
abandons	-2
abducted	-2
abduction	-2
```

Also in the <code>~/data/</code> directory, I have a file called <code>secrets.csv</code>.
In this file, I have entries for the cohort page's group id, and my Facebook token.
The file looks like this:
```
keys,values
cohort_page,<cohort page id>
api_token,<api token>
```
