class ZonaRemota {
  
  boolean actualizado;
  int ultimaActualizacion;
  
  int limite_tiempo_salir;

  float mov_x, mov_y;
  
  int id;

  // datos del area
  float x;
  float y;
  float w;
  float h;
 
  ZonaRemota() {
    
    actualizado = false;

    ultimaActualizacion = 0;
    
    limite_tiempo_salir = -5;

    mov_x = 0; 
    mov_y = 0;
    
    id = -1;

    // datos del area
    x = 0;
    y = 0;
    w = 0;
    h = 0;
  }

  void actualizarDatos(OscMessage m) {
    
    mov_x = m.get(1).floatValue();
    mov_y = m.get(2).floatValue();

    // datos del area
    x = m.get(3).floatValue();
    y = m.get(4).floatValue();
    w = m.get(5).floatValue();
    h = m.get(6).floatValue();
  }

  void setID( int id) {
    this.id = id;
  }

  void dibujar(float w, float h) {

    float cx = (x + this.w /2) * w;
    float cy = (y + this.h /2) * h;

    stroke(255, 255, 0);
    pushMatrix();
    translate(cx, cy);
    stroke(255, 0, 0);
    line(0, 0, mov_x, mov_y);
    fill(0);
    text("id: " + id, 5, 5);
    popMatrix();

    // Bounding Rect
    float rx = x * w;
    float ry = y * h;
    float rw = this.w * w;
    float rh = this.h * h;

    noFill();
    stroke(0, 255, 0);
    pushMatrix();
    translate(rx, ry);
    rect( 0, 0, rw, rh);
    popMatrix();
  }
}
