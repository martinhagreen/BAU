import processing.pdf.*;

float number=90;
float largo;
float rota;
boolean record;

void setup() {
  size(600, 600);
}

void draw() {
  background(255);
  noFill();
  
  if (record) {
    beginRecord(PDF, "####.pdf"); 
  }
 
  strokeWeight(10);
  stroke(0);

  for (int i=100; i<width; i+=100) {
    for (int j=100; j<height; j+=100) {
      pushMatrix();
      geo01(i, j);
      popMatrix();
    }
  }
  
   if (record) {
    endRecord();
    record = false;
  }
}

void geo01(float x, float y) {
  translate(x, y);
  
  for (float n=0; n<360; n+=number) {
    pushMatrix();
    rotate(radians(rota));
    rotate(radians(n));
    strokeCap(PROJECT);
    line(50+largo, -50, 50, 50-largo);
    popMatrix();
  }
}


void keyPressed() {
  rota = random(360);
  largo = random(50);

}

void mouseReleased(){
  record = true;
}
