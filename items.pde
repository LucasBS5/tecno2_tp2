class Item {
  FBox Item;

  // Constructor que acepta parámetros
  Item(float posX, float posY, float tamX, float tamY, String nombre) {
    push();
    Item = new FBox(tamX, tamY);
    Item.setPosition(posX, posY);
    Item.setName(nombre);
    //aca se cambia el tamaño de la imagen de la soda
    soda.resize(50,50);
    Item.attachImage(soda);
    Item.setRestitution(0);
    Item.setSensor(true);
    Item.setStatic(true);
    Item.setGrabbable(false);
    pop();

    mundo.add(Item);
  }
}
