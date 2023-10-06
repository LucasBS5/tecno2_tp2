import fisica.*;
import processing.sound.*;
//TO DO LIST 
//borrar bflow
//cambiar metodo de captura  a bblob punto mas brillante 
//replicar mecanica de angry birds
//achicar tuneles 
//revisar pantallas de ganaste y perdiste

// para calibrar imprimir gestor de señal
//para minimo moverme lo minimo posible y lo  mismo para el maximo  moverme lo maximo

// mejor captura de punto mas brillante con blob tacker filtrado con gestor

//la densidad hace las cosas mas pesadas se podria probar con la nave

//fuente
PFont miFuente;
//fuente normal
PFont fuente_normal;

//bflow
int PUERTO_IN_OSC = 12345; // puerto de entrada
int PUERTO_OUT_OSC = 12346; // puerto de salida
String IP = "127.0.0.1"; // ip del BFlow


Receptor receptor;

Emisor emisor;

//gestor senial
GestorSenial gestorX;
GestorSenial gestorY;
float min;
float max;
float amortiguacion;

float averageFlow_x;
float averageFlow_y;

float totalFlow_x;
float totalFlow_y;



//crear imagenes
PImage zombie1;
PImage zombie2;
PImage[] imagenesNaveDanada = new PImage[4];

PImage obstaculo_img;
PImage hover_d;
PImage hover_t;
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
PImage logoccuadrado;

//imagen ganaste
//fondo
PImage ganaste;
//manchas
PImage manchas_ganaste;
//conejo con letras ganaste
PImage conejoyletras;


//imagen perdiste
PImage perdiste;
PImage manchas_perdiste;
//zombie con letras ganaste
PImage zombieyletras;

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

PImage estrella;
PImage estrella_ganaste;
PImage estrella_perdiste;
//vars pantallas
//dibujar estrellas
ArrayList<PVector> stars;
int numStarsX = 10; // Número de estrellas en el eje X
int numStarsY = 5; // Número de estrellas en el eje Y
float starSpacingX; // Espaciado entre estrellas en el eje X
float starSpacingY; // Espaciado entre estrellas en el eje Y
float starSize = 5; // Tamaño de las estrellas
float starSpeed = 2; // Velocidad de movimiento
Pantallas pantallas;
String dirX, dirY;
PImage bg;
// Animación del texto
float textOpacity; // Variable para controlar la opacidad del texto

void setup() {
  miFuente = createFont("CapricaScriptPersonalUse.ttf", 30); // Reemplaza "NombreDeTuFuente.ttf" con el nombre real de tu archivo de fuente y ajusta el tamaño.
  fuente_normal = createFont("Helvetica-Bold.ttf", 30); // Reemplaza "NombreDeTuFuente.ttf" con el nombre real de tu archivo de fuente y ajusta el tamaño.
  //bflow
  setupOSC(PUERTO_IN_OSC, PUERTO_OUT_OSC, IP);
  receptor = new Receptor();
  //descomentar para usar zonalocales
  //receptor.setZonasLocales(emisor.zonasLocales);
  emisor = new Emisor();
  //descomentar para usar zonalocal
  //z= new ZonaLocal(2001, 778, 418, 300, 300);
  //emisor.addZona(z);

  //gestor para filtrar captura
  //el movimiento minimo que no se considere ruido
  min=0.7;
  //el valor maximo
  max=0.15;
  //0.99 mucha amortiguacion 0.1 poca amortiguacion
  amortiguacion=0.9;

  gestorX= new GestorSenial( min, max, amortiguacion );
  gestorY= new GestorSenial( min, max, amortiguacion );

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
  fondo1.resize(1080, 720);
  zombie1 = loadImage("images/zombie1.png");
  zombie2 = loadImage("images/zombie2.png");
  for (int i = 0; i < 4; i++) {
    imagenesNaveDanada[i] = loadImage("images/conejo_nave_s_fuego" + i  + ".png");
    imagenesNaveDanada[i].resize(110, 110);
  }

  fuego_nave = loadImage("images/nave_c_fuego.png");
  fuego_nave.resize(185, 185);
  //obstaculo img
  obstaculo_img= loadImage("images/img_obstaculo.png");
  hover_d=loadImage("images/hover_d.png");
  hover_t=loadImage("images/hover_t.png");
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
  inicio =  loadImage("images/inicio1.jpg");
  logoccuadrado = loadImage("images/cuadrado_y_logo.png");

  //imagen ganaste
  ganaste = loadImage("images/ganar_fondo.png");
  ganaste.resize(1080, 720);
  manchas_ganaste = loadImage("images/manchas_ganaste.png");
  conejoyletras = loadImage("images/conejoyletras.png");

  //imagen perdiste
  perdiste = loadImage("images/perder_fondo.png");
  perdiste.resize(1080, 720);
  manchas_perdiste= loadImage("images/manchas_perdiste.png");
  //zombie con letras ganaste
  zombieyletras= loadImage("images/zombieyletras.png");



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

  // dibujar estrellas
  estrella = loadImage("images/burbuja.png");
  estrella.resize(20, 20);
  estrella_ganaste = loadImage("images/estrella_ganaste.png");
  estrella_ganaste.resize(30, 40);
  estrella_perdiste = loadImage("images/estrella_perdiste.png");
  estrella_perdiste.resize(30, 40);
  stars = new ArrayList<PVector>();
  starSpacingX = width / (numStarsX + 1); // Espaciado uniforme en el eje X
  starSpacingY = height / (numStarsY + 1); // Espaciado uniforme en el eje Y

  // Genera las posiciones iniciales de las estrellas con cierta aleatoriedad
  for (int y = 0; y < numStarsY; y++) {
    for (int x = 0; x < numStarsX; x++) {
      float startX = (x + 1) * starSpacingX + random(-starSpacingX, starSpacingX);
      float startY = (y + 1) * starSpacingY + random(-starSpacingY, starSpacingY);
      stars.add(new PVector(startX, startY));
    }
  }
  pantallas = new Pantallas();
  bg=inicio;
}

