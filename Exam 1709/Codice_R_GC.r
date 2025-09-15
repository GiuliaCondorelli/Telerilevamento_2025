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

im.multiframe(1,2)
campoimp15_cl = im.classify(campoimp15, num_clusters=2)
campoimp25_cl = im.classify(campoimp25, num_clusters=2)
ev.off()           # Chiudo il pannello grafico dopo aver salvato l'immagine in .png    (forse non lo inserisco!!!)
# Visualizzo le quattro bande separate (RGB e NIR) per entrambe le immagini

par(mfrow = c(2, 2))      # Per impostare una griglia 2x2 per le quattro immagini
# Plotto ogni banda separatamente, per evitare sovrapposizioni
plot(campoimp15[[1]], main = "B4 - Red", col = magma(100))
plot(campoimp15[[2]], main = "B3 - Green", col = magma(100))
plot(campoimp15[[3]], main = "B2 - Blue", col = magma(100))
plot(campoimp15[[4]], main = "B8 - NIR", col = magma(100))
dev.off()           # Chiudo il pannello grafico dopo aver salvato l'immagine in .png

par(mfrow = c(2, 2))
plot(campoimp25[[1]], main = "B4 - Red", col = magma(100))
plot(campoimp25[[2]], main = "B3 - Green", col = magma(100))
plot(campoimp25[[3]], main = "B2 - Blue", col = magma(100))
plot(campoimp25[[4]], main = "B8 - NIR", col = magma(100))
dev.off()          # Chiudo il pannello grafico dopo aver salvato l'immagine in .png

# Calcolo DVI
 dvi_2015 <- campoimp15[[4]] - campoimp15[[1]]
> dvi_2025 <- campoimp25[[4]] - campoimp25[[1]]
> 
> # Visualizzazione della DVI
> im.multiframe(1, 2)
> plot(dvi_2015, col = viridis(100), main = "DVI 2015")
> plot(dvi_2025, col = viridis(100), main = "DVI 2025")
> dvi_diff <- dvi_2025 - dvi_2015
> 
> # Visualizzazione differenza DVI
> im.multiframe(1, 1)
> plot(dvi_diff, col = magma(100), main = "Differenza DVI (2025 - 2015)")

# ---
# 🌱 CALCOLO NDVI
ndvi_2015 <- (campoimp15[[4]] - campoimp15[[1]]) / (campoimp15[[4]] + campoimp15[[1]])
ndvi_2025 <- (campoimp25[[4]] - campoimp25[[1]]) / (campoimp25[[4]] + campoimp25[[1]])

# Visualizzazione NDVI
im.multiframe(1, 2)
plot(ndvi_2015, col = viridis(100), main = "NDVI 2015")
plot(ndvi_2025, col = viridis(100), main = "NDVI 2025")
dev.off()     # Chiudo il pannello grafico dopo aver salvato l'immagine in .png

# ---
# 🔎 CLASSIFICAZIONE BINARIA (Vegetazione / Non vegetazione)
> hist(ndvi_2015, main = "Distribuzione NDVI 2015", col = "darkgreen")
> hist(ndvi_2025, main = "Distribuzione NDVI 2025", col = "darkblue")
 ndvi_class_matrix <- matrix(c(
+   -Inf, 0.25, 1,
+    0.25, 0.45, 2,
+    0.45, Inf, 3
+ ), ncol = 3, byrow = TRUE)
> 
> # Applico la classificazione
> ndvi_2015_cl <- classify(ndvi_2015, ndvi_class_matrix)
> ndvi_2025_cl <- classify(ndvi_2025, ndvi_class_matrix)
> 
> # Visualizzo le classi con colori adatti
> im.multiframe(1, 2)
> plot(ndvi_2015_cl, col = c("orange", "yellow", "darkgreen"), main = "NDVI class. 2015")
> plot(ndvi_2025_cl, col = c("orange", "yellow", "darkgreen"), main = "NDVI class. 2025")
> dev.off()           # Chiudo il pannello grafico dopo aver salvato l'immagine in .png


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
           classi a2015 a2025
1        Suolo nudo  0.17  9.05
2 Vegetazione media 16.42 90.01
3  Vegetazione sana 83.41  0.94

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
p1+p2  # Per visualizzare i grafici affiancati

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

