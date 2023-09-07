class Item {
  FBox Item;

  // Constructor que acepta parámetros
  Item(float posX, float posY, float tamX, float tamY, String nombre) {
    push();
    Item = new FBox(tamX, tamY);
    Item.setPosition(posX, posY);
    Item.setName(nombre);
    Item.setFill(0, 255, 0);
    Item.setRestitution(0);
    Item.setStatic(true);
    Item.setGrabbable(false);
    pop();

    mundo.add(Item);
  }
}
