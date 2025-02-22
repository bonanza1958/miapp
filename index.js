const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

// Definición de la ruta raíz
app.get('/', (req, res) => {
  res.send('¡Hola Mundo!');
});

// Solo inicia el servidor si el archivo se ejecuta directamente
if (require.main === module) {
  app.listen(port, () => {
    console.log(`Servidor corriendo en http://localhost:${port}`);
  });
}

// Exporta la app para que pueda ser utilizada en pruebas
module.exports = app;
