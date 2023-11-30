

class Platform {
  
  int x; 
  int y; 
  
  //int side; 
  int w; 
  int h; 
  
  int left; 
  int right; 
  int top; 
  int bottom; 
  
  int moveSpeed; 
  
  boolean shouldDelete; 
  boolean hitsLeft; 
  boolean hitsTop; 
  
  Platform(int startX, int startY, int startW, int startH, boolean startShouldDelete) {
    rectMode(CENTER); 
    x = startX; 
    y = startY; 
    
    w = startW; 
    h = startH; 
   
    left = x - w/2; 
    right = x + w/2; 
    top = y - h/2; 
    bottom = y + h/2; 
    
    moveSpeed = 10; 
    
    shouldDelete = startShouldDelete; 
    hitsLeft = false; 
    hitsTop = false; 
  }
  
  void render() {
    fill(#C352F5); 
    stroke(#C352F5); 
    rect(x, y, w, h); 
    //platformImg.resize(w, h); 
    //image(platformImg, x, y-50); 
  }
  
  void move() {
    left = x - w/2; 
    right = x + w/2; 
    top = y - h/2; 
    bottom = y + h/2; 
    x -= moveSpeed; 
  }
  
  void scroll() {
    if (x < w/2) {
      this.shouldDelete = true; 
    }
  }

  void playerCollide(Player aPlayer) {
    // if player collides with a platform
    //if(aPlayer.right >= left && aPlayer.right <= right) {
    //  println("hit left"); 
    //  state = 2; 
    //} else if (aPlayer.bottom >= bottom && aPlayer.bottom <= top) {
    //  println("hit top");
    //  aPlayer.isFalling = false; // stop falling
    //  aPlayer.y = this.y - h/2 - aPlayer.h/2; 
    //}
    
    if (left <= aPlayer.right && 
        right >= aPlayer.left && 
        top <= aPlayer.bottom && 
        bottom >= aPlayer.top) {
          aPlayer.isFalling = false; // stop falling
          aPlayer.y = this.y - h/2 - aPlayer.h/2; 
        }
  }
  
}
