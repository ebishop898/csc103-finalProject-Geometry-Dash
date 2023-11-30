import processing.sound.*; 


// declaring my vars
Player player1;

Score score1;
Score endingScore;
int maxScore = 500;
int numSpikes = 500;

int firstSpikeX = width-25;
int firstSpikeY = 650;
int randomSpacing;
int howManySpikesToSkipBeforeTrio; 
int howManyObstoSkipBeforePlatforms;
int howManyObstoSkipBeforeStairs;
int trackOfHowManyObsAdded; 

ArrayList<Platform> platformList;
ArrayList<Spike> spikeList;

int startTime;
int currentTime;
int interval = 5000;

int state = 0;

PImage startScreen;
PImage blueMadImg;
PImage blueMadImgLarge;
PImage backgroundImg;
PImage gameOverScreen;
PImage congratsScreen;
PImage floorImg; 

SoundFile mainSound; 
SoundFile weeee; 

Animation playerAnimation;
int amountOfPlayerImages = 3;
PImage[] playerImages = new PImage[amountOfPlayerImages];

void setup() {
  rectMode(CENTER);
  imageMode(CENTER);
  size(1200, 800);

  // initializing and resizing images and background
  startScreen = loadImage("startScreen.png"); // all fonts used are from canva
  blueMadImg = loadImage("blueMadFace0.png"); // the player image was pulled form google off of this website: https://dinosaur-game.io/geometry-dash-subzero
  blueMadImgLarge = loadImage("blueMadFace0.png");
  blueMadImgLarge.resize(blueMadImg.width - 175, blueMadImg.height - 175);
  blueMadImg.resize(blueMadImg.width - 175, blueMadImg.height - 175);
  backgroundImg = loadImage("background.png"); // image is generated from the canva AI image generater
  gameOverScreen = loadImage("gameOver.png");
  congratsScreen = loadImage("congrats.png");
  floorImg = loadImage("floor.png"); 
  
  // initializing sound files 
  mainSound = new SoundFile(this, "coolgeodash.wav"); 
  mainSound.amp(0.3); 
  weeee = new SoundFile(this, "weeSound.wav"); 
  weeee.rate(2); 
  weeee.amp(100); 

  /** do i need the loop here or should i change the index
   when the player presses space and needs to rotate and
   then put this in a method called `rotate player`? **/

  for (int i = 0; i < playerImages.length; i++) {
    playerImages[i] = loadImage("blueMadFace" + i + ".png");
    playerImages[i].resize(50, 50);
  }

  playerAnimation = new Animation(playerImages, .1, 1);
}


void draw() {
  drawBackground();

  //playerAnimation.display();

  switch(state) {
    // first state, start screen
  case 0:
    startscreen();
    break;

    // second state, when 'r' is pressed, reinitialize variables and play game
  case 1:
    playgame();
    break;

    // third state, once player dies, shows players score and gives option to restart game
  case 2:
    playerGameOverScreen();
    break;

    // fourth state, once player reachs maximum time, shows players score and gives option to restart game
  case 3:
    playerWinScreen();
    break;
  }
}

void keyPressed() {
  if (key == ' ' && player1.isJumping == false) {
    player1.isJumping = true;
    player1.highestY = player1.y - player1.jumpHeight;
    playerAnimation.isAnimating = true;
    weeee.play(); 
  }
  if (key == 'p' || key == 'r') {
    if (state > 1) {
      state = 0;
      reinitialize();
      
    } else {
      state = 1;
      reinitialize();
    }
  }
}

void reinitialize() {
  // initialize my vars
  player1 = new Player(150, height-220, 50, 50);

  spikeList = new ArrayList<Spike>();
  platformList = new ArrayList<Platform>();

  score1 = new Score(0, 50, 50, 1000, false);

  initializeObstacles();

  startTime = millis();
}

void playgame() {
  image(floorImg, width/2, 420); 
  player1.render(playerAnimation);
  player1.move();
  player1.jumping();
  player1.falling();
  player1.topOfJump();
  player1.land();
  player1.fallOffPlatform(platformList);

  score1.drawScore(25);
  score1.updateScore();
  
  if(!mainSound.isPlaying()) {
    mainSound.play(); 
  }
  
  //draws the "floor"
  //fill(#52E3F5);
  //rect(width/2, height-80, width, 200);
  //image(floorImg, width/2, 430); 

  for (Spike aSpike : spikeList) {
    aSpike.render();
    aSpike.move();
    aSpike.scroll();
    aSpike.playerCollide(player1);
  }

  for (int i=spikeList.size()-1; i>=0; i--) {
    if (spikeList.get(i).shouldDelete) {
      spikeList.remove(spikeList.get(i));
    }
  }

  for (Platform p : platformList)
  {
    p.render();
    p.move();
    p.scroll();
    p.playerCollide(player1);
  }
  
  for (int j = platformList.size()-1; j>= 0; j--) {
    if (platformList.get(j).shouldDelete) {
      platformList.remove(platformList.get(j)); 
    }
  }

  currentTime = millis();

  if (currentTime - startTime > interval) {
    player1.speed++;
    for(Spike s : spikeList) {
      s.moveSpeed++;
    }
    for (Platform p : platformList)
    {
      p.moveSpeed++;
    }
    startTime = currentTime;
  }

  if (score1.currentScore >= maxScore) {
    state = 3;
  }
}

