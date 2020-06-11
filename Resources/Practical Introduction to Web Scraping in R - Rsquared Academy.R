# Practical Introduction to Web Scraping in R ####
# Rsquared Academy
# Article: https://blog.rsquaredacademy.com/2019/04/11/web-scraping/
# Slides:  https://slides.rsquaredacademy.com/web-scraping/web-scraping.html#/section

# Libraries ####
library(robotstxt)
library(rvest)
library(tidyverse)
library(lubridate)
library(magrittr)

#### 1) IMDB SCRAPE ####

# Check URL robotstxt ####
paths_allowed(paths = c("https://www.imdb.com/search/title?groups=top_250&sort=user_rating"))

# Define URL ####
imdb <- read_html("https://www.imdb.com/search/title?groups=top_250&sort=user_rating")

# Movie Title ####
imdb %>% 
	html_nodes(".lister-item-content h3 a") %>% 
	html_text() -> movie_title
movie_title

# Movie Release Year ####
imdb %>% 
	html_nodes(".lister-item-content h3 .lister-item-year") %>% 
	html_text() %>% 
	str_sub(start = 2, end = 5) %>% 
	as.Date(format = "%Y") %>% 
	year() -> movie_year
movie_year

# Movie Certificate ####
imdb %>% 
	html_nodes(".lister-item-content p .certificate") %>% 
	html_text() -> movie_certificate
movie_certificate

# Movie Runtime ####
imdb %>% 
	html_nodes(".lister-item-content p .runtime") %>% 
	html_text() %>% 
	str_split(" ") %>% 
	map_chr(1) %>% 
	as.numeric() -> movie_runtime
movie_runtime

# Movie Genre ####
imdb %>% 
	html_nodes(".lister-item-content p .genre") %>% 
	html_text() %>% 
	str_trim() -> movie_genre
movie_genre

# Movie Rating ####
imdb %>% 
	html_nodes(".ratings-bar .ratings-imdb-rating") %>% 
	html_attr("data-value") %>% 
	as.numeric() -> movie_rating
movie_rating

# Movie Votes ####
imdb %>%
	html_nodes(xpath = '//meta[@itemprop="ratingCount"]') %>% 
	html_attr('content') %>% 
	as.numeric() -> movie_votes
movie_votes

# Movie Revenue ####
imdb %>% 
	html_nodes(xpath = '//span[@name="nv"]') %>% 
	html_text() %>% 
	str_extract(pattern = "^\\$.*") %>% 
	na.omit() %>% 
	as.character() %>% 
	append(values = NA, after = 18) %>% 
	append(values = NA, after = 29) %>% 
	append(values = NA, after = 31) %>% 
	append(values = NA, after = 46) %>% 
	append(values = NA, after = 49) %>% 
	str_sub(start = 2, end = nchar(.) - 1) %>% 
	as.numeric() -> movie_revenue
movie_revenue

# Combining Movie Data ####
top_50 <- tibble(title = movie_title,
								 release = movie_year,
								 `runtime (mins)` = movie_runtime,
								 genre = movie_genre,
								 rating = movie_rating,
								 votes = movie_votes,
								 `revenue ($ millions)` = movie_revenue)
top_50

#### 2) RBI GOVERNORS ####
# Check URL robotstxt ####
paths_allowed(paths = c("https://en.wikipedia.org/wiki/List_of_Governors_of_Reserve_Bank_of_India"))

# Define URL ####
rbi_gov <- read_html("https://en.wikipedia.org/wiki/List_of_Governors_of_Reserve_Bank_of_India")

# Governor List ####
rbi_gov %>% 
	html_nodes("table") %>% 
	html_table %>% 
	extract2(2) -> profile # pulls 2nd table via magrittr

# Sort Governor List ####
profile %>% 
	separate(`Term in office`, into = c("term", "days")) %>% 
	select(Officeholder, term) %>% 
	arrange(desc(as.numeric(term)))

# Backgrounds ####
profile %>% 
	count(Background)

# Create Categories ####
profile %>%
	pull(Background) %>%
	fct_collapse(
		Bureaucrats = c("IAS officer",
										"ICS officer",
										"Indian Administrative Service (IAS) officer",
										"Indian Audit and Accounts Service officer",
										"Indian Civil Service (ICS) officer"),
		`No Info` = c(""),
		`RBI Officer` = c("Career Reserve Bank of India officer")
	) %>%
	fct_count() %>%
	rename(background = f, count = n) -> backgrounds

backgrounds %>% 
	ggplot() +
	geom_col(aes(background, count), fill = "blue") +
	xlab("Background") +
	ylab("Count") +
	ggtitle("Background of RBI Governors")
