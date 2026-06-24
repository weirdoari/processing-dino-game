float w = 1470*.7, h = 956*.7;
int score, candyTimer, respawnTimer;
Player human;
ArrayList<Dinos> players = new ArrayList<Dinos>();
ArrayList<BasicEnemy> basicEnemies = new ArrayList<BasicEnemy>();
ArrayList<BossEnemy> enemies = new ArrayList<BossEnemy>();
ArrayList<EntitySpawn> entities = new ArrayList<EntitySpawn>();
PImage frontLayer,frontLayer_a,frontLayer_b,startLayer,glow_y,glow_r,glow_b,cont;
PImage[] entityImages = new PImage[4];
float wScaler, hScaler,difficultyLevel = 200;
boolean gameStarted = false,startSeqEnded = false, playerDead = false;
PGraphics cachedOverlay,cachedFront,cachedBack;
PFont font;
color RED = color(205,32,64);
int storySkipper = 0;
int dropRate = 1, lastSpawnFrame = 0; // out of 10
boolean upPressed = false, downPressed = false, leftPressed = false, rightPressed = false, shiftPressed = false;

final int MAX_TEXTS = 10;
String[] timedTexts = new String[MAX_TEXTS];
int[] timedX = new int[MAX_TEXTS];
int[] timedY = new int[MAX_TEXTS];
int[] timedTimers = new int[MAX_TEXTS];


String[] story = {
  "You ready to lose again, Trixie?\nLast time you barely made it past Level 3.",
  "That was because someone\ndistracted me by yelling -Incoming meteor!-\nevery two seconds.",
  "Hey, it's called immersion.\nYou gotta stay sharp if you wanna\nsurvive the dino-apocalypse.",
  "Well this time, I've got snacks, I've got focus,\nand I've memorized the boss pattern.\nYou're going down, claw-boy.",
  "We'll see about that!\nJust make sure to remember:\nWASD to move, \"shift\" to sprint.",
  "Rex, I just said I know the patterns.",
  "Also - don't forget you can use:\n1 for health potions,\n2 for mana potions,\n3 for candy.",
  "Candy? Seriously?",
  "Yeah! Candies restore both health and mana,\nplus they boost your damage by 1.",
  "... Are you done yet?",
  "One last thing, I think you'd like to \nknow there will be other types of enemies \nas the game progresses."
};



void settings() {
  size(int(w),int(h));
  noSmooth();
}

void setup(){
  wScaler = w/1470;
  hScaler = h/956;
  frontLayer = loadImage("front_layer.png");
  frontLayer_a = loadImage("front_layer_addition.png");
  frontLayer_b = loadImage("front_layer_back.png");
  startLayer = loadImage("start.png");
  glow_y = loadImage("glow_y.png");
  glow_r = loadImage("glow_r.png");
  glow_b = loadImage("glow_b.png");
  cont = loadImage("continue.png");
  entityImages[1] = loadImage("entity_1.png");
  entityImages[2] = loadImage("entity_2.png");
  entityImages[3] = loadImage("entity_3.png");
  frameRate(60);
  
  cachedOverlay = createGraphics(int(w), int(h));
  cachedOverlay.beginDraw();
  cachedOverlay.image(frontLayer_a, 0, 0, w, h);
  cachedOverlay.endDraw();
  
  cachedFront = createGraphics(int(w), int(h));
  cachedFront.beginDraw();
  cachedFront.image(frontLayer, 0, 0, w, h);
  cachedFront.endDraw();
  
  cachedBack = createGraphics(int(w), int(h));
  cachedBack.beginDraw();
  cachedBack.image(frontLayer_b, 0, 0, w, h);
  cachedBack.endDraw();
  
  

  font = loadFont("comicStory.vlw");
  
  players.add(new Dinos(new PVector(80*wScaler,300*hScaler),"character_self_happy.png"));
  players.add(new Dinos(new PVector(1100*wScaler,300*hScaler),"character_other.png"));
  human = new Player(new PVector(500*wScaler,700*hScaler), new PVector(0,0), 100, 65, 65);
}

