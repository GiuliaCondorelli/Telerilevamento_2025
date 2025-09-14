# PROGETTO D'ESAME (17/09/2025) - ANALISI DELL'IMPATTO DEI PASCOLI SULLA VEGETAZIONE DEL CAMPO IMPERATORE DAL 2015 AL 2025
# Telerilevamento geo-ecologico in R
# Giulia Condorelli

# CODICE IN R PER L'ELABORAZIONE DELLE IMMAGINI

# Le immagini vogliono mettere in evidenza i cambiamenti nella vegetazione nell'ultimo decennio a causa di pascoli poco regolamentati, aumentata siccità e elevato turismo
# Grazie a Google Earth Engine sono state scaricate due immagini di Sentinel-2 (per il codice si veda lo script Esame.js)
# La prima riguarda una mediana delle immagini dell'estate 2015, la seconda una mediana delle immagini dell'estate 2025

# Il salvataggio delle immagini da R è stato fatto con il menù a tendina di R, in formato .png

# Pacchetti richiesti e utilizzati
library(terra)       # Pacchetto per l'analisi spaziale dei dati con vettori e dati raster
library(imageRy)     # Pacchetto per manipolare, visualizzare ed esportare immagini raster in R
library(viridis)     # Pacchetto per cambiare le palette di colori anche per chi è affetto da colorblindness
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

# Visualizzo le quattro bande separate (RGB e NIR) per entrambe le immagini
plot(campoimp15, main=c("B4-Red", "B3-Green", "B2-Blue", "B8-NIR"), col=magma(100))
plot(campoimp25, main=c("B4-Red", "B3-Green", "B2-Blue", "B8-NIR"), col=magma(100))
dev.off()           # Chiudo il pannello grafico dopo aver salvato l'immagine in .png






BOZZA
# ---
# 🌱 CALCOLO NDVI
ndvi_2015 <- (campoimp15[[4]] - campoimp15[[1]]) / (campoimp15[[4]] + campoimp15[[1]])
ndvi_2025 <- (campoimp25[[4]] - campoimp25[[1]]) / (campoimp25[[4]] + campoimp25[[1]])

# Visualizzazione NDVI
im.multiframe(1, 2)
plot(ndvi_2015, col = viridis(100), main = "NDVI 2015")
plot(ndvi_2025, col = viridis(100), main = "NDVI 2025")
dev.off()

# ---
# 🔎 CLASSIFICAZIONE BINARIA (Vegetazione / Non vegetazione)
# Soglia NDVI > 0.4 → vegetazione

ndvi_classes <- matrix(c(
  -1, 0.4, 0,   # non vegetazione
   0.4, 1, 1    # vegetazione
), ncol = 3, byrow = TRUE)

class_2015 <- classify(ndvi_2015, ndvi_classes)
class_2025 <- classify(ndvi_2025, ndvi_classes)

# Visualizzazione classificazioni
im.multiframe(1, 2)
plot(class_2015, col = c("yellow", "darkgreen"), main = "Classi 2015")
plot(class_2025, col = c("yellow", "darkgreen"), main = "Classi 2025")
dev.off()

# ---
# 📊 PERCENTUALI E TABELLA CON freq(), ncell(), ggplot

# Calcolo frequenze
freq_2015 <- freq(class_2015)
freq_2025 <- freq(class_2025)

# Percentuali
total_2015 <- ncell(class_2015)
total_2025 <- ncell(class_2025)

freq_2015$percent <- round((freq_2015$count / total_2015) * 100, 2)
freq_2025$percent <- round((freq_2025$count / total_2025) * 100, 2)

# Etichette classi
labels <- c("Non vegetazione", "Vegetazione")
freq_2015$classi <- labels[freq_2015$value + 1]
freq_2025$classi <- labels[freq_2025$value + 1]

# Tabella finale
tab <- data.frame(
  classi = labels,
  a2015 = freq_2015$percent,
  a2025 = freq_2025$percent
)
print(tab)

# Grafici ggplot
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

# Visualizza i due grafici affiancati
library(gridExtra)
grid.arrange(p1, p2, ncol = 2)

# ---
# 🔁 ANALISI MULTITEMPORALE

# Differenza NIR (B8)
nir_diff <- campoimp25[[4]] - campoimp15[[4]]

# Differenza NDVI
ndvi_diff <- ndvi_2025 - ndvi_2015

# Plot differenze
im.multiframe(1, 2)
plot(nir_diff, col = viridis(100), main = "Δ NIR (2025 - 2015)")
plot(ndvi_diff, col = viridis(100), main = "Δ NDVI (2025 - 2015)")
dev.off()

# Statistiche differenza NDVI
summary(values(ndvi_diff), na.rm = TRUE)

# ---
# 💾 ESPORTAZIONE DATI (facoltativo)
write.csv(tab, "percentuali_classi_ndvi.csv", row.names = FALSE)
writeRaster(ndvi_diff, "NDVI_diff_2025_2015.tif", overwrite = TRUE)

# ---
# ✅ FINE SCRIPT
print("Analisi completata con successo.")

