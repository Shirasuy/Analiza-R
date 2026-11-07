#Zadanie 5 — poznaj respondentów

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

#Zadanie 6

library(dplyr)

# 1. Liczebności i odsetki odpowiedzi na kierunek

tabela_kierunek <- cbos %>%
  filter(!is.na(kierunek)) %>%
  count(kierunek, name = "liczba") %>%
  mutate(
    odsetek = 100 * liczba / sum(liczba)
  ) %>%
  arrange(desc(liczba))

tabela_kierunek

# 2. Najczęstsza odpowiedź

tabela_kierunek %>%
  slice_max(liczba, n = 1)

# 3. Odsetek "W dobrym" w całej próbie

n_cala_proba <- sum(!is.na(cbos$kierunek))

n_w_dobrym <- sum(
  as.character(cbos$kierunek) == "W dobrym",
  na.rm = TRUE
)

odsetek_cala_proba <- 100 * n_w_dobrym / n_cala_proba

# 4. Odsetek "W dobrym" wśród osób,
# które wybrały "W dobrym" lub "W złym"

zdecydowani <- cbos %>%
  filter(
    as.character(kierunek) %in% c("W dobrym", "W złym")
  )

n_zdecydowani <- nrow(zdecydowani)

n_dobrym_zdecydowani <- sum(
  as.character(zdecydowani$kierunek) == "W dobrym"
)

odsetek_zdecydowani <- 100 * n_dobrym_zdecydowani / n_zdecydowani

# 5. Porównanie

tibble(
  grupa = c("Cała próba", "Osoby zdecydowane"),
  liczba = c(n_w_dobrym, n_dobrym_zdecydowani),
  mianownik = c(n_cala_proba, n_zdecydowani),
  odsetek = c(odsetek_cala_proba, odsetek_zdecydowani)
)

