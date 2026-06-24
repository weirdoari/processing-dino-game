class Dinos {
  PVector pos;
  PImage playerImg;
  String image;
  boolean playerMoving;
  boolean isHappy;

  Dinos(PVector pos, String image) {
    this.pos = pos;
    this.image = image;
    this.playerImg = loadImage(image);
    this.isHappy = image.equals("character_self_happy.png");
  }

void drawCharacter() {
  playerMoving = (upPressed || downPressed || leftPressed || rightPressed);

  if (isHappy && playerMoving && !image.equals("character_self.png")) {
    playerImg = loadImage("character_self.png");
    image = "character_self.png";
  } else if (isHappy && !playerMoving && !image.equals("character_self_happy.png")) {
    playerImg = loadImage("character_self_happy.png");
    image = "character_self_happy.png";
  } else if (human.health <= 0 && (image.equals("character_self.png") || image.equals("character_self_happy.png"))) { playerImg = loadImage("character_self_worried.png");}

  boolean anyDying = false;
  for (int j = enemies.size() - 1; j >= 0; j--) {
    if (enemies.get(j).isDying) {
      anyDying = true;
      break;
    }
  }
  
  for (int j = basicEnemies.size() - 1; j >= 0; j--) {
    if (basicEnemies.get(j).isDying && anyDying == false) {
      anyDying = true;
      break;
    }
  }

  if (image.equals("character_other.png") || 
      image.equals("character_other_angry.png") || 
      image.equals("character_other_worried.png")) {

    if (anyDying) {
      if (!image.equals("character_other_angry.png") && !image.equals("character_other_worried.png")) {
        image = random(1) < 0.5 ? "character_other_angry.png" : "character_other_worried.png";
        playerImg = loadImage(image);
      }
    } else {
      if (!image.equals("character_other.png")) {
        image = "character_other.png";
        playerImg = loadImage(image);
      }
    }
  }

  pushMatrix();
  translate(pos.x, pos.y);
  image(playerImg, 0, 0, 300 * wScaler, 450 * hScaler);
  popMatrix();
}

}
