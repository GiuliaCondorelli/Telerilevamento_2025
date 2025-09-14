# PROGETTO D'ESAME (17/09/2025) - ANALISI DELL'IMPATTO DEI PASCOLI SULLA VEGETAZIONE DEL CAMPO IMPERATORE DAL 2015 AL 2025
# Telerilevamento geo-ecologico in R
# Giulia Condorelli

# CODICE IN R PER L'ELABORAZIONE DELLE IMMAGINI

# Le immagini vogliono mettere in evidenza i cambiamenti nella vegetazione nell'ultimo decennio a causa di pascoli poco regolamentati, aumentata siccità e elevato turismo
# Grazie a Google Earth Engine sono state scaricate due immagini di Sentinel-2 (per il codice si veda lo script Esame.js)
# La prima riguarda una mediana delle immagini dell'estate 2015, la seconda una mediana delle immagini dell'estate 2025

# Il salvataggio delle immagini da R è stato fatto con il menù a tendina di R, in formato .png

# Pacchetti richiesti e utilizzati
library(terra) # Pacchetto per l'analisi spaziale dei dati con vettori e dati raster
library(imageRy) # Pacchetto per manipolare, visualizzare ed esportare immagini raster in R
library(viridis) # Pacchetto per cambiare le palette di colori anche per chi è affetto da colorblindness
library()

# Imposto la working directory
setwd("C://Users/giuli/OneDrive/telexam/")

# ---
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
im.multiframe(1,2)
plotRGB(campoimp15, r = 1, g = 2, b = 3, stretch = "lin", main = "Campo Imperatore, 2015")
plotRGB(campoimp25, r = 1, g = 2, b = 3, stretch = "lin", main = "Campo Imperatore, 2025")
dev.off()           # Chiudo il pannello grafico dopo aver salvato l'immagine in .png

