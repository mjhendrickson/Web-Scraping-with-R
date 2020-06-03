# Web-Scraping-with-R

## Project to Illustrate Web Scraping with R
This project seeks to collect resources and provide examples of web scraping with R

## A bit on web scraping
Web scraping allows the extraction of data elements from them HTML and/or CSS of a website.

*ALWAYS* ensure that you have permission from the site before scraping. This is done by checking the `robots.txt` file of a site. This can be done simply with the library `robotstxt` `paths_allowed()` command.

For example, to determine if you can scrape a site, you can run the following:
```
library(robotstxt)
paths_allowed(
  paths = c("https://www.imdb.com/")
)
```

If the result is `TRUE`, you are permitted to scrape the site.
