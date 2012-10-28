
int n = 5;  // 2^n + 1 = 5
int terrain_size = int(pow(2,n)+1);
float[][] ter = new float[terrain_size][terrain_size];
float factor = 0.5;
float range;
int seed = 1234;
int old_seed = 1234;
float draw_size = 100;
PrintWriter file;

void setup() {
  size(600,600,P3D);
  noFill();
  randomSeed(seed);
  init_array(ter);
  generate(ter);
  file = createWriter("terrain.stl");
  output_model(ter,file);
  println("Model saved.");
}

void draw() {
  if (seed != old_seed) {
    println("Generating.");
    generate(ter);
    old_seed = seed;
  }
  draw_array(ter);
}

void generate(float[][] terrain) {
  for (int iter=0;iter<n;iter++) {
    range = 20*pow(factor,iter);
    int w = int(pow(2,(n-iter)));  // width of square
    int h = int(pow(2,(n-iter-1)));  // half width of square
    // Square step
    for (int x=0;x<int(pow(2,n));x+=w) {
      for (int y=0;y<int(pow(2,n));y+=w) {
        terrain[x+h][y+h] = (terrain[x][y] + terrain[x+w][y] + terrain[x+w][y+w] + terrain[x][y+w])/4.0 
            + random(-range,range);;
      }
    }
    // Diamond Step
    for (int x=0;x<int(pow(2,n));x+=w) {
      for (int y=0;y<int(pow(2,n));y+=w) {
        terrain[ind(y+h)][x] = (terrain[y][x] + terrain[ind(y+h)][ind(x+h)] + terrain[ind(y+w)][x] 
            + terrain[ind(y+h)][ind(x-h)])/4.0 + random(-range,range);;
        x += h; y -= h;
        terrain[ind(y+h)][x] = (terrain[ind(y)][x] + terrain[ind(y+h)][ind(x+h)] + terrain[ind(y+w)][x] 
            + terrain[ind(y+h)][ind(x-h)])/4.0 + random(-range,range);;
        x += h; y += h;
        terrain[ind(y+h)][x] = (terrain[y][x] + terrain[ind(y+h)][ind(x+h)] + terrain[ind(y+w)][x]
            + terrain[ind(y+h)][ind(x-h)])/4.0 + random(-range,range);;
        x -= h; y += h;
        terrain[ind(y+h)][x] = (terrain[y][x] + terrain[ind(y+h)][ind(x+h)] + terrain[ind(y+w)][x]
            + terrain[ind(y+h)][ind(x-h)])/4.0 + random(-range,range);;
        x -= h; y -= h;
      }
    }
  }
}

int ind(int i) {    // wrap out-of-bound array indices
  if (i<0) {
    return int(pow(2,n))+i;
  } else if (i>pow(2,n)) {
    return i-int(pow(2,n));
  } else {
    return i;
  }
}

void init_array(float[][] terrain) {
  terrain[0][0] = 1;
  terrain[int(pow(2,n))][0] = 1;
  terrain[0][int(pow(2,n))] = 1;
  terrain[int(pow(2,n))][int(pow(2,n))] = 1;
}

void print_array(float[][] terrain) {
  for (int i=0;i<pow(2,n)+1;i++) {
    for (int j=0;j<pow(2,n)+1;j++) {
      print(terrain[i][j]);
      print("\t");
    }
    print("\n");
  }
  println();
}

void draw_array(float[][] terrain) {
  background(200);
  camera(80,80,90,0,0,0,0,0,-1);
  lights();
  rotateZ(mouseX/-100.0);
//  rotateX(mouseY/40.0);
  translate(-draw_size/2,-draw_size/2,0);
  stroke(0);
  for (int i=0;i<(pow(2,n));i++) {
    for (int j=0;j<(pow(2,n));j++) {
    noStroke();
    float elev = (terrain[i][j] + terrain[i+1][j] + terrain[i][j+1] + terrain[i+1][j+1])/4.0;
    // peak color = #DDE0CE = 221,224,204
    // valley color = # 4F791D = 79,121,29
    fill(map(elev,-5,10,79,221),map(elev,-5,10,121,224),map(elev,-5,10,29,204));
    // every 4 adjacent height points are tiled with two triangles
    beginShape(TRIANGLES);
      vertex(i*draw_size/(pow(2,n)),j*draw_size/(pow(2,n)),terrain[i][j]);
      vertex((i+1)*draw_size/(pow(2,n)),j*draw_size/(pow(2,n)),terrain[i+1][j]);
      vertex((i+1)*draw_size/(pow(2,n)),(j+1)*draw_size/(pow(2,n)),terrain[i+1][j+1]);
    endShape();
    beginShape(TRIANGLES);
      vertex(i*draw_size/(pow(2,n)),j*draw_size/(pow(2,n)),terrain[i][j]);
      vertex(i*draw_size/(pow(2,n)),(j+1)*draw_size/(pow(2,n)),terrain[i][j+1]);
      vertex((i+1)*draw_size/(pow(2,n)),(j+1)*draw_size/(pow(2,n)),terrain[i+1][j+1]);
    endShape();
    }
  }
}

void draw_grayscale(float[][] terrain) {
  float min_elev = -5;
  float max_elev = 10;
  for (int i=0;i<(pow(2,n)+1);i++) {
    for (int j=0;j<(pow(2,n)+1);j++) {
      stroke(map(terrain[i][j],min_elev,max_elev,0,255));
      point(i,j);
    }
  }
}

void output_model(float[][] terrain, PrintWriter file) {
  file.println("solid terrain");
  for (int i=0;i<(pow(2,n));i++) {
    for (int j=0;j<(pow(2,n));j++) {
      file.println("facet normal 0 0 1");
      file.println("outer loop");
      file.println("vertex " + i*draw_size/(pow(2,n)) + " " + j*draw_size/(pow(2,n)) + " " + terrain[i][j]);
      file.println("vertex " + (i+1)*draw_size/(pow(2,n)) + " " + j*draw_size/(pow(2,n)) + " " + terrain[i+1][j]);
      file.println("vertex " + (i+1)*draw_size/(pow(2,n)) + " " + (j+1)*draw_size/(pow(2,n)) + " " + terrain[i+1][j+1]);
      file.println("endloop");
      file.println("endfacet");
      file.println("facet normal 0 0 0");
      file.println("outer loop");
      file.println("vertex " + i*draw_size/(pow(2,n)) + " " + j*draw_size/(pow(2,n)) + " " + terrain[i][j]);
      file.println("vertex " + (i+1)*draw_size/(pow(2,n)) + " " + (j+1)*draw_size/(pow(2,n)) + " " + terrain[i+1][j+1]);
      file.println("vertex " + i*draw_size/(pow(2,n)) + " " + (j+1)*draw_size/(pow(2,n)) + " " + terrain[i][j+1]);
      file.println("endloop");
      file.println("endfacet");
    }
  }
  file.println("endsolid terrain");
}

void mouseClicked() {
  old_seed = seed;
  seed = int(random(1000));
}
