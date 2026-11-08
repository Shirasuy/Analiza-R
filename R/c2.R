dane %>%
  filter(Genre == "Comedy" & Languages == "Polish") %>%
  arrange(desc(IMDb.Score)) %>%
  select(Title, Genre, Languages, IMDb.Score) %>%
    head(3)