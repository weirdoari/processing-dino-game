class Player extends mainCharacter {
  
  PImage playerImg = loadImage("main_player.png");
  PImage wandImg = loadImage("main_player_wand.png");
  PImage swordImg = loadImage("main_player_sword.png");
  PVector acceleration = new PVector(0, 0);
  float accelMag;
  float stamina = 50;
  float shootCost = 20;
  boolean goingADirection = false, facingRight = true;
  ArrayList<Projectile> projectiles = new ArrayList<Projectile>();
  int healthPotion = 1, manaPotion = 1, candyCount = 0;
  int damage = 1;
  
  Player(PVector pos, PVector vel, float health, float playerWidth, float playerHeight) {
    super(pos, vel, health, playerWidth, playerHeight);
  }
  
  void movementUpdate() {
    acceleration = new PVector(0, 0);
    accelMag = 1.5;
  
    goingADirection = (upPressed || downPressed || leftPressed || rightPressed);
    if (shiftPressed && stamina > 0 && goingADirection) {accelMag *= 4; stamina = stamina - (int)random(1,3);} else if(!goingADirection) {stamina = constrain(stamina + 1.6, 0, 60);} else {stamina = constrain(stamina + 0.8, 0, 60);}
    if (upPressed) acceleration.add(0, -accelMag*hScaler);
    if (downPressed) acceleration.add(0, accelMag*hScaler);
    if (leftPressed) { acceleration.add(-accelMag*wScaler, 0); facingRight = false;}
    if (rightPressed) { acceleration.add(accelMag*wScaler, 0); facingRight = true;}

  
    accelerate(acceleration);
    applyFriction(0.75);
  }
  
  void drawCharacter() {
    pushStyle();
    pushMatrix();
    noStroke();
    translate(pos.x, pos.y);
 
    if (!facingRight) scale(-1, 1);
    image(playerImg, -(playerWidth * wScaler) / 2, -(playerHeight * hScaler) / 2,  playerWidth * wScaler, playerHeight * hScaler);
    
    pushMatrix();
    translate(-(playerWidth * wScaler) / 4,0);
    image(wandImg,0, 0, playerWidth * wScaler/2, playerHeight * hScaler/2);
    popMatrix();
    
    if (!facingRight) scale(-1, 1);
    fill(0,0,0,100);
    rect(-(playerWidth * wScaler) / 2,-(playerHeight * hScaler)/5*3,playerWidth * wScaler,10*hScaler);
    fill(22,17,255,100);
    rect(-(playerWidth * wScaler) / 2,-(playerHeight * hScaler)/5*3,map(stamina,0,60,0,playerWidth * wScaler),5*hScaler);
    fill(76,255,44,100);
    rect(-(playerWidth * wScaler) / 2,-(playerHeight * hScaler)/5*3+5*hScaler,map(health,0,100,0,playerWidth * wScaler),5*hScaler);
  
    if (!facingRight) scale(-1, 1);
    pushMatrix();
    translate(-playerWidth * 0.5 * wScaler, playerHeight * hScaler);
    rotate(PI + QUARTER_PI);             
    tint(0, 20);                          
    image(playerImg, -(playerWidth * wScaler) / 2, -(playerHeight * hScaler) / 2, playerWidth * wScaler, playerHeight * hScaler);
    popMatrix();
    
    popStyle();
    popMatrix();
  }


  void update() {
    super.update();
    drawCharacter();
    movementUpdate();
    checkProjectiles();
  }
  
  void checkProjectiles() {
      for (int i = projectiles.size() - 1; i >= 0; i--) {
      Projectile a = projectiles.get(i);
      a.update(projectiles);
      for (int j = enemies.size() - 1; j >= 0; j--) {
        BossEnemy be = enemies.get(j);
        if (a.hit(be) && !be.isDying) { projectiles.remove(i); be.health = be.health-damage; 
        timedText(str(-damage),(int)be.pos.x,(int)be.pos.y,30);
        if (enemies.get(j).health <= 0) score++; return;}
      }
      
      for (int j = basicEnemies.size() - 1; j >= 0; j--) {
        BasicEnemy be = basicEnemies.get(j);
        if (a.hit(be) && !be.isDying) { projectiles.remove(i); be.health = be.health-damage; 
        timedText(str(-damage),(int)be.pos.x,(int)be.pos.y,30);
        if (basicEnemies.get(j).health <= 0) score++; break;}
      }
    }
  }
  
  void shoot() {
    if (stamina > shootCost) {
      PVector mouse = new PVector(mouseX, mouseY);
      PVector direction = PVector.sub(mouse, pos);
      direction.normalize();
      direction.mult(12); // speed of projectile
      projectiles.add(new Projectile(pos.copy(), direction, color(22,17,255,100)));
      stamina-=shootCost;
      
      if (direction.x > 0) {facingRight = true;} else {facingRight = false;}
    }
  }

}
