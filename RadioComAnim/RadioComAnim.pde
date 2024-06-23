import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer player;
String currentStation = "";
int sensibilidade;//sensibilidade da variação do cursor
AudioMetaData ProcuraRuido;

// Lista de URLs de rádios online
String[] AMStations = {
  "nd","nd",
  "http://stream.whus.org:8000/whusfm", // Exemplo de estação AM
  "nd","nd","nd",                                 //Estacao nao definida
  "http://ice1.somafm.com/groovesalad-128-mp3", // Exemplo de estação AM
  "nd","nd","nd"
};
String[] FMStations = {
  "nd","nd","nd",
  "http://stream.radioparadise.com/mp3-128", // Exemplo de estação FM
  "nd","nd","nd",
  "http://ice1.somafm.com/groovesalad-128-mp3", // Exemplo de estação FM
  "nd","nd"
};

String ruido = "radio_noise.mp3";

void setup() {
  size(880, 600);
  pg = createGraphics(880, 600);
  minim = new Minim(this);
}

color neon = color(51, 232, 254);
color corpo = color(233, 31, 60);
color corpo2 = color(150, 10, 30);
PGraphics pg;
int boca_width = 250;
int boca_hight = 255;
int Cursor = 0;
boolean AM = false, FM = false, ligado = false;

// Variáveis de controle de volume
int volumeLevel = 1;
float[] volumeValues = {0.0, 0.25, 0.5, 0.75, 1.0};

