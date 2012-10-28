void setup() {
  size(800,400);
  background(255);
}

int seed = 1234;

void draw() {
  background(255);
  randomSeed(seed);
  float terrain[] = {1,1};
  float factor = 0.6; //map(mouseY,0,400,1,0);
  float range = 1;
  int m = int(map(mouseX,0,800,1,12));
  for (int j=0;j<m;j++) {
    int i = terrain.length - 1;
    while (i>0) {
      float midpoint = (terrain[i]+terrain[i-1])/2.0;
      terrain = splice(terrain, (midpoint + random(-range,range)), i);
      i--;   
    }
    range = range * factor;
  }
  int iter = int(map(mouseX,0,800,0,5));
  println(iter);
//  for (int j=0;j<iter;j++) {
//    for (int i=1;i<(terrain.length-1);i++) {
////      terrain[i] = (terrain[i-1]+terrain[i]+terrain[i+1])/3.0;
//
//      if (terrain[i-1]<terrain[i+1]) {
//        terrain[i] = terrain[i-1];
//      } else {
//        terrain[i] = terrain[i+1];
//      }
//    }
//  }
  
  
  noFill();
  beginShape();
  for (int n=0;n<terrain.length;n++) {
    vertex(map(n,0,terrain.length-1,0,800),map(terrain[n],0,2,400,0));
  }
  endShape();
//  println(terrain.length);
}

void mouseClicked() {
  seed = int(random(0,5000));
}








