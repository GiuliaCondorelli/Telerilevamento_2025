# PROGETTO D'ESAME (17/09/2025) - ANALISI DELL'IMPATTO DEI PASCOLI SULLA VEGETAZIONE DEL CAMPO IMPERATORE DAL 2015 AL 2025
# Telerilevamento geo-ecologico in R
# Giulia Condorelli

# Le immagini sono state prese da : https://earthengine.google.com/
# Di seguito il codice in JavaScript per scaricare le immagini di Sentinel-2

// Immagine del 2015
// Definisci area di interesse: Campo Imperatore
var CampoImp = ee.Geometry.Rectangle([13.2, 42.2, 13.8, 42.7]);

// Finestra temporale più ampia: da luglio a settembre 2015
var startDate = ee.Date('2015-07-01');
var endDate = ee.Date('2015-09-01');

// Collezione Sentinel‑2 TOA (L1C)
var s2col = ee.ImageCollection('COPERNICUS/S2')
  .filterBounds(geometry2)
  .filterDate(startDate, endDate)
  .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 10))  // poco tollerante
  .sort('CLOUDY_PIXEL_PERCENTAGE');

print('Numero immagini trovate 2015:', s2col.size());

// Prendi la prima immagine disponibile
var image2015 = ee.Image(s2col.first());

print('Immagine selezionata 2015:', image2015);

// Controllo: se non trova, vuol dire che non ci sono immagini con questi criteri
// (ciao a image2015 come null)

// Se c'è immagine, seleziona le bande B2, B3, B4, B8
var bands = ['B2', 'B3', 'B4', 'B8'];

var selected2015 = image2015.select(bands);

// Visualizza RGB (natural) su mappa
Map.centerObject(CampoImp, 10);
Map.addLayer(selected2015, {bands: ['B4','B3','B2'], min: 0, max: 3000}, 'RGB 2015 CampoImp');

// Esporta l’immagine su Google Drive se esiste
Export.image.toDrive({
  image: selected2015,
  description: 'CampoImp2015',
  folder: 'GEE_Export',
  fileNamePrefix: 'CampoImp2015',
  region: geometry2,
  scale: 10,
  crs: 'EPSG:32633',
  maxPixels: 1e9
});


  // Immagine del 2025
  // Definisci area di interesse: Campo Imperatore
var CampoImp = ee.Geometry.Rectangle([13.2, 42.2, 13.8, 42.7]);

// Finestra temporale più ampia: da luglio a settembre 2025
var startDate = ee.Date('2025-07-01');
var endDate = ee.Date('2025-09-01');

// Collezione Sentinel‑2 TOA (L1C)
var s2col = ee.ImageCollection('COPERNICUS/S2')
  .filterBounds(geometry2)
  .filterDate(startDate, endDate)
  .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 10))  // poco tollerante
  .sort('CLOUDY_PIXEL_PERCENTAGE');

print('Numero immagini trovate 2025:', s2col.size());

// Prendi la prima immagine disponibile
var image2025 = ee.Image(s2col.first());

print('Immagine selezionata 2025:', image2025);

// Controllo: se non trova, vuol dire che non ci sono immagini con questi criteri
// (ciao a image2025 come null)

// Se c'è immagine, seleziona le bande B2, B3, B4, B8
var bands = ['B2', 'B3', 'B4', 'B8'];

var selected2025 = image2025.select(bands);

// Visualizza RGB (natural) su mappa
Map.centerObject(CampoImp, 10);
Map.addLayer(selected2025, {bands: ['B4','B3','B2'], min: 0, max: 3000}, 'RGB 2025 CampoImp');

// Esporta l’immagine su Google Drive se esiste
Export.image.toDrive({
  image: selected2025,
  description: 'CampoImp2025',
  folder: 'GEE_Export',
  fileNamePrefix: 'CampoImp2025',
  region: geometry2,
  scale: 10,
  crs: 'EPSG:32633',
  maxPixels: 1e9
});
