import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer player;
String currentStation = "";

// Lista de URLs de rádios online
String[] AMStations = {
  
  "http://stream.whus.org:8000/whusfm", // Exemplo de estação AM
  "http://stream.wrmh.fm:8000/stream", // Exemplo de estação AM
  // Adicionar mais URLs de rádios AM
};
String[] FMStations = {
  "http://stream.radioparadise.com/mp3-128", // Exemplo de estação FM
  "http://ice1.somafm.com/groovesalad-128-mp3", // Exemplo de estação FM
  
  // Adicionar mais URLs de rádios FM
};

void setup() {
  size(880, 600);
  pg = createGraphics(880, 600);
  minim = new Minim(this);
}

color neon = color(51, 232, 254);
color corpo = color(233, 31, 60);
PGraphics pg;
int Cursor = 0;
boolean AM = false, FM = false, ligado = false;

void draw() {
  stroke(0);
  strokeWeight(3);
  translate(0, 64);
  strokeWeight(3);
  fill(corpo);
  rect(50, 20, 780, 400, 40); // corpo do rádio
  rect(49, 420, 780, 80, 40, 40, 15, 15); // base do rádio
  stroke(0);
  fill(corpo);
  rect(104, 1, 41, 19, 28, 34, 0, 0); // botão de ligar
  fill(100);
  stroke(neon);
  line(827, 477, 51, 477); // linha da base(tem que ser azul)
  stroke(0);
  rect(750, 252, 33, 146, 40); // saída de som menor
  rect(76, 44, 350, 354, 27); // saída de som maior
  fill(0);
  for (int j = 0; j < 9; j++) {
    ellipse(759, 265 + 15 * j, 10, 10);
    if (j != 0)
      ellipse(773, 257 + 15 * j, 10, 10);
  }
  for (int j = 0; j < 19; j++) {
    for (int k = 0; k < 23; k++) {
      if (j % 2 == 0 && k != 22) {
        ellipse(90 + 18 * j, 61 + 15 * k, 10, 10);
      } else if (j != 19 && j % 2 != 0) {
        ellipse(90 + 18 * j, 54 + 15 * k, 10, 10);
      }
    }
  }
  fill(corpo);
  rect(459, 73, 214, 42, 40); // controle de volume
  line(656, 94, 476, 94);
  fill(100);
  rect(473, 79, 53, 30, 13); // botão de volume
  fill(255);
  stroke(0);
  for (int i = 0; i < 5; i++) {
    rect(552 + 16 * i, 65 - (i * 7), 10, 7 * i);
  }
  rect(754, 147, 25, 25, 10); // botão AM
  rect(754, 184, 25, 25, 10); // botão FM
  fill(corpo);
  ellipse(567, 270, 180, 180); // controle de frequencia do rádio
  strokeWeight(4);
  stroke(0);
  line(643, 270, 491, 270); // botão de frequência
  line(567, 347, 567, 201); // botão de frequência
  fill(0);
  textSize(20);
  text("volume", 471, 65);
  textSize(12);
  text("195.8Mhz", 508, 177);
  text("188.5Mhz", 509, 377);
  text("FM", 758, 224);
  text("AM", 758, 142);
  text("ON/OFF", 103, -6);
  triangle(509, 94, 493, 105, 493, 83); // seta de volume
  fill(250);
  stroke(neon);
  line(827, 76, 738, 76);

  // Desenha as barras verticais crescentes a partir do centro
  if (ligado && (AM || FM)) {
    float startX = 440; // ponto central
    int numBars = 50; // número de barras de cada lado
    float barSpacing = 8; // espaçamento entre as barras
    float centerY = 477;

    if (AM) {
      for (int i = 0; i <= abs(Cursor); i++) {
        float barHeight = map(i, 0, numBars, 5, 40);
        float barX1 = startX + i * barSpacing; // barras para a direita
        line(barX1, centerY, barX1, centerY - barHeight);
      }
    }
    if (FM) {
      for (int i = 0; i <= abs(Cursor); i++) {
        float barHeight = map(i, 0, numBars, 5, 40);
        float barX2 = startX - i * barSpacing; // barras para a esquerda
        line(barX2, centerY, barX2, centerY - barHeight);
      }
    }
  }

  pg.beginDraw();
  pg.noFill();
  pg.stroke(neon);
  pg.rect(69, 37, 364, 368, 30); // contorno saída de som maior
  pg.line(825, 477, 53, 477); // linha da base(tem que ser azul)
  pg.line(684, 270, 658, 270);
  pg.arc(685, 245, 50, 50, 0, HALF_PI);
  pg.line(710, 245, 710, 104);
  pg.arc(735, 101, 50, 50, -PI, -1*HALF_PI);
  pg.line(825, 76, 734, 76);
  pg.strokeWeight(2);
  pg.fill(neon);
  pg.filter(BLUR, 0.7);
  pg.endDraw();
  image(pg, 0, 0);

  if (ligado == true) {
    fill(0);
    rect(104, 1, 41, 19, 28, 34, 0, 0); // botão de ligar
    if (AM == true) {
      fill(0, 0, 0);
      rect(754, 147, 25, 25, 10); // botão AM
    }
    if (FM == true) {
      fill(0, 0, 0);
      rect(754, 184, 25, 25, 10); // botão FM
    }
  }
  if (keyPressed == true) {
    if (ligado == true) {
      if (key == 'a') {
        AM = true;
        FM = false;
        Cursor = 0;
        tuneRadio();
      } else if (key == 'f') {
        FM = true;
        AM = false;
        Cursor = 0;
        tuneRadio();
      }
    }
  }
  if (keyPressed == true) {
    if (key == CODED) {
      if (FM == true) {
        if (keyCode == UP && Cursor < 0) {
          Cursor = Cursor + 1;
          tuneRadio();
        }
        if (keyCode == DOWN && Cursor > -45) {
          Cursor = Cursor - 1;
          tuneRadio();
        }
      }
      if (AM == true) {
        if (keyCode == UP && Cursor > 0) {
          Cursor = Cursor - 1;
          tuneRadio();
        }
        if (keyCode == DOWN && Cursor < 45) {
          Cursor = Cursor + 1;
          tuneRadio();
        }
      }
    }
  }
  translate(567, 270);
  rotate(PI * Cursor / 45);
  fill(0);
  stroke(0);
  triangle(-10, -68, 0, -84, 10, -69); // seta que indica frequência
  line(0, -75, 0, 75); // botão de frequência
  line(-75, 0, 75, 0); // botão de frequência
}

void keyReleased() {
  if (key == '1') {
    if (ligado == false) {
      ligado = true;
    } else {
      ligado = false;
      FM = false;
      AM = false;
      Cursor = 0;
      stopRadio();
    }
  }
}

// Função para sintonizar a rádio
void tuneRadio() {
  if (player != null) {
    player.close();
  }
  if (AM) {
    int index = int(map(Cursor, 0, 10, 0, AMStations.length - 1));
    currentStation = AMStations[index];
  } else if (FM) {
    int index = int(map(Cursor, 0, -10, 0, FMStations.length - 1));
    currentStation = FMStations[index];
  }
  player = minim.loadFile(currentStation, 2048);
  player.play();
}

// Função para parar a rádio
void stopRadio() {
  if (player != null) {
    player.close();
  }
}
