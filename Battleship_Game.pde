/*
Ryan Chisholm
Computer Science Battleship Game Code
Resubmission
June 19th 2022
From the base code given, I added the ability for the AI to shoot at players ships,
and hid the AI ships so the player cannot see them, added newer colors and graphics
an information menu and a winner and loser message screen, and a live scoreboard.

Stuff added since last submission:
-Quit Button
-Improved Game Over and Winner EndGame screens, better looking than just one word
-Added ships to graphics as well as hit and miss symbols
-Changed some of the colors of the game to make it more appealing on the eyes, as the colors were too bright before
*/

//2D array Code
int[][] map = new int[5][5];//map array
int stage = 0;//staritng stage in game
int playerShips = 3; 
int AIships, Playerships;
boolean AIWinner = false;
boolean PlayerWinner = false;
PImage battleship,question,GameOver,Close,Winner,Boat,Flame,Sunk,Miss,Scope;//image files

int row, col;
int guessX,guessY;

/*
Stages
0 - main menu
1 - placing ships
2 - playing game
3 - Endgame screen
4 - Info screen
Grid reference
0 = water
1 = player boat
2 = Enemy boat
3 = sunk boat
4 = missed boat/splash
*/
void setup() {
  size(500,500);
  //Images
  battleship = loadImage("battleship.jpg");
  question = loadImage("QuestionMark.jpg");
  GameOver = loadImage("GameOver.jpg");
  Close = loadImage("Close.jpg");
  Winner = loadImage("Winner.jpg");  
  Boat = loadImage("Boat.png");
  Flame = loadImage("Flame.png");
  Miss = loadImage("RedX.png");
  Scope = loadImage("Crosshairs.png");
  
  AIships = 3;//starting number of ships
  Playerships = 3;
}
void draw() {
  background(10,20,180);
  stroke(255);
  if(stage != 4 && stage != 0){//if not on start screen or pause screen
    for (int r = 0; r < 5; r++) {
      for (int c = 0; c < 5; c++) {
        textSize(20);
        //code for the colour of squares and graphics
        if (map[r][c] == 0) fill(10,20,180);
        else if (map[r][c] == 1){ 
          fill(10,20,180);
          noFill();
          image(Boat,(r*100)+20,(c*100),60,100);
       }
        else if (map[r][c] == 2) fill(10,20,180);
        else if (map[r][c] == 3){
          noFill();
          image(Flame,(r*100),(c*100),100,100);
        }
        else if (map[r][c] == 4){
          //fill(120,120,120);
          noFill();
          image(Miss,(r*100),(c*100),100,100);
        }
        rect(r*100, c*100, 100, 100); 
        fill(255);
        text("(" + r + "," + c + ")", r*100, c * 100 + 50);
        if(stage == 2)image(Scope,mouseX-50,mouseY-50,100,100);
      }
    }
  }
  if(stage == 0){//main menu
    fill(255);
    image(battleship,-10,0,700,500);
    rect(45,425,290,30);
    textSize(30);
    fill(0,0,0);
    text("Press Enter to Start",50,450);
  }
  else if(stage != 0){//if not on start screen
    rect(0,0,500,30);
    image(Close,205,0,30,30);
    fill(0,0,0);
    text("Ships Remaining: " + Playerships,0,20);
    text("AI Ships Remaining: " + AIships,288,20);
    image(question,235,0,23,30);
    fill(255,255,255);
    if(stage == 3){//if game is over
      if(AIWinner == true){//AI wins
        fill(0);
        rect(100,300,300,100);
        fill(255);
        image(GameOver,100,160,300,160);
        textSize(60);
        text("You Lose",120,380);
        textSize(20);
      }
      else if(PlayerWinner == true){//Player wins
      image(Winner,60,160,400,130);
      }
    }
    else if(stage == 1) text("Place your ships: " + playerShips,110,90);
  }
  if(stage == 4){//setup for info screen
    textSize(30);
    text("Additional",5,60);
    text("Information",5,90);
    textSize(25);
    //Legend for color codes
    text("Legend",5,135);
    textSize(20);
    text("Ships = Your Ships",5,160);
    text("Blue = Water",5,185);
    text("Flame = Hit(for both player and AI)",5,210);
    text("X = Miss",5,235);
    //Rules/Description
    textSize(25);
    text("Rules",5,280);
    textSize(20);
    text("The goal of the game is to sink all three of the",5,300);
    text("enemies ships. Only one hit is needed to sink a",5,320);
    text("ship, the side whos ships are sank first, loses.",5,340);
    text("You can quit the game at any time by pressing",5,380);
    text("the DELETE button on your keyboard",5,400);
    textSize(15);
    text("(Click the question mark again to return to the game)",5,480);
    textSize(20);
  }
}

