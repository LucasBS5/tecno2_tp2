
class Nave {
  FBox nave;
  //vars movimiento
  float x;
  float y;
  //vars angulo
  float angulo;
  float velocidad;
  float dx;
  float dy;
  //float rotinicial;
  //vars visuales
  int alto;
  int ancho;
  int vidas;
  //invulnerable
  boolean invulnerable;
  int tiempoInvulnerable;
  int duracionInvulnerabilidad;
  int tiempoEsperaInvulnerabilidad;



  // Constructor de la clase Nave
  Nave() {
    nave = new FBox(25, 50);
    //vars movimiento
    float angulo;
    //vars visuales
    ancho = 25;
    alto = 50;
    nave.setPosition(100, height-100);
    nave.setGrabbable(false);
    nave.setName("Nave");
    vidas=5;
    //imagen nave
    nave_s_fuego.resize(90, 90);
    nave.attachImage(nave_s_fuego);

    //nave invulnerable el tiempo de espera entre activaciones es el tiempo que dura la invulnerabilidad (5s)
    invulnerable = false;
    tiempoInvulnerable = millis();
    //tiempo de invulnerabilidad (2 segundos)
    duracionInvulnerabilidad = 2000;
    //añadir al mundo
    mundo.add(nave);
  }


  void moverNave() {
    if (estado=="jugando") {
      push();
      //revisar angulo para que coincida
      angulo = radians(map(mouseX, 0, width, -130, 130));

      // Calcula la velocidad en el eje X basada en el ángulo
      float  velocidadX = map(mouseX, width/2, width, -60, 60); // Utiliza cos(angulo) para determinar la velocidad en X

      // Calcula la velocidad en el eje Y basada en el movimiento vertical del mouse
      float velocidadY = map(mouseY, height / 2, height, -60, 60); // Limita el movimiento vertical al cuarto inferior
      nave.setRotation(angulo);
      // Aplica el impulso en X y Y utilizando addImpulse
      nave.setVelocity(velocidadX, velocidadY);
      pop();
    } else
    {
      nave.setVelocity(0, 0);
    }
  }



  //hacer invulnerable
  void hacerInvulnerable() {
    invulnerable = true;
    tiempoInvulnerable = millis();
  }

  boolean estaInvulnerable() {
    // Verifica si ha pasado suficiente tiempo desde la última vez que se hizo invulnerable
    if (invulnerable && millis() - tiempoInvulnerable >= duracionInvulnerabilidad) {
      invulnerable = false;
    }
    return invulnerable;
  }
}
