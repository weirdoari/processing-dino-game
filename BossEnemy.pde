class BossEnemy extends BasicEnemy {
  ArrayList<Projectile> projectiles = new ArrayList<Projectile>();  
  PImage enemy2Image = loadImage("enemy_2.png");
  int age = 0;
  int howManySecondsToShoot = 1;
  
  BossEnemy(PVector pos, PVector vel, float playerWidth, float playerHeight, Player player, float shootSec){
     super(pos,vel,playerWidth,playerHeight,player); 
     health = 6;
     initialHealth = 6;
     shootSec *= 60;
     howManySecondsToShoot = (int)shootSec;
  }
  
  void update() {
    super.update();
    shoot();
    checkProjectiles();
  }
  
  void drawCharacter() {
    age++;
    
    pushStyle();
    pushMatrix();
    translate(pos.x, pos.y);
    noStroke();
    fill(isDead() ? deadColor : aliveColor, isDying ? 150 : 255);
    image(enemy2Image,-playerWidth/2, -playerHeight/2, playerWidth, playerHeight);
    rect(-(playerWidth * wScaler) / 2,-(playerHeight * hScaler)-5*hScaler,playerWidth * wScaler,5*hScaler);
    fill(25,199,36);
    rect(-(playerWidth * wScaler) / 2,-(playerHeight * hScaler)-5*hScaler,map(health,0,initialHealth,0,playerWidth * wScaler),5*hScaler);
    popMatrix();
    popStyle();
  }
  
  void shoot() {
    if (age % howManySecondsToShoot == 0 && !isDying) {
      PVector direction = PVector.sub(player.pos, pos);
      direction.normalize();
      direction.mult(5); 
      projectiles.add(new Projectile(pos.copy(), direction, RED));
    }
  }
  
    void checkProjectiles() {
      for (int i = projectiles.size() - 1; i >= 0; i--) {
        Projectile a = projectiles.get(i);
        a.update(projectiles);
        if (a.hit(player)) { 
          projectiles.remove(i); 
          player.health = player.health-10; 
        }
      } 
    }
  
}
