library(haven)
library(dplyr)
adres_cbos <- paste0("https://raw.githubusercontent.com/kflisikowsky/sad/",
                     "main/data/CBOS_201733_331_SPSS.sav")
plik_cbos <- tempfile(fileext = ".sav")
download.file(adres_cbos, plik_cbos, mode = "wb", quiet = TRUE)
cbos_raw <- read_sav(plik_cbos)
unlink(plik_cbos)

cbos <- cbos_raw %>% transmute(
  plec = as_factor(plec),
  miejscowosc = as_factor(klm6),
  kierunek = as_factor(q24),
  prognoza = as_factor(q25),
  wyksztalcenie = as_factor(q15)
)
dim(cbos)
head(cbos)

attach(cbos)

#zadanie 7

zadanie7 <- cbos %>%
  filter(miejscowosc=="wieś" | miejscowosc=="miasto 500 000 i więcej") %>%
  group_by(miejscowosc) %>%
  count(kierunek, name = "liczba") %>%
  mutate(procent = 100 * liczba / sum(liczba))

zadanie7

#zadanie 8

zadanie8 <- cbos %>%
  filter(kierunek == "W złym") %>%
  count(prognoza, name = "liczba", sort = TRUE) %>%
  mutate(procent = 100 * liczba / sum(liczba))

zadanie8