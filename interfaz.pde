class Interfaz {
  float tiempoInicial; // Tiempo inicial en segundos
  float tiempoRestante; // Tiempo restante en segundos
  float barraAnchoInicial; // Ancho inicial de la barra
  float barraAncho; // Ancho actual de la barra
  String text_vidas;
  int num_vidas;
  Interfaz() {
    tiempoInicial = 100; // Tiempo inicial en segundos
    tiempoRestante = tiempoInicial; // Tiempo restante en segundos
    barraAnchoInicial = 400; // Ancho inicial de la barra
    text_vidas ="Vidas: ";
    num_vidas=5;
  }
  void dibujar_Barra_T() {
    barraAncho = barraAnchoInicial; // Ancho actual de la barra
    push();
    //tiene que estar en corner porque sino se achican los dos lados
    rectMode(CORNER);
    // Actualizar el ancho de la barra
    barraAncho = map(tiempoRestante, 0, tiempoInicial, 0, barraAnchoInicial);
    // Dibujar la barra
    fill(255, 0, 200);
    rect(width/2, height/18, barraAncho, 20);
    pop();
    // Actualizar el tiempo restante
    if (tiempoRestante >0) {
      tiempoRestante -= 1 / frameRate;
    }
  }

  void dibujar_vidas() {
    textSize(30);
    fill(0);
    if (num_vidas>0 && tiempoRestante>0) {
      text(text_vidas+num_vidas, width/25, height/15);
    }
    //perdiste por vidas o tiempo
    else if (num_vidas<1 || tiempoRestante<=0) {
      text_vidas ="perdiste";
      text(text_vidas, width/25, height/15);
    }
  }
}
