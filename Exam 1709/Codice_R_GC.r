# PROGETTO D'ESAME (17/09/2025) - ANALISI DELL'IMPATTO DEI PASCOLI SULLA VEGETAZIONE DEL CAMPO IMPERATORE DAL 2015 AL 2024
# Telerilevamento geologico in R
# Giulia Condorelli

# CODICE IN R PER L'ELABORAZIONE DELLE IMMAGINI

# Le immagini vogliono mettere in evidenza i cambiamenti nella vegetazione negli ultimi anni a causa di pascoli poco regolamentati, aumentata siccità e elevato turismo
# Grazie a Google Earth Engine sono state scaricate due immagini di Sentinel-2 (per il codice si veda lo script Esame.js)
# La prima riguarda una mediana delle immagini dell'estate 2015, la seconda una mediana delle immagini dell'estate 2024

# Il salvataggio delle immagini da R è stato fatto con il menù a tendina di R, in formato .png

# Pacchetti richiesti e utilizzati
library(terra) # Pacchetto per l'analisi spaziale dei dati con vettori e dati raster
library(imageRy) # Pacchetto per manipolare, visualizzare ed esportare immagini raster in R
library(viridis) # Pacchetto per cambiare le palette di colori anche per chi è affetto da colorblindness