void mousePressed() {
  row = mouseX / 100;
  col = mouseY / 100;
  
  if (stage == 1){//placing ships
    if(map[row][col] == 0) {//Clicked water
      map[row][col] = 1;//Make the empty tile now hold a boat
      playerShips--;
      if(playerShips == 0){//if all ships placed
        stage = 2;
        //place AI ships now
        placePlayer(3);
      }
    } 
    else if (map[row][col] == 1) {//tried to place boat on already filled spot
    }
  } 
  else if (stage == 2){//game has been started
    if(map[row][col] == 0) {//missed
      map[row][col] = 4;//show missed square
    } 
    else if (map[row][col] == 1) {//hit own boat
      map[row][col] = 3;//sunk your own boat
      Playerships -= 1;
    } 
    else if (map[row][col] == 2) {//hit AI boat
      map[row][col] = 3;
      AIships -= 1;
    } 
    else if (map[row][col] == 3) {//sunk boat, can't hit a sunk boat, so do nothing
    } 
    else if (map[row][col] == 4) {//hitting a square that was already shot at
    }
    AIGuess();//AI Guessing function
    if(Playerships == 0){//if all players ships have been sunk
      stage = 3;
      AIWinner = true;
    }
    else if(AIships == 0){//if all AI ships have been sunk
      stage = 3;
      PlayerWinner = true;
    }
  }
  if(stage != 4 && stage != 0){//if the information button is pressed
    if(mouseX > 235 && mouseX < 255 && mouseY > 0 && mouseY < 30) stage = 4;
    else if(mouseX > 205 && mouseX < 235 && mouseY > 0 && mouseY < 28) exit();
  }
  else if(stage == 4){//return to game
    if(mouseX > 205 && mouseX < 235 && mouseY > 0 && mouseY < 28) exit();
    if(mouseX > 235 && mouseX < 258 && mouseY > 0 && mouseY < 25){
      if(playerShips == 3){//if all ships have already been placed return to game
        stage = 2;
      }
      else if(playerShips < 3){//if not all ships have been placed, return to placing stage
        stage = 1;
      }
    }
  }
}

void keyPressed(){
  if(stage == 0){//start game
    if(keyCode == ENTER) stage = 1;
  }
  else if(keyCode == DELETE) exit();//quit game function
}
void placePlayer(int n) {
  //place n player boats on the map
  int toPlace = n;
  //int guessX, guessY;
  while(toPlace > 0){//if there are still boats to be placed
    //make a guess
    guessX = floor(random(5));
    guessY = floor(random(5));
    //Only allowed to place on open water
   if(map[guessX][guessY] == 0){
      map[guessX][guessY] = 2;
      toPlace--;
    }
  }
}

void AIGuess(){//AI Guessing function
   int guessX, guessY;
   if(stage == 2){//game has started
     guessX = floor(random(5));
     guessY = floor(random(5));
     if(map[guessX][guessY] == 1){//AI hit player boat
       map[guessX][guessY] = 3;
       Playerships -= 1;
     }
     else if(map[guessX][guessY] == 0){
       map[guessX][guessY] = 4;//miss
     }
     else if(map[guessX][guessY] == 2){
       map[guessX][guessY] = 3;//hit own boat
       AIships -= 1;
     }
     else if(map[guessX][guessY] == 3 || map[guessX][guessY] == 4){
       //if it tries to shoot where it has already shot
       AIGuess();//guess again
     }
   }
}