void drawBackground() {
  image(backgroundImg, width/2, height/2);
}

void startscreen() {
  drawBackground();
  image(startScreen, width/2, height/2);
  image(blueMadImgLarge, 250, 650);
}

void playerGameOverScreen() {
  drawBackground();
  endingScore = new Score(score1.currentScore, 850, 700, 0, true);
  endingScore.drawScore(200);
  image(gameOverScreen, width/2, height/2);
}

void playerWinScreen() {
  drawBackground();
  endingScore = new Score(score1.currentScore, 850, 700, 0, true);
  endingScore.drawScore(200);
  image(congratsScreen, width/2, height/2);
}

void initializeObstacles() {
  //Spike[] spikeList = new Spike[numSpikes];
  spikeList.clear();
  firstSpikeX = width-25;
  firstSpikeY = 620;
  trackOfHowManyObsAdded = 1; 
  howManySpikesToSkipBeforeTrio = (int)random(2, 6);
  howManyObstoSkipBeforePlatforms = (int)random(4, 10); 
  howManyObstoSkipBeforeStairs = (int)random(3, 8); 
  randomSpacing = 500; 
  
  for (int i = 0; i < numSpikes; i++) { 
    firstSpikeX += randomSpacing;
    
    if (trackOfHowManyObsAdded == howManyObstoSkipBeforePlatforms) {
      println("platform stairs"); 
        stairs(); 
      } else if (trackOfHowManyObsAdded == howManyObstoSkipBeforeStairs) {
        stairsWithSpikes(); 
      } else if (trackOfHowManyObsAdded == howManySpikesToSkipBeforeTrio) {
        tripleSpikes(); 
      } else  {
        spikeList.add(new Spike(firstSpikeX, firstSpikeY, 50, false, false));
        randomSpacing = (int) random(300, 500); 
        trackOfHowManyObsAdded++; 
      }
  }
}

void stairs() {
  platformList.add(new Platform(firstSpikeX, firstSpikeY - 25, 50, 50, false)); 
  platformList.add(new Platform(firstSpikeX + 50, firstSpikeY - 50, 50, 100, false));
  platformList.add(new Platform(firstSpikeX + 100, firstSpikeY - 75, 50, 150, false));
  howManySpikesToSkipBeforeTrio = (int)random(2, 6);
  howManyObstoSkipBeforePlatforms = (int)random(4, 10); 
  howManyObstoSkipBeforeStairs = (int)random(3, 8); 
   randomSpacing = (int)random(500, 700); 
  trackOfHowManyObsAdded = 1;
}

void tripleSpikes() {
  spikeList.add(new Spike(firstSpikeX, firstSpikeY, 50, false, false)); 
  spikeList.add(new Spike(firstSpikeX + 50, firstSpikeY, 50, false, false));
  spikeList.add(new Spike(firstSpikeX + 100, firstSpikeY, 50, false, false));
  spikeList.add(new Spike(firstSpikeX+50, firstSpikeY - 275, 50, false, true)); 
  spikeList.add(new Spike(firstSpikeX + 100, firstSpikeY - 275, 50, false, true));
  spikeList.add(new Spike(firstSpikeX + 150, firstSpikeY - 275, 50, false, true));
  howManySpikesToSkipBeforeTrio = (int)random(2, 6);
  howManyObstoSkipBeforePlatforms = (int)random(4, 10); 
  howManyObstoSkipBeforeStairs = (int)random(3, 8); 
  randomSpacing = (int) random(500, 700); 
  trackOfHowManyObsAdded = 1;
}

void stairsWithSpikes() {
  spikeList.add(createSmallSpike(0)); // small spike
  spikeList.add(new Spike(firstSpikeX + 25, firstSpikeY, 50, false, false)); //large spike
  platformList.add(new Platform(firstSpikeX+100, firstSpikeY-75, 50, 150, false)); // small platform
  spikeList.add(createSmallSpike(125)); // small spike
  spikeList.add(createSmallSpike(150)); // small spike
  spikeList.add(createSmallSpike(175)); // small spike
  spikeList.add(createSmallSpike(200)); // small spike
  spikeList.add(createSmallSpike(225)); // small spike
  spikeList.add(createSmallSpike(250)); // small spike
  spikeList.add(createSmallSpike(275)); // small spike
  spikeList.add(createSmallSpike(300)); // small spike
  spikeList.add(createSmallSpike(325)); // small spike
  spikeList.add(createSmallSpike(350)); // small spike
  spikeList.add(createSmallSpike(375)); // small spike
  spikeList.add(createSmallSpike(400)); // small spike
  platformList.add(new Platform(firstSpikeX+450, firstSpikeY-100, 50, 200, false)); // medium platform
  howManySpikesToSkipBeforeTrio = (int)random(2, 6);
  howManyObstoSkipBeforePlatforms = (int)random(4, 10); 
  howManyObstoSkipBeforeStairs = (int)random(3, 8); 
  randomSpacing = (int)random(1300, 1500); 
  trackOfHowManyObsAdded = 1;
}

Spike createSmallSpike(int spacing) {
  return new Spike(firstSpikeX+spacing, firstSpikeY, 25, false, false);
}
