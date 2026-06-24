class EntitySpawn extends mainCharacter {
  Player player;
  int type;
  PImage entityImg;
  boolean collected = false;

  EntitySpawn(PVector pos,Player player,int type){
    super(pos, new PVector(0,0), 1,20*wScaler,20*hScaler);
    this.player = player;
    this.type = type; // 1 = health potion, 2 = mana potion, 3 = candy
    entityImg = entityImages[type];
  }
  
  void checkWalls() {
    super.checkWalls();
  
    if (hitCharacter(player)) {
      if (type == 1) player.healthPotion++;
      if (type == 2) player.manaPotion++;
      if (type == 3) player.candyCount++;
      collected = true;
    }
  }
  
  void drawCharacter() {
    image(entityImg,pos.x-50*wScaler/2,pos.y-50*hScaler/2,50*wScaler,50*hScaler);
  }
}
