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
  
  <p align="center">
  <img width="480" height="480" src="https://github.com/user-attachments/assets/136b5baa-19d8-411c-8e60-2fcae486efc9" />
</p>

---

# 🛰️ Obiettivo del Progetto in R

L’obiettivo dell’elaborazione telerilevata in R è **monitorare i cambiamenti nella vegetazione** dal **2015 al 2025**, utilizzando immagini **Sentinel-2** e calcolando alcuni **indici spettrali**, in particolare:

- **DVI** (Difference Vegetation Index)  
- **NDVI** (Normalized Difference Vegetation Index)
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

## Visualizzazione con colori reali (RGB)
 ````md
# Creazione di un pannello multiframe dove poter affiancare le due immagini  
im.multiframe(1,2)   
# Utilizzo della funzione plotRGB() proveniente dal pacchetto imageRy  
plotRGB(campoimp15, r = 1, g = 2, b = 3, stretch = "lin", main = "Campo Imperatore, 2015")   
plotRGB(campoimp25, r = 1, g = 2, b = 3, stretch = "lin", main = "Campo Imperatore, 2025")   
 ````
<p align="center">
<img width="514" height="513" alt="CampoImpRGB" src="https://github.com/user-attachments/assets/cbe066b7-c7c1-4ef6-828a-cdf96856a449" />
  
Sostituendo il NIR al posto della banda del blu, si evidenziano le zone di vegetazione (blu) e tutto ciò che non è vegetazione (giallo)

 ````md
 im.multiframe(1,2)  
plotRGB(campoimp15, r = 1, g = 2, b = 4, stretch="lin", main = "Campo Imperatore, 2015")   
plotRGB(campoimp25, r = 1, g = 2, b = 4, stretch="lin", main = "Campo Imperatore, 2025")  
 ````
<p align="center">
<img width="514" height="513" alt="campoimpblu2015_2025" src="https://github.com/user-attachments/assets/b3928881-e598-4a8a-89b9-25fb57933724" />

# Analisi DVI

Il DVI (Difference Vegetation Index) è uno dei più semplici indici spettrali utilizzati per valutare la presenza e la vitalità della vegetazione.
Si calcola sottraendo la riflettanza nel rosso (Red) da quella nel vicino infrarosso (NIR):   
DVI = NIR − Red    
Le piante sane riflettono molto nel NIR e poco nel rosso, quindi valori alti di DVI indicano vegetazione vigorosa.
È un indice non normalizzato, ma fornisce indicazioni dirette sulla biomassa verde e può essere utile per analisi comparative quando le condizioni di acquisizione sono simili.   
dvi_2015 <- im.dvi(campoimp15, 4, 1)  
dvi_2025 <- im.dvi(campoimp25, 4, 1)

# 🌿 Analisi NDVI
Il NDVI è uno degli indici di vegetazione più diffusi in telerilevamento grazie alla sua capacità di normalizzare le differenze tra immagini acquisite in tempi o condizioni diverse.
Si calcola come:
NDVI = (NIR − Red) / (NIR + Red)
I valori ottenuti variano tra -1 e +1: valori vicini a +1 indicano vegetazione densa e sana, mentre valori prossimi a 0 o negativi indicano suolo nudo, rocce o acqua.
L'NDVI è particolarmente utile per monitorare variazioni nella copertura vegetale nel tempo e valutare stress idrici, cambiamenti climatici o impatti antropici, come nel caso di pascoli intensivi.

$` NDVI = \frac{(NIR - Red)}{(NIR + Red)} `$  
Per semplificare si userà la funzione im.ndvi(), che è una funzione del pacchetto imageRy   
ndvi_2015 <- im.ndvi(campoimp15, 4, 1)    
ndvi_2025 <- im.ndvi(campoimp25, 4, 1)  
Per scegliere il range di valori adatto alla classificazione osservo gli istogrammi della distribuzione  dell'NDVI:
 ````md
hist(ndvi_2015, main = "NDVI 2015", col = "darkgreen")   
hist(ndvi_2025, main = "NDVI 2025", col = "darkblue")
 ````
<details>
<summary>Istogrammi (cliccare qui)</summary>  
  
<p align="center">
<img width="414" height="413" alt="histNDVI2015" src="https://github.com/user-attachments/assets/59237733-25df-479f-8fef-9cd9e7085358" />

<img width="414" height="413" alt="histNDVI2025" src="https://github.com/user-attachments/assets/b2ed5967-d200-4416-b284-787dcb8b4d5f" />
</p>

</details>


Classificazione per classi di vegetazione:
 ````md
class_matrix <- matrix(c(-Inf, 0.2, 1, 
                         0.2, 0.4, 2, 
                         0.4, Inf, 3), 
                       ncol = 3, byrow = TRUE)
class_matrix
     [,1] [,2] [,3]
[1,] -Inf  0.2    1       # Se NDVI < 2 allora si associa una classe di tipo 1 (Suolo nudo)
[2,]  0.2  0.4    2       # Se 0.2 ≤ NDVI < 0.4 allora si associa una classe di tipo 2 (Vegetazione media)
[3,]  0.4  Inf    3       # Se NDVI ≥ 0.4 allora si associa una classe di tipo 3 (Vegetazione sana)  

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






