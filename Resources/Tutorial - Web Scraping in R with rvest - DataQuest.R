# Tutorial: Web Scraping in R with rvest ####
# DataQuest
# https://www.dataquest.io/blog/web-scraping-in-r-rvest/

# Libraries ####
library(rvest)
library(readr)

# Read HTML ####
simple <- read_html("http://dataquestio.github.io/web-scraping-pages/simple.html")
simple

# Extract the 'p' level of html ####
simple %>%
	html_nodes("p") %>%
	html_text()

# Scrape weather forecast from weather.gov ####
forecasts <- read_html("https://forecast.weather.gov/MapClick.php?lat=37.7771&lon=-122.4196#.Xl0j6BNKhTY") %>%
	html_nodes(".temp") %>%
	html_text()
forecasts
# Use `readr` to extract the numerical forecast
parse_number(forecasts)