void draw() {
  //bflow
  receptor.actualizar(mensajes);
  //valor de captura x
  gestorX.actualizar( averageFlow_x );
  //valor de captura y
  gestorY.actualizar( averageFlow_y );

  //pasar vars de movimiento de la zona local a la nave o average para toda la pantalla
  //aca se puede pasar el valor del averge o de la zona local
 nave.moverNave(averageFlow_x, averageFlow_y);

  //o el valor de captura pero filtrado
  //nave.moverNave(gestorX.filtradoNorm(), gestorY.filtradoNorm());

  //o el mouseX y mouseY
  //nave.moverNave(mouseX, mouseY);

  //dibujar imagenes de fondo
  background(bg);
  pantallas.pantallas_dib_obj(estado);
  pantallas.animar_pantallas(estado, sin(frameCount *0.1));
  //estado incio
  if (estado=="inicio") {
    pantallas.inicio();
    //cuando se levanta la mano
    if (estado!="jugando" && averageFlow_y>0.5 && !inicioCargado && millis() - tiempoInicio >= 3000) {
      estado="jugando";
    }
  }

  //estado jugando y pasó el tiempo de carga
  if (estado=="jugando") {
    pantallas.jugando();
  }

  //estado ganaste
  if (estado=="ganaste") {
    if (!esperaIniciada_gop) {
      // Si la espera no se ha iniciado, configura el tiempo de espera y marca que se ha iniciado
      tiempoEspera_gop = millis();
      esperaIniciada_gop = true;
      //la imagen de ganaste
      pantallas.ganaste();
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
      pantallas.perdiste();
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
    pantallas.reincio();
  }
  //BFLOW
  emisor.actualizar();
  //COMENTAR PARA NO DIBUJARLO
  //gestorX.imprimir(width/2,height/2,400,200,true,false);
  //dibujar estrellas
  pantallas.moveStars(dirX, dirY);
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
      //si las vidas son mayores a 0 y la nave no esta invulnerable
      //perdiste una vida
      interfaz.num_vidas-=1;
      vidas.remove(vidas.size() - 1); // Elimina la última imagen de vida

      // Activa la invulnerabilidad,el tiempo de espera entre activaciones es el tiempo que dura la invulnerabilidad (5s)
      nave.hacerInvulnerable();
      nave.tiempoEsperaInvulnerabilidad = millis();
      pantallas.damage=true;
    }

    //cuando colisionas con la meta  y no se termino el tiempo o las vidas pasa a ganaste
    if (body1.getName() == "Nave" && body2.getName() == "meta" && interfaz.num_vidas>0 && interfaz.tiempoRestante>0 ) {
      estado="ganaste";
    }


    //cuando la nave choca contra un item
    if (body1.getName() == "Nave" && body2.getName() == "Item")
    {
      bebida.amp(0.3);
      bebida.play();

      //para evitar que se agarren vidas una vez que se acabaron las vidas
      if (interfaz.num_vidas>0 && interfaz.tiempoRestante>0) {
        interfaz.borrarItem();
        //dar tiempo
        interfaz.tiempoRestante+=1;
        interfaz.sume_tiempo=true;
      }
    }

    /*cuando la nave choca contra un enemigo y no está invulnerable
     y las vidas son mas que 0*/
    if (body1.getName() == "Nave" && body2.getName() == "Enemigo"
      && !nave.estaInvulnerable() && interfaz.num_vidas>0)
    {
      zombies.amp(0.3);
      zombies.play();
      interfaz.num_vidas-=1;
      vidas.remove(vidas.size() - 1); // Elimina la última imagen de vida
      // Activa la invulnerabilidad,el tiempo de espera entre activaciones es el tiempo que dura la invulnerabilidad (5s)
      nave.hacerInvulnerable();
      nave.tiempoEsperaInvulnerabilidad = millis();
      pantallas.damage=true;
      nave.incrementarDanio();
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
      pantallas.damage=false;
    }
  }
}
