

class Spike {
  
  int x; 
  int y; 
  
  int side; 
  
  int left; 
  int right; 
  int top; 
  int bottom; 
  
  int moveSpeed; 
  
  boolean shouldDelete; 
  
  boolean stopSound;
  
  boolean upsideDown; 
  
  Spike(int startX, int startY, int startS, boolean startShouldDelete, boolean startUpsideDown) {
    rectMode(CENTER); 
    x = startX; 
    y = startY; 
    
    side = startS; 
    
    shouldDelete = startShouldDelete; 
    
    stopSound = false; 
    upsideDown = startUpsideDown; 
    
    left = x; 
    right = x + side; 
    top = y - side; 
    bottom = y; 
    
    moveSpeed = 10; 
  }
  
  void render() {
    fill(#C352F5);
    stroke(#C352F5); 
    if(this.upsideDown) {
      //udSpikeImg.resize(side*2, side*2); 
      //image(udSpikeImg, x, y-20);
      triangle (x, y, x - side/2, y + side, x - side, y);
    } else {
      //spikeImg.resize(side*2, side*2); 
      //image(spikeImg, x, y-20);
      triangle (x, y, x + side/2, y - side, x +side, y); 
    }
    
  }
  
  
  void move() {
    left = x - side/3; 
    right = x + side; 
    top = y - side; 
    bottom = y; 
    x -= moveSpeed; 
  }
  
  void scroll() {
    if (x < side/2) {
      this.shouldDelete = true; 
    }
  }
  
  void playerCollide(Player aPlayer) {
    // check to see if player is colliding 
    if (aPlayer.top <= bottom && 
        aPlayer.bottom >= top &&
        aPlayer.right >= left && 
        aPlayer.left <= left) {
          state = 2; 
        }
  }
  
  
}
