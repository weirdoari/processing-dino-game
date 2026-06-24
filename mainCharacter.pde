class mainCharacter {
  PVector pos;
  PVector vel;
  float health, playerWidth, playerHeight;

  mainCharacter(PVector pos, PVector vel, float health, float playerWidth, float playerHeight) {
    this.pos = pos; 
    this.vel = vel;
    this.health = health;
    this.playerWidth = playerWidth;
    this.playerHeight = playerHeight;
  }
 
  void moveCharacter() {
    pos.add(vel);
  }
  
  void applyFriction(float friction) {
    vel.mult(friction);
  }

  void accelerate(PVector accelerator) {
    vel.add(accelerator);
  }

  void drawCharacter() {
    pushStyle();
    pushMatrix();
    
    fill(150);
    //smooth();
    noStroke();
    translate(pos.x,pos.y);
    rect(-playerWidth/2, -playerHeight/2, playerWidth, playerHeight);
    
    popStyle();
    popMatrix();
  }
  
  boolean isDead() {
    return health <= 0;
  }

  boolean hitCharacter(mainCharacter other) {
    return !(pos.x + playerWidth < other.pos.x ||
             pos.x > other.pos.x + other.playerWidth ||
             pos.y + playerHeight < other.pos.y ||
             pos.y > other.pos.y + other.playerHeight);
  }

  void decreaseHealth(int damage) {
    health -= damage;
    timedText(str(-damage),(int)pos.x,(int)pos.y,50);
  }

  void checkWalls() {
    float halfW = playerWidth / 2;
    float halfH = playerHeight / 2;
  
    if (pos.x - halfW < 325 * wScaler || pos.x + halfW > 1150 * wScaler) {
      vel.x *= -1;
    }
  
    if (pos.y - halfH < 500 * hScaler || pos.y + halfH > 800 * hScaler) {
      vel.y *= -1;
    }
  
    pos.x = constrain(pos.x, 325 * wScaler + halfW, 1150 * wScaler - halfW);
    pos.y = constrain(pos.y, 500 * hScaler + halfH, 800 * hScaler - halfH);
  }

  void update() {
    moveCharacter();
    checkWalls();
  }
}
