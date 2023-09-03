import fisica.*;
//crear mundo
FWorld mundo;
//crear nave
Nave nave;
//crear caja
FBox obstaculo1;
void setup() {
  //inicializar libreria fisica
  Fisica.init(this);
  //inicializar mundo
  mundo= new FWorld();
  //gravedad del mundo
  //mundo.setGravity(0,0);
  //inicializar caja
  //obstaculo 1
  obstaculo1=new FBox(400, height);
  //bordes del mundo
  mundo.setEdges();
  mundo.add(obstaculo1);
  //obstaculo1.setPosition(100, height);
  obstaculo1.setFill(255, 0, 0);
  obstaculo1.setName("obstaculo1");
  obstaculo1.setRestitution(1);
  obstaculo1.setFill(255, 0, 0);
  obstaculo1.setStatic(true);
  obstaculo1.setGrabbable(false);
  obstaculo1.setGrabbable(false);
  obstaculo1.setStatic(true);
  size(500, 500);
  nave = new Nave();
}
//impulso nave


void draw() {
  background(255);
  nave.moverNave();
  //mundo
  mundo.step();
  mundo.draw();
}
//metodos para saber si se arrastró o no el mouse
void mousePressed() {
  nave.mousePressed(); // Llamar al método para manejar el mouse cuando se presiona
}

void mouseReleased() {
  nave.mouseReleased(); // Llamar al método para manejar el mouse cuando se suelta
}

//colisones
//cuando colisiona
void contactStarted(FContact contacto) {
  FBody body1 = contacto.getBody1();
  FBody body2 = contacto.getBody2();
  //los dos ifs de abajo son para evitar que calcule cuando chocas contra las paredes
  if (body1 != null && body2 != null)
  {
    if (body1.getName() != null && body2.getName() != null)
    {
      println("body1: " + body1.getName());
      println("body2: " + body2.getName());
      //perdiste una vida
      println("perdiste una vida");
      body2.setFillColor(color(255, 0, 0));
    }
  }
}

//cuando deja de colisionar
void contactEnded(FContact contacto)
{
  FBody body1 = contacto.getBody1();
  FBody body2 = contacto.getBody2();
  if (body1 != null && body2 != null)
  {
    if (body1.getName() != null && body2.getName() != null)
    {
      body2.setFillColor(color(0, 0, 255));
    }
  }
}
