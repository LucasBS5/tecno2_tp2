class Interfaz {
  float tiempoInicial; // Tiempo inicial en segundos
  float tiempoRestante; // Tiempo restante en segundos
  float barraAnchoInicial; // Ancho inicial de la barra
  float barraAncho; // Ancho actual de la barra
  String text_vidas;
  int num_vidas;
  int cant_items;
  int cant_enem;

  //vector posiciones validas para generar
  ArrayList<PVector> coordenadasValidas = new ArrayList<PVector>();
  //meteoritos
  ArrayList<Meteorito> meteoritos = new ArrayList<Meteorito>();
  int numMeteoritos;
  ArrayList<PVector> sparks = new ArrayList<PVector>();

  Interfaz() {
    tiempoInicial = 50; // Tiempo inicial en segundos
    tiempoRestante = tiempoInicial; // Tiempo restante en segundos
    barraAnchoInicial = 400; // Ancho inicial de la barra
    text_vidas ="Vidas: ";
    num_vidas=5;

    //meteoritos
    numMeteoritos = 5;
    for (int i = 0; i < numMeteoritos; i++) {
      meteoritos.add(new Meteorito());
    }
  }

  void dibujar_Barra_T() {
    barraAncho = barraAnchoInicial; // Ancho actual de la barra
    push();
    //tiene que estar en corner porque sino se achican los dos lados
    rectMode(CORNER);
    // Actualizar el ancho de la barra
    barraAncho = map(tiempoRestante, 0, tiempoInicial, 0, barraAnchoInicial);
    // Dibujar la barra
    noStroke();
    fill(255, 0, 200);
    rect(width/3-10, height/22, barraAncho, 22, 20);
    pop();

    //imagen marco
    marco_barra_t.resize(700, 110);
    push();
    imageMode(CENTER);
    image(marco_barra_t, width/2-50, height/17.8);
    pop();

    //imagen soda de la barra
    soda_barra_t.resize(70, 70);
    image(soda_barra_t, barraAncho+310, 0);
    // Actualizar el tiempo restante
    if (tiempoRestante >0) {
      tiempoRestante -= 1 / frameRate;
    }
  }
  //vidas
  void dibujar_vidas() {
    if (num_vidas>0 && tiempoRestante>0) {
      for (int i = 0; i < vidas.size(); i++) {
        PImage vida = vidas.get(i);
        image(vida, i * 35, 15); // Dibuja cada imagen de vida en una posición
      }
    }

    //perdiste por vidas o tiempo
    else if (num_vidas<1 || tiempoRestante<=0) {
      text_vidas ="perdiste";
      text(text_vidas, width/25, height/15);
    }
  }

  //crear mapa de colisiones
  void crearMapaDeColisiones() {
    for (int x = 0; x < mascara.width; x++) {
      for (int y = 0; y < mascara.height; y++) {
        int index = x + y * mascara.width;
        // Comprueba si el píxel es negro (u otro color deseado)
        if (mascara.pixels[index] == color(0)) {
          coordenadasValidas.add(new PVector(x, y));
        }
      }
    }
  }

  void generarItem(float tiempo_vida) {
    int tam=20;
    int offset =150; // Ajusta el offset según tus necesidades
    if (coordenadasValidas.size() > 0) {
      // Elige una coordenada aleatoria de las coordenadas válidas
      int indiceAleatorio = int(random(coordenadasValidas.size()));
      PVector coordenada = coordenadasValidas.get(indiceAleatorio);
      //evalua si falta algun objeto
      if (enemigo != null && enemigo.enemigo != null && obstaculo != null && obstaculo.obstaculo != null && nave!=null && nave.nave!=null) {
        //verifica si está cerca del borde sumando y restando el tamaño del item
        boolean estaCercaDelBorde = coordenada.x <= offset || coordenada.x >= width - offset ||
          coordenada.y <= offset || coordenada.y >= height - offset;
        boolean cercaenemigo = dist(enemigo.enemigo.getX(), enemigo.enemigo.getY(), coordenada.x, coordenada.y) <= 50;
        boolean cercanave = dist(nave.nave.getX(), nave.nave.getY(), coordenada.x, coordenada.y) <= 10;
        boolean cercaobstaculo = dist(obstaculo.obstaculo.getX(), obstaculo.obstaculo.getY(), coordenada.x, coordenada.y) <= 10;
        // Verifica si la distancia entre la nave y el item es positiva para no dibujarse detras de la nave
        if (!estaCercaDelBorde && !cercanave && !cercaobstaculo && !cercaenemigo) {
          // Crea un objeto en la coordenada seleccionada
          item = new Item(coordenada.x, coordenada.y, tam, tam, "Item");
          //sumar uno a la cantidad actual de items
          cant_items+=1;
        }
      }
    }
  }




  void borrarItem() {
    //borrar el item
    mundo.remove(item.Item);
    //restar uno a la cantidad actual de items en pantalla
    if (cant_items>0) {
      cant_items-=1;
    }
  }




  void generarEnem() {
    int tam = 50;
    //constructor  float posX, float posY, float tam, String nombre, float minY, float maxY, float velocidadRotacion, float velocidadMovimiento
    enemigo= new Enemigo(255, 670, tam, "Enemigo", 480, 645, -0.03, 0.4);
    enemigo1= new Enemigo(550, 550, tam, "Enemigo", 540, 630, 0.03, 0.5);
    cant_enem += 1;
  }

  void borrarEnem() {
    // Elimina el enemigos del mundo si existe
    if (enemigo != null && enemigo.enemigo != null) {
      mundo.remove(enemigo.enemigo);
      mundo.remove(enemigo1.enemigo);
    }
    // Disminuye la cantidad actual de enemigos en pantalla
    cant_enem -= 1;
  }

  //dibujar obstaculos
  void dibujar_obstaculos() {
    //obstaculo1
    //constructor:posX,posY,tamX,tamY,nombre
    obstaculo = new Obstaculo(68, 150, 45, "obstaculo1");

    //obstaculo2
    obstaculo = new Obstaculo(193, 265, 40, "obstaculo1");

    //obstaculo3
    obstaculo = new Obstaculo(220, 295, 45, "obstaculo1");

    //obs4
    obstaculo = new Obstaculo(440, 170, 45, "obstaculo1");

    //obs5
    obstaculo = new Obstaculo( 480, 171, 45, "obstaculo1");

    //obs6
    obstaculo = new Obstaculo(534, 300, 45, "obstaculo1");

    //obs7
    //obstaculo = new Obstaculo(618, 20, 45, "obstaculo1");

    //obs 8
    obstaculo = new Obstaculo( 715, 105, 45, "obstaculo1");

    //9
    obstaculo = new Obstaculo( 820, 170, 45, "obstaculo1");


    //10
    obstaculo = new Obstaculo(996, 30, 45, "obstaculo1");


    //11
    obstaculo = new Obstaculo(1028, 30, 45, "obstaculo1");


    //12
    obstaculo = new Obstaculo(1030, 380, 45, "obstaculo1");


    //13
    obstaculo = new Obstaculo(890, 225, 45, "obstaculo1");


    //14
    obstaculo = new Obstaculo(800, 245, 40, "obstaculo1");


    //15
    obstaculo = new Obstaculo(770, 389, 45, "obstaculo1");


    //16
    obstaculo = new Obstaculo(790, 405, 35, "obstaculo1");


    //17
    obstaculo = new Obstaculo(730, 505, 45, "obstaculo1");


    //18
    obstaculo = new Obstaculo(690, 505, 45, "obstaculo1");


    //19
    obstaculo = new Obstaculo(500, 435, 45, "obstaculo1");


    //20
    obstaculo = new Obstaculo( 650, 710, 45, "obstaculo1");


    //21
    obstaculo = new Obstaculo(470, 710, 45, "obstaculo1");

    //22
    obstaculo = new Obstaculo(420, 710, 45, "obstaculo1");

    //23
    obstaculo = new Obstaculo(230, 710, 45, "obstaculo1");

    //24
    obstaculo = new Obstaculo(320, 430, 45, "obstaculo1");
  }

  void dibuja_meteoritos() {
    for (Meteorito meteorito : meteoritos) {
      meteorito.mover();
      meteorito.mostrar();
    }
  }
  
  //pantalla perdiste con animación


  
 /*void perdiste_c_anim{
 //imagen del fondo
 //dibujar_sparks();
 //imagen conejo
 //imagen perdiste
 }*/
 
}
