class BasicEnemy extends mainCharacter {
  boolean isDying = false;
  int deathTimer = 60; 
  color aliveColor = color(200, 0, 0);
  color deadColor = color(100, 100, 100);
  PImage enemy1Image = loadImage("enemy_1.png");
  Player player; 
  float initialHealth;

  BasicEnemy(PVector pos, PVector vel, float playerWidth, float playerHeight, Player player) {
    super(pos, vel, 3, playerWidth, playerHeight); 
    this.player = player;
    initialHealth = super.health;
  }

void update() {
  if (!isDead()) {
    moveCharacter();
    checkWalls();
  } else {
    if (!isDying) {
      isDying = true;
    } else {
      deathTimer--;
    }
  }
}
  
void checkWalls() {
  super.checkWalls();

  if (hitCharacter(player)) {
    player.decreaseHealth((int)random(1,15)); 

    PVector pushBack = PVector.sub(pos, player.pos); 
    pushBack.normalize();
    pushBack.mult(12*wScaler);
    pos.add(pushBack);  
    
    vel.mult(-1);
  }
}


  void drawCharacter() {
    pushStyle();
    pushMatrix();
    translate(pos.x, pos.y);
    noStroke();
    fill(isDead() ? deadColor : aliveColor, isDying ? 150 : 255);
    image(enemy1Image,-playerWidth/2, -playerHeight/2, playerWidth, playerHeight);
    rect(-(playerWidth * wScaler) / 2,-(playerHeight * hScaler)-5*hScaler,playerWidth * wScaler,5*hScaler);
    fill(25,199,36);
    rect(-(playerWidth * wScaler) / 2,-(playerHeight * hScaler)-5*hScaler,map(health,0,initialHealth,0,playerWidth * wScaler),5*hScaler);
    popMatrix();
    popStyle();
  }

  boolean readyToRemove() {
    return isDead() && deathTimer <= 0;
  }
}
