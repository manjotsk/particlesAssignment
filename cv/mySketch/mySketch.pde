CollisionSystem CSystem;

void setup() {
  size(1000, 500);
  CSystem = new CollisionSystem();
}

void draw() {
  background(255);
  CSystem.run();
}