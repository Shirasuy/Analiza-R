dane$Release.Date <- as.Date(dane$Release.Date, format = '%m/%d/%y')
dane %>%
  filter(Director == "Woody Allen") %>%
  sort(Release.Date, decreasing = TRUE) %>%
  head(1)

