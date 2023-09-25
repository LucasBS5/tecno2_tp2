import fisica.*;
import processing.sound.*;
//to do list
//calibrar trackeo de manos
//filtrar trackeo de mov
//hacer circulo de interfaz ?


//EL movimiento se ajusta en la linea "nave.moverNave(averageFlow_x *10, averageFlow_y *10);]" linea 222
//--------
//bflow
int PUERTO_IN_OSC = 12345; // puerto de entrada
int PUERTO_OUT_OSC = 12346; // puerto de salida
String IP = "127.0.0.1"; // ip del BFlow


Receptor receptor;

Emisor emisor;

float averageFlow_x;
float averageFlow_y;

float totalFlow_x;
float totalFlow_y;

//si quiero usar la zona local descomentar
//ZonaLocal z;


//crear imagenes
PImage conejo_motosierra;
//obstaculo
PImage obstaculo_img;
PImage nave_s_fuego;
PImage fuego_nave;
PImage nave_s_fuego_golpe;
//fuego nave
//soda
PImage soda;
//plus
PImage vidaImage; // Imagen de una vida
ArrayList<PImage> vidas = new ArrayList<PImage>(); // ArrayList para las vidas

//fondo
PImage fondo1;
//poligonos
PImage poly1;
PImage poly2;
PImage poly3;
//mapa colisiones
PImage mascara; //imagen mascara
//imagenes interfaz
PImage marco_barra_t;
PImage soda_barra_t;

//imagenes estados
//imagen inicio
PImage inicio;
//imagen ganaste
PImage ganaste;
//imagen perdiste
PImage perdiste;

//vars items
float cant_max_items=0;
//tiempo items
float tiempoActual;
float tiempoUltimaGeneracion;
float tiempoEntreGeneraciones = 03.0; // Tiempo en segundos entre generaciones

//Variable de sonido
SoundFile musicaFondo;
SoundFile winlose;
SoundFile choqueNave;
SoundFile bebida;
SoundFile zombies;
SoundFile aplausos;

//crear mundo
FWorld mundo;
//crear nave
Nave nave;
//crear obstaculo
Obstaculo obstaculo;

//crear item
Item item;
//crear enemigo
Enemigo enemigo, enemigo1;
//crear interfaz
Interfaz interfaz;
//crear caminos
Camino camino1, camino2, camino3;

//crear meta
FBox meta;

//estado
String estado;
//carga para evitar crasheos
boolean inicioCargado = false;
float tiempoInicio;

//tiempo espera ganaste o perdiste
// Definir una variable para llevar el registro del tiempo
boolean esperaIniciada_gop = false;
long tiempoEspera_gop=0;


void setup() {

  //bflow
  setupOSC(PUERTO_IN_OSC, PUERTO_OUT_OSC, IP);
  receptor = new Receptor();
  //descomentar para usar zonalocales
  //receptor.setZonasLocales(emisor.zonasLocales);
  emisor = new Emisor();
  //descomentar para usar zonalocal
  //z= new ZonaLocal(2001, 778, 418, 300, 300);
  //emisor.addZona(z);




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
  nave_s_fuego_golpe = loadImage("images/conejo_nave_s_fuego_golpe.png");
  nave_s_fuego_golpe.resize(90, 90);
  fuego_nave = loadImage("images/nave_c_fuego.png");
  fuego_nave.resize(185, 185);
  //obstaculo img
  obstaculo_img= loadImage("images/img_obstaculo.png");
  //fuego
  //soda
  soda = loadImage("images/soda.png");
  //vidas
  vidaImage =loadImage("images/vidas.png");
  //tamaño vidas
  vidaImage.resize(55, 55);
  for (int i = 0; i < 5; i++) {
    vidas.add(vidaImage.copy()); // Agrega copias de la imagen al arreglo
  }
  //marco barra tiempo
  marco_barra_t =loadImage("images/barra.png");
  //soda barra tiempo
  soda_barra_t = loadImage("images/soda.png");

  //poligonos
  poly1 = loadImage("images/poly1.png");
  poly2 = loadImage("images/poly2.png");
  poly3 = loadImage("images/poly3.png");

  //imagenes estados
  //imagen inicio
  inicio =  loadImage("images/inicio.jpg");
  //imagen ganaste
  ganaste = loadImage("images/ganar.png");
  ganaste.resize(1080, 720);
  //imagen perdiste
  perdiste = loadImage("images/perder.png");
  perdiste.resize(1080, 720);

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

  //Sonidos
  musicaFondo = new SoundFile(this, "sonido/musica fondo1.wav");
  choqueNave = new SoundFile(this, "sonido/choque2.wav");
  zombies = new SoundFile(this, "sonido/zombie1.wav");
  bebida = new SoundFile(this, "sonido/bebida-combustible2.wav");
  winlose = new SoundFile(this, "sonido/musicawl.wav");
  aplausos = new SoundFile(this, "sonido/aplausos.wav");

  //mapa de colisiones
  interfaz.crearMapaDeColisiones();
  //estados empieza en inicio
  estado="inicio";
  //meta
  meta = new FBox(150, 150);
  meta.setStatic(true);
  meta.setSensor(true);
  meta.setPosition(135, 0);
  meta.setDrawable(false);
  meta.setGrabbable(false);
  meta.setName("meta");
  mundo.add(meta);
  // Guarda el tiempo actual en milisegundos.
  tiempoInicio = millis();
}

