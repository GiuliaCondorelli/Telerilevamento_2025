# PROGETTO D'ESAME (17/09/2025) - ANALISI DELL'IMPATTO DEI PASCOLI SULLA VEGETAZIONE DEL CAMPO IMPERATORE DAL 2015 AL 2025
# Telerilevamento geo-ecologico in R
# Giulia Condorelli

# Le immagini vogliono mettere in evidenza i cambiamenti nella vegetazione nell'ultimo decennio a causa di pascoli poco regolamentati, aumentata siccità e elevato turismo
# Grazie a Google Earth Engine sono state scaricate due immagini di Sentinel-2 (per il codice si veda lo script Code.js)
# La prima riguarda una mediana delle immagini dell'estate 2015, la seconda una mediana delle immagini dell'estate 2025

# Il salvataggio delle immagini da R è stato fatto con il menù a tendina di R, in formato .png

# Imposto la working directory
setwd("C://Users/giuli/OneDrive/telexam/")

# Pacchetti richiesti e utilizzati
library(terra)       # Pacchetto per l'analisi spaziale dei dati con vettori e dati raster
library(imageRy)     # Pacchetto per manipolare, visualizzare ed esportare immagini raster in R
library(viridis)     # Pacchetto per cambiare le palette di colori anche per chi è affetto da colorblindness
library(ggridges)    # Pacchetto per creare ridgeline plot
library(ggplot2)     # Pacchetto per creare grafici a barre
library(patchwork)   # Per la visualizzazione di più grafici assieme

# IMPORTAZIONE DELLE IMMAGINI
# Importo in R le immagini scaricate con Google Earth Engine
campoimp15 <- rast("CampoImp2015.tif")
campoimp15           # Per visualizzare le specifiche del raster
plot(campoimp15)     # Plot che permette di visualizzare l'immagine
dev.off()            # Chiudo il pannello grafico

campoimp25 <- rast("CampoImp2025.tif")
campoimp25
plot(campoimp25)
dev.off()

# Visualizzo entrambe le immagini in RGB creando un multiframe
im.multiframe(1,2)  # Funzione del pacchetto imageRy che permette di aprire un pannello grafico dove poter affiancare delle immagini
plotRGB(campoimp15, r = 1, g = 2, b = 3, stretch = "lin", main = "Campo Imperatore, 2015")
plotRGB(campoimp25, r = 1, g = 2, b = 3, stretch = "lin", main = "Campo Imperatore, 2025")
dev.off()           # Chiudo il pannello grafico dopo aver salvato l'immagine in .png

# Visualizzo le quattro bande separate (RGB e NIR) per entrambe le immagini
im.multiframe(2,2)       # Per impostare una griglia 2x2 per le quattro immagini
# Plotto ogni banda separatamente, per evitare sovrapposizioni
plot(campoimp15[[1]], main = "B4 - Red", col = magma(100))
plot(campoimp15[[2]], main = "B3 - Green", col = magma(100))
plot(campoimp15[[3]], main = "B2 - Blue", col = magma(100))
plot(campoimp15[[4]], main = "B8 - NIR", col = magma(100))
dev.off()           # Chiudo il pannello grafico dopo aver salvato l'immagine in .png

im.multiframe(2,2)  
plot(campoimp25[[1]], main = "B4 - Red", col = magma(100))
plot(campoimp25[[2]], main = "B3 - Green", col = magma(100))
plot(campoimp25[[3]], main = "B2 - Blue", col = magma(100))
plot(campoimp25[[4]], main = "B8 - NIR", col = magma(100))
dev.off()          # Chiudo il pannello grafico dopo aver salvato l'immagine in .png

# Le immagini col NIR (Near-InfraRed) sono molto importanti perché sono quelle che permettono di osservare lo stato di salute della vegetazione. 
# Una minor riflessione del NIR indica una vegetazione sottoposta a stress. 

