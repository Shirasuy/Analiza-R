dane %>%
  filter(Genre == "Comedy" & Languages == "Polish") %>%
  arrange(desc(IMDb.Score)) %>%
  head(3)