void draw() {
  //bflow
  receptor.actualizar(mensajes);
  //pasar vars de movimiento de la zona local a la nave
  //el *10 ajusta la sensibilidad
  nave.moverNave(averageFlow_x *10, averageFlow_y *10);
  //receptor.dibujarZonasRemotas(width, height);
  //estado incio
  if (estado=="inicio") {
    image(inicio, 0, 0);
    push();
    textSize(30);
    fill(200);
    text("Levanta la mano para jugar", 380, 520);
    pop();
    //cuando se detecta una mano de este estado pasa a jugando
    /*if(){
     estado="jugando";
     }*/
  }

  //estado jugando y pasó el tiempo de carga
  if (estado=="jugando") {
    image(fondo1, 0, 0);
    interfaz.dibuja_meteoritos();
    //Musica de fondo en loop
    winlose.stop();
    // Iniciar la música de fondo si no se está reproduciendo
    if (!musicaFondo.isPlaying()) {
      musicaFondo.amp(0.5);
      musicaFondo.loop();
    }
    //mundo
    mundo.step();
    mundo.draw();
    //nave


    //generar enemigos
    //aca se modifica la cantidad de enemigos que se genera
    if (interfaz.cant_enem<=0) {
      interfaz.generarEnem();
    }
    if (interfaz.cant_enem>0) {
      enemigo.mover();
      enemigo1.mover();
    }



    push();
    tiempoActual = millis() / 1000.0; // Tiempo actual en segundos
    float tiempoVidaMaximoItem =5.0; // Tiempo de vida máximo de un item en segundos
    // Comprueba si ha pasado suficiente tiempo desde la última generación
    boolean  pasotiempo_generacion=tiempoActual - tiempoUltimaGeneracion >= tiempoEntreGeneraciones ;
    // si se termina el tiempo de vida del item
    boolean pasotiempo_vida = tiempoActual - tiempoUltimaGeneracion >=tiempoVidaMaximoItem;
    if (pasotiempo_generacion && interfaz.cant_items == cant_max_items) {
      interfaz.generarItem(tiempoVidaMaximoItem);
      tiempoUltimaGeneracion = tiempoActual; // Actualiza el tiempo de la última generación
    } else if (pasotiempo_vida && interfaz.cant_items>cant_max_items) {
      interfaz.borrarItem();
      interfaz.generarItem(tiempoVidaMaximoItem);
      tiempoUltimaGeneracion = tiempoActual; // Actualiza el tiempo de la última generación
    }
    


    interfaz.dibujar_Barra_T();
    interfaz.dibujar_vidas();
    pop();
          // Llama al método mover para cada objeto Item
  if (item!=null) {
    item.mover();
  }

    //si se acaban las vidas o el tiempo pasa al estado perdiste
    if (interfaz.num_vidas<=0 || interfaz.tiempoRestante<0) {
      estado="perdiste";
      musicaFondo.stop();
      winlose.amp(0.5);
      winlose.loop();
    }
  }

  //estado ganaste
  if (estado=="ganaste") {
    if (!esperaIniciada_gop) {
      // Si la espera no se ha iniciado, configura el tiempo de espera y marca que se ha iniciado
      tiempoEspera_gop = millis();
      esperaIniciada_gop = true;
      //la imagen de ganaste
      image(ganaste, 0, 0);
    }

    // Verifica si ha pasado el tiempo deseado (por ejemplo, 3000 milisegundos, es decir, 3 segundos)
    if (millis() - tiempoEspera_gop >= 3000) {
      // Reinicia las variables y cambia al estado "inicio"
      esperaIniciada_gop = false;
      estado = "reinicio";
    }
  }
  if (estado=="perdiste") {
    if (!esperaIniciada_gop) {
      // Si la espera no se ha iniciado, configura el tiempo de espera y marca que se ha iniciado
      tiempoEspera_gop = millis();
      esperaIniciada_gop = true;
      //la imagen de ganaste
      image(perdiste, 0, 0);
    }

    // Verifica si ha pasado el tiempo deseado (por ejemplo, 3000 milisegundos, es decir, 3 segundos)
    if (millis() - tiempoEspera_gop >= 3000) {
      // Reinicia las variables y cambia al estado "inicio"
      esperaIniciada_gop = false;
      estado = "reinicio";
    }
  }
  // cuando pasa x cantidad de tiempo de este estado pasa a inicio
  if (estado=="reinicio") {
    //interfaz
    interfaz.tiempoInicial=50;
    interfaz.tiempoRestante = interfaz.tiempoInicial; // Tiempo restante en segundos
    interfaz.barraAnchoInicial = 400;
    interfaz.num_vidas=5;

    //nave
    //quizas resetear el angulo?
    nave.nave.setVelocity(0, 0);
    nave.nave.setPosition(100, height-100);
    // Reinicia las variables y cambia al estado "inicio"
    esperaIniciada_gop = false;
    tiempoEspera_gop=0;

    //restear items y enemigos
    interfaz.borrarItem();
    interfaz.cant_items=0;
    // Restablecer tiempo de última generación
    tiempoUltimaGeneracion = tiempoActual;
    interfaz.borrarEnem();
    //borra las imagenes
    // Borra todas las imágenes del ArrayList
    vidas.clear();
    // Vuelve a agregar la cantidad inicial de imágenes de vida al arreglo
    for (int i = 0; i < 5; i++) {
      vidas.add(vidaImage.copy());
    }
    estado="inicio";
  }
  //BFLOW
  emisor.actualizar();
  //COMENTAR PARA NO DIBUJARLO
  //emisor.dibujar();
}

