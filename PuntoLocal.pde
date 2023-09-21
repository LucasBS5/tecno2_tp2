class PuntoLocal{

  float mov_x, mov_y;
  
  float id;

  // datos del area
  float x;
  float y;

  PuntoLocal(float id, float x, float y){

    mov_x = 0; 
    mov_y = 0;
    
    this.id = id;
    
    this.x = x;
    this.y = y;
  }
  
  void actualizarPosicion(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  void actualizarDatos(OscMessage m) {
    mov_x = m.get(1).floatValue();
    mov_y = m.get(2).floatValue();
  }

  void setID( int id) {
    this.id = id;
  }
  
  float getMovX() {
    return(mov_x);
  }

  float getMovY() {
    return(mov_y);
  }

  void dibujar() {


    stroke(255, 255, 0);
    pushMatrix();
    translate(x, y);
    stroke(0, 255, 255);
    line(0, 0, mov_x, mov_y);
    fill(0);
    text("id: " + id, 10, 10);
    popMatrix();

    // Point
    noFill();
    stroke(0, 0, 255);
    pushMatrix();
    translate(x, y);
    ellipse( 0, 0, 10, 10);
    popMatrix();
  }
}
