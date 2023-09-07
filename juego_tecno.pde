import fisica.*;
//to do list
//trackeo de manos
//arreglar rotacion en ejeX
//arreglar tamaño caja de colisiones
//hacer un impulso para alejar del enemigo u obstaculo
//hacer aparecer items de tiempo cada tanto o en diferentes lugares
//implementar escenario y hacer una hitbox con poligonos?
//hacer circulo de interfaz ?
//dar feedback en las colisiones
//diagrama de estados
//pantallas de incio,ganaste,perdiste?

//crear imagenes
PImage conejo_motosierra;
PImage nave_s_fuego;
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


void setup() {
  //inicializar libreria fisica
  Fisica.init(this);
  //inicializar mundo
  mundo=new FWorld();
  //gravedad del mundo
  mundo.setGravity(0, 0);


  //bordes del mundo
  mundo.setEdges();
  size(1080, 720);
  //cargar imagenes
  conejo_motosierra = loadImage("images/enemigo_motosierra.png");
  nave_s_fuego = loadImage("images/conejo_nave_s_fuego.png");

  //objetos
  nave = new Nave();
  //constructor:posX,posY,tamX,tamY,nombre
  obstaculo = new Obstaculo(random(200, width-200), random(100, height-100), 200, 100, "obstaculo1");
  //item
  item = new Item (random(50, width-50), random(50, height-50), 50, 50, "Item");
  //revisar el tamaño de la caja de colisiones
  enemigo = new Enemigo(random(50, width-50), random(50, height-50), 150, 150, "Enemigo");
  interfaz =new Interfaz();
}
//impulso nave


void draw() {
  background(255);
  //mundo
  mundo.step();
  mundo.draw();
  //nave
  nave.moverNave();
  enemigo.mover();
  push();
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
      //cambia el color de nave
      body1.setImageAlpha(90);
      nave.tiempoEsperaInvulnerabilidad = millis();
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
        //borrar el item
        mundo.remove(item.Item);
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
