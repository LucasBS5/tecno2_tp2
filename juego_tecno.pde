import fisica.*;
//to do list
//trackeo de manos
//arreglar rotacion en ejeX
//arreglar tamaño caja de colisiones
//hacer un impulso para alejar del enemigo u obstaculo?
//arreglar hacer aparecer items de tiempo cada tanto o en diferentes lugares, capaz es mejor un array con un for para que cada uno tenga un nombre
//hacer circulo de interfaz ?
//dar feedback en las colisiones
//diagrama de estados
//pantallas de incio,ganaste,perdiste?

//crear imagenes
PImage conejo_motosierra;
PImage nave_s_fuego;
PImage fondo1;
//poligonos
PImage poly1;
PImage poly2;
PImage poly3;
//mapa colisiones
PImage mascara; //imagen mascara
//tiempo
float tiempoActual;
float tiempoUltimaGeneracion;
float tiempoEntreGeneraciones = 05.0; // Tiempo en segundos entre generaciones

//crear mundo
FWorld mundo;
//crear nave
Nave nave;
//crear obstaculo
Obstaculo obstaculo;

//crear item
Item item;
//crear enemigo
Enemigo enemigo;
//crear interfaz
Interfaz interfaz;
//crear caminos
Camino camino1, camino2, camino3;


void setup() {
  //inicializar libreria fisica
  Fisica.init(this);
  //inicializar mundo
  mundo=new FWorld();
  //gravedad del mundo
  mundo.setGravity(0, 0);


  //bordes del mundo
  mundo.setEdges();
  mundo.left.setDrawable(false);
  mundo.top.setDrawable(false);
  mundo.bottom.setDrawable(false);
  mundo.right.setDrawable(false);
  size(1080, 720);
  //cargar imagenes
  fondo1 = loadImage("images/fondo1.png");
  conejo_motosierra = loadImage("images/enemigo_motosierra.png");
  nave_s_fuego = loadImage("images/conejo_nave_s_fuego.png");
  //poligonos
  poly1 = loadImage("images/poly1.png");
  poly2 = loadImage("images/poly2.png");
  poly3 = loadImage("images/poly3.png");
  //imagen mapa colision
  mascara = loadImage("images/mapa_colision.jpg");
  mascara.loadPixels();

  //objetos
  nave = new Nave();
  interfaz =new Interfaz();
  interfaz.dibujar_obstaculos();
  //caminos
  camino1=new Camino(1);
  camino2=new Camino(2);
  camino3=new Camino(3);
  //mapa de colisiones
  interfaz.crearMapaDeColisiones();
}

void draw() {
  background(0);
  image(fondo1, 0, 0);

  //mundo
  mundo.step();
  mundo.draw();

  //nave
  nave.moverNave();
  if (interfaz.cant_enem<3) {
    interfaz.generarEnem();
  }

  push();
  tiempoActual = millis() / 1000.0; // Tiempo actual en segundos
  // Comprueba si ha pasado suficiente tiempo desde la última generación
  boolean  pasotiempo_generacion=tiempoActual - tiempoUltimaGeneracion >= tiempoEntreGeneraciones ;
  if (pasotiempo_generacion && interfaz.cant_items <1) {
    interfaz.generarItem();
    tiempoUltimaGeneracion = tiempoActual; // Actualiza el tiempo de la última generación
  }
  interfaz.dibujar_Barra_T();
  interfaz.dibujar_vidas();
  pop();
}

//metodos para saber si se arrastró o no el mouse
void mousePressed() {
  nave.mousePressed(); // Llamar al método para manejar el mouse cuando se presiona
}

void mouseReleased() {
  nave.mouseReleased(); // Llamar al método para manejar el mouse cuando se suelta
}

//colisones
void contactStarted(FContact contacto) {
  FBody body1 = contacto.getBody1();
  FBody body2 = contacto.getBody2();
  //si la colision no es con una pared
  if (body1 != null && body2 != null)
  {
    /*cuando la nave choca contra un obstaculo y no está invulnerable
     y las vidas son mas que 0*/
    if (body1.getName() == "Nave" && body2.getName() == "obstaculo1"
      &&!nave.estaInvulnerable() && interfaz.num_vidas>0)
    {
      println("body1: " + body1.getName());
      println("body2: " + body2.getName());
      //si las vidas son mayores a 0 y la nave no esta invulnerable
      //perdiste una vida
      interfaz.num_vidas-=1;

      // Activa la invulnerabilidad,el tiempo de espera entre activaciones es el tiempo que dura la invulnerabilidad (5s)
      nave.hacerInvulnerable();
      nave.tiempoEsperaInvulnerabilidad = millis();
      //cambia el color de nave
      body1.setImageAlpha(90);
    }

    //cuando la nave choca contra un item
    if (body1.getName() == "Nave" && body2.getName() == "Item")
    {
      println("body1: " + body1.getName());
      println("body2: " + body2.getName());

      //para evitar que se agarren vidas una vez que se acabaron las vidas
      if (interfaz.num_vidas>0 && interfaz.tiempoRestante>0) {
        //agarraste un item
        println("agarraste un item");
        interfaz.borrarItem();
        //dar tiempo
        interfaz.tiempoRestante+=1;
      }
    }

    /*cuando la nave choca contra un enemigo y no está invulnerable
     y las vidas son mas que 0*/
    if (body1.getName() == "Nave" && body2.getName() == "Enemigo"
      && !nave.estaInvulnerable() && interfaz.num_vidas>0)
    {
      println("body1: " + body1.getName());
      println("body2: " + body2.getName());
      interfaz.num_vidas-=1;
      // Activa la invulnerabilidad,el tiempo de espera entre activaciones es el tiempo que dura la invulnerabilidad (5s)
      nave.hacerInvulnerable();
      nave.tiempoEsperaInvulnerabilidad = millis();
      //cambia el color de nave
      body1.setImageAlpha(90);
    }
    if (body2.getName() == "Nave" && body1.getName() == "Enemigo"
      && !nave.estaInvulnerable() && interfaz.num_vidas>0)
    {
      println("body1: " + body1.getName());
      println("body2: " + body2.getName());
      interfaz.num_vidas-=1;
      // Activa la invulnerabilidad,el tiempo de espera entre activaciones es el tiempo que dura la invulnerabilidad (5s)
      nave.hacerInvulnerable();
      nave.tiempoEsperaInvulnerabilidad = millis();
      //cambia el color de nave
      body2.setImageAlpha(90);
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
      body1.setImageAlpha(255);
    }
  }
}
