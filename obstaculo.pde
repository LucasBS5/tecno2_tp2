class Obstaculo {
FCircle obstaculo;

  // Constructor que acepta parámetros
  Obstaculo(float posX, float posY, float tam, String nombre) {
    obstaculo = new FCircle(tam);
    obstaculo.setPosition(posX, posY);
    obstaculo.setName(nombre);
    obstaculo.setFill(255, 0, 0);
    obstaculo.setSensor(true);
    obstaculo.setStatic(true);
    //rebote
    //obstaculo.setRestitution(0.2);
    obstaculo.setGrabbable(false);
    //imagen obstaculo
    obstaculo.attachImage(obstaculo_img);
    mundo.add(obstaculo);
  }
}
