const { saludar } = require("./saludo");

describe("Grupo de prueba para saludo.js", () => {
  test('Debe retornar "hello"', () => {
    const resp = saludar();
    // console.log(resp);
    expect(resp).toBe("hello");
  });
});
