> #### Giulia Condorelli
>> ##### matricola n. 1185693

#  🏔️

In questo lavoro è stato analizzato tramite telerilevamento satellitare l'**impatto sulla copertura vegetale** di alcune opere relative ai **XXV Giochi Olimpici Invernali**, previsti a Milano, Cortina d'Ampezzo e altre località delle Alpi Italiane per il febbraio 2026.

Nel dettaglio, è stata confrontata la situazione **tra il 2019 e il 2025** in alcune località situate in **Valle del Boite** (provincia di Belluno) interessate da opere direttamente o indirettamente connesse alle Olimpiadi, ovvero:
+ **Cortina d'Ampezzo**, sede dei Giochi, presso cui sono recentemente terminati i lavori per l'**ammodernamento della Pista Olimpica *"Eugenio Monti"*** dove si terranno le discipline di bob, slittino e skeleton;
+ **San Vito di Cadore**, dove sono in corso i lavori per la **costruzione di una variante stradale** alla Strada statale 51 di Alemagna che permetta di alleggerire il traffico all'interno del centro cittadino;
+ **Tai di Cadore**, dove sempre per la SS51 è in costruzione una **galleria stradale** a sud dell'abitato in modo da evitarne l'attraversamento.
---
title: "Analisi dell’Impatto dei Pascoli sulla Vegetazione del Campo Imperatore (2015-2025)"
subtitle: "Progetto LIFE11/NAT/IT/234 - PRATERIE"
author: "Giulia Condorelli"
date: "`r Sys.Date()`"
output:
  html_document:
    toc: true
    toc_depth: 3
    number_sections: true
    theme: cerulean
    highlight: tango
---

# 📌 Introduzione

Il progetto **LIFE PRATERIE** (LIFE11/NAT/IT/234) si propone la conservazione a lungo termine delle **praterie e dei pascoli** nel territorio del **Parco Nazionale del Gran Sasso e Monti della Laga**, con particolare attenzione all’equilibrio tra **attività produttive** (come il pascolo estensivo) e **tutela ambientale**.

Campo Imperatore rappresenta una delle aree più sensibili, interessata da:

- pascolo non regolamentato,
- sovraccarico da parte del bestiame in specifiche zone,
- ridotta disponibilità di infrastrutture (es. abbeveratoi),
- impatto crescente del turismo su strada e escursionistico.

---

# 🛰️ Obiettivo del Progetto in R

L’obiettivo dell’elaborazione telerilevata in R è **monitorare i cambiamenti nella vegetazione** dal **2015 al 2025**, utilizzando immagini **Sentinel-2** e calcolando alcuni **indici spettrali**, in particolare:

- **NDVI** (Normalized Difference Vegetation Index)
- **DVI** (Difference Vegetation Index)
- **NDWI** (Normalized Difference Water Index)

---

# 🧪 Dati e Metodologia

```r
# Caricamento pacchetti
library(terra)
library(imageRy)
library(viridis)
library(ggplot2)
library(patchwork)

# Importazione raster Sentinel-2
campoimp15 <- rast("CampoImp2015.tif")
campoimp25 <- rast("CampoImp2025.tif")

# Calcolo indici spettrali
ndvi_2015 <- im.ndvi(campoimp15, 4, 1)
ndvi_2025 <- im.ndvi(campoimp25, 4, 1)
dvi_2015 <- im.dvi(campoimp15, 4, 1)
dvi_2025 <- im.dvi(campoimp25, 4, 1)
ndwi_2015 <- im.ndwi(campoimp15, 3, 8)
ndwi_2025 <- im.ndwi(campoimp25, 3, 8)

# 🌿 Analisi NDVI

L’NDVI è uno degli indici più utilizzati per misurare la densità e salute della vegetazione. I valori si distribuiscono tra -1 e 1.

# Istogramma distribuzione NDVI
hist(ndvi_2015, main = "NDVI 2015", col = "darkgreen")
hist(ndvi_2025, main = "NDVI 2025", col = "darkblue")

Classificazione per classi di vegetazione:
class_matrix <- matrix(c(-Inf, 0.2, 1, 0.2, 0.4, 2, 0.4, Inf, 3), ncol = 3, byrow = TRUE)
ndvi_2015_cl <- classify(ndvi_2015, class_matrix)
ndvi_2025_cl <- classify(ndvi_2025, class_matrix)

# Calcolo percentuali
freq_2015 <- freq(ndvi_2015_cl)
freq_2025 <- freq(ndvi_2025_cl)
perc_2015 <- freq_2015$count * 100 / ncell(ndvi_2015_cl)
perc_2025 <- freq_2025$count * 100 / ncell(ndvi_2025_cl)
tab <- data.frame(
  classi = c("Suolo nudo", "Vegetazione media", "Vegetazione sana"),
  a2015 = round(perc_2015, 2),
  a2025 = round(perc_2025, 2)
)
print(tab)

Visualizzazione
p1 <- ggplot(tab, aes(x = classi, y = a2015, fill = classi)) +
  geom_bar(stat = "identity") +
  scale_fill_viridis_d() +
  ylim(0, 100) +
  labs(title = "Classi NDVI 2015", y = "%", x = NULL) +
  theme_minimal()

p2 <- ggplot(tab, aes(x = classi, y = a2025, fill = classi)) +
  geom_bar(stat = "identity") +
  scale_fill_viridis_d() +
  ylim(0, 100) +
  labs(title = "Classi NDVI 2025", y = "%", x = NULL) +
  theme_minimal()

p1 + p2

💧 Analisi NDWI

L’NDWI (Normalized Difference Water Index) evidenzia la presenza e lo stress idrico della vegetazione.

ndwi_diff <- ndwi_2025 - ndwi_2015
plot(ndwi_diff, col = viridis(100), main = "Differenza NDWI (2025 - 2015)")

📉 Differenze multitemporali
ndvi_diff <- ndvi_2025 - ndvi_2015
plot(ndvi_diff, col = viridis(100), main = "Differenza NDVI (2025 - 2015)")


Risultano evidenti zone di degrado vegetativo nei pressi delle aree sovraccariche di pascolo e lungo i principali assi turistici.

📌 Commenti e Conclusioni

L’analisi ha evidenziato cambiamenti significativi tra il 2015 e il 2025:

Forte riduzione della vegetazione sana (NDVI > 0.4) e incremento di aree a suolo nudo o vegetazione degradata.

Presenza di stress idrico in molte aree (valori NDWI in calo).

I dati supportano la necessità di regolamentare i pascoli, migliorare le infrastrutture e gestire il turismo con maggiore attenzione.

🎯 Il contributo del telerilevamento

L’uso del telerilevamento ha permesso un’analisi spaziale e temporale oggettiva, evidenziando come l’attività antropica (pascolo e turismo) impatti sulla biodiversità e sulla qualità degli habitat.

📎 Riferimenti

LIFE11/NAT/IT/234 – PRATERIE: Sito ufficiale del progetto

Documentazione Sentinel-2 ESA

Pacchetti R: terra, imageRy, ggplot2, viridis, patchwork
