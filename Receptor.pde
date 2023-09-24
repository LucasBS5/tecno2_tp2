class Receptor { //<>// //<>// //<>//

  ArrayList <ZonaRemota> zonas;
  int tiempo_para_borrar = -15;

  ArrayList <PuntoLocal> puntosLocales; // puntero
  ArrayList <ZonaLocal> zonasLocales; // puntero

  Receptor() {

    zonas = new ArrayList<ZonaRemota>();
  }

  void actualizar(ArrayList <OscMessage> mensajes) {

    resetZonasRemotas(); // Si hay blobs, pone la variable "estaActualizado" en false, en todos las zonas

    while (mensajes.size() > 0) { // Mientras hay mensajes en el buffer

      OscMessage m = mensajes.get(0); // carga el primer mensaje que llegó en la variable m

      if (m.addrPattern().equals("/bflow/averageFlow")) { // si el mensaje tiene la etiqueta (address) "/averageFlow"

        averageFlow_x = m.get(0).floatValue();
        averageFlow_y = m.get(1).floatValue();
      } else if (m.addrPattern().equals("/bflow/totalFlow")) { // si el mensaje tiene la etiqueta (address) "/totalFlow"

        totalFlow_x = m.get(0).floatValue();
        totalFlow_y = m.get(1).floatValue();
      } else if (m.addrPattern().equals("/bflow/averageFlowInRegion")) { // si el mensaje tiene la etiqueta (address) "/averageFlowInRegion"

        boolean encontrado = false;  // 

        int id = (int) m.get(0).floatValue(); // le pido el ID a cada zona del mensaje

        for (int i=0; i<zonas.size(); i++) { // recorro la lista de zonas del repector

          ZonaRemota z = zonas.get(i);

          if (z.id == id) { // si la zona del mensaje ya estaba en mi lista de zonas

            z.actualizarDatos(m); // le envio el mensaje a la zona para que tome los datos del indice correspondiente para actualizarse
            z.actualizado = true; // aviso que este blob ya fue actualizado
            z.ultimaActualizacion = 0;
            encontrado = true; // aviso que la zona del mensaje ya fue encontrado para que deje de buscar entre los de mi lista de blobs
            break; // salgo del siclo for para que deje de buscar
          }
        }

        if (!encontrado) { 

          ZonaRemota nz = new ZonaRemota();   // creo un NUEVO blob
          nz.setID(id);           // le pongo el ID
          nz.actualizarDatos(m);   // le actualizo los datos
          nz.actualizado = true; // lo marco como ya actualizado
          zonas.add(nz);
        }
      } else if (m.addrPattern().equals("/fromBflow/flowInPosition")) { // si el mensaje tiene la etiqueta (address) "/bblobtracke/blobs"

        int id = (int) m.get(0).floatValue(); // le pido el ID a cada blob del mensaje

        for (int i=0; i<puntosLocales.size(); i++) { // recorro la lista de blobs del repector

          PuntoLocal p = puntosLocales.get(i);

          if (p.id == id) { // si el blob del mensaje ya estaba en mi lista de blobs
            p.actualizarDatos(m); // le envio el mensaje al punto para que tome los datos del indice correspondiente para actualizarse
            break; // salgo del siclo for para que deje de buscar
          }
        }
      } else if (m.addrPattern().equals("/fromBflow/flowInRegion")) { // si el mensaje tiene la etiqueta (address) "/bblobtracke/blobs"

        println("recibiendo region pedida");

        int id = (int) m.get(0).floatValue(); // le pido el ID a cada blob del mensaje

        for (int i=0; i<zonasLocales.size(); i++) { // recorro la lista de blobs del repector

          ZonaLocal zl = zonasLocales.get(i);

          if (zl.id == id) { // si el blob del mensaje ya estaba en mi lista de blobs
            zl.actualizarDatos(m); // le envio el mensaje al punto para que tome los datos del indice correspondiente para actualizarse
            break; // salgo del siclo for para que deje de buscar
          }
        }
      }
      mensajes.remove(0);
    }

    for (int k=zonas.size()-1; k>=0; k--) { //recorro mi lista de blobs de atras para adelante
      ZonaRemota vz = zonas.get(k);
      if (!vz.actualizado) {  // si encuentro alguno que no fue actualizado (porque en los mensajes de entrada no estaba
        vz.ultimaActualizacion--;
      }
      if (vz.ultimaActualizacion < tiempo_para_borrar) {
        zonas.remove(k);  // lo borro de la lista
      }
    }
  }

  void setPuntosLocales(ArrayList <PuntoLocal> _puntos) {
    puntosLocales = _puntos;
  }

  void setZonasLocales(ArrayList <ZonaLocal> _zonas) {
    zonasLocales = _zonas;
  }

  void resetZonasRemotas() {
    for (ZonaRemota z : zonas) {
      z.actualizado = false;
    }
  }

  void dibujarZonasRemotas(float w, float h) {
    for (ZonaRemota z : zonas) {
      z.dibujar(w, h);
    }
  }
}
