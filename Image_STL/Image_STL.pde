import processing.opengl.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.processing.*;

// terrain resolution
int RES = 500;
// physical terrain size in mm
int TOTAL_WIDTH = 250;
int TOTAL_HEIGHT = 40;
// height of plinth below sea level (elevation=0)
int BASE_HEIGHT = 10;
float CELL_SIZE = (float)TOTAL_WIDTH/RES;
float ELEVATION_SCALE = (float)(TOTAL_HEIGHT-BASE_HEIGHT)/255;

WETriangleMesh mesh;
ToxiclibsSupport gfx;
PImage img;

void setup() {
  size(1280, 720, OPENGL);
  img=loadImage("pajaro.jpg");
  img.resize(RES, RES);
  Terrain terrain = new Terrain(RES, RES, CELL_SIZE);
  float[] el = new float[RES*RES];
  for (int i=0; i<img.pixels.length; i++) {
    el[i] = brightness(img.pixels[i])*ELEVATION_SCALE;
  }
  terrain.setElevation(el);
  mesh = new WETriangleMesh();
  terrain.toMesh(mesh,-BASE_HEIGHT);
  
  new LaplacianSmooth().filter(mesh,1);
  String fileName = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2 )+ ".stl"; 
  mesh.saveAsSTL(sketchPath(fileName));
  gfx = new ToxiclibsSupport(this);
  

}

void draw() {
  background(0);
  image(img,0,0);
  ambientLight(150, 150, 150);
  lightSpecular(230,230,230);
  directionalLight(200,200,255,0,1,1);
  specular(255,255,255);
  shininess(16.0);
  translate(width/2, height/2, 0);
  rotateX(mouseY*0.01);
  rotateY(mouseX*0.01);
  noStroke();
  
  gfx.mesh(mesh);
}