void draw() {
  stroke(0);
  strokeWeight(3);
  translate(0, 64);
  strokeWeight(3);
  fill(corpo);
  rect(50, 20, 780, 400, 40); // corpo do rádio
  rect(49, 420, 780, 80, 40, 40, 15, 15); // base do rádio
  stroke(0);
  fill(corpo2);
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
  
  // Desenha olhos e boca dentro do rádio
  desenhaOlhosEMoca();
  
  fill(corpo);
  rect(461, 73, 214, 42, 40); // controle de volume
  line(656, 94, 476, 94);
  fill(100);
  rect(473+volumeLevel*33, 79, 53, 30, 13); // botão de volume
  fill(255);
  stroke(0);
  for (int i = 0; i < 5; i++) { // Barras de indicação do volume
    rect(552 + 16 * i, 65 - (i * 7), 10, 7 * i);
  }
  fill(corpo2);
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
  text("volume", 471, 51);
  textSize(12);
  fill(corpo2);
  noStroke();
  rect(481, 67, 14, -14, 2);
  rect(509, 67, 14, -14, 2);
  fill(0);
  text("-  |  +", 485, 65);
  text("195.8Mhz", 508, 177);
  text("188.5Mhz", 509, 377);
  text("FM", 758, 224);
  text("AM", 758, 142);
  text("ON/OFF", 103, -6);
  triangle(509+volumeLevel*33, 94, 493+volumeLevel*33, 105, 493+volumeLevel*33, 83); // seta de volume
  fill(250);
  stroke(neon);
  line(827, 76, 738, 76);

  // Desenha as barras verticais crescentes a partir do centro
  if (ligado && (AM || FM)) {
    float startX = 440; // ponto central
    int numBars = 50; // número de barras de cada lado
    float barSpacing = 8; // espaçamento entre as barras
    float centerY = 477;

    if (FM) {
      for (int i = 0; i <= abs(Cursor); i++) {
        float barHeight = map(i, 0, numBars, 5, 40);
        float barX1 = startX + i * barSpacing; //barras para a direita
        line(barX1, centerY, barX1, centerY - barHeight);
      }
    }
    if (AM) {
      for (int i = 0; i <= abs(Cursor); i++) {
        float barHeight = map(i, 0, numBars, 5, 40);
        float barX2 = startX - i * barSpacing; //barras para a esquerda
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
    stroke(0);
    strokeWeight(3);
    fill(neon);
    rect(104, 1, 41, 19, 28, 34, 0, 0); // botão de ligar
    rect(754, 147, 25, 25, 10); // botão AM
    rect(754, 184, 25, 25, 10); // botão FM
    
    if (AM == true) {
      fill(255,255,0);
      rect(754, 147, 25, 25, 10); // botão AM
    }
    if (FM == true) {
      fill(255,255,0);
      rect(754, 184, 25, 25, 10); // botão FM
    }
  }
  if (keyPressed == true) {
    if (ligado == true) {
      if (key == 'a' || key == 'A') {
        AM = true;
        FM = false;
        Cursor = 0;
        tuneRadio();
      } else if (key == 'f' || key == 'F') {
        FM = true;
        AM = false;
        Cursor = 0;
        tuneRadio();
      }
    }
  }
  sensibilidade=3;//mude o valor para cursor para aumentar a velocidade, apenas valores inteiros, preferência para valores que dividem 45 sem resto(1, 3, 5, 7, 9, etc...) para não gerar incosistência
  if (keyPressed == true) {
     if (AM == true) {
       if ((key== '4' || keyCode == LEFT) &&  Cursor > -45) {
         Cursor = Cursor - sensibilidade;
         tuneRadio();
       }
       if ((key== '6' || keyCode == RIGHT) && Cursor < 0) {
         Cursor = Cursor + sensibilidade;
         tuneRadio();
       }
     }
     if (FM == true) {
       if ((key== '6' || keyCode == RIGHT) && Cursor < 45) {
         Cursor = Cursor + sensibilidade;
         tuneRadio();
       }
       if ((key== '4' || keyCode == LEFT) && Cursor > 0) {
         Cursor = Cursor - sensibilidade;
         tuneRadio();
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
  if (key == 'o' || key == 'O') {
    if (ligado == false) {
      ligado = true;
    } else {
      ligado = false;
      FM = false;
      AM = false;
      Cursor = 0;
      stopRadio();
    }
  } else if (key == '=' || key == '+') {
    if (volumeLevel < 4) {
      volumeLevel++;
      setVolume(volumeLevel);
    }
  } else if (key == '-' || key == '_') {
    if (volumeLevel > 0) {
      volumeLevel--;
      setVolume(volumeLevel);
    }
  }
}

// Função para sintonizar a rádio
void tuneRadio() {
  if (FM) {
    int index = int(map(Cursor, 0, 45, 0, FMStations.length - 1)); //<>// //<>//
    if (index >= 0 && index < FMStations.length) {
      currentStation = FMStations[index]; //<>//
    
    }
  } else if (AM) {
    int index = int(map(Cursor, 0, -45, 0, AMStations.length - 1)); //<>// //<>//
    if (index >= 0 && index < AMStations.length) {
      currentStation = AMStations[index]; //<>//
     //<>//
    }
  } //<>//
  
  if (currentStation != null && !currentStation.isEmpty()) {
    if (player != null) {
      player.close(); //<>//
    }
    player = minim.loadFile(currentStation, 2048); //<>//
    if (player != null) {
      player.play();
      setVolume(volumeLevel);
    } else {
        // Ruido em caso de erro
        
          player = minim.loadFile(ruido, 2048);
          player.play();
          player.loop();
          setVolume(volumeLevel);
    }
  } else {
      // Ruido se a URL não estiver definida
        player = minim.loadFile(ruido, 2048);
        player.play();
        player.loop();
        setVolume(volumeLevel);
  }
  
}

// Função para parar a rádio
void stopRadio() {
  if (player != null) {
    player.close();
  }
}

void setVolume(int level) {
  if (player != null) {
    player.setGain(-20.0 + 20.0 * volumeValues[level]);
  }
}



void desenhaOlhosEMoca() {
  // Desenha olhos e boca baseados no estado do rádio
  if (ligado ) { // Se estiver ligado e sintonizado
    if ((AM || FM) && player != null) {
      if(player.getMetaData().fileName()=="radio_noise.mp3"){
        desenhaOlhosAbertos();
        desenhaBocaTriste();
      }else{
        desenhaOlhosFelizes();
        desenhaBocaFeliz();
      }
    }
    if(!AM && !FM){
      desenhaOlhosAbertos();
      desenhaBocaFechada();
    }
  } else {
    desenhaOlhosFechados();
    desenhaBocaFechada();
  }
}

void desenhaOlhosFechados() {
  // Olhos fechados estilo Mario
  fill(255);
  stroke(0);
  strokeWeight(5);
  line(150, 135, 210, 135);
  line(290, 135, 350, 135);
  //ellipse(180, 150, 60, 30); // Olho esquerdo
  //ellipse(320, 150, 60, 30); // Olho direito
  fill(0);
  //ellipse(180, 155, 30, 10); // Pupila olho esquerdo
  //ellipse(320, 155, 30, 10); // Pupila olho direito
}

void desenhaOlhosAbertos(){
  fill(255);
  stroke(0);
  strokeWeight(5);
  ellipse(180, 150, 80, 80);//Olho esquerdo
  ellipse(320, 150, 80, 80);//Olho direito
  fill(0);
  ellipse(180, 160, 40, 40);//Pupila olho esquerdo
  ellipse(320, 160, 40, 40);//Pupila olho direito
  fill(255);
  ellipse(186, 169, 20, 20);//Brilho olho esquerdo
  ellipse(314, 169, 20, 20);//Brilho olho direito
}

void desenhaOlhosFelizes(){
  fill(255);
  stroke(0);
  strokeWeight(5);
  ellipse(180, 150, 80, 80);//Olho esquerdo
  ellipse(320, 150, 80, 80);//Olho direito
  fill(0);
  ellipse(180, 150, 40, 40);//Pupila olho esquerdo
  ellipse(320, 150, 40, 40);//Pupila olho direito
  fill(255);
  ellipse(169, 144, 20, 20);//Brilho olho esquerdo
  ellipse(309, 144, 20, 20);//Brilho olho direito
}

void desenhaBocaFechada(){
  // Boca fechada estilo Mario
  stroke(0);
  strokeWeight(5);
  noFill();
  line(200, 250, 300, 250);
  //arc(250, 300, 100, 50, 0, PI); //Boca fechada
}

void desenhaBocaTriste(){
  // Boca triste estilo Mario
  fill(corpo);
  stroke(0);
  strokeWeight(5);
  arc(boca_width, boca_hight, 130, 60, PI, 2*PI); //Boca triste
  line(boca_width - 65, boca_hight, boca_width + 65, boca_hight); //Linha da boca triste
}

void desenhaBocaFeliz(){
  // Boca feliz estilo Mario
  fill(neon);
  stroke(0);
  strokeWeight(5);
  arc(boca_width, boca_hight, 130, 60, 0, PI); //Boca feliz
  line(boca_width - 65, boca_hight, boca_width + 65, boca_hight); //Linha da boca feliz
}
