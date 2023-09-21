class Emisor {

  ArrayList <PuntoLocal> puntosLocales;
  ArrayList <ZonaLocal> zonasLocales;

  Emisor() {
    
    puntosLocales = new ArrayList<PuntoLocal>();
    zonasLocales = new ArrayList<ZonaLocal>();
  }

  void addPunto(PuntoLocal p) {
    puntosLocales.add(p);
  }

  void addZona(ZonaLocal zl) {
    zonasLocales.add(zl);
  }

  void actualizar() {

    for (PuntoLocal p : puntosLocales ) {

      OscMessage myMessage = new OscMessage("/toBflow/flowInPosition");

      myMessage.add(p.id);
      myMessage.add(p.x / width); 
      myMessage.add(p.y / height);

      /* send the message */
      osc.send(myMessage, myRemoteLocation);
    }


    for (ZonaLocal z : zonasLocales ) {

      OscMessage myMessage = new OscMessage("/toBflow/flowInRegion");

      myMessage.add(z.id);
      myMessage.add(z.x / width); 
      myMessage.add(z.y / height);
      myMessage.add(z.w / width); 
      myMessage.add(z.h /height);

      /* send the message */
      osc.send(myMessage, myRemoteLocation);
    }
  }
  
  void dibujar() {
    for (PuntoLocal p : puntosLocales) {
      p.dibujar();
    }

    for (ZonaLocal r : zonasLocales) {
      r.dibujar();
    }
  }
}
