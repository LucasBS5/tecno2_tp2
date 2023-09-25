class Enemigo {
  FBox enemigo1;
  FBox enemigo;
  float minY;
  float maxY;
  float velocidadRotacion;
  float velocidadMovimiento;
  float direccion; // 1 para mover hacia abajo, -1 para mover hacia arriba

  Enemigo(float posX, float posY, float tamX, float tamY, String nombre, float minY, float maxY, float velocidadRotacion, float velocidadMovimiento) {
    enemigo = new FBox(tamX, tamY);
    enemigo.setPosition(posX, posY);
    enemigo.setName(nombre);
    enemigo.setFill(255, 0, 255);
    enemigo.setGrabbable(false);
    enemigo.setRestitution(0.2);
    conejo_motosierra.resize(100, 100);
    enemigo.attachImage(conejo_motosierra);
    mundo.add(enemigo);

    this.minY = minY;
    this.maxY = maxY;
    this.velocidadRotacion = velocidadRotacion;
    this.velocidadMovimiento = velocidadMovimiento;
    this.direccion = 1; // Comienza moviéndose hacia abajo
  }

  void mover() {
    push();
    float rotacion = velocidadRotacion * frameCount;
    enemigo.setRotation(rotacion);

    // Calcula la nueva posición en el eje Y
    float nuevaY = enemigo.getY() + velocidadMovimiento * direccion;

    // Verifica los límites en el eje Y
    if (nuevaY <= minY) {
      nuevaY = minY;
      direccion = 1; // Cambia la dirección hacia abajo
    } else if (nuevaY >= maxY) {
      nuevaY = maxY;
      direccion = -1; // Cambia la dirección hacia arriba
    }

    // Establece la nueva posición en Y
    enemigo.setPosition(enemigo.getX(), nuevaY);
    pop();
  }
}
