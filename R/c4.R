dane %>%
  filter(Languages == "Polish") %>%
  separate_rows(Tags, sep = ",") %>%
  count(Tags) %>%
  arrange(desc(n)) %>%
  slice_head(n = 3)
  
  #arrange(Tags) %>%
  #select(Title, Tags, Languages) %>%
  #head(3)