void mousePressed() {
  if (estado == "inicio" && !inicioCargado && millis() - tiempoInicio >= 3000 ) {
    estado = "jugando";
  }
}

void mouseReleased() {
  // nave.mouseReleased(); // Llamar al método para manejar el mouse cuando se suelta
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
      choqueNave.amp(0.3);
      choqueNave.play();
      println("body1: " + body1.getName());
      println("body2: " + body2.getName());
      //si las vidas son mayores a 0 y la nave no esta invulnerable
      //perdiste una vida
      interfaz.num_vidas-=1;
      vidas.remove(vidas.size() - 1); // Elimina la última imagen de vida

      // Activa la invulnerabilidad,el tiempo de espera entre activaciones es el tiempo que dura la invulnerabilidad (5s)
      nave.hacerInvulnerable();
      nave.tiempoEsperaInvulnerabilidad = millis();
      //cambia el color de nave
      body1.setImageAlpha(150);
      body1.attachImage(nave_s_fuego_golpe);
    }

    //cuando colisionas con la meta  y no se termino el tiempo o las vidas pasa a ganaste
    if (body1.getName() == "Nave" && body2.getName() == "meta" && interfaz.num_vidas>0 && interfaz.tiempoRestante>0 ) {
      estado="ganaste";
      musicaFondo.stop();
      winlose.amp(0.5);
      winlose.loop();
      aplausos.amp(0.3);
      aplausos.play();
    }


    //cuando la nave choca contra un item
    if (body1.getName() == "Nave" && body2.getName() == "Item")
    {
      bebida.amp(0.3);
      bebida.play();
      println("body1: " + body1.getName());
      println("body2: " + body2.getName());
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
      zombies.amp(0.3);
      zombies.play();
      println("body1: " + body1.getName());
      println("body2: " + body2.getName());
      interfaz.num_vidas-=1;
      vidas.remove(vidas.size() - 1); // Elimina la última imagen de vida
      // Activa la invulnerabilidad,el tiempo de espera entre activaciones es el tiempo que dura la invulnerabilidad (5s)
      nave.hacerInvulnerable();
      nave.tiempoEsperaInvulnerabilidad = millis();
      body1.setImageAlpha(150);
      body1.attachImage(nave_s_fuego_golpe);
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
    if (body1.getName()=="Nave" && body2.getName() == "Enemigo" || body1.getName()=="Nave" && body2.getName() == "obstaculo1" )
    {
      body1.setImageAlpha(255);
      body1.attachImage(nave_s_fuego);
    }
  }
}