# Dunque, sostituendo la banda del blu al NIR posso evidenziare tutto ciò che è vegetazione in blu mentre tutto ciò che non lo è in giallo.
im.multiframe(1,2)
plotRGB(campoimp15, r = 1, g = 2, b = 4, stretch="lin", main = "Campo Imperatore, 2015")   # Imposto il NIR sulla banda Blu
plotRGB(campoimp25, r = 1, g = 2, b = 4, stretch="lin", main = "Campo Imperatore, 2025")
dev.off()          # Chiudo il pannello grafico dopo aver salvato l'immagine in .png
# Si nota una evidente diminuzione del blu nell'immagine di quest'anno.

# INDICI SPETTRALI
# DIFFERENT VEGETATION INDEX - DVI
# Questo indice che ci dà informazione sullo stato di salute delle piante attraverso la riflettanza della vegetazione nelle bande del rosso e NIR. In caso di stress la riflettanza nel NIR sarà più bassa.
# Calcolo: DVI= NIR - red
dvi_2015 <- im.dvi(campoimp15, 4, 1)  # Calcolo semplificato grazie alla funzione im.dvi() del pacchetto imageRy.
dvi_2025 <- im.dvi(campoimp25, 4, 1)
 
# Visualizzazione della DVI
im.multiframe(1, 2)
plot(dvi_2015, col = viridis(100), main = "DVI 2015")
plot(dvi_2025, col = viridis(100), main = "DVI 2025")
dvi_diff <- dvi_2025 - dvi_2015
 
# Visualizzazione differenza DVI
im.multiframe(1, 1)
plot(dvi_diff, col = magma(100), main = "Differenza DVI (2025 - 2015)")

#  CALCOLO NDVI (NORMALIZED DIFFERENCE VEGETATION INDEX)
# Un secondo indice per l'analisi della vegetazione, dato che i valori vengono normalizzati  tra -1 e +1 possiamo attuare analisi che sono state acquisite in tempi diversi.
# Calcolo: NDVI= (NIR - red) / (NIR + red)
ndvi_2015 <- im.ndvi(campoimp15, 4, 1)   # Calcolo semplificato grazie alla funzione im.ndvi() del pacchetto imageRy.
ndvi_2025 <- im.ndvi(campoimp25, 4, 1)

# Visualizzazione NDVI
im.multiframe(1, 2)
plot(ndvi_2015, col = viridis(100), main = "NDVI 2015")
plot(ndvi_2025, col = viridis(100), main = "NDVI 2025")
dev.off()     # Chiudo il pannello grafico dopo aver salvato l'immagine in .png

# Creazione ridgeline plot
campoimp_ridg=c(ndvi_2015, ndvi_2025) # Creazione vettore per visualizzare le due immagini contemporaneamente
names(campoimp_ridg) =c("NDVI 2015", "NDVI 2025") # Vettore con i nomi relativi alle due immagini
im.ridgeline(campoimp_ridg, scale=2, palette="viridis")    # Applico la funzione im.ridgeline del pacchetto imageRy
dev.off()     # Chiudo il pannello grafico dopo aver salvato l'immagine in .png
# Si nota che la curva relativa al 2025 è più spostata verso sinistra e più stretta rispetto alla curva del 2015 e ciò potrebbe significare che ci sono più aree con vegetazione in sofferenza (valori NDVI più bassi) e con una copertura piuttosto omogenea (tutto degradato o tutto pascolo). 

# CLASSIFICAZIONE BINARIA (Vegetazione / Non vegetazione)
# Visualizzo la distribuzione delle due NDVI con degli istogrammi per poter avere una classificazione più adeguata
hist(ndvi_2015, main = "Distribuzione NDVI 2015", col = "darkgreen")
hist(ndvi_2025, main = "Distribuzione NDVI 2025", col = "darkblue")

