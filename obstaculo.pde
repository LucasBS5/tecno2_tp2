class Obstaculo {
  FBox obstaculo;

  // Constructor que acepta parámetros
  Obstaculo(float posX, float posY, float tamX, float tamY, String nombre) {
    obstaculo = new FBox(tamX, tamY);
    obstaculo.setPosition(posX, posY);
    obstaculo.setName(nombre);
    obstaculo.setFill(255, 0, 0);
    obstaculo.setStatic(true);
    //rebote
    obstaculo.setRestitution(0.2);
    obstaculo.setGrabbable(false);
    mundo.add(obstaculo);
  }
}
