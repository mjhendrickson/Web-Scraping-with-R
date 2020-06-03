# Web Scraping Specialized Bike Site in R
# https://www.business-science.io/code-tools/2019/10/07/rvest-web-scraping.html

# Load libraries ####
library(rvest)     # HTML Hacking & Web Scraping
library(jsonlite)  # JSON manipulation
library(tidyverse) # Data Manipulation
library(tidyquant) # ggplot2 theme
library(xopen)     # Opens URL in Browser
library(knitr)     # Pretty HTML Tables

# URL to View All Bikes ####
url <- "https://www.specialized.com/us/en/shop/bikes/c/bikes?q=%3Aprice-desc%3Aarchived%3Afalse&show=All"

# View URL in Browser ####
xopen(url)

# Read HTML from URL ####
html <- read_html(url)
html

# Filter HTML to isolate nodes ####
html %>%
  html_nodes(".product-list__item-wrapper")

# Extract Attribute Data - store JSON as object ####
json <- html %>%
  html_nodes(".product-list__item-wrapper") %>%
  html_attr("data-product-ic")

# Show the 1st JSON element (1st of all bikes) ####
json[1]

# Create function to convert JSON to Tibble ####
from_json_to_tibble <- function(json) {
  json %>%
    fromJSON() %>%
    as_tibble()
}

# Run on 1st element of list ####
json[1] %>%
  from_json_to_tibble() %>%
  knitr::kable()

# Iterate over all JSON elements ####
bike_data_list <- json %>%
  map(safely(from_json_to_tibble))

# Inspect first conversion: $result & $error ####
bike_data_list[1]

# Inspect for errors ####
error_tbl <- bike_data_list %>%
  # Grab just the $error elements
  map(~ pluck(., "error")) %>%
  # Convert from list to tibble
  enframe(name = "row") %>%
  # Return TRUE if element has error
  mutate(is_error = map(value, function(x) !is.null(x))) %>%
  # Unnest nested list
  unnest(is_error) %>%
  # Filter where error == TRUE
  filter(is_error)
error_tbl

# Check the error ####
error_tbl %>%
  pluck("value", 1)
# Due to a " symbol

# Replace " ####
json[222] %>%
  str_replace('22.5\\" TT', '22.5 TT') %>%
  from_json_to_tibble()
json[222] %>%
  str_replace('\\"BMX / Dirt Jump\\"', 'BMX / Dirt Jump') %>%
  str_replace('22.5\\" TT', '22.5 TT') %>%
  from_json_to_tibble()

# Run again and ensure there are no errors ####
bike_features_tbl <- json %>%
  str_replace('\\"BMX / Dirt Jump\\"', 'BMX / Dirt Jump') %>%
  str_replace('22.5\\" TT', '22.5 TT') %>%
  map_dfr(from_json_to_tibble)

# Show first 6 rows ####
bike_features_tbl %>%
  head() %>%
  kable()

# Explore bike models ####
bike_features_tbl %>%
  select(dimension3, price) %>%
  mutate(dimension3 = as_factor(dimension3) %>%
           fct_reorder(price, .fun = median)) %>%
  # Plot
  ggplot(aes(dimension3, price)) +
  geom_boxplot() +
  coord_flip() +
  theme_tq() +
  scale_y_continuous(labels = scales::dollar_format()) +
  labs(title = "Specialized Bike Models by Price")

# Update plot to segment bikes with 'S-Works" in the model ####
bike_features_tbl %>%
  select(name, price, dimension3) %>%
  mutate(s_works = ifelse(str_detect(name, "S-Works"), "S-Works", "Not S-Works")) %>%
  mutate(dimension3 = as_factor(dimension3) %>%
           fct_reorder(price, .fun = median)) %>%
  # Plot
  ggplot(aes(dimension3, price, color = s_works)) +
  geom_boxplot() +
  coord_flip() +
  facet_wrap(~ s_works, ncol = 1, scales = "free_y") +
  theme_tq()  +
  scale_color_tq() +
  scale_y_continuous(labels = scales::dollar_format()) +
  labs(title = "S-Works Effect on Price by Model")