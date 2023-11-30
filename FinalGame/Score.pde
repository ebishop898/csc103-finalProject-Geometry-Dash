

class Score {
  int currentScore; 
  int x; 
  int y; 
  int scoreInterval;
  boolean displayEnd; 
  
  Score(int startScore, int startX, int startY, int startScoreInterval, boolean isEnd) {
    currentScore = startScore; 
    x = startX; 
    y = startY; 
    scoreInterval = startScoreInterval; 
    displayEnd = isEnd; 
  }
  
  
  void drawScore (int size) {
    fill(#C352F5); 
    stroke(#C352F5); 
    textSize(size); 
    //text(currentScore, x, y); 
    if (!displayEnd) {
      text("Score: " + currentScore, x, y); 
    } else {
      text(this.currentScore, x, y); 
    }
  }
  
  void updateScore() {
    if(currentTime - startTime > scoreInterval) {
      currentScore++; 
    startTime = currentTime; 
    } 
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
}
