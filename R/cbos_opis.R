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

# Liczba obserwacji i braków danych
dim(cbos)

cbos %>%
  summarise(
    liczba_obserwacji = n(),
    braki_plec = sum(is.na(plec)),
    braki_miejscowosc = sum(is.na(miejscowosc))
  )

# Tabela liczności i odsetków dla płci
tabela_plec <- cbos %>%
  filter(!is.na(plec)) %>%
  count(plec, name = "liczba") %>%
  mutate(
    odsetek = 100 * liczba / sum(liczba)
  )

tabela_plec

# Tabela liczności i odsetków dla miejscowości
tabela_miejscowosc <- cbos %>%
  filter(!is.na(miejscowosc)) %>%
  count(miejscowosc, name = "liczba") %>%
  mutate(
    odsetek = 100 * liczba / sum(liczba)
  )

tabela_miejscowosc
