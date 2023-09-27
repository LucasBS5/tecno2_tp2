
class Nave {


  FBox nave;
  FBox fuego;
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
    fuego = new FBox(25, 50);
    //vars movimiento
    float angulo;
    //vars visuales
    ancho = 25;
    alto = 50;
    nave.setPosition(100, height-100);
    nave.setRestitution(0.02);
    nave.setGrabbable(false);
    fuego.setGrabbable(false);
    nave.setName("Nave");
    vidas=5;
    //imagen nave
    nave_s_fuego.resize(90, 90);
    //nave invulnerable el tiempo de espera entre activaciones es el tiempo que dura la invulnerabilidad (5s)
    invulnerable = false;
    tiempoInvulnerable = millis();
    //tiempo de invulnerabilidad (2 segundos)
    duracionInvulnerabilidad = 2000;
    nave.attachImage(nave_s_fuego);
    fuego.attachImage(fuego_nave);
    fuego.setSensor(true);
    //añadir al mundo

    mundo.add(nave);
    mundo.add(fuego);
    // Llamar al método para crear la unión entre la nave y el fuego
    crearUnionFuego();
  }


  void moverNave(float bx, float by) {
    if (estado=="jugando") {
      push();
      //revisar angulo para que coincida
      angulo = radians(map(bx, 0, width, -130, 130));

      // Calcula la velocidad en el eje X basada en el ángulo
      float  velocidadX = map(bx, 0, width, -100, 100);

      // Calcula la velocidad en el eje Y basada en el movimiento vertical del mouse
      float velocidadY = map(by, 0, height, -60, 60); // Limita el movimiento vertical al cuarto inferior
      nave.setRotation(angulo);
      fuego.setRotation(angulo);
      //descomentar para mover con bmove
      nave.addImpulse(bx*13, by*13);
      pop();
    }
    fuego.setPosition(nave.getX(), nave.getY());
  }


  // Método para crear la unión entre la nave y el fuego
  void crearUnionFuego() {
    // Crea un FDistanceJoint entre la nave y el fuego
    FDistanceJoint unionFuego = new FDistanceJoint(nave, fuego);
    // Configura la rigidez y amortiguación de la unión según tus necesidades
    unionFuego.setDamping(0.2);
    unionFuego.setFrequency(5);
    unionFuego.setDrawable(false);
    // Agrega la unión al mundo
    mundo.add(unionFuego);
  }

  //metodo para dibujar un joystick
  //posicion iniical x,y tamaño , valor de entrada del mouse o trackeo de manos x,y
  void dibujar_joy(float posX, float posY, float tam, float bx, float by) {
    push();
    // Mapa para el color rojo: comienza en blanco (255, 255, 255) y se vuelve rojo (255, 0, 0) a medida que by aumenta
    float mapeo_color = map(by, 0, height - 100, 1, 0);
    color c = lerpColor(color(200, 200, 200), color(255, 165, 0), mapeo_color);

    // Mapa para ajustar posX y posY en función de bx y by
    float distanciaMaxima = 50; // Distancia máxima de movimiento del joystick
    float mapeo_posX = map(bx*13, 0, width, posX - distanciaMaxima / 2, posX + distanciaMaxima / 2);
    float mapeo_posY = map(by*13, 0, height, posY - distanciaMaxima / 2, posY + distanciaMaxima / 2);

    noStroke();
    fill(c);
    ellipse(posX,posY, tam, tam);
    pop();
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