# Creazione di una matrice di classificazione
class_matrix <- matrix(c(-Inf, 0.2, 1, 
                         0.2, 0.4, 2, 
                         0.4, Inf, 3), 
                       ncol = 3, byrow = TRUE)   # Matrice basata sui valori ricavati dagli istogrammi
# Visualizzo la matrice a tre colonne
class_matrix
     [,1] [,2] [,3]
[1,] -Inf  0.2    1       # Se NDVI < 2 allora si associa una classe di tipo 1 (Suolo nudo)
[2,]  0.2  0.4    2       # Se 0.2 ≤ NDVI < 0.4 allora si associa una classe di tipo 2 (Vegetazione media)
[3,]  0.4  Inf    3       # Se NDVI ≥ 0.4 allora si associa una classe di tipo 3 (Vegetazione sana)

# Classificazione NDVI
ndvi_2015_cl <- classify(ndvi_2015, class_matrix)
ndvi_2025_cl <- classify(ndvi_2025, class_matrix)

# Verifica visuale
im.multiframe(1, 2)
plot(ndvi_2015_cl, col = c("orange", "yellow", "darkgreen"), main = "NDVI class. 2015")
plot(ndvi_2025_cl, col = c("orange", "yellow", "darkgreen"), main = "NDVI class. 2025")
dev.off()                # Chiudo il pannello grafico dopo aver salvato l'immagine in .png

# Calcolo percentuali

# Calcolo frequenze
freq_2015 <- freq(ndvi_2015_cl)
freq_2025 <- freq(ndvi_2025_cl)
 
# Percentuale
perc_2015 <- freq_2015$count * 100 / ncell(ndvi_2015_cl)
perc_2025 <- freq_2025$count * 100 / ncell(ndvi_2025_cl) 

# Tabella con merge per gestire classi mancanti
tab <- data.frame(classi = c("Suolo nudo", "Vegetazione media", "Vegetazione sana"), a2015 = round(perc_2015, 2), a2025 = round(perc_2025, 2))
print(tab)
             classi a2015 a2025
1        Suolo nudo  0.17  9.05
2 Vegetazione media 16.42 90.01
3  Vegetazione sana 83.41  0.94

# Grafici ggplot
p1 <- ggplot(tab, aes(x = classi, y = a2015, fill = classi)) +           # ggplot(tab, aes(...)): inizializza il grafico dal data.frame tab
  geom_bar(stat = "identity") +                                          # geom_bar(): crea le barre del grafico
  scale_fill_viridis_d() +                                               # scale_fill_viridis_d(): applica una palette a contrasto visivo compatibile con persone affette da daltonismo
  ylim(0, 100) +                                                         # ylim(): impone che l'asse delle y vada da 0 a 100 (percentuali)
  labs(title = "Classi NDVI 2015", y = "%", x = NULL) +                  # labs(): modifica titoli e etichette degli assi
  theme_minimal()                                                        # theme_minimal(): applica un tema minimale per rendere il grafico più pulito e leggibile

p2 <- ggplot(tab, aes(x = classi, y = a2025, fill = classi)) +     
  geom_bar(stat = "identity") + 
  scale_fill_viridis_d() + 
  ylim(0, 100) + 
  labs(title = "Classi NDVI 2025", y = "%", x = NULL) + 
  theme_minimal()
p1+p2        # Grazie al pacchetto patchwork posso affiancare i due grafici nella stessa immagine
dev.off()    # Chiudo il pannello grafico dopo aver salvato l'immagine in .png

# ANALISI MULTITEMPORALE

# Differenza NIR (B8)
nir_diff <- campoimp25[[4]] - campoimp15[[4]]

# Differenza NDVI
ndvi_diff <- ndvi_2025 - ndvi_2015

# Plot differenze
im.multiframe(1, 2)
plot(nir_diff, col = viridis(100), main = "NIR (2025 - 2015)")
plot(ndvi_diff, col = viridis(100), main = "NDVI (2025 - 2015)")
dev.off()     # Chiudo il pannello grafico dopo aver salvato l'immagine in .png
