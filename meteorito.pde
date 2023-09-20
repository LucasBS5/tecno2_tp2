class Meteorito {
  float x, y;
  float vel;
  float angle;
  PImage img;
  float size;
  Meteorito() {
    img = loadImage("images/meteorito.png");
    x = width-img.width;
    y = random(height);
    vel = random(2, 5);
    // Inicializa el ángulo con un valor aleatorio
    angle = random(TWO_PI);
    size = random(20, 60); // Cambia los valores según tus preferencias
  }


  void mover() {
    x -= vel;
    if (x < -img.width) {
      x = width-img.width;
      y = random(0+img.height, height-img.height);
    }
  }

  void mostrar() {
    push();
    img.resize(int(size), int(size));
    translate(x + img.width / 2, y + img.height / 2);
    angle += random(-0.02, 0.02);
    rotate(radians(frameCount));
    imageMode(CENTER);
    image(img, 0, 0);
    pop();
  }
}
