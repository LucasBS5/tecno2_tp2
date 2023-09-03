class Obstaculo {
  FBox obstaculo;
  //constructor
  Obstaculo() {
    //obstaculo
    obstaculo=new FBox(200, 200);
    obstaculo.setPosition(200, 0);
    obstaculo.setName("obstaculo");
    //añadir obstaculo mundo
    mundo.add(obstaculo);
  }

  void dibujar() {
  }
}
