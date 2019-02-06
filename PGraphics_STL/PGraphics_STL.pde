

import processing.opengl.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.processing.*;
import toxi.volume.*;

// terrain resolution
int RES= 200;

// physical terrain size in mm
int TOTAL_WIDTH = 100;
int TOTAL_HEIGHT = 10;
int BASE_HEIGHT = 5;
// compute cell size and scale
float CELL_SIZE = (float)TOTAL_WIDTH/RES;
float ELEVATION_SCALE = (float)(TOTAL_HEIGHT-BASE_HEIGHT)/255;

WETriangleMesh mesh;
ToxiclibsSupport gfx;


int mode;
color color1;
color color2;
PGraphics img;
float number=90;
float largo;
float rota;

void setup() {
  size(1280, 720, P3D);
  img = createGraphics(RES,RES);
  img.beginDraw();
  img.endDraw();
  Terrain terrain = new Terrain(RES, RES, CELL_SIZE);
  float[] el = new float[RES*RES];
  for (int i=0; i<img.pixels.length; i++) {
    el[i] = brightness(img.pixels[i])*ELEVATION_SCALE;
  }
  
  terrain.setElevation(el);
  mesh = new WETriangleMesh();
  terrain.toMesh(mesh,-BASE_HEIGHT);
  new LaplacianSmooth().filter(mesh,1);
  gfx = new ToxiclibsSupport(this);

}

void draw() {
  background(128);
  image(img,0,0);
 
   ambientLight(150, 150, 150);
  lightSpecular(230,230,230);
  directionalLight(200,200,255,0,1,1);
  specular(255,255,255);
  shininess(16.0);

  pushMatrix();  
    translate(width/2, height/2, 0);
    rotateX(mouseY*0.01);
    rotateY(mouseX*0.01);
    noStroke(); 
    scale(4);
  gfx.mesh(mesh);
  popMatrix();
   
}


void keyReleased(){
  if(key == 's'){
    String fileName = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2 )+ ".stl"; 
    mesh.saveAsSTL(sketchPath(fileName));
  }
  
  if(key == 'a'){ 
    mode = int(random(2));
    if(mode == 0){
      color1 = color( 0);
      color2 = color(255);
    }
     if(mode == 1){
      color1 = color(255);
      color2 = color(0);
    }
    
    rota = random(360);
    largo = random(50);
    
  //AQUI EMPIEZA EL PGRAPHICS 
 img.beginDraw();
  
    img.background(color1);
    img.noFill();
    img.strokeWeight(5);
    img.stroke(color2);
  
     for (int i=50; i<img.width; i+=50) {
      for (int j=50; j<img.height; j+=50) {
      img.pushMatrix();
      img.translate(i,j);
        for (float n=0; n<360; n+=number) {
          img.pushMatrix();
            img.rotate(radians(rota));
            img.rotate(radians(n));
            img.strokeCap(PROJECT);
            img.line(10+largo, -10, 10, 10-largo);
          img.popMatrix();
      }
      img.popMatrix();
    }
  }
  
  img.endDraw(); 
  //AQUI TERMINA EL PGRAPHICS
  
  Terrain terrain = new Terrain(RES, RES, CELL_SIZE);
  float[] el = new float[RES*RES];

  for (int i=0; i<img.pixels.length; i++) {
    el[i] = brightness(img.pixels[i])*ELEVATION_SCALE;
  }
    terrain.setElevation(el);
    mesh = new WETriangleMesh();
    terrain.toMesh(mesh,-BASE_HEIGHT);
    new LaplacianSmooth().filter(mesh,1);
  }
}
