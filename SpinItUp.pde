import ddf.minim.*;

Minim minim;
AudioPlayer gameRun_bgm;
AudioPlayer gameStart_bgm;
AudioSample bounce;
AudioSample hit;
AudioSample addScore;
AudioSample tap;
AudioSample fireHit;
AudioSample fly;

PImage bg;
PImage aircraftImg;
PImage jetpointImg;
PImage barrierImg;
PImage eyeImg;
PImage fireImg;

PFont font;

final int GAME_START = 0;
final int GAME_RUN = 1;
int gameState = GAME_START;
boolean transition = false;

final int AIRCRAFT_SIZE = 50;
float angle = 0;
float aircraftMaxY;

Aircraft aircraft;
JetPoint jetpoint;
Barrier barriers[];
Fire fire;
OnFire onfire;
OnFireMove onFireMove;
Transition isTransition;

float scoreTopMinOffset = 100;
float scoreTopMaxOffset = 120;
float scoreTopOffset = scoreTopMinOffset;
float scoreTextSize = 72;
int score = 0;
int highestScore = 0;

float subTitleAlpha = 200;
boolean subTitleDisplay = true;

boolean firstTime = true;

void spawnBarriers(){
    barriers = new Barrier[3];
    for (int i = 0; i < barriers.length; i++) {
        boolean left = random(2) < 1;
        float x = (left) ? -75 : width / 2;
        float y = i * height / 3  - 36;
        barriers[i] = new Barrier(x, y, left);
    }
}

void setup() {
    size(380, 680, P3D);
    smooth();
    
    minim = new Minim(this);
    
    gameStart_bgm = minim.loadFile("audio/gameStartBGM.mp3");
    gameRun_bgm = minim.loadFile("audio/gameRunBGM.mp3");
    bounce = minim.loadSample("audio/bounce.wav", 128);
    hit = minim.loadSample("audio/hit.wav", 128);
    addScore = minim.loadSample("audio/score.wav", 128);
    tap = minim.loadSample("audio/tap.wav", 128);
    fireHit = minim.loadSample("audio/fireHit.wav", 128);
    fly = minim.loadSample("audio/fly.wav", 128);
    
    bg = loadImage("img/bg.png");
    aircraftImg = loadImage("img/aircraft.png");
    jetpointImg = loadImage("img/jetpoint.png");
    barrierImg = loadImage("img/barrier.png");
    eyeImg = loadImage("img/eye.png");
    fireImg =  loadImage("img/fire.png");
    
    font = createFont("text/ObelixPro.ttf", 64, true);
    textFont(font);
    
    aircraft = new Aircraft();
    aircraftMaxY = height / 4 * 3;
    spawnBarriers();
    fire = new Fire(-1000, -50);
    onfire = new OnFire(fire.x, fire.y);
    onFireMove = new OnFireMove(aircraft.x, aircraft.y);
    isTransition = new Transition();
    
    gameRun_bgm.play();
    gameRun_bgm.loop();
    gameStart_bgm.play();
    gameStart_bgm.loop();
}

void draw() {
  switch(gameState) {
      case GAME_START:
      gameRun_bgm.pause();
      gameStart_bgm.play();
      
      background(bg);
      drawTitle("SPIN IT UP", 40, 230, 230);
      drawScore(40, 320, highestScore);
      drawDivider();
      if(!firstTime) drawScore(25, 390, score);
      drawTitle("Tap To Start", 20, height - 50, subTitleAlpha);
      if(subTitleDisplay) {
          subTitleAlpha -= 2.5;
      }else {
          subTitleAlpha += 2.5;
      }
      if(subTitleAlpha == 0) subTitleDisplay = false;
      if(subTitleAlpha > 200) subTitleDisplay = true;
      
      if(isTransition.over) { 
          gameState = GAME_RUN;
          score = 0;
          isTransition.over = false;
      }
      
      break;
      
      case GAME_RUN:
      gameStart_bgm.pause();
      gameRun_bgm.play();
      
      background(55, 27, 50);
      firstTime = false;
      onFireMove.display(aircraft.x, aircraft.y);
      onFireMove.update();
      
      drawScore();
      // aircraft
      aircraft.display();
      aircraft.update();
      if(!onfire.isAlive) aircraft.barrierCollision();
      aircraft.eye();
      aircraft.keepInScreen();
      
      for (int i = 0; i < barriers.length; i++) {
          barriers[i].display();
          barriers[i].update();
      }
      
      fire.display();
      fire.update();
      fire.hit();
      
      break;
  }
  isTransition.display();
  isTransition.update();
}

void mouseReleased() {
  switch(gameState){
      case GAME_START:
      isTransition.isAlive = true;
      tap.trigger();
      break;
      
      case GAME_RUN:
      if(aircraft.timer >= 60 
      && aircraft.y + aircraft.size / 2 < height){
        aircraft.move();
      }
      break;
  }
}

boolean isHit(float ax, float ay, float aw, float ah, float bx, float by, float bw, float bh){
	return	ax + aw > bx &&    // a right edge past b left
		    ax < bx + bw &&    // a left edge past b right
		    ay + ah > by &&    // a top edge past b bottom
		    ay < by + bh;
}

void drawTitle(String title, float size, float topOffset, float alpha){
    pushStyle();
    textAlign(CENTER, CENTER);
    textSize(size);
    fill(#ffffff, alpha);
    text(title, width / 2, topOffset);
    popStyle();
}

void drawScore(){
    pushStyle();
    scoreTopOffset = lerp(scoreTopOffset, scoreTopMinOffset, 0.09);
    textAlign(CENTER, CENTER);
    textSize(scoreTextSize);
    fill(115, 89, 128);
    text(score, width / 2, scoreTopOffset);
    popStyle();
}
 
void drawScore(float size, float topOffset, int score) {
    pushStyle();
    textAlign(CENTER, CENTER);
    textSize(size);
    fill(#ffffff, 180);
    text(score, width / 2, topOffset);
    popStyle();
}

void drawDivider() {
    pushStyle();
    rectMode(CENTER);
    noStroke();
    fill(#ffffff, 100);
    rect(width / 2, 360, 150, 5);
    popStyle();
}

void addScore(int value){
    addScore.trigger();
    score += value;
    scoreTopOffset = scoreTopMaxOffset;
    if(score > highestScore) highestScore = score;
}
