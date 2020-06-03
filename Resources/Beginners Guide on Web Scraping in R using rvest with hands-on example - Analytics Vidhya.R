# Beginner’s Guide on Web Scraping in R (using rvest) with hands-on example ####
# Analytics Vidhya
# https://www.analyticsvidhya.com/blog/2017/03/beginners-guide-on-web-scraping-in-r-using-rvest-with-hands-on-knowledge/

# Libraries ####
library(rvest)
library(ggplot2)

# URL to scrape ####
url <- 'http://www.imdb.com/search/title?count=100&release_date=2016,2016&title_type=feature'

# Read the HTML ####
webpage <- read_html(url)

# Scrape rank for each title ####
# Use selector gadget Chrome extension
rank_data_html <- html_nodes(webpage,'.text-primary')
# Converting rankings data to text
rank_data <- html_text(rank_data_html)
head(rank_data)
# Convert to numerical
rank_data <- as.numeric(rank_data)
head(rank_data)

# Scrape titles ####
title_data_html <- html_nodes(webpage,'.lister-item-header a')
# Convert title to text
title_data <- html_text(title_data_html)
head(title_data)

# Scrape descriptions ####
description_data_html <- html_nodes(webpage,'.ratings-bar+ .text-muted')
#Convert to text
description_data <- html_text(description_data_html)
head(description_data)
# Remove '\n'
description_data <- gsub("\n","",description_data)
head(description_data)

# Scrape Movie runtime ####
runtime_data_html <- html_nodes(webpage,'.text-muted .runtime')
# Convert to text
runtime_data <- html_text(runtime_data_html)
head(runtime_data)
# Remove 'min' from runtime, convert to numeric
runtime_data <- gsub(" min","",runtime_data)
runtime_data <- as.numeric(runtime_data)
head(runtime_data)

# Scrape Genre ####
genre_data_html <- html_nodes(webpage,'.genre')
# Convert to text
genre_data <- html_text(genre_data_html)
head(genre_data)
# Remove '\n' & excess spaces
genre_data <- gsub("\n","",genre_data)
genre_data <- gsub(" ","",genre_data)
# Get 1st genre for each movie
genre_data <- gsub(",.*","",genre_data)
# Genre - text to factor
genre_data <- as.factor(genre_data)
head(genre_data)

# Scrape IMDB rating ####
rating_data_html <- html_nodes(webpage,'.ratings-imdb-rating strong')
# Convert to text
rating_data <- html_text(rating_data_html)
head(rating_data)
# Convert to numeric
rating_data <- as.numeric(rating_data)
head(rating_data)

# Scrape votes ####
votes_data_html <- html_nodes(webpage,'.sort-num_votes-visible span:nth-child(2)')
# Convert to text
votes_data <- html_text(votes_data_html)
head(votes_data)
# Remove commas
votes_data <- gsub(",","",votes_data)
# Convert to numeric
votes_data <- as.numeric(votes_data)
head(votes_data)

# Scrape directors ####
directors_data_html <- html_nodes(webpage,'.text-muted+ p a:nth-child(1)')
# Convert to text
directors_data <- html_text(directors_data_html)
head(directors_data)
# Convert to factors
directors_data <- as.factor(directors_data)
head(directors_data)

# Scrape actors ####
actors_data_html <- html_nodes(webpage,'.lister-item-content .ghost+ a')
# Convert to text
actors_data <- html_text(actors_data_html)
head(actors_data)
# Convert to factors
actors_data <- as.factor(actors_data)
head(actors_data)

# Scrape metascore ####
metascore_data_html <- html_nodes(webpage,'.metascore')
# Convert to text
metascore_data <- html_text(metascore_data_html)
head(metascore_data)
# Remove extra spaces
metascore_data <- gsub(" ","",metascore_data)
head(metascore_data)
length(metascore_data)
# Some do not have metascores - but which?
# Function to assign metascores to the right movies
for (i in c(13,56,95)){
	a <- metascore_data[1:(i-1)]
	b <- metascore_data[i:length(metascore_data)]
	metascore_data <- append(a,list("NA"))
	metascore_data <- append(metascore_data,b)
}
# Convert to numeric
metascore_data <- as.numeric(metascore_data)
length(metascore_data)
summary(metascore_data)

# Scrape Gross Earnings ####
gross_data_html <- html_nodes(webpage,'.ghost~ .text-muted+ span')
# Convert to text
gross_data <- html_text(gross_data_html)
head(gross_data)
# Remove '$' and 'M'
gross_data <- gsub("M","",gross_data)
gross_data <- substring(gross_data,2,6)
length(gross_data)
# Fill missing entries with NA
for (i in c(13,51,55,57,61,67,71,73,84,89,91,93,95)){
	a <- gross_data[1:(i-1)]
	b <- gross_data[i:length(gross_data)]
	gross_data <- append(a,list("NA"))
	gross_data <- append(gross_data,b)
}
# Convert to numeric
gross_data <- as.numeric(gross_data)
length(gross_data)
summary(gross_data)

# Combine features into a dataframe ####
movies_df <- data.frame(
	Rank = rank_data,
	Title = title_data,
	Description = description_data,
	Runtime = runtime_data,
	Genre = genre_data,
	Rating = rating_data,
	Metascore = metascore_data,
	Votes = votes_data,
	Gross_Earning_in_Mil = gross_data,
	Director = directors_data,
	Actor = actors_data
)
# Structure for dataframe
str(movies_df)

# Analyze data ####
# Which movie Genre runs longest?
qplot(data = movies_df, Runtime, fill = Genre, bins = 30)

# In 130-160 runtime, which genre had the highest votes?
ggplot(movies_df, aes(x = Runtime, y = Rating)) +
	geom_point(aes(size = Votes, col = Genre))

# Which genre had the highest earnings in runtime
ggplot(movies_df, aes(x = Runtime, y = Gross_Earning_in_Mil)) +
	geom_point(aes(size = Rating, col = Genre))