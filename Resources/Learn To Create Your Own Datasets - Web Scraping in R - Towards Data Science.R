# Learn To Create Your Own Datasets — Web Scraping in R ####
# https://towardsdatascience.com/learn-to-create-your-own-datasets-web-scraping-in-r-f934a31748a5

# ----- Intro -----
# Scraping the web for data is a great way to create a df for analysis.
# One popular tool is rvest by Hadley Wickham.

# This is a 2 part process
  # 1. Use rvest to extract Top 10 Pop Artists of All Time from billboard.com
  # 2. Extract popular song and lyrics of these artists from genius.com

# ----- Set Up Environment -----
library(tidyverse)
library(rvest)

# ----- Extract Top 10 Artists -----
# Identify the URL you want to use, then use read_html().
# Identify the CSS selector for the data (SelectorGadget).
# Use html_nodes() with the CSS selector to get the data.
# Then save the results to a df/tibble.

#Identify the url from where you want to extract data
base_url <- "https://www.billboard.com/charts/greatest-of-all-time-pop-songs-artists"
webpage <- read_html(base_url)

# Get the artist name
artist <- html_nodes(webpage, ".chart-row__artist")
artist <- as.character(html_text(artist))

# Get the artist rank
rank <- html_nodes(webpage, ".chart-row__rank")
rank <- as.numeric(html_text(rank))

# Save it to a tibble
top_artists <- tibble('Artist' = gsub("\n", "", artist),   #remove the \n character in the artist's name
                      'Rank' = rank) %>%
  filter(rank <= 10)

# ----- Extract Pop Songs & Lyrics of Top 10 -----
# Identify the URL you want ot use.
# Use a nested for loop to extrac tthe songs and lyrics.
# Save results into a df/tibble.
# Add a random sleep interval to avoid being booted!

#Format the link to navigate to the artists genius webpage
genius_urls <- paste0("https://genius.com/artists/",top_artists$Artist)

#Initialize a tibble to store the results
artist_lyrics <- tibble()

# Outer loop to get the song links for each artist
for (i in 1:10) {
  genius_page <- read_html(genius_urls[i])
  song_links <- html_nodes(genius_page, ".mini_card_grid-song a") %>%
    html_attr("href")

  #Inner loop to get the Song Name and Lyrics from the Song Link
  for (j in 1:10) {

    # Get lyrics
    lyrics_scraped <- read_html(song_links[j]) %>%
      html_nodes("div.lyrics p") %>%
      html_text()

    # Get song name
    song_name <- read_html(song_links[j]) %>%
      html_nodes("h1.header_with_cover_art-primary_info-title") %>%
      html_text()

    # Save the details to a tibble
    artist_lyrics <- rbind(artist_lyrics, tibble(Rank = top_artists$Rank[i],
                                                 Artist = top_artists$Artist[i],
                                                 Song = song_name,
                                                 Lyrics = lyrics_scraped ))

    # Insert a time lag - to prevent me from getting booted from the site :)
    Sys.sleep(10)
  }
}

#Inspect the results
artist_lyrics