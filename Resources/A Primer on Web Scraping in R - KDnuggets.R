# A Primer on Web Scraping in R ####
# KDnuggets
# Article: https://www.kdnuggets.com/2018/01/primer-web-scraping-r.html
# Code:    https://gist.githubusercontent.com/anonymous/1f12ee0992981566f9b0bebfb49c6fe0/raw/018872963216eff14ca2c9b53c530558192d9465/web-scraping.r

# Libraries ####
library(rvest)

# URL to scrape ####
# Define the URL
url <- 'http://pgdbablog.wordpress.com/2015/12/10/pre-semester-at-iim-calcutta/'
# Read the HTML
webpage <- read_html(url)

# Identify CSS to extract ####
# Extract ratings
rating_html <- html_nodes(webpage,'.imdb-rating')
# Convert to text
rating <- html_text(rating_html)
rating

# Scraping a page ####
# Scrape post date
post_date_html <- html_nodes(webpage,'.entry-date')
# Convert post date to text
post_date <- html_text(post_date_html)
# Verify date captured
post_date

# Capture the headings ####
# Scrape title and summary sections
title_summary_html <- html_nodes(webpage,'em')
# Convert title data to text
title_summary <- html_text(title_summary_html)
# Check title of the article
title_summary[2]
# Read the title summary of the article
title_summary[1]

# Capture main content from 'p' tag ####
# Scrape blog content
content_data_html <- html_nodes(webpage,'p')
# Convert blog content data to text
content_data <- html_text(content_data_html)
# Check how much content was scraped
length(content_data)
# Read the content of the article ####
# Includes comments section
content_data[1]
content_data[2]
content_data[3]
content_data[4]
content_data[5]
content_data[6]
content_data[7]
content_data[8]
content_data[9]
content_data[10]
content_data[11]

# Since comments were captured, check how many comments were made ####
comments_html <- html_nodes(webpage,'.fn')
# Convert comments to text
comments <- html_text(comments_html)
# Look at the commenter names
comments
# How many comments were made?
length(comments)
# How many diferent people commented?
length(unique(comments))

# Convert the data to a data frame
first_blog <- data.frame(Date = post_date,
												 Title = title_summary[2],
												 Description = title_summary[1],
												 content = paste(content_data[1:11], collapse = ''),
												 commenters = length(comments))
# Check data structure of the data frame
str(first_blog)

# Try it again on another page on the site ####
# Specify url
url <- 'http://pgdbablog.wordpress.com/2015/12/18/pgdba-chronicles-first-semester/'
# Read html
webpage <- read_html(url)
# Scrape rankings section
post_date_html <- html_nodes(webpage,'.entry-date')
# Convert ranking to text
post_date <- html_text(post_date_html)
# Look at the rankings
post_date
# Scrape title section
title_summary_htm <- html_nodes(webpage,'.entry-date')
# Convert title to text
title_summary <- html_text(title_summary_html)
# Look at the title - there are only 6
title_summary[1] # Summary
title_summary[2] # Caption
title_summary[3] # Caption
title_summary[4] # Caption
title_summary[5] # Caption
title_summary[6] # Title heading
# Seeting an html_session
webpage <- html_session(url)
# Getting the image using the tag
Image_link <- webpage %>% html_nodes(".wp-image-54")
# Fetch url to the image
img.url <- Image_link[1] %>% html_attr("src")
# Save image as a jped file in the working directory
download.file(img.url, "test.jpg", mode = 'wb')

# Scraping multiple content ####
# Scraping the cast using titleCast tag
cast_html = html_nodes(webpage,"#titleCast .itemprop span")
# Convert to text
cast = html_text(cast_html)
# See the cast
cast
# Scraping the cast using table tag
cast_table_html = html_nodes(webpage,"table")
# Convert to a table
cast_table = html_table(cast_table_html)
# Check the table for the cast values
cast_table[[1]]
