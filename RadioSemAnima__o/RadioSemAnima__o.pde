void setup(){
  size(880,600);
}
//altura do corpo do rádio =185pixeis
//altura da base do rádio =40p
//largura do ráido=390p
void draw(){
   translate(0,64);
   strokeWeight(3);
   rect(50,20,780,400,40);//corpo do rádio
   rect(49,420,780,80,40,40,15,15);//base do rádio
   rect(104,0,41,19,28,34,0,0);
   line(827,477,51,477);
   rect(750,252,33,146,40);//saida de som menor
   rect(76,44,350,354,27);//saida de som maior
   rect(459,73,214,42,40);//controle de volume
   line(656,94,476,94);
   rect(473,79,53,30,13);
   triangle(509,94,493,105,493,83);
   for(int i=0;i<5;i++){
     rect(552+16*i,65-(i*7),10,7*i);
   }
   rect(754,147,25,25,10);//botão AM
   rect(754,184,25,25,10);//botão FM
   ellipse(567,270,180,180);//controle de frequencia do rádio
   line(684,270,657,270);
   arc(685,245,50,50,0,HALF_PI);
   line(710,245,710,104);
   arc(735,101,50,50,-PI,-1*HALF_PI);
   line(827,76,738,76);
   strokeWeight(2);
   triangle(567,185,557,200,577,200);//seta que indica frequência
   line(643,270,491,270);//botão de frequência
   line(567,347,567,201);//botão de frequência
   fill(0);
   textSize(20);
   text("volume",471,65);
   textSize(12);
   text("195.8Mhz",508,177);
   text("188.5Mhz",509,377);
   fill(250);
}
