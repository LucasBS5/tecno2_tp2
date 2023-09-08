float anteX, anteY;
boolean hayUnPunto=false;
ArrayList <PVector> puntos;
void setup(){
  size( 1200 , 600 );
  println("FPoly myPoly = new FPoly();");
  puntos = new ArrayList();
}
void draw(){
  background(0);
  stroke(255);
  push();
  translate( width/2 , height/2 );
  for( int i=1 ; i<puntos.size() ; i++ ){
    PVector uno = puntos.get(i-1);
    PVector dos = puntos.get(i);
    line( uno.x , uno.y , dos.x , dos.y );
  }
  pop();
}
void mousePressed(){
  float x = mouseX-width/2;
  float y = mouseY-height/2;
  println( "myPoly.vertex("+x+", "+y+");");
  puntos.add( new PVector( x , y ) );
}
