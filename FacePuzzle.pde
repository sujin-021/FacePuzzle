import java.util.Collections;

// Define tile size 
int tileW = 120;
int tileH = 120;

// 3*3 grid tile values
int[][] tiles = new int[3][3];

// empty tile used to make the slide puzzle
int emptyX = 2;
int emptyY = 1;

// image
PImage Background;
PImage[] tileImages = new PImage[9]; // [0] = empty, [1 ~ 8] = tiles

// image colors
String[] colors = {"red", "green", "blue"};


void setup() {
  size(561, 1000);
  noStroke();

  // initializing tile grid 
  int count = 1;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (i == emptyX && j == emptyY) {
        tiles[i][j] = 0; // 0 : empty
      } else {
        tiles[i][j] = count; // 1 ~ 8 : tiles
        count++;
      }
    }
  }

  // shuffle tiles randomly when the program is executed
  shuffleTiles(100);
  
  // load image
  Background = loadImage("face.png");
  
  // tile images *image files is named "color + number"
  ArrayList<Integer> numbers = new ArrayList<Integer>();
  for (int i = 1; i <= 9; i++) {
    numbers.add(i); // add numbers 1 to 9 
  }
  Collections.shuffle(numbers); // shuffle the numbers 

  for (int i = 0; i < 8; i++) {
    int num = numbers.get(i); // get 8 numbers from 1 to 9 to avoid repetition
    String tilecolor = colors[(int)random(colors.length)]; // 0:red or 1:green or 2:blue
    String filename = tilecolor + num + ".jpg"; // ex)red3.jpg

    tileImages[i + 1] = loadImage(filename); // tileImage[0] : empty, [1~8] : loadImage(filename)
    tileImages[i + 1].resize(110, 110);
  }
  
}


void draw() {
  background(100);
  
  // draw the background with image
  if (Background != null) {
    image(Background, 0, 0, width, height);
  }
  
  // draw the tiles
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      int val = tiles[i][j];
      if (val != 0 && tileImages[val] != null) {
        image(tileImages[val], 130 + i * 121, 200 + j * 121, tileW, tileH);
      }
    }
  }
  
  // draw particle-based text "FIX MY FACE"
  int density = 100; // particle density

  // F
 fill(0);
  drawParticles(150, 100, 40, 10, density);
  drawParticles(150, 130, 40, 10, density);
  drawParticles(140, 100, 10, 70, density);

  // I
  drawParticles(200, 100, 30, 10, density);
  fill(255);
  drawParticles(210, 110, 10, 60, density);
  drawParticles(200, 160, 30, 10, density);

  // X
  drawQuadParticles(240, 100, 250, 100, 290, 170, 280, 170, density);
  drawQuadParticles(280, 100, 290, 100, 250, 170, 240, 170, density);

  // M
  drawParticles(340, 100, 10, 70, density);
  drawParticles(390, 100, 10, 70, density);
  drawQuadParticles(340, 100, 350, 100, 375, 150, 365, 150, density);
  drawQuadParticles(390, 100, 400, 100, 375, 150, 365, 150, density);

  // Y 
  drawParticles(430, 130, 10, 40, density);
  fill(0);
  drawQuadParticles(410, 100, 420, 100, 440, 130, 430, 130, density);
  drawQuadParticles(450, 100, 460, 100, 440, 130, 430, 130, density);

  // F 
  drawParticles(180, 600, 40, 10, density);
  drawParticles(180, 630, 40, 10, density);
  drawParticles(170, 600, 10, 70, density);

  // A 
  drawQuadParticles(250, 600, 260, 600, 240, 670, 230, 670, density);
  drawQuadParticles(250, 600, 260, 600, 280, 670, 270, 670, density);
  drawParticles(240, 640, 30, 10, density);

  // C 
  drawParticles(300, 600, 50, 10, density);
  drawParticles(300, 610, 10, 50, density);
  drawParticles(300, 660, 50, 10, density);

  // E 
  drawParticles(380, 600, 40, 10, density);
  drawParticles(370, 600, 10, 70, density);
  drawParticles(380, 630, 40, 10, density);
  drawParticles(380, 660, 40, 10, density);
}


// mouse interaction
void mousePressed() {
  
  // convert mouse position to grid index
  int clickedX = (mouseX - 130) / 120;
  int clickedY = (mouseY - 200) / 120;
  
  // check if clicked position is within bounds
  if (clickedX >= 0 && clickedX < 3 && clickedY >= 0 && clickedY < 3) {
    if ((abs(clickedX - emptyX) == 1 && clickedY == emptyY) ||
        (abs(clickedY - emptyY) == 1 && clickedX == emptyX)) {
          
      tiles[emptyX][emptyY] = tiles[clickedX][clickedY]; // swap the clicked tile with the empty tile
      tiles[clickedX][clickedY] = 0;
      emptyX = clickedX;
      emptyY = clickedY;
    }
  }
}


void shuffleTiles(int moves) {
  for (int k = 0; k < moves; k++) {
    ArrayList<int[]> neighbors = new ArrayList<int[]>();
    
    // collect tiles
    if (emptyX > 0) neighbors.add(new int[]{emptyX - 1, emptyY});
    if (emptyX < 2) neighbors.add(new int[]{emptyX + 1, emptyY});
    if (emptyY > 0) neighbors.add(new int[]{emptyX, emptyY - 1});
    if (emptyY < 2) neighbors.add(new int[]{emptyX, emptyY + 1});
    
    // randomly select one to swap with the empty tile
    int[] chosen = neighbors.get((int)random(neighbors.size()));
    int cx = chosen[0];
    int cy = chosen[1];
    
    // swap the selected tile with the empty one
    tiles[emptyX][emptyY] = tiles[cx][cy];
    tiles[cx][cy] = 0;
    emptyX = cx;
    emptyY = cy;
  }
}


// draw particles within a text area
void drawParticles(float x, float y, float w, float h, int count) {
  for (int i = 0; i < count; i++) {
    float px = random(x, x + w);
    float py = random(y, y + h);
    ellipse(px, py, 1, 1);
  }
}

void drawQuadParticles(float x1, float y1, float x2, float y2,
                       float x3, float y3, float x4, float y4, int count) {
  for (int i = 0; i < count; i++) {
    float t1 = random(1);
    float t2 = random(1);

    PVector a = PVector.lerp(new PVector(x1, y1), new PVector(x4, y4), t1);
    PVector b = PVector.lerp(new PVector(x2, y2), new PVector(x3, y3), t1);
    PVector p = PVector.lerp(a, b, t2);
    
    ellipse(p.x, p.y, 1, 1);
  }
}
