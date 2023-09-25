class Enemigo {
  FCircle enemigo;
  float minY;
  float maxY;
  float velocidadRotacion;
  float velocidadMovimiento;
  float direccion; // 1 para mover hacia abajo, -1 para mover hacia arriba

  Enemigo(float posX, float posY, float tam, String nombre, float minY, float maxY, float velocidadRotacion, float velocidadMovimiento) {
    enemigo = new FCircle(tam);
    enemigo.setPosition(posX, posY);
    enemigo.setName(nombre);
    enemigo.setGrabbable(false);
    conejo_motosierra.resize(100, 100);
    enemigo.attachImage(conejo_motosierra);
    enemigo.setRestitution(0.0); 
    //enemigo.setSensor(true);
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
