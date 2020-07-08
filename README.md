# Web-Scraping-with-R

## Project to Illustrate Web Scraping with R
This project was created to illustrate scraping data from Amazon with R and rvest.

## A bit on web scraping
Web scraping allows the extraction of data elements from the HTML/CSS of a website.

*ALWAYS* ensure that you have permission from the site before scraping. This is done by checking the `robots.txt` file of a site. This can be done simply with the library `robotstxt` `paths_allowed()` command.

For example, to determine if you can scrape a site, you can run the following:
```
library(robotstxt)
paths_allowed(
  paths = c("https://www.imdb.com/")
)
```

If the result is `TRUE`, you are permitted to scrape the site.

## A little help selecting the right elements
There are a few ways to select elements from a webpage.
1. Inspecting the page via developer tools in any major browser.
2. Selector Gadget (<https://selectorgadget.com/>), which allows point and click selection of elements.

## Presentation
The .html files do not render directly as a true .html file within GitHub. [GitHub & BitBucket HTML Preview](https://htmlpreview.github.io/) works well to convert these .html files into viewable webpages.

**The presentation [can be accessed here](https://htmlpreview.github.io/?https://github.com/mjhendrickson/Web-Scraping-with-R/blob/master/web-scraping-with-r.html#/).**
