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
    //añadir al mundo
    mundo.add(nave);
  }

  // Función para mover la nave
  void moverNave() {

    if (mouseArrastrado && pmouseY > mouseY) {
      impY-=1;
    } else if (!mouseArrastrado) {
      impY = 0;
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
    nave.setRotation(radians(constrain(rotinicial, -80, 80)));
    //aca habria que hacer un calculo para que el angulo determine la direccion
    nave.addImpulse(impX, impY);
  }




  // Métodos para saber si se arrastro o no el mouse
  void mousePressed() {
    mouseArrastrado = true;
  }

  void mouseReleased() {
    mouseArrastrado = false;
  }
}
