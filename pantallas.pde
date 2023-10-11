class Pantallas {
  boolean damage;
  //mover cosas
  float movimiento;
  //inicio
  float mover_inicio;
  //ganaste
  float mover_ganaste;
  //perdiste
  float mover_perdiste;
  Pantallas() {
    damage=false;
    //inicio
    mover_inicio=0;
    //ganaste
    mover_ganaste = 0;
    //perdiste
    mover_perdiste = 0;
  }



  //pantalla inicio
  void inicio() {
    bg=inicio;
    //cambiar direccion de las estrellas
    dirX="no";
    dirY="ar";
  }

  void jugando() {
    bg=fondo1;
    interfaz.dibuja_meteoritos();
    //Musica de fondo en loop
    winlose.stop();
    // Iniciar la música de fondo si no se está reproduciendo
    if (!musicaFondo.isPlaying()) {
      musicaFondo.amp(0.5);
      musicaFondo.loop();
    }
  //mundo
  mundo.draw();

    //generar enemigos
    //aca se modifica la cantidad de enemigos que se genera
    if (interfaz.cant_enem<=0) {
      interfaz.generarEnem();
    }
    if (interfaz.cant_enem>0) {
      enemigo.mover();
      enemigo1.mover();
    }



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
    nave.dibujar_joy(width-100, height-100, 50, gestorX.filtradoNorm(), gestorY.filtradoNorm());

    // Llama al método mover para cada objeto Item
    if (item!=null) {
      item.mover();
    }

    //si se acaban las vidas o el tiempo pasa al estado perdiste
    if (interfaz.num_vidas<=0 || interfaz.tiempoRestante<0) {
      estado="perdiste";
    }
    if (damage) {
      image(hover_d, 0, 0);
    }
  }

  //pantalla perdiste
  void perdiste() {
    bg=perdiste;
    dirX="i";
    dirY="ab";
    //audio
    musicaFondo.stop();
    winlose.amp(0.5);
    winlose.loop();
  }

  //pantalla ganaste
  void ganaste() {
    bg=ganaste;
    dirX="d";
    dirY="ar";
    //audio
    musicaFondo.stop();
    winlose.amp(0.5);
    winlose.loop();
    aplausos.amp(0.3);
    aplausos.play();
  }

  //pantalla reincio
  void reincio() {
    //fondo y objs pantallas perdiste y ganaste
    bg=inicio;
    //interfaz
    interfaz.tiempoInicial=50;
    interfaz.tiempoRestante = interfaz.tiempoInicial; // Tiempo restante en segundos
    interfaz.barraAnchoInicial = 400;
    interfaz.num_vidas=5;
    
    nave.nivelDeDanio=0;
    if(nave.nave!=null){
    nave.nave.attachImage(imagenesNaveDanada[nave.nivelDeDanio]);

    //nave
    nave.nave.setVelocity(0, 0);
    nave.nave.setPosition(100, height-100);
    }
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

  //animaciones pantallas
  void animar_pantallas(String cual, float movimiento) {
    float posicion_actual = 0;
    // Asegúrate de que el logo no se salga de la pantalla
    mover_inicio = constrain(mover_inicio, 0, height - logoccuadrado.height);

    if (cual=="inicio") {
      // Aplicar interpolación lineal (lerp) para suavizar el movimiento
      posicion_actual = lerp(posicion_actual, mover_inicio, 0.4);
      // Actualiza la posición del icono cuadrado y el texto
      mover_inicio += movimiento *0.4;
    }
    //ganaste
    if (cual=="ganaste") {
      //mover cosas en la pantalla ganaste
    }
    //perdiste
    if (cual=="perdiste") {
      //mover cosas en la pantalla perdiste
    }
  }

  void pantallas_dib_obj(String cual) {

    if (cual=="inicio") {
      drawStars();
      textOpacity = map(sin(frameCount * 0.05), -1, 1, 70, 255);

      pushStyle();
      //logo con cuadrado
      imageMode(CENTER);
      image(logoccuadrado, width/2, height/2);
      textAlign(CENTER);
      textFont(miFuente);
      fill(220, textOpacity); // Aplica la opacidad
      text("Levanta la mano para jugar", width/2, height/4.5*3.5+mover_inicio);
      popStyle();
    }

    //ganaste
    if (cual=="ganaste") {
      //manchas
      image(manchas_ganaste, 0, 0);
      drawStars();
      image(conejoyletras, 0, 0);
    }
    
    //perdiste
    if (cual=="perdiste") {
      image(manchas_perdiste, 0, 0);
      drawStars();
      image(zombieyletras, 0, 0);
    }
  }


  //dibujar estrellas
  // Función para mover las estrellas
  void moveStars(String dirX, String dirY) {
    // Define las velocidades en X e Y en función de las cadenas de dirección
    float speedX = 0;
    float speedY = 0;
    if (dirX.equals("d")) {
      speedX = starSpeed; // Mueve hacia la derecha en X
    } else if (dirX.equals("i")) {
      speedX = -starSpeed; // Mueve hacia la izquierda en X
    }

    if (dirY.equals("ar")) {
      speedY = -starSpeed; // Mueve hacia arriba en Y
    } else if (dirY.equals("ab")) {
      speedY = starSpeed; // Mueve hacia abajo en Y
    }

    if (dirX.equals("no")) {
      speedX = 0;
    } else if (dirY.equals("no")) {
      speedY = 0;
    }

    // Mueve todas las estrellas
    for (PVector star : stars) {
      star.x += speedX + random(-1, 1); // Agrega un valor aleatorio a la coordenada X
      star.y += speedY + random(-1, 1); // Agrega un valor aleatorio a la coordenada Y

      if (dirX.equals("d")) {
        // Verifica si una estrella ha salido completamente de la pantalla a la derecha
        if (star.x > width) {
          star.x = 0; // Reinicia la estrella al lado izquierdo de la pantalla
        }
      } else if (dirX.equals("i")) {
        // Verifica si una estrella ha salido completamente de la pantalla por la izquierda
        if (star.x < 0) {
          star.x = width; // Reinicia la estrella al lado derecho de la pantalla
        }
      }

      if (dirY.equals("ab")) {
        // Verifica si una estrella ha salido completamente de la pantalla por abajo
        if (star.y > height) {
          star.y = 0; // Reinicia la estrella en la parte superior de la pantalla
        }
      } else if (dirY.equals("ar")) {
        // Verifica si una estrella ha salido completamente de la pantalla por arriba
        if (star.y < 0) {
          star.y = height; // Reinicia la estrella en la parte inferior de la pantalla
        }
      }
    }

    // Verifica si el bloque de estrellas ha salido completamente de la pantalla en el eje X
    if (stars.get(0).x > width + starSpacingX) {
      // Calcular la nueva posición inicial de las estrellas
      float startX = stars.get(numStarsX - 1).x + starSpacingX;
      for (int x = 0; x < numStarsX; x++) {
        float startY = stars.get(x).y;
        stars.get(x).set(startX, startY);
        startX += starSpacingX;
      }
    }
  }

  // Función para dibujar las estrellas
  void drawStars() {
    for (PVector star : stars) {
      if (estado != "jugando" && estado=="inicio") {
        image(estrella, star.x, star.y);
      } else if (estado=="ganaste") {
        image(estrella_ganaste, star.x, star.y);
      } else if (estado=="perdiste") {
        image(estrella_perdiste, star.x, star.y);
      }
    }
  }
}
