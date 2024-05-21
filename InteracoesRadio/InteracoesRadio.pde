//testando o git ao adicionar um comentário
//duas doses duplas de teste
void setup() {
  size(1000, 800);
}
int gira=0;
int CursorX=0; //<>// //<>// //<>//
boolean AM=false, FM=false, ligado=false; //<>// //<>//
void draw() {
  strokeWeight(4);
  fill(255);
  rect(50, 100, 400, 100);
  line(60+CursorX, 110, 60+CursorX, 190);
  for (int i=0; i<5; i++) {
    rect(50+80*i, 20, 80, 80);
  }
  rect(50, 200, 400, 100);
  if (ligado==true) {
    fill(0);
    rect(60, 210, 80, 80);
    if (AM==true) {
      fill(#DECB38);
      rect(150, 210, 80, 80);
      if (CursorX>50 && CursorX<60) {
        fill(255, 0, 0);
        rect(60, 30, 60, 60);
      }
    }
    if (FM==true) {
      fill(#1BACF2);
      rect(240, 210, 80, 80);
      if (CursorX>90 && CursorX<110) {
        fill(0, 255, 0);
        rect(140, 30, 60, 60);
      }
    }
  }
  if (keyPressed==true) {   
    if (ligado == true) {
      if (key=='a') {
        AM=true;
        FM=false;
        CursorX=0;
      } else if (key=='f') {
        FM=true;
        AM=false;
        CursorX=0;
      }
      if (key == CODED && keyCode == RIGHT) {
        if (CursorX<380) {
          CursorX++;
        }
      } else if (key == CODED && keyCode == LEFT) {
        if (CursorX>0) {
          CursorX--;
        }
      }
    }
  }
  rect(60, 350, 800, 350, 30);
  rect(60, 700, 800, 50, 30);
  if (keyPressed==true) {
    if (key == CODED && keyCode == UP) {
      gira=gira+1;
    }if (key == CODED && keyCode == DOWN) {
      gira=gira-1;
    }
  }
  translate(500,400);
  rotate(PI*gira/99);
  line(-50,-50,50,50);
  triangle(30,45,51,51,45,30);
}

void keyReleased() {
  if (key =='1') { 
    if (ligado==false) {
      ligado=true;
    } else {
      ligado=false;
      FM=false;
      AM=false;
      CursorX=0;
    }
  }
}
