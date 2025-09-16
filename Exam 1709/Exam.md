> #### Giulia Condorelli
>> ##### matricola n. 1185693

# Analisi dell’Impatto dei Pascoli sulla Vegetazione del Campo Imperatore (2015-2025) 🐄

---

# 📌 Introduzione

Il progetto **LIFE PRATERIE** (LIFE11/NAT/IT/234) propone la conservazione a lungo termine delle **praterie e dei pascoli** nel territorio del **Parco Nazionale del Gran Sasso e Monti della Laga**, con particolare attenzione all’equilibrio tra **attività produttive** (come il pascolo estensivo) e **tutela ambientale**.

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

---

# 🧪 Data gathering e Metodologia

## Raccolta delle immagini
Le immagini sono state scaricate attraverso il sito web di [Google Earth Engine](https://earthengine.google.com/), scegliendo l'area descritta precedentemente.

> [!NOTE]
>
> Il codice completo in JavaScript utilizzato per ottenere le immagini si trova nel file Codice.js

## Impostazione della working directory
````md
setwd("C://Users/giuli/OneDrive/telexam/")
````

## Caricamento pacchetti
````md
library(terra)  
library(imageRy)  
library(viridis)
library(ggridges)
library(ggplot2)  
library(patchwork)  
````
## Importazione raster Sentinel-2
````md
campoimp15 <- rast("CampoImp2015.tif")  
campoimp25 <- rast("CampoImp2025.tif")
 ````

> [!NOTE]
>
> I raster campoimp15 e campoimp25 corrispondo al periodo che va da luglio a settembre rispettivamente dell'anno 2015 e 2025.

## Calcolo indici spettrali
 ````md
ndvi_2015 <- im.ndvi(campoimp15, 4, 1)  
ndvi_2025 <- im.ndvi(campoimp25, 4, 1)  
dvi_2015 <- im.dvi(campoimp15, 4, 1)  
dvi_2025 <- im.dvi(campoimp25, 4, 1)
 ````
>[!NOTE]
> Le funzioni im.ndvi() e im.dvi() sono esclusive del pacchetto imageRy.

RGB

RGB con banda blu

# Analisi DVI


# 🌿 Analisi NDVI

L’NDVI è uno degli indici più utilizzati per misurare la densità e salute della vegetazione. I valori si distribuiscono tra -1 e 1.  
$` NDVI = \frac{(NIR - Red)}{(NIR + Red)} `$

Per scegliere il range di valori adatto alla classificazione osservo gli istogrammi della distribuzione  dell'NDVI:
 ````md
hist(ndvi_2015, main = "NDVI 2015", col = "darkgreen")   
hist(ndvi_2025, main = "NDVI 2025", col = "darkblue")
 ```` 

Classificazione per classi di vegetazione:
 ````md
class_matrix <- matrix(c(-Inf, 0.2, 1, 0.2, 0.4, 2, 0.4, Inf, 3), ncol = 3, byrow = TRUE)
ndvi_2015_cl <- classify(ndvi_2015, class_matrix)
ndvi_2025_cl <- classify(ndvi_2025, class_matrix)
 ````

## Calcolo percentuali
 ````md
# Frequenze
freq_2015 <- freq(ndvi_2015_cl)
freq_2025 <- freq(ndvi_2025_cl)
# Percentuali
perc_2015 <- freq_2015$count * 100 / ncell(ndvi_2015_cl)
perc_2025 <- freq_2025$count * 100 / ncell(ndvi_2025_cl)
# Tabella
tab <- data.frame(
  classi = c("Suolo nudo", "Vegetazione media", "Vegetazione sana"),
  a2015 = round(perc_2015, 2),
  a2025 = round(perc_2025, 2)
)
print(tab)
           classi a2015 a2025  
1        Suolo nudo  0.17  9.05  
2 Vegetazione media 16.42 90.01    
3  Vegetazione sana 83.41  0.94
   ````

Si riportano i risultati in una tabella:

| classi | a2015 | a2025 |
|--- |--- |--- |
|   1: Suolo nudo |  0.17%  |  9.05%  |
|   2: Vegetazione media |16.42% |90.01% |
|   3: Vegetazione sana |83.41% |0.94% |

## Visualizzazione
 ````md
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

p1 + p2      # Grazie al pacchetto patchwork si possono unire i grafici in questo modo
 ````
---

ridgeline plot

## 📉 Differenze multitemporali
````md
ndvi_diff <- ndvi_2025 - ndvi_2015  
plot(ndvi_diff, col = viridis(100), main = "Differenza NDVI (2025 - 2015)")
````
Risultano evidenti zone di degrado vegetativo nei pressi delle aree sovraccariche di pascolo e lungo i principali assi turistici.

## 📌 Commenti e Conclusioni

L’analisi ha evidenziato cambiamenti significativi tra il 2015 e il 2025:

Forte riduzione della vegetazione sana (NDVI > 0.4) e incremento di aree a suolo nudo o vegetazione degradata.

Presenza di stress idrico in molte aree (valori NDWI in calo).

I dati supportano la necessità di regolamentare i pascoli, migliorare le infrastrutture e gestire il turismo con maggiore attenzione.

## 🎯 Il contributo del telerilevamento

L’uso del telerilevamento ha permesso un’analisi spaziale e temporale oggettiva, evidenziando come l’attività antropica (pascolo e turismo) impatti sulla biodiversità e sulla qualità degli habitat.

## 📎 Link utili

LIFE11/NAT/IT/234 – PRATERIE: [Sito ufficiale del progetto](http://www.lifepraterie.it/pagina.php?id=11)

Documentazione Sentinel-2 ESA - [Google Earth Engine](https://earthengine.google.com/)






