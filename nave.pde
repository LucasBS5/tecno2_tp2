//mirar video de coordenadas polares para arreglar el movimiento en x
/*quiero que el angulo determine la direccion de antemano no que incremente o decremente
 dependiendo para donde arrastro el mouse*/
class Nave {
  FBox nave;
  //vars movimiento
  float impY;
  float impX;
  float naveX;
  float naveY;
  float posX;
  float posY;
  boolean mouseArrastrado;
  //vars angulo
  float angulo;
  float rotinicial;
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
    impY = 0;
    impX=0;
    posY = height/2; // Inicializar la posición vertical al centro de la pantalla
    posX = width/2;
    rotinicial=0;
    mouseArrastrado = false;
    //vars visuales
    ancho = 25;
    alto = 50;
    naveX = width - 200;
    naveY = height - 50;
    nave.setPosition(naveX, naveY);
    nave.setGrabbable(false);
    nave.setFill(0, 0, 255);
    nave.setName("Nave");
    vidas=5;
    //imagen nave
    nave_s_fuego.resize(200, 200);
    nave.attachImage(nave_s_fuego);

    //nave invulnerable el tiempo de espera entre activaciones es el tiempo que dura la invulnerabilidad (5s)
    invulnerable = false;
    tiempoInvulnerable = millis();
    //tiempo de invulnerabilidad (2 segundos)
    duracionInvulnerabilidad = 2000;
    //añadir al mundo
    mundo.add(nave);
  }

  // Función para mover la nave
  void moverNave() {
    if (mouseArrastrado && pmouseY > mouseY) {
      impY-=1;
    } else if (!mouseArrastrado) {
      //impY=0;
      //descomentar esto si vamos a usar gravedad 0
      impY =5;
    }
    if (mouseArrastrado && pmouseX < mouseX) {
      rotinicial +=1; // Ajusta la sensibilidad de la rotacion
      impX+=0.1;
    } else if (mouseArrastrado && pmouseX > mouseX) {
      rotinicial -=1; // Ajusta la sensibilidad de la rotacion
      impX-=0.1;
    } else if (!mouseArrastrado) {
      impX=0;
    }
    //constrain para limitar los angulos de rotracion a 80 grados
    nave.setRotation(radians(constrain(rotinicial, -90, 90)));
    //aca habria que hacer un calculo para que el angulo determine la direccion
    nave.addImpulse(impX, impY);
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

  // Métodos para saber si se arrastro o no el mouse
  void mousePressed() {
    mouseArrastrado = true;
  }

  void mouseReleased() {
    mouseArrastrado = false;
  }
}
