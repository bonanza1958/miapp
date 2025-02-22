const request = require('supertest');
const app = require('../index'); // Importa la aplicación

describe('GET /', () => {
  it('debería responder con "¡Hola Mundo!"', (done) => {
    request(app)
      .get('/')
      .expect(200)
      .expect('¡Hola Mundo!', done);
  });
});
