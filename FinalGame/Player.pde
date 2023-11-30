

class Player{
  
  // vriables 
  int x; 
  int y; 
  
  int w; 
  int h; 
  
  int left; 
  int right; 
  int top; 
  int bottom; 
  
  int speed; 
  
  boolean isJumping; 
  boolean isFalling; 
  
  int jumpHeight; // distance that you can jump upwards 
  int highestY; // y value of the top of your jump 
  
  // constructor 
  Player(int startX, int startY, int startW, int startH){
    rectMode(CENTER); 
    x = startX; 
    y = startY; 
    w = startW; 
    h = startH; 
    
    left = x - w/2; 
    right = x + w/2; 
    top = y - h/2; 
    bottom = y + h/2; 
    
    speed = 10;
    
    isJumping = false; 
    isFalling = false; 
    
    jumpHeight = 150; 
    highestY = y - jumpHeight;  
  }
  
  //functions 
  void render(Animation aPlayerAnimation){
    if (aPlayerAnimation.isAnimating) {
      playerAnimation.display(x, y);
    }else {
      blueMadImg.resize(w, h); 
      image(blueMadImg, x, y); 
      //rect(x, y, w, h); 
    }
  }
  
  
  
  void move() {
    left = x - w/2; 
    right = x + w/2; 
    top = y - h/2; 
    bottom = y + h/2; 
  }
  
  void jumping() {
    if(isJumping) {
      y -= speed; 
    }
  }
  
  void falling() {
    if(isFalling) {
      y += speed; 
    }
  }
  
  void topOfJump() {
    if(y <= highestY) {
      isJumping = false; // stop jumping upward 
      isFalling = true; // start falling downward
    }
  }
  
  void land() {
    if(y >= height - 205) {
      isFalling = false; // stop falling
      y = height -205; // snap player to position where they are standing on bottom of window
      highestY = y - jumpHeight;  
    }
  }
  
  // check to see if the player is colliding with any platform 
  // if the player is not colliding with any platforms, then 
  // make the player start falling  
  void fallOffPlatform(ArrayList<Platform> aPlatformList) {
    
    // check that the player is not in the middle of a jump 
    // and check that the player is not on the ground 
    if (isJumping == false && y < height - h/2) {
      boolean onPlatform = false;  
      
      for (Platform aPlatform : aPlatformList) {
        // if the player is colliding with a platform
        if (aPlatform.left <= right && 
            aPlatform.right >= left && 
            aPlatform.top <= bottom && 
            aPlatform.bottom >= top) {
              onPlatform = true;  // make onPlatform true
            } 
      }
      
      // if you are not on a platform, start falling
      if(onPlatform == false ) {
        isFalling = true; 
      } 
    }
  }
}
