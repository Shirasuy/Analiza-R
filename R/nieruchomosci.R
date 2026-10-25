## 2. Nieruchomości: co wpływa na cenę jednostkową?

#Źródło: [Real Estate Valuation (UCI)](https://archive.ics.uci.edu/dataset/477/real+estate+valuation+data+set), [plik CSV w repozytorium prowadzącego](https://github.com/kflisikowsky/pandas_exercises/blob/62863036107888c0c7273c40e8d309a43f4da3a9/data/models/real_estate.csv). To **414 historycznych obserwacji** z rynku nieruchomości w New Taipei (Tajwan). Zmienna ceny oznacza 10 000 TWD za ping, a nie cenę całej nieruchomości. Przyjmujemy 1 ping ≈ 3,3 m².

library(dplyr)
library(tidyr)

adres_nieruchomosci <- paste0(
  "https://raw.githubusercontent.com/kflisikowsky/pandas_exercises/",
  "62863036107888c0c7273c40e8d309a43f4da3a9/data/models/real_estate.csv"
)
raw_nier <- read.csv(adres_nieruchomosci, check.names = FALSE)
stopifnot(nrow(raw_nier) == 414, ncol(raw_nier) == 7)

nier <- raw_nier
names(nier) <- c("id", "wiek_lat", "metro_m", "sklepy", "lat", "lon",
                 "cena_10k_twd_ping")
head(nier)

#| Zmienna | Znaczenie |
 # |:--|:--|
  #| `wiek_lat` | wiek budynku w latach |
  #| `metro_m` | odległość do najbliższej stacji MRT w metrach |
  #| `sklepy` | liczba sklepów w otoczeniu |
  #| `lat`, `lon` | współrzędne geograficzne |
  #| `cena_10k_twd_ping` | cena jednostkowa w 10 000 TWD/ping |
  
  ### Zadanie 1 — najpierw sprawdź tabelę
  
#Sprawdź liczbę rekordów i kolumn, typy danych, liczbę braków oraz podstawowe statystyki. Zweryfikuj, czy `id` jest unikatowe. Wskaż zmienne liczbowe, których nie powinno się interpretować jako zwykłych miar ilościowych (np. identyfikator).

# WASZE ROZWIĄZANIE
nrow(nier)
ncol(nier)
dim(nier)
#dim to to samo co nrow+ncol
str(nier)
summary(nier)
colSums(is.na(nier))
#nie ma braków
anyDuplicated(nier$id)
#id jest unikatowe
# dim(), str(), summary(), colSums(is.na(...)), anyDuplicated()

### Zadanie 2 — przelicz cenę i sprawdź jej rozkład
#Dodaj kolumnę `cena_twd_m2`: `cena_10k_twd_ping * 10000 / 3.3`. Oblicz minimum, medianę, średnią i maksimum ceny za m². Wyświetl pięć nieruchomości o najwyższej cenie jednostkowej wraz z ich wiekiem, odległością od metra i liczbą sklepów.

#Pytanie: czy średnia jest wyższa od mediany? Co to mówi o rozkładzie cen? Nie interpretuj tej ceny jako wartości całego lokalu.

# WASZE ROZWIĄZANIE
# mutate(), summarise(), arrange(desc(...)), slice_head(n = 5)

### Zadanie 3 — ile obserwacji jest blisko metra?

#Policz, ile nieruchomości znajduje się w odległości do 500 m od stacji oraz jaki to odsetek wszystkich rekordów. Następnie porównaj mediany ceny TWD/m² w dwóch grupach: **do 500 m** i **powyżej 500 m**.

#Wynik opisz jednym zdaniem z liczbami i jednostkami. To proste porównanie opisowe, a nie dowód, że odległość powoduje zmianę ceny.

# WASZE ROZWIĄZANIE
# Wskazówka: mutate(blisko_metra = metro_m <= 500)
# group_by(blisko_metra) %>% summarise(liczba = n(), mediana = median(...))

### Zadanie 4 — wiek, odległość i sklepy

#Podziel obserwacje na trzy strefy odległości od metra: **do 500 m**, **powyżej 500 do 1500 m**, **powyżej 1500 m**. Dla każdej strefy oblicz liczbę obserwacji, medianę ceny TWD/m², medianę wieku i średnią liczbę sklepów.

#Następnie sprawdź, czy wśród budynków w wieku najwyżej 20 lat ranking median stref pozostaje taki sam. Dlaczego porównanie wszystkich budynków może różnić się od porównania budynków młodszych?
  
# Przykład tworzenia zmiennej grupującej
nier <- nier %>% mutate(
  strefa = cut(metro_m, c(-Inf, 500, 1500, Inf),
               labels = c("do 500 m", "500–1500 m", "ponad 1500 m"))
)

# WASZE ROZWIĄZANIE
# group_by(strefa), summarise(), filter(wiek_lat <= 20)