void draw() {
  background(255);
  image(cachedFront, 0, 0);
  image(cachedBack, 0,0);

  if (!gameStarted) {
    drawStartScreen();
    return;
  }
  
  noStroke();
  rect(1350*wScaler,760*hScaler,60*wScaler,-map(difficultyLevel,0,200,350*hScaler,0));
  
  for (int i = 0; i < players.size(); i++) {
    Dinos current = players.get(i);
    current.drawCharacter();
  }
  
  if (!startSeqEnded) {
    drawStartSequence();
    return;
  }
  
  if (human.health <= 0) {
    drawDeadScreen();
    return;
  }
  
  if (candyTimer > 0) {
    candyConsumed();
  }
  
  handleTimedTextDraw();
  handleSpawn();
  
  noFill();
  stroke(1);
  image(cachedOverlay, 0, 0);
  arc(580*wScaler, 550*hScaler, 550*wScaler, 200*hScaler, -PI+QUARTER_PI, -PI/6, OPEN);
  arc(960*wScaler, 500*hScaler, 450*wScaler, 200*hScaler, -PI+PI/10, -QUARTER_PI, OPEN);
  drawGlows();
  human.update();
  
  fill(RED);
  textFont(font, 35*wScaler);
  text(human.healthPotion, 115*wScaler, 520*hScaler);
  text(human.manaPotion, 115*wScaler, 595*hScaler);
  text(human.candyCount, 115*wScaler, 685*hScaler);
  
  textFont(font, 17*wScaler);
  text("Difficulty-meter", 1360*wScaler, 800*hScaler);
  
  textFont(font, 25*wScaler);
  textAlign(CENTER);
  text("SCORE:"+score, w/2, h*.1);
  
  if (frameCount % 90 == 0) {
    difficultyLevel = max(30, difficultyLevel - 1); 
  }
  
}

void mousePressed() {
  if (gameStarted && startSeqEnded) {
    human.shoot();
  }
  
  if (!startSeqEnded && gameStarted) {
    storySkipper++;
  }
  
  if (human.health < 0) {
    Restart();
  }
}

void drawStartScreen() {
  pushMatrix();
  translate(width/2,height/2);
  rotate(map(sin(frameCount * 0.05),-1,1,PI/10,-PI/10));
  image(startLayer, -1168/4*wScaler, -417/4*hScaler,1168/2*wScaler,417/2*hScaler);
  popMatrix();
  
  if (mousePressed) {gameStarted = true;}
  return;
}

void drawStartSequence() {
  if (storySkipper >= story.length) {
    startSeqEnded = true;
    return;
  }

  fill(0);
  textFont(font, 30 * wScaler);
  if (storySkipper % 2 != 0) { textAlign(LEFT); } else { textAlign(RIGHT); }
  if (storySkipper % 2 != 0) {text(story[storySkipper], 400 * wScaler, 520 * hScaler);} else {text(story[storySkipper], 1100 * wScaler, 520 * hScaler);}

  pushStyle();
  tint(255, map(sin(frameCount * 0.07), -1, 1, 0, 255));
  image(cont,w/2-(814*.40*wScaler)/2,h*.69,814*.42*wScaler,542*.4*hScaler);
  popStyle();
}

void drawGlows() {
  if (upPressed) image(glow_y,290*wScaler, 750*hScaler,200*wScaler, 200*hScaler);
  if (leftPressed) image(glow_y,200*wScaler, 850*hScaler,200*wScaler, 200*hScaler);
  if (rightPressed) image(glow_y,410*wScaler, 850*hScaler,200*wScaler, 200*hScaler);
  if (shiftPressed) image(glow_r,650*wScaler, 750*hScaler,200*wScaler, 200*hScaler);
  if (candyTimer > 0) image(glow_b,human.pos.x-(human.playerWidth * wScaler)-30*wScaler,human.pos.y-(human.playerHeight * hScaler),200*wScaler, 200*hScaler);
}

void spawnRandomEnemy() {
  float x = random(325 * wScaler + 20, 1150 * wScaler - 20);
  float y = random(500 * hScaler + 20, 800 * hScaler - 20);
  PVector pos = new PVector(x, y);
  while(dist(human.pos.x,human.pos.y,x,y) < 100*wScaler) {
     x = random(325 * wScaler + 20, 1150 * wScaler - 20);
     y = random(500 * hScaler + 20, 800 * hScaler - 20);
     pos = new PVector(x, y);
  }
  PVector vel = new PVector(random(-3, 3), random(-3, 3)); // Optional scaling
  float w = 60*wScaler;
  float h = 75*hScaler;

  if (difficultyLevel < 150) {
   int random = (int)random(1,3);
       if (random == 2) {
         pos = new PVector(random(325 * wScaler + 20, 1150 * wScaler - 20), random(500 * hScaler + 20, 800 * hScaler - 20));
         vel = new PVector(random(-1, 1), random(-1, 1));
         vel.mult(map(difficultyLevel,0,200,3,1));
         enemies.add(new BossEnemy(pos, vel, w, h, human,1 * map(difficultyLevel,200,0,1,2)));
       } 
       else 
       {
         basicEnemies.add(new BasicEnemy(pos, vel, w, h, human));
       }
   } 
   else 
   {
     basicEnemies.add(new BasicEnemy(pos, vel, w, h, human));
   }
  }

