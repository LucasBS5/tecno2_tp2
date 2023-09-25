class Item {
  FBox Item;
  float itemX; // Posición X del item
  float itemY; // Posición Y del item

  //movimiento
  float velocidadX;
  float amplitudY;  // Amplitud del movimiento vertical
  float frecuenciaY;  // Frecuencia del movimiento vertical (número de oscilaciones por segundo)
  float tiempo;

  // Constructor que acepta parámetros
  Item(float posX, float posY, float tamX, float tamY, String nombre) {
    // En el constructor de la clase Item
    velocidadX = 0.0;  // Ajusta la velocidad horizontal como desees
    amplitudY = 1.0;  // Ajusta la amplitud vertical como desees (controla la altura de la flotación)
    frecuenciaY = 1.0;  // Ajusta la frecuencia vertical como desees (controla la velocidad de la flotación)
    tiempo = 0.0;
    Item = new FBox(tamX, tamY);
    Item.setPosition(posX, posY);
    Item.setName(nombre);
    //aca se cambia el tamaño de la imagen de la soda
    soda.resize(50, 50);
    Item.attachImage(soda);
    Item.setRestitution(0);
    Item.setSensor(true);
    //Item.setStatic(true);
    Item.setGrabbable(false);
    mundo.add(Item);
  }

  void mover() {
    push();
    // Actualiza la posición horizontal
    itemX += velocidadX;

    // Actualiza la posición vertical usando una función sinusoidal
    itemY = amplitudY * sin(2 * PI * frecuenciaY * tiempo);
    tiempo += 1.0 / frameRate;  // Asegura que el movimiento sea independiente de la velocidad de cuadro

    // Actualiza la posición del objeto FBox en el mundo físico
    Item.setPosition(Item.getX() + itemX, Item.getY() + itemY);
    pop();
  }
}
