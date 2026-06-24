class Projectile {
  PVector pos;
  PVector velocity;
  color rgb;

  Projectile(PVector initialPos, PVector initialVel, color rgb) {
    pos = initialPos.copy();
    velocity = initialVel.copy();
    this.rgb = rgb;
  }

  void move() {
    pos.add(velocity);
  }

  void draw() {
    pushStyle();
      fill(rgb);
      noStroke();
      ellipse(pos.x, pos.y, 10, 10);
    popStyle();
  }

  boolean checkWalls() {
    return (pos.x < 0 || pos.x > width || pos.y < 0 || pos.y > height);
  }

  boolean hit(mainCharacter target) {
    float d = dist(pos.x, pos.y, target.pos.x, target.pos.y);
    return d < 50*wScaler;
  }

  void update(ArrayList<Projectile> list) {
    move();
    draw();
  
    if (checkWalls()) {
      list.remove(this);
    }
  }
}
