int sliderY = 477; // Posição inicial do slider
int sliderX = 87; // Posição inicial no eixo X do slider
String modo = "FM"; // Modo inicial

void setup() {
  size(880, 600);
  pg = createGraphics(880, 600);
}

color neon = color(51, 232, 254);
color corpo = color(233, 31, 60);
PGraphics pg;

// altura do corpo do rádio = 185 pixeis
// altura da base do rádio = 40 p
// largura do rádio = 390 p

void draw() {
  background(255); // Fundo branco para melhor visualização
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
  line(827, 477, 51, 477); // linha da base (tem que ser azul)
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
  //ellipse(567, 270, 180, 180); // controle de frequência do rádio
  strokeWeight(4);
  stroke(0);
  //line(643, 270, 491, 270); // botão de frequência
  //line(567, 347, 567, 201); // botão de frequência
  fill(0);
  textSize(20);
  text("volume", 471, 65);
  textSize(12);
  //text("195.8Mhz", 508, 177);
  //text("188.5Mhz", 509, 377);
  text("FM", 758, 224);
  text("AM", 758, 142);
  text("ON/OFF", 103, -6);
  fill(250);
  stroke(neon);
  line(827, 76, 738, 76);

  // Adicionar a barra vertical de ajuste de frequência
  stroke(neon);
  line(sliderX, 477, sliderX, 425); // Linha vertical
  fill(neon);
  ellipse(sliderX, sliderY, 10, 10); // Indicador do slider

  // Desenhar a tela LCD neon
  fill(0);
  stroke(neon);
  rect(468, 320, 180, 40, 10); // Área da tela LCD
  fill(neon);
  textSize(20);
  String frequencia = calcularFrequencia(sliderX);
  text(frequencia, 478, 350);

  pg.beginDraw();
  pg.noFill();
  pg.stroke(neon);
  pg.rect(69, 37, 364, 368, 30); // contorno saída de som maior
  pg.line(825, 477, 53, 477); // linha da base (tem que ser azul)
  pg.line(684, 270, 668, 270);
  pg.arc(685, 245, 50, 50, 0, HALF_PI);
  pg.line(710, 245, 710, 104);
  pg.arc(735, 101, 50, 50, -PI, -1 * HALF_PI);
  pg.line(825, 76, 734, 76);
  pg.strokeWeight(2);
  pg.fill(neon);
  //pg.triangle(567, 185, 557, 200, 577, 200); // seta que indica frequência
  pg.triangle(508, 245, 508,295, 458, 270); // Botão que indica frequência esquerda
  pg.triangle(608, 245, 608, 295, 658, 270); // Botão que indica frequência direita
  pg.triangle(509, 94, 493, 105, 493, 83); // seta de volume
  pg.rect(540, 245, 7, 50);// botão play/pause
  pg.rect(576, 245, -7, 50);//botão play/pause
  pg.filter(BLUR, 0.7);
  pg.endDraw();
  image(pg, 0, 0);
}

void keyPressed() {
  // Atualizar a posição do slider quando as teclas de seta são pressionadas
  if (keyCode == LEFT) {
    sliderX -= 5;
    if (sliderX < 87) sliderX = 87;
  } else if (keyCode == RIGHT) {
    sliderX += 5;
    if (sliderX > 791) sliderX = 791;
  } else if (key == 'A' || key == 'a') {
    modo = "AM";
  } else if (key == 'F' || key == 'f') {
    modo = "FM";
  }
}

String calcularFrequencia(int posicaoSlider) {
  float frequencia;
  if (modo.equals("FM")) {
    frequencia = map(posicaoSlider, 87, 791, 76, 108);
    return String.format("%.1f MHz FM", frequencia);
  } else {
    frequencia = map(posicaoSlider, 87, 791, 500, 1600);
    return String.format("%.0f KHz AM", frequencia);
  }
}
