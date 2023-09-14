class Enemigo {
  FBox enemigo;
  // Constructor que acepta parámetros
  Enemigo(float posX, float posY, float tamX, float tamY, String nombre) {
    enemigo = new FBox(tamX, tamY);
    enemigo.setPosition(posX, posY);
    enemigo.setName(nombre);
    enemigo.setFill(255, 0, 255);
    enemigo.setGrabbable(false);
    //rebote
    enemigo.setRestitution(0.2);
    conejo_motosierra.resize(100, 100);
    enemigo.attachImage(conejo_motosierra);
    mundo.add(enemigo);
  }
  void mover() {
    float velocidad=0.02;
    float rotacion=+velocidad*frameCount;
    enemigo.setRotation(rotacion);
  }
}