void handleSpawn() {
  if (gameStarted && frameCount - lastSpawnFrame >= difficultyLevel) {
    spawnRandomEnemy();
    lastSpawnFrame = frameCount;
  }
  
  for (int i = enemies.size() - 1; i >= 0; i--) {
    BossEnemy e = enemies.get(i);
    e.update();
    e.drawCharacter();
    if (e.readyToRemove()) {
      enemies.remove(i);
      if (int(random(1, 11)) <= dropRate*2) { //Double droprate cuz its daa boss.
        entities.add(new EntitySpawn(e.pos,human,int(random(1,4))));
      }
    }
  } 
  
    for (int i = basicEnemies.size() - 1; i >= 0; i--) {
    BasicEnemy e = basicEnemies.get(i);
    e.update();
    e.drawCharacter();
    if (e.readyToRemove()) {
      if (int(random(1, 11)) <= dropRate) {
        entities.add(new EntitySpawn(e.pos,human,int(random(1,4))));
      }
      basicEnemies.remove(i);
    }
  } 
  
    for (int i = entities.size() - 1; i >= 0; i--) {
      EntitySpawn e = entities.get(i);
      e.update();
      e.drawCharacter();
      if (e.collected) {
        entities.remove(e);
      }
    } 
}

void drawDeadScreen() {
  fill(0);
  textAlign(CENTER);
  textFont(font, 50*wScaler);
  text("You died! \nLeft click to start again.",w/2,h/2);
}

void candyConsumed() {
  if (frameCount % 10 == 0) {
    human.health = constrain(human.health + 5, 0, 100);
    human.stamina = constrain(human.stamina + 10, 0, 50);
  }

  candyTimer--;

  if (candyTimer <= 0) {
    human.damage = 1;
  }
}


void keyPressed() {
  if (key == 'w' || key == 'W' || keyCode == UP) upPressed = true;
  if (key == 's' || key == 'S' || keyCode == DOWN) downPressed = true;
  if (key == 'a' || key == 'A' || keyCode == LEFT) leftPressed = true;
  if (key == 'd' || key == 'D' || keyCode == RIGHT) rightPressed = true;
  if (keyCode == SHIFT) shiftPressed = true;
  if (key == '1') {
    if (human.healthPotion > 0 && human.health < 100) {
      human.healthPotion--;
      human.health += 50;
      human.health = constrain(human.health, 0, 100);
    }
  }
  if (key == '2') {
    if (human.manaPotion > 0 && human.stamina < 100) {
      human.manaPotion--;
      human.stamina = 100;
    }
  }
   if (key == '3') {
    if (human.candyCount > 0) {
      human.candyCount--;
      candyTimer = 6*60;
      human.damage = 2;
    }
  }

}

void keyReleased() {
  if (key == 'w' || key == 'W' || keyCode == UP) upPressed = false;
  if (key == 's' || key == 'S' || keyCode == DOWN) downPressed = false;
  if (key == 'a' || key == 'A' || keyCode == LEFT) leftPressed = false;
  if (key == 'd' || key == 'D' || keyCode == RIGHT) rightPressed = false;
  if (keyCode == SHIFT) shiftPressed = false;
}

void timedText(String txt, int x, int y, int time) {
  for (int i = 0; i < MAX_TEXTS; i++) {
    if (timedTimers[i] <= 0) {
      timedTexts[i] = txt;
      timedX[i] = x;
      timedY[i] = y;
      timedTimers[i] = time;
      break;
    }
  }
}

void handleTimedTextDraw() {
  for (int i = 0; i < MAX_TEXTS; i++) {
    if (timedTimers[i] > 0) {
      fill(RED);
      textFont(font, 25*wScaler);
      textAlign(CENTER);
      text(timedTexts[i], timedX[i], timedY[i]);
      timedTimers[i]--;
    }
  }
}

void Restart() {
  human.health = 100;
  human.stamina = 100;
  human.pos = new PVector(w/2,h*.7);
  difficultyLevel = 200;
  basicEnemies = new ArrayList<BasicEnemy>();
  enemies = new ArrayList<BossEnemy>();
  entities = new ArrayList<EntitySpawn>();
  score = 0;
  frameCount = 0;
}
