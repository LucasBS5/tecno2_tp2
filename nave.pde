
class Nave {
  FBox nave;
  FBox fuego;
  float  velocidadX;
  float  velocidadY;
  //vars visuales
  int alto;
  int ancho;
  int vidas;
  //invulnerable
  boolean invulnerable;
  int tiempoInvulnerable;
  int duracionInvulnerabilidad;
  int tiempoEsperaInvulnerabilidad;
  //imgs nave dañada
  int nivelDeDanio;



  // Constructor de la clase Nave
  Nave() {
    nave = new FBox(25, 50);
    fuego = new FBox(25, 50);
    velocidadY=0;
    //vars visuales
    ancho = 25;
    alto = 50;
    nave.setPosition(100, height-100);
    nave.setRestitution(0.02);
    nave.setGrabbable(false);
    fuego.setGrabbable(false);
    nave.setName("Nave");
    vidas=5;

    //nave invulnerable el tiempo de espera entre activaciones es el tiempo que dura la invulnerabilidad (5s)
    invulnerable = false;
    tiempoInvulnerable = millis();
    //tiempo de invulnerabilidad (2 segundos)
    duracionInvulnerabilidad = 2000;
    nave.attachImage(imagenesNaveDanada[0]);
    fuego.attachImage(fuego_nave);
    fuego.setSensor(true);
    nivelDeDanio=0;
    // Llamar al método para crear la unión entre la nave y el fuego
    crearUnionFuego();
    //añadir al mundo
    mundo.add(nave);
    mundo.add(fuego);
  }





  void moverNave(float bx,float by) {
    if (estado == "jugando") {
      velocidadX= map(bx, 0, 1, -100, 100);
      //velocidadY = map(by, 0, 1, -100, 100);
      // Aplicar gravedad (simulando caída)
      float gravedad = 2;
      velocidadY += gravedad;

      // Detecta el swipe hacia arriba
      float swipeThreshold = 0.01; // Umbral para considerar un swipe
      if (by <ultimaPosicionBY - swipeThreshold) {
        // Se ha realizado un swipe hacia arriba, aplica un impulso hacia arriba
        velocidadY = -70; // Ajusta la fuerza del impulso según sea necesario
        println("arriba");
      }

      // Limitar la velocidad máxima hacia arriba para evitar que suba demasiado rápido
      float velocidadMaximaY = -70; // Ajusta según sea necesario
      if (velocidadY < velocidadMaximaY) {
        velocidadY = velocidadMaximaY;
      }
      nave.setRotation(0);
      // Aplicar la velocidad en el eje Y utilizando setVelocity
      nave.setVelocity(velocidadX, velocidadY);
    }
  }






  // Método para crear la unión entre la nave y el fuego
  void crearUnionFuego() {
    // Crea un FDistanceJoint entre la nave y el fuego
    FDistanceJoint unionFuego = new FDistanceJoint(nave, fuego);
    // Configura la rigidez y amortiguación de la unión
    unionFuego.setDamping(0.2);
    unionFuego.setFrequency(5);
    unionFuego.setDrawable(false);
    // Agrega la unión al mundo
    mundo.add(unionFuego);
  }

  //metodo para dibujar un joystick
  //posicion iniical x,y tamaño , valor de entrada del mouse o trackeo de manos x,y
  void dibujar_joy(float posX, float posY, float tam, float bx, float by) {

    // Mapa para el color rojo: comienza en blanco (255, 255, 255) y se vuelve rojo (255, 0, 0) a medida que by aumenta
    float mapeo_color = map(by, 0, 1, 1, 0);
    color c = lerpColor(color(200, 200, 200), color(255, 165, 0), mapeo_color);

    // Mapa para ajustar posX y posY en función de bx y by
    float distanciaMaxima = 50; // Distancia máxima de movimiento del joystick
    float mapeo_posX = map(bx, 0, 1, posX - distanciaMaxima / 2, posX + distanciaMaxima / 2);
    float mapeo_posY = map(by, 0, 1, posY - distanciaMaxima / 2, posY + distanciaMaxima / 2);
    push();
    noStroke();
    fill(c);
    ellipse(mapeo_posX, mapeo_posY, tam, tam);
    pop();
  }

  void incrementarDanio() {
    nivelDeDanio++;
    // Cambiar la imagen de la nave según el nivel de daño actual
    if (estado=="jugando" && nivelDeDanio < imagenesNaveDanada.length) {
      // Asegúrate de que el nivel de daño no exceda la cantidad de imágenes disponibles
      nave.attachImage(imagenesNaveDanada[nivelDeDanio]);
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
