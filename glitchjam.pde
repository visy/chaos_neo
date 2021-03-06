/* @pjs globalKeyEvents=true; 
pauseOnBlur=true; 
preload="tilemapsmall.png,tilemapsmall_alpha.png"; 
crisp=true;
font="Shaston320.ttf";
*/

class Frame {
  int x;
  int y;
  int w;
  int h;
  
  Frame() {
     x = 0;
     y = 0;
     w = 0;
     h = 0;
  }

  Frame(int _x, int _y, int _w, int _h) {
     x = _x;
     y = _y;
     w = _w;
     h = _h;
  }

}
class Sprite {
  
  Frame[] frames;
  
  int ox;
  int oy;
  int ow;
  int oh;
  
  float wx;
  float wy;
  
  int framecount;
  
  Sprite(int _ox, int _oy, int _ow, int _oh, float _wx, float _wy, int _framecount) {

    ox = _ox;
    oy = _oy;
    ow = _ow;
    oh = _oh;
    wx = _wx;
    wy = _wy;
    framecount = _framecount;
    
    frames = new Frame[framecount];
    
    for (int i = 0; i < framecount; i++) {
      frames[i] = new Frame();
      frames[i].x = ox + (i*ow);
      frames[i].y = oy;
      frames[i].w = ow;
      frames[i].h = oh;
    }
  }
  
  int sfl;
  int efl;
  int sfr;
  int efr;
  
  void setAnimationLeft(int startFrame, int endFrame) {
    sfl = startFrame;
    efl = endFrame;
    animframe = 0;
  }
  void setAnimationRight(int startFrame, int endFrame) {
    sfr = startFrame;
    efr = endFrame;
    animframe = 0;
  }
  
  int animframe = 0;
  int animtimer = 0;
  int dir = 0;
  
  void setDir(int d) {
    dir = d;
  }
  
  void animate(int animspeed, float dt) {
    
    animtimer+=(int)dt;
    if (animtimer > animspeed) { animtimer = 0; animframe++; }
    if (animframe > 1) animframe = 0;
  }
  
  Frame getAnimFrame() {
    int i = 0;
    if (dir == 0) i = sfl+animframe;
    else if (dir == 1) i = sfr+animframe;
    
    return frames[i];
  }
  
  Frame getFrame(int frameIndex) {
    return frames[frameIndex];
  }
}
class Enemy {
	public int tx;
	public int ty;
	public int tw;
	public int th;
	int type = -1;
	float speedmod;
	boolean alive;
	boolean corrupting;

	Sprite sprite = null;
	Sprite sprite2 = null;
  Frame frame;
	int frames;

	int swx;
	int swy;

	int sdir;

	Enemy(int _tx, int _ty, int _tw, int _th) {
		tx = _tx;
		ty = _ty;
		tw = _tw;
		th = _th;
		alive = false;
		type = -1;
		frames = 4;
		frame = new Frame(tx,ty,tw,th);
		corrupting = false;
	}

	void reset() {
		if (sprite != null) {
			sprite.wx = swx;
			sprite.wy = swy;
			sprite.dir = sdir;
		}
		if (sprite2 != null) {
			sprite2.wx = swx;
			sprite2.wy = swy+4;
			sprite2.dir = 0;
			sprite.dir = 0;
		}
	}

	void resurrect() {
		alive = true;
		reset();
	}

	void setStartPos(int x, int y, int d) {
		swx = x;
		swy = y;
		sdir = d;
	}

	void setEnemyType(int _type) {
		type = _type;
		
		if (type == 0) {
			tx = 0;
			ty = 8;
			tw = 2;
			th = 3;
			frames = 4;
			speedmod = 0.5;
		}
		else if (type == 1) {
			tx = 8;
			ty = 8;
			tw = 2;
			th = 3;
			frames = 4;
			speedmod = 0.75;
		}
		else if (type == 2) {
			tx = 16;
			ty = 8;
			tw = 2;
			th = 3;
			frames = 4;
			speedmod = 0.85;
		}
		else if (type == 3) {
			tx = 24;
			ty = 8;
			tw = 2;
			th = 3;
			frames = 4;
			speedmod = 1;
		}
		else if (type == 4) {
			tx = 20;
			ty = 19;
			tw = 2;
			th = 3;
			frames = 4;
			speedmod = 0.85;
		}
		else if (type == 5) {
			tx = 12;
			ty = 5;
			tw = 2;
			th = 2;
			frames = 4;
			speedmod = 0.9;
		}
		else if (type == 6) {
			tx = 8;
			ty = 16;
			tw = 2;
			th = 2;
			frames = 4;
			speedmod = 0.7;
		}
		else if (type == 7) {
			tx = 20;
			ty = 5;
			tw = 2;
			th = 2;
			frames = 2;
			speedmod = 0.7;
		}
		else if (type == 8) {
			tx = 24;
			ty = 5;
			tw = 2;
			th = 2;
			frames = 2;
			speedmod = 0.7;
		}
		else if (type == 9) {
			tx = 0;
			ty = 22;
			tw = 4;
			th = 3;
			frames = 2;
			speedmod = 0.7;
			sprite2 = null;
			sprite2 = new Sprite(tx+tw, ty, tw, th, (int)swx, (int)swy, frames);
		}

		sprite = null;
		sprite = new Sprite(tx, ty, tw, th, (int)swx, (int)swy, frames);

		if (type >= 0 && type < 7) { // guard
			sprite.setAnimationLeft(0,1);
			sprite.setAnimationRight(2,3);
			sprite.setDir(0);
		} else if (type >= 7 && type <= 8) {
			sprite.setAnimationLeft(0,1);
			sprite.setAnimationRight(0,1);
			sprite.setDir(type == 7 ? 0 : 1);
		} else if (type == 9) {
			sprite.setAnimationLeft(0,1);
			sprite.setAnimationRight(0,1);
			sprite2.setAnimationLeft(0,1);
			sprite2.setAnimationRight(0,1);
			sprite.setDir(0);
			sprite2.setDir(0);
		}

		alive = true;
	}
	void checkCorruption(float nx, float ny) {
		  for (int y = 0; y < 3; y++) {
		    for (int x = 0; x < 2; x++) {
		      float newx = nx+(x);
		      float newy = ny-(y-1);

			if (screenBG[currentScreen][((int)(newy)*screenWidth)+(int)newx] >= 135 && screenBG[currentScreen][((int)(newy)*screenWidth)+(int)newx] <= 138) {
				corrupting = true;
			}

		    }
		  }
	}

	boolean passable(float nx, float ny) {
		boolean bg = false;
		  for (int y = 0; y < 1; y++) {
		    for (int x = 0; x < 2; x++) {
		      float newx = nx+(x);
		      float newy = ny-(y-1);

			if (th == 2) {
				newy-=1;
			}

			if (screenBG[currentScreen][((int)(newy)*screenWidth)+(int)newx] >= 135 && screenBG[currentScreen][((int)(newy)*screenWidth)+(int)newx] <= 138) {
				corrupting = true;
			}


			if (screenBlocks[currentScreen][((int)(newy)*screenWidth)+(int)newx] == 1) {
				return false;
			}


		    }
		  }
		return true;
	}

	void tick(float _dt) {
		if (type == -1) return;
  		sprite.animate(50,_dt);
		if (sprite2 != null) sprite2.animate(50,_dt);
		float hSpeed = _dt*0.035*speedmod;
		float vSpeed = _dt*0.035*speedmod;
	
		if (type >= 0 && type < 7 && type != 3) {  // guard type
			if (sprite.wx <= 0) sprite.dir = 1;
			else if (sprite.wx >= screenWidth-2) sprite.dir = 0;
			else if (!passable(sprite.wx-tw/2,sprite.wy) || !passable(sprite.wx+tw/2,sprite.wy)) {
				if (sprite.dir == 0) sprite.dir = 1;
				else sprite.dir = 0;
			}
			if (sprite.dir == 0) sprite.wx-=hSpeed;
			else sprite.wx+=hSpeed;
			checkCorruption(sprite.wx,sprite.wy);
		} else if (type >= 7 && type <= 8 || type == 3) { // spider type

			if (sprite.wy <= 1) sprite.dir = 1;
			else if (sprite.wy >= screenHeight-3) sprite.dir = 0;
			else if (!passable(sprite.wx,sprite.wy+1) || !passable(sprite.wx,sprite.wy-1)) {
				if (sprite.dir == 0) sprite.dir = 1;
				else sprite.dir = 0;
			}
			if (sprite.dir == 0) sprite.wy-=vSpeed;
			else sprite.wy+=vSpeed;
			checkCorruption(sprite.wx,sprite.wy);
		}
		
	}

	void draw() {
		if (type == -1) return;
		Frame pf = sprite.getAnimFrame();
		if (!corrupting) {
			if (type != 9) {
				drawFrameAlpha((int)sprite.wx, (int)sprite.wy, pf);
			} else {
				Frame pf2 = sprite2.getAnimFrame();
				int yp1 = (int)sprite.wy;
				int yp2 = (int)sprite.wy+3;
				if (pf != null) drawFrameAlpha((int)sprite.wx, sprite.animframe == 0 ? yp1 : yp2, pf);
				if (pf2 != null) drawFrameAlpha((int)sprite.wx, sprite.animframe == 0 ? yp2 : yp1, pf2);
			}
		} else { 
			drawFrameGlitch((int)sprite.wx, (int)sprite.wy, pf);
		}
	}
}

float dt;
float st;
float et;

PImage tilemap;
PImage[] tiles;

PImage tilemapalpha;
PImage[] tilesalpha;
ArrayList<Undoable> undoables;

int currentScreen = 0;
int screenCount = 40;

int currentLayer = 0;
int layerCount = 2;

int defaultLives = 8;
int defaultMana = 0;
int magicCoolOff = 0;
int messageCoolOff = 0;
int messageSpeed = 20;
int messageCounter = 0;
int messageLength = 0;

int lives = defaultLives;
int mana = defaultMana;
int manaTotal = 0;
int winMana = 35;
boolean gotMana = false;
boolean showingMessage = false;
boolean died = false;

int pMagicX;
int pMagicY;

int endCount = 0;

boolean blockOn = false;

String[] layerNames = { "BG","FG" };

int[][] screenBG; // layer 0
int[][] screenFG; // layer 1
int[][] screenBlocks; // block layer (stops player, solid)
Exit[] screenExit; // exits
Enemy[][] screenEnemies; // enemies 

String[] screenName = {
"Chaos Portal exit                           The Ossuary",
"The Forgotten Crypt",
"The Boathouse",
"Castle Courtyards",
"On the Drawbridge",
"The MegaTree?",
"The Guardhouse Entrance",
"Red Carpet",
"Afterparty",
"Second-hand Love",
"Rattus Rattus",
"Totally spiked",
"The Day After",
"Sunday Brunch",
"Insect Island",
"Shores of Hell",
"Portal Process",
"Mind the Gap",
"Prison Cells",
"The Three Stooges",
"On the Attic",
"Armed to the Teeth",
"Wine Reserves",
"The Church of Chaos",
"Holy Steps",
"Romance in Chaos",
"Leap of Faith",
"Comedown",
"Don't misbeehave",
"The Impossible Jump",
"Graham's Nightmare",
"Just out of reach",
"Disco Inferno",
"The Drop",
"Into the Hive",
"Clockworks",
"Shaft",
"Copy of shaft (1)",
"No foreshadoing intended...",
"Throne Room                  Chaos Portal entrance"
};


int currentExit = 0;
boolean justChangedScreen = false;

int enemyTypeCount = 10;
int enemiesPerScreen = 5;
int currentEnemy = 0;
int currentEnemyType = 0;

int tilemapWidth;
int tilemapHeight;

int screenWidth = 40;
int screenHeight = 30;

int screenStartX = 2;
int screenStartY = 8;

int prevExitDir = 0;
boolean usingMagic = false;

int savedScreenCount;

int gridX = 0;
int gridY = 0;

int gridW = 4;
int gridH = 4;

int pScreenX = 0;
int pScreenY = 0;
int screenX = 0;
int screenY = 0;

Frame gridFrame;
Frame enemyFrame;

int EDITORMODE_EDIT = 1;
int EDITORMODE_TEST = 2;
int EDITORMODE_PLAY = 3;

float playerHSpeed = 0.0;
float playerVSpeed = 1;
float playerJumpTimer = 0;
float playerOY;

boolean playerJumping = false;
boolean playerFalling = true;

boolean holdingLeft = false;
boolean holdingRight = false;
boolean holdingDown = false;
boolean holdingJump = false;
boolean holdingAction = false;
	
int ggw = 0;
int ggh = 0;

int showTilemap = 0;
int showExits = 0;
int showEnemies = 0;
int editormode = EDITORMODE_PLAY;

boolean addedBlock = false;

boolean getEditorMode() {
	return editormode == EDITORMODE_EDIT;
}

void setupEditor() {
  showTilemap = 1;
  showExits = -1;
  showEnemies = -1;
  gridX = 0;
  gridY = 9;

  gridW = 2;
  gridH = 3;

  gridFrame = new Frame();
  gridFrame.x = gridX;
  gridFrame.y = gridY;
  gridFrame.w = gridW;
  gridFrame.h = gridH;
  
  enemyFrame = new Frame();

  undoables = new ArrayList<Undoable>();
}

void dumpData() {
	for (int i = currentScreen; i < currentScreen + 10; i++) {
	println("//----------------- SCREENDATA " + i);
	
		for (int scr = 0; scr < 3; scr++) {
			if (scr == 0) println("screenBG[" + i + "] = {");
			if (scr == 1) println("screenFG[" + i + "] = {");
			if (scr == 2) println("screenBlocks[" + i + "] = {");
			for (int j = 0; j < screenWidth*screenHeight; j++) {
				if (scr == 0) print(screenBG[i][j] + ",");
				if (scr == 1) print(screenFG[i][j] + ",");
				if (scr == 2) print(screenBlocks[i][j] + ",");
			}
			print("};");
		}
		println("");
		for (int j = 0; j < enemiesPerScreen; j++) {
			println("screenEnemies[" + i + "][" + j + "] = null;");
			println("screenEnemies[" + i + "][" + j + "] = new Enemy(0,0,0,0);");
			println("screenEnemies[" + i + "][" + j + "].swx = " + screenEnemies[i][j].swx + ";");
			println("screenEnemies[" + i + "][" + j + "].swy = " + screenEnemies[i][j].swy + ";");
			println("screenEnemies[" + i + "][" + j + "].sdir = " + screenEnemies[i][j].sdir + ";");
			println("screenEnemies[" + i + "][" + j + "].setEnemyType(" + screenEnemies[i][j].type + ");");
		}
		println("");
		println("screenExit[" + i + "].set(" + screenExit[i].n + "," + screenExit[i].e + "," + screenExit[i].w + "," + screenExit[i].s + ");");
		println("");
	}
}

void resetScreens() {
  screenBG = new int[screenCount][screenWidth*screenHeight];
  screenFG = new int[screenCount][screenWidth*screenHeight];
  screenBlocks = new int[screenCount][screenWidth*screenHeight];
  screenExit = new Exit[screenCount];
  screenEnemies = new Enemy[screenCount][enemiesPerScreen];

  for (int j = 0; j < screenCount; j++) {
    screenBG[j] = new int[screenWidth*screenHeight];
    for (int i = 0; i < screenWidth*screenHeight; i++) screenBG[j][i] = 510;
    screenFG[j] = new int[screenWidth*screenHeight];
    for (int i = 0; i < screenWidth*screenHeight; i++) screenFG[j][i] = 510;
    screenBlocks[j] = new int[screenWidth*screenHeight];
    for (int i = 0; i < screenWidth*screenHeight; i++) screenBlocks[j][i] = 0;
    for (int i = 0; i < enemiesPerScreen; i++) screenEnemies[j][i] = new Enemy(0,0,0,0);

    screenExit[j] = new Exit(0,0,0,0);
  }
  textAlign(CENTER);
  
  loadScreens();

  setDefaultScreens();
   
  currentScreen = 0;
}

Sprite playerSprite;

void resetPlayer() {
  playerSprite = null;
  playerSprite = new Sprite(16, 22, 2, 3, screenStartX, screenStartY, 8);
  playerSprite.setAnimationLeft(0,1);
  playerSprite.setAnimationRight(4,5);
  playerSprite.setDir(prevExitDir == 2 ? 0 : prevExitDir == 1 ? 1 : 1);
  playerJumping = false;
  playerFalling = true;
  playerVSpeed = 0.0;
  playerHSpeed = 0;
}

void resetEnemies() {
	for(int i = 0; i < enemiesPerScreen; i++) {
		screenEnemies[currentScreen][i].reset();
	}
}

void setupGame() {
  resetScreens();
  resetPlayer();
}

void resetGameToStart() {
	screenStartX = 2; 
	screenStartY = 8; 
	endCount = 0;
	resetScreens();
	loadScreens();
	resetPlayer(); 
	playerSprite.setDir(1); 
	currentScreen = 0;
	lives = defaultLives;
	mana = defaultMana;
	manaTotal = 0;
	gotMana = false;
	died = false;
	showingMessage = false;
	showingEnd = false;
	showingWin = false;
	showingGameover = false;
	newScreen();
}

PGraphics pg;
PShader postShader;

void setup() {
  fullScreen(P3D);
  noSmooth();

  postShader = loadShader("shader.glsl");
  pg = createGraphics(320,240);
  tilemap = loadImage("tilemapsmall.png");
  tilemapalpha = loadImage("tilemapsmall_alpha.png");
  
  tilemapWidth = (int)(tilemap.width/8);
  tilemapHeight = (int)(tilemap.height/8);
  
  tiles = new PImage[tilemapWidth*tilemapHeight];
  tilesalpha = new PImage[tilemapWidth*tilemapHeight];
  
  for (int y = 0; y < tilemapHeight; y++) {
    for (int x = 0; x < tilemapWidth; x++) {
      tiles[(y*tilemapWidth)+x] = tilemap.get(x*8,y*8, 8,8);
      tilesalpha[(y*tilemapWidth)+x] = tilemapalpha.get(x*8,y*8, 8,8);
    }
  }
  

  pg.noSmooth();
  frameRate(30);
  pg.imageMode(CORNERS);
  
  setupEditor();
  setupGame();
}

void drawTileset() {
  pg.fill(0);
  pg.noStroke();
  pg.rect(0,8,tilemapWidth*8,tilemapHeight*8);
  pg.image(tilemap,0,8);
}

void drawGrid(int x,int y,int w,int h) {
  pg.pushMatrix();
  pg.fill(0,64);

  if (showEnemies == -1) pg.stroke(0,255,0,255);
  else pg.stroke(0,255,255,255);
  pg.rect(x*8,y*8,w*8,h*8);
  pg.popMatrix();
}

void drawTileNumP(int x, int y, int tnum) {
	if (tnum == 999) return;
  if (x < 0) return;
  if (x > screenWidth-1) return;

  int fnum = 510;

  // tile animations
 
  int yy = y;
  int xx = x;

  if ((tnum >= 103 && tnum <= 106) || (tnum >= 135 && tnum <= 138) || (tnum >= 167 && tnum <= 170) || (tnum >= 199 && tnum <= 202)) { // red portal
  	if (Math.random() * 10000000 > 9415000-abs(cos(millis()*0.1)*10000000)) {
		fnum = (int)(Math.random() * 700);
	} 
	else fnum = tnum; 
  } else {
	fnum = tnum;
  }

  screenBG[currentScreen][(y*screenWidth)+x] = fnum;
  screenFG[currentScreen][(y*screenWidth)+x] = fnum;
}
void drawTileNum(int x, int y, int tnum) {
	if (tnum == 999) return;
  int fnum = 510;

  // tile animations
 
  int yy = y;
  int xx = x;

  if (tnum == 40) { // leaf 1
  	if (Math.random() * 10000000 > 9995000) {
		fnum = 41;
	}
	else fnum = tnum; 
  } else if (tnum == 41) { // leaf 2
  	if (Math.random() * 10000000 > 9995000) {
		fnum = 40;
	} 
	else fnum = tnum; 
  } else if (tnum == 44) { // stars
  	if (Math.random() * 10000000 > 9995000) {
		fnum = 510;
	} 
	else fnum = tnum; 
  } else if (tnum == 381) { // smoke
  	if (Math.random() * 10000000 > 9035000) {
		fnum = 510;
	} 
	else fnum = tnum; 
  } else if ((tnum >= 103 && tnum <= 106) || (tnum >= 135 && tnum <= 138) || (tnum >= 167 && tnum <= 170) || (tnum >= 199 && tnum <= 202)) { // red portal
  	if (Math.random() * 10000000 > 9415000-abs(cos(millis()*0.1)*10000000)) {
		fnum = (int)(Math.random() * 700);
	} 
	else fnum = tnum; 
  } else {
	fnum = tnum;
  }

  pg.image(tiles[fnum], x*8,y*8);
}
void drawTileNumAlpha(int x, int y, int tnum) {
	if (tnum == 999) return;
  int fnum = 510;

  // tile animations
 
  int yy = y;
  int xx = x;

  if (tnum == 40) { // leaf 1
  	if (Math.random() * 10000000 > 9995000) {
		fnum = 41;
	}
	else fnum = tnum; 
  } else if (tnum == 41) { // leaf 2
  	if (Math.random() * 10000000 > 9995000) {
		fnum = 40;
	} 
	else fnum = tnum; 
  } else if (tnum == 44) { // stars
  	if (Math.random() * 10000000 > 9995000) {
		fnum = 510;
	} 
	else fnum = tnum; 
  } else if (tnum == 381) { // smoke
  	if (Math.random() * 10000000 > 9035000) {
		fnum = 510;
	} 
	else fnum = tnum; 
  } else if ((tnum >= 103 && tnum <= 106) || (tnum >= 135 && tnum <= 138) || (tnum >= 167 && tnum <= 170) || (tnum >= 199 && tnum <= 202)) { // red portal
  	if (Math.random() * 10000000 > 9415000-abs(cos(millis()*0.1)*10000000)) {
		fnum = (int)(Math.random() * 700);
	} 
	else fnum = tnum; 
  } else {
	fnum = tnum;
  }

  pg.image(tilesalpha[fnum], x*8,y*8);
}

void drawTileXY(int x, int y, int tx, int ty) {
  pg.image(tiles[(ty*tilemapWidth)+tx], x*8,y*8);
}
void drawTileXYAlpha(int x, int y, int tx, int ty) {
  pg.image(tilesalpha[(ty*tilemapWidth)+tx], x*8,y*8);
}

void drawFrame(int x, int y, Frame frame) {
  for (int fy = 0; fy<frame.h; fy++) {
    for (int fx = 0; fx<frame.w; fx++) {
      drawTileXY(x+fx,y+fy, frame.x+fx, frame.y+fy);
    }
  }
}
void drawFrameAlpha(int x, int y, Frame frame) {
  for (int fy = 0; fy<frame.h; fy++) {
    for (int fx = 0; fx<frame.w; fx++) {
      drawTileXYAlpha(x+fx,y+fy, frame.x+fx, frame.y+fy);
    }
  }
}

void drawFrameGlitch(int x, int y, Frame frame) {
  for (int fy = 0; fy<frame.h; fy++) {
    for (int fx = 0; fx<frame.w; fx++) {

      int corr = (int)(Math.random() * 3);
      if (corr != 1) drawTileXY(x+fx,y+fy, frame.x+fx, frame.y+fy);
      else drawTileNum(x+fx,y+fy,135+(int)(Math.random() * 4));
	   
    }
  }
}

void drawMessage(String msgtext) {
	int lines = msgtext.split("\n").length;

	messageLength = msgtext.length();

	messageSpeed-=dt*12.5;
	if (messageSpeed <= 0) { messageSpeed = 20; messageCounter++; if(messageCounter > messageLength) messageCounter = messageLength; }

	pg.noStroke();
	pg.fill(0,192);
	pg.rect(0,0,pg.width,pg.height);

	pg.fill(0);
	pg.stroke(128);
	pg.strokeWeight(8);
	int sh = (8-lines)*8;

	pg.rect(32,64+sh,pg.width-64,pg.height-(128+sh*2));
	pg.textAlign(CENTER);
	pg.noStroke();
	pg.fill(255);

	pg.text(msgtext.substring(0,messageCounter), (pg.width/2), (pg.height/2)-32);
	pg.textAlign(LEFT);
}

void renderEditorGUI() {
  pg.noStroke();
  pg.fill(0);
  pg.rect(0,0,pg.width,8);
  pg.fill(255,255);
  if (editormode == EDITORMODE_EDIT && showTilemap == 1) pg.text("["+currentScreen + "/" + screenCount + "] " + "tiles (tnum: " + (((screenY-1)*tilemapWidth)+screenX) + ", x/y: " + screenX + "/" + (screenY-1) + ", l: " + layerNames[currentLayer] + ")" + (blockOn ? " block" : ""),0,7);

  if (editormode == EDITORMODE_EDIT && showTilemap == -1) pg.text("["+currentScreen + "/" + screenCount + "] " + "edit world (" + "l: " + layerNames[currentLayer] + ")" + (blockOn ? " block" : "") + (showExits == 1 ? " exits" : "") + (showEnemies == 1 ? " enemies (" + currentEnemy + "/" + (enemiesPerScreen-1) + ")" : ""),0,7);

  if (editormode == EDITORMODE_EDIT && showTilemap == -1 && showEnemies == -1) {
    drawFrame((int)(width/8)-gridW, 0, gridFrame);
  }


  if (editormode == EDITORMODE_EDIT && showExits == 1 && showTilemap == -1) {
	pg.fill(255,0,0);
	if (currentExit == 0) fill(0,255,0);
	pg.text(screenExit[currentScreen].getN(), pg.width/2,16);
	pg.fill(255,0,0);
	if (currentExit == 1) pg.fill(0,255,0);
	pg.text(screenExit[currentScreen].getE(), pg.width-64,pg.height/2);
	pg.fill(255,0,0);
	if (currentExit == 3) pg.fill(0,255,0);
	pg.text(screenExit[currentScreen].getW(), 16,pg.height/2);
	pg.fill(255,0,0);
	if (currentExit == 2) pg.fill(0,255,0);
	pg.text(screenExit[currentScreen].getS(), pg.width/2,pg.height-16);
  }
}

boolean bgCached = false;
boolean fgCached = false;

void drawBG() {
  for (int y = 0; y < screenHeight; y++) {
    for (int x = 0; x < screenWidth; x++) {
      drawTileNum(x,y+1,screenBG[currentScreen][(y*screenWidth)+x]);
    }
  }
}

void drawFG() {
  for (int y = 0; y < screenHeight; y++) {
    for (int x = 0; x < screenWidth; x++) {
      if (screenBlocks[currentScreen][(y*screenWidth)+x] == 0 && key == 'f') continue;
      if (screenFG[currentScreen][(y*screenWidth)+x] == 52 || screenFG[currentScreen][(y*screenWidth)+x] == 53) drawTileNumAlpha(x,y+1,screenFG[currentScreen][(y*screenWidth)+x]);
      else drawTileNum(x,y+1,screenFG[currentScreen][(y*screenWidth)+x]);
    }
  } 

  if (editormode == EDITORMODE_EDIT && blockOn) {
	  for (int y = 0; y < screenHeight; y++) {
	    for (int x = 0; x < screenWidth; x++) {
	      pg.stroke(255,0,0);
	      pg.noFill();
	      if (screenBlocks[currentScreen][(y*screenWidth)+x] == 1) pg.rect(x*8,(y+1)*8,8,8);
	    }
	  }  
  }
}

boolean isBGTileInPos(int x, int y) {
  if (y > screenHeight) return false;
  if (screenBG[currentScreen][(y*screenWidth)+x] != 510) return true;
  else return false;
}

boolean isFGTileInPos(int x, int y) {
  if (y > screenHeight) return false;
  if (screenFG[currentScreen][(y*screenWidth)+x] != 510) return true;
  else return false;
}

void killPlayer() {
	resetPlayer();
	resetEnemies();
	pg.background(255,0,0);
	
	if (editormode == EDITORMODE_PLAY) {
		if (lives == 0) gameOver();
		else lives--;
		died = true;
	}
}

boolean showingGameover = false;
boolean showingEnd = false;
boolean showingWin = false;

void gameOver() {
	messageCounter = 0;
	showingGameover = true;
	showingMessage = true;
}

int TILENUM_SPIKES = 4;
int TILENUM_MSG1 = 422;
int TILENUM_MSG2 = 94;
int TILENUM_END = 999;

int TILENUM_BIGHEART = 110;
int TILENUM_SMALLHEART = 114;

void playerTileHitBG(int tilenum, int x, int y) {
	if (tilenum == TILENUM_SPIKES) {
		killPlayer();
	}
	else if (tilenum == TILENUM_MSG1 || tilenum == TILENUM_MSG2) {
		showingMessage = true;
		screenBG[currentScreen][y*screenWidth+x] = 510;
		screenBG[currentScreen][y*screenWidth+(x+1)] = 510;
		screenBG[currentScreen][(y-1)*screenWidth+(x)] = 510;
		screenBG[currentScreen][(y-1)*screenWidth+(x+1)] = 510;
	}
	else if (tilenum == TILENUM_BIGHEART || tilenum == TILENUM_SMALLHEART) {
		screenBG[currentScreen][y*screenWidth+x] = 510;
		screenBG[currentScreen][y*screenWidth+(x+1)] = 510;
		screenBG[currentScreen][(y-1)*screenWidth+(x)] = 510;
		screenBG[currentScreen][(y-1)*screenWidth+(x+1)] = 510;
		if (tilenum == TILENUM_BIGHEART) { mana+=2; manaTotal+=2; }
		else { mana+=1; manaTotal+=1; }
		pg.background(0,255,0);
		gotMana = true;
	}
	else if (tilenum == TILENUM_END && showingEnd == false) {
		if (manaTotal < winMana) {
			showingEnd = true;
			showingMessage = true;
			messageCounter = 0;
			endCount++;
			screenBG[0][(10)*screenWidth+(34)] = 92;
			screenBG[0][(10)*screenWidth+(35)] = 93;
			screenBG[0][(11)*screenWidth+(34)] = 94;
			screenBG[0][(11)*screenWidth+(35)] = 95;
		}
	}
}

void playerTileHitFG(int tilenum, int x, int y) {
	if (tilenum == TILENUM_SPIKES) {
		killPlayer();
	}
	else if (tilenum == TILENUM_MSG1 || tilenum == TILENUM_MSG2) {
		showingMessage = true;
		screenFG[currentScreen][y*screenWidth+x] = 510;
		screenFG[currentScreen][y*screenWidth+(x+1)] = 510;
		screenFG[currentScreen][(y-1)*screenWidth+(x)] = 510;
		screenFG[currentScreen][(y-1)*screenWidth+(x+1)] = 510;
	}
	else if (tilenum == TILENUM_BIGHEART || tilenum == TILENUM_SMALLHEART) {
		screenFG[currentScreen][y*screenWidth+x] = 510;
		screenFG[currentScreen][y*screenWidth+(x+1)] = 510;
		screenFG[currentScreen][(y-1)*screenWidth+(x)] = 510;
		screenFG[currentScreen][(y-1)*screenWidth+(x+1)] = 510;
		if (tilenum == TILENUM_BIGHEART) { mana+=2; manaTotal+=2; }
		else { mana+=1; manaTotal+=1; }
		pg.background(0,255,0);
		gotMana = true;
	}
}

int prevScreen = 0;

void exitScreenLeft() {
	prevScreen = currentScreen;
	if (screenExit[currentScreen].w == -2) { killPlayer(); return; }
	else if (screenExit[currentScreen].w == -1) return;
	else currentScreen = screenExit[currentScreen].w;

	justChangedScreen = true;
	playerSprite.wx = screenWidth-2;

	screenStartX = (int)playerSprite.wx;
	screenStartY = (int)playerSprite.wy;

	prevExitDir = 2;
	newScreen();
}

void exitScreenRight() {
	prevScreen = currentScreen;
	if (screenExit[currentScreen].e == -2) { killPlayer(); return; }
	else if (screenExit[currentScreen].e == -1) return;
	else currentScreen = screenExit[currentScreen].e;

	justChangedScreen = true;
	playerSprite.wx = 0;
	playerFalling = true;
	screenStartX = (int)playerSprite.wx;
	screenStartY = (int)playerSprite.wy;

	prevExitDir = 1;
	newScreen();
}

void exitScreenTop() {
	prevScreen = currentScreen;
	if (screenExit[currentScreen].n == -2) { killPlayer(); return; }
	else if (screenExit[currentScreen].n == -1) return;
	else currentScreen = screenExit[currentScreen].n;

	justChangedScreen = true;
	playerSprite.wy = screenHeight-1;
	playerFalling = true;
	screenStartX = (int)playerSprite.wx;
	screenStartY = (int)playerSprite.wy;

	prevExitDir = 0;
	newScreen();
}

void exitScreenBottom() {
	prevScreen = currentScreen;
	if (screenExit[currentScreen].s == -2) { killPlayer(); return; }
	else if (screenExit[currentScreen].s == -1) return;
	else currentScreen = screenExit[currentScreen].s;

	justChangedScreen = true;
	playerSprite.wy = 1;
	playerFalling = true;
	screenStartX = (int)playerSprite.wx;
	screenStartY = (int)playerSprite.wy;

	prevExitDir = 3;
	newScreen();
}

void newScreen() {
	messageCounter = 0;
	if (prevScreen != currentScreen) resetEnemies();
	if (manaTotal >= winMana && currentScreen == 39) {
		screenEnemies[39][0].type = -1;
	}
}

boolean playerCheckBounds(float nx, float ny) {

  int ii = 0;



  for (int y = 0; y < 3; y++) {
    for (int x = 0; x < 2; x++) {
      float newx = nx+x;
      float newy = ny+y;
  
      if (newx < -1) { exitScreenLeft(); return false; }
      if (newx > screenWidth) { exitScreenRight(); return false; }
      if (newy < -2) { exitScreenTop(); return false; }
      if (newy > screenHeight) { exitScreenBottom(); return false; }

	ii++;


      if (isFGTileInPos((int)newx,(int)(newy))) {
	playerTileHitFG(screenFG[currentScreen][((int)newy*screenWidth)+(int)newx], (int)newx,(int)newy);
      }
      if (isBGTileInPos((int)newx,(int)(newy))) {
	playerTileHitBG(screenBG[currentScreen][((int)newy*screenWidth)+(int)newx], (int)newx, (int)newy);
      }
    }
  }

  for (int y = 0; y < 1; y++) {
    for (int x = 0; x < 2; x++) {
      float newx = nx+(1-x);
      float newy = ny-(y-1);
  
      if (newx < -1) return false;
      if (newx > screenWidth) return false;
      if (newy < -2) return false;
      if (newy > screenHeight) return false;

	if (screenBlocks[currentScreen][((int)(newy)*screenWidth)+(int)newx] == 1) {
		playerFalling = true;
		return false;
	}


    }
  }
  return true;
}

void playerLeft() {
  if (playerCheckBounds(playerSprite.wx-playerHSpeed, playerSprite.wy)) playerSprite.wx-=playerHSpeed;
  playerSprite.setDir(0);
}

void playerRight() {
  if (playerCheckBounds(playerSprite.wx+playerHSpeed, playerSprite.wy)) playerSprite.wx+=playerHSpeed;
  playerSprite.setDir(1);
}

void playerJump() {
  if (playerJumping) return;
       
  playerOY = playerSprite.wy;
  playerVSpeed = 1;
  playerJumpTimer = 0;
  jumpStarting = true;
  playerJumping = true;

}

int mx, my = 0;

void playerMagic() {
	if (mana <= 0) return;


	if (mx < 0) return;
	if (mx > screenWidth-1) return;
	if (mx == pMagicX && my == pMagicY) return;
		
	if (editormode == EDITORMODE_PLAY) {
		mana--;
	}

	magicCoolOff = 100;

	pMagicX = mx;
	pMagicY = my;
	
	for (int y = my; y < my+ggh; y++) {
		for (int x = mx; x < mx+ggw; x++) {
			screenFG[currentScreen][y*screenWidth+x] = 510;
			screenBG[currentScreen][y*screenWidth+x] = 135+(int)(Math.random() * 4);
			
			screenBlocks[currentScreen][y*screenWidth+x] = 0;
		} 
	} 

	playerFalling = true;
	playerJumping = false;
}

int playerWalkSpeed = 55;

void drawPlayer() {
  if (holdingLeft || holdingRight) playerSprite.animate(playerWalkSpeed,dt);
  Frame pf;
  if (!playerJumping) pf = playerSprite.getAnimFrame();
  else { pf = playerSprite.getFrame(2+playerSprite.dir*4); }
  drawFrameAlpha((int)((playerSprite.wx*8)/8), (int)((playerSprite.wy*8)/8), pf);
}

void drawEnemies() {
	for (int i = 0; i < enemiesPerScreen; i++) {
		if (screenEnemies[currentScreen][i].alive) screenEnemies[currentScreen][i].draw();
	}
}

void renderMagic() {
	if (winTimer > 0) return;
	mx = (int)playerSprite.wx;
	my = (int)playerSprite.wy-1;

	if (!holdingDown) {
		if (playerSprite.dir == 0) { 
			mx-=1;
			ggw = 1;
			ggh = 3;
		}
		else if (playerSprite.dir == 1) {
			mx+=2;
			ggw = 1;
			ggh = 3;
		}
	} else {
		my+=3;	
    		ggw = 2;
    		ggh = 1;
	}
    pg.noFill();
    pg.stroke(0,255,0);
    pg.strokeWeight(1);
    if (mx >= 0 && mx <= screenWidth-1) pg.rect(((int)(mx))*8,((int)(my+1))*8,ggw*8,ggh*8);
}

String MsToTime(int s) {
  int ms = s % 1000;
  s = (s - ms) / 1000;
  int secs = s % 60;
  String sec_Str = "" + secs;
  s = (s - secs) / 60;
  int mins = s % 60;
  String min_Str = "" + mins;
  int hrs = (s - mins) / 60;

  if (sec_Str.length() == 1) sec_Str = "0" + sec_Str;
  if (min_Str.length() == 1) min_Str = "0" + min_Str;

  String ms_str = "" + ms;
  if (ms_str.length() == 1) ms_str = "0" + ms_str;
  return hrs + ":" + min_Str + ":" + sec_Str + "." + ms_str.substring(0,2);
}

float speedRunTime = 0;
boolean speedRunEnd = false;

void drawScreenUI() {
  pg.noStroke();
  pg.fill(0);
  pg.rect(0,0,pg.width,8);
  pg.rect(0,pg.height-8,pg.width,8);
  pg.fill(255);
  pg.textAlign(CENTER);
  pg.text(screenName[currentScreen],(int)(pg.width/2)+0.5,pg.height-1);
  speedTimer = millis();
  if (!speedRunEnd) speedRunTime = (speedTimer-speedStartTime);
  if (editormode == EDITORMODE_TEST) pg.text("play test",pg.width/2,8);
  if (editormode == EDITORMODE_PLAY && !speedRunMode) pg.text("lives: " + lives + " - mana: " + mana + " (mana collected: " + manaTotal + "/" + winMana + ")",pg.width/2+1.5,7);
  else if (editormode == EDITORMODE_PLAY && speedRunMode) pg.text("speedrun mode l: " + lives + " m: " + mana + " (" + manaTotal + "/" + winMana + ") [" + MsToTime((int)speedRunTime) + "]",pg.width/2+1.5,7);
  pg.textAlign(LEFT);
}

void drawMessages() {
	if (showingMessage && !showingEnd && !showingGameover) {
		if (currentScreen == 0 && endCount == 0) drawMessage("Ouch! Hmm, another close escape?\nLittle do they know, that\nduring years of exhaustive study\nI had hidden away the secret\nof ancient chaos magic...\n\nPress action to corrupt world.\nYou can do this left, right & down.");
		else if (currentScreen == 0 && endCount > 0) drawMessage("I seem to be able to retain\nbits and pieces of memories of my\ntrips through the chaos portal.\nThe essence of magic is seeping\nthrough our reality and is\nrepresented by heart emblems.\nI must collect them all to seal\nthe portal in the Throne Room.");

		if (currentScreen == 1) drawMessage("\n\nSmall hearts yield 1 mana.\nBig hearts yield 2 mana.\nI can use mana for the\nchaotic corruption magic.");
		if (currentScreen == 3) drawMessage("\n\nAbandoned houses...\nNobody around...\nThey must have left in a hurry.\nI wonder why?");
		if (currentScreen == 23) drawMessage("\n\nExcerpt from The Book of Chaos\n- Will of The Corruption -\n\"It's useless to pain and ache,\ntry what forms shall Chaos take.\"");
		if (currentScreen == 39) drawMessage("\n\nTHE WORLD IS CHAOS.\nALL IS CHAOS.\nCONGRATULATIONS!\nYOU WIN.");
  	} 
	if (showingEnd) {
		drawMessage("And here we are again,\nat the beginning of the end.\nThe hero with a thousand faces\ncompletes another cycle\nwith minute variation.\nWe both know what must be done.\nI wonder who the real monster is\nin this endless thread of stories?");
	}

	if (showingGameover) {
		drawMessage("\n\nGAME OVER\nRest in peace\nRequiescat in pace\npress R or start to try again");
	}
}

float winTimer = 0;

void drawTileRect(int x, int y, int w, int h) {
	for (int i = x; i < x+w; i++) {
		int tn = (int)(Math.random() * 3) + 135;
		drawTileNumP(i,y,tn);
	}
	for (int i = x; i < x+w; i++) {
		int tn = (int)(Math.random() * 3) + 135;
		drawTileNumP(i,y+h,tn);
	}
	for (int i = y; i < y+h; i++) {
		int tn = (int)(Math.random() * 3) + 135;
		drawTileNumP(x,i,tn);
	}
	for (int i = y; i < y+h; i++) {
		int tn = (int)(Math.random() * 3) + 135;
		drawTileNumP(x+w,i,tn);
	}
}

float messageTimer = 0;

void drawWin() {
	winTimer+=dt;
	float ss = winTimer*0.02;
	drawTileRect((int)(screenWidth-5-ss*1.2),(int)((screenHeight/2-3)-ss),(int)(ss*2),(int)(ss*2));	
	if (winTimer > 2000) {
		showingMessage = true;
		messageTimer = 0;
	}	
}

void renderGame() {

  if (!showingGameover) {
	  drawBG();
	  drawEnemies();
	  drawPlayer();  
	  drawFG();
	  if (showingWin) drawWin();
  }
  if (editormode != EDITORMODE_EDIT) renderMagic();

  drawScreenUI();
  drawMessages();
}

boolean speedRunMode = false;

void keyPressed() {
  
    if (key == '4') holdingLeft = true;
    if (key == '6') holdingRight = true;
    if (key == '5') holdingDown = true; 
    if (key == '8') holdingJump = true; 
    if (key == ' ') setholdingAction(1); 

  if (key == 't' && editormode == EDITORMODE_EDIT) { editormode = EDITORMODE_TEST; showingGameover = false; saveScreen(); resetPlayer(); mana = 1;}
  if (key == 't' && editormode == EDITORMODE_PLAY) { editormode = EDITORMODE_PLAY; showingGameover = false; resetGameToStart(); speedRunMode = true; speedTimer = 0; speedStartTime = millis(); speedRunEnd = false; }
  if (key == 'p' && editormode != EDITORMODE_PLAY) { editormode = EDITORMODE_PLAY; showingGameover = false; resetGameToStart(); speedRunMode = false;}
  if (key == 'e' && editormode != EDITORMODE_EDIT) { editormode = EDITORMODE_EDIT; showingGameover = false; loadScreen(false); resetPlayer(); resetEnemies(); showTilemap = -1; }
  else if (key == 'e' && editormode == EDITORMODE_EDIT && showTilemap == -1) { showExits = -showExits; }

  if (key == 'r' && editormode == EDITORMODE_PLAY) { setrestart(); speedRunMode = false; }
  if (editormode == EDITORMODE_EDIT) {
	  if (key == 'v') { showEnemies = -showEnemies; if (showEnemies == 1) { blockOn = false; showTilemap = -1; } }

	  if (key == 'l') { loadScreen(true); }
	  if (key == 's') { saveScreen(); }
	  if (key == 'd') { dumpData(); }
  }

  if (editormode == EDITORMODE_EDIT && showExits == -1 && showEnemies == -1) {
	  if (key == ' ') { showTilemap = -showTilemap; if (showTilemap == 1) { blockOn = false; showEnemies = -1; } }  
	  if (key == 'z') { currentLayer--; if (currentLayer < 0) currentLayer = 0; }
	  if (key == 'x') { currentLayer++; if (currentLayer >= layerCount-1) currentLayer = layerCount-1; }

	  if (key == 'n') { currentScreen--; if (currentScreen < 0) currentScreen = 0; resetEnemies(); newScreen(); }
	  if (key == 'm') { currentScreen++; if (currentScreen >= screenCount-1) currentScreen = screenCount-1; resetEnemies(); newScreen(); }

	  if (key == 'b') { 
		if (blockOn) blockOn = false;
		else { blockOn = true; showTilemap = -1; showEnemies = -1; }
	  }

	  if (key == 'u') { undo(); }

      if (key == '8') {
        gridY-=gridH;
        if (gridY < 1) gridY = 1;
      }
      else if (key == '5') {
        gridY+=gridH;
        if (gridY+gridH > (int)(tilemap.height/8)-6) gridY = (int)(tilemap.height/8)-7;
      }
      else if (key == '4') {
        gridX-=gridW;
        if (gridX < 0) gridX = 0;
      }
      else if (key == '6') {
        gridX+=gridW;
        if (gridX+gridW > (int)(tilemap.width/8)) gridX = (int)(tilemap.width/8);
      }
  }
  else if (editormode == EDITORMODE_EDIT && showExits == 1) {
    int modval = 0;
      if (key == '8') {
	modval-=1;
      }
      else if (key == '5') {
	modval+=1;
      }
      else if (key == '4') {
	currentExit--;
	if (currentExit < 0) currentExit = 3;
      }
      else if (key == '6') {
	currentExit++;
	if (currentExit > 3) currentExit = 0;
      }
       
      if (currentExit == 0) screenExit[currentScreen].n+=modval;
      else if (currentExit == 1) screenExit[currentScreen].e+=modval;
      else if (currentExit == 3) screenExit[currentScreen].w+=modval;
      else if (currentExit == 2) screenExit[currentScreen].s+=modval;
  } else if (editormode == EDITORMODE_EDIT && showEnemies == 1) {
      if (key == '5') {
	currentEnemyType--;
	if (currentEnemyType < -1) currentEnemyType = enemyTypeCount-1;
	      screenEnemies[currentScreen][currentEnemy].setStartPos(screenX,screenY,0);
	      screenEnemies[currentScreen][currentEnemy].setEnemyType(currentEnemyType);
	      screenEnemies[currentScreen][currentEnemy].alive = currentEnemyType != -1;
      }
      else if (key == '8') {
	currentEnemyType++;
	if (currentEnemyType >= enemyTypeCount) currentEnemyType = -1;
	      screenEnemies[currentScreen][currentEnemy].setStartPos(screenX,screenY,0);
	      screenEnemies[currentScreen][currentEnemy].setEnemyType(currentEnemyType);
	      screenEnemies[currentScreen][currentEnemy].alive = currentEnemyType != -1;
      }
      else if (key == '4') {
	currentEnemy--;
	if (currentEnemy < 0) currentEnemy = enemiesPerScreen-1;
      }
      else if (key == '6') {
	currentEnemy++;
	if (currentEnemy >= enemiesPerScreen) currentEnemy = 0;
      }
      
  }
  
}

void keyReleased() { 
  
  if (key == '8') holdingJump = false;
  if (key == ' ') setholdingAction(0);
  
    if (key == '4') holdingLeft = false;
    if (key == '6') holdingRight = false;
    if (key == '5') holdingDown = false; 

}

String[] screenToStrings() {
  String screenData = "";
  
  for (int i = 0; i < (screenWidth*screenHeight); i++) {
    screenData += screenBG[currentScreen][i] + ",";
  }
  for (int i = 0; i < (screenWidth*screenHeight); i++) {
    screenData += screenFG[currentScreen][i] + ",";
  }
  
  for (int i = 0; i < (screenWidth*screenHeight); i++) {
    screenData += screenBlocks[currentScreen][i] + ",";
  }

  for (int i = 0; i < enemiesPerScreen; i++) {
    screenData += screenEnemies[currentScreen][i].swx + "," + screenEnemies[currentScreen][i].swy + "," + screenEnemies[currentScreen][i].sdir + "," + screenEnemies[currentScreen][i].type + ",";
  }

  screenData += screenExit[currentScreen].asData();
  return screenData.split(",");
}

void loadScreens() {
  for(int i = 0; i < screenCount; i++) {
    currentScreen = i;
    loadScreen(false);
  }
}

void loadScreen() {
  loadScreen(true);
}

void loadScreen(boolean verbose) {
  if (verbose) println("loading " + "scrdata"+currentScreen+".dat" + "...");
  int iter = 0;
  int iter2 = 0;
  int iter3 = 0;
  /*
  if (localStorage["scrdata"+currentScreen+".dat"] == null) return;
  */
  return;
  /*
  
  String lines[] = loadStrings("scrdata"+currentScreen+".dat");
  if (lines == null) return;
  if (lines.length < screenWidth*screenHeight*3) return;

  // screendata
  for (int i=0; i < lines.length-4-(enemiesPerScreen*4); i++) {
    if (iter < screenWidth*screenHeight) screenBG[currentScreen][iter++] = parseInt(lines[i]);
    else if (i >= screenWidth*screenHeight && i < ((screenWidth*screenHeight)*2)) screenFG[currentScreen][iter2++] = parseInt(lines[i]);
    else if (i >= screenWidth*screenHeight*2) {
    	screenBlocks[currentScreen][iter3++] = parseInt(lines[i]);
    }
  }

  // enemies
  iter = 0;
  for (int i=screenWidth*screenHeight*3; i < lines.length-4; i+=4) {
	screenEnemies[currentScreen][iter] = null;
	screenEnemies[currentScreen][iter] = new Enemy(0,0,0,0);
	screenEnemies[currentScreen][iter].swx = parseInt(lines[i]);
	screenEnemies[currentScreen][iter].swy = parseInt(lines[i+1]);
	screenEnemies[currentScreen][iter].sdir = parseInt(lines[i+2]);
	screenEnemies[currentScreen][iter].setEnemyType(parseInt(lines[i+3]));
	iter++;
  }
  screenExit[currentScreen].n = parseInt(lines[lines.length-4]);
  screenExit[currentScreen].e = parseInt(lines[lines.length-3]);
  screenExit[currentScreen].w = parseInt(lines[lines.length-2]);
  screenExit[currentScreen].s = parseInt(lines[lines.length-1]);
  if (verbose) println("loading complete.");
  */
}

void saveScreen() {
  println("saving...");
  saveStrings("scrdata"+currentScreen+".dat", screenToStrings());
  println("saving complete. filename: " + "scrdata"+currentScreen+".dat");
}

void undo() {
  if (undoables.size() <= 0) return; 

  Undoable u = undoables.get(undoables.size()-1);
  int tileCounter = 0;

  for (int y = 0; y < u.frame.h; y++) {
    for (int x = 0; x < u.frame.w; x++) {
      if ((u.sx+x) < screenWidth) {
        int tilenum = u.savedBlock[tileCounter];
        tileCounter++;
        
        if (u.layer == 0) 
          screenBG[currentScreen][((u.sy+y-1)*screenWidth)+(u.sx+x)] = tilenum;
        else if (u.layer == 1) 
          screenFG[currentScreen][((u.sy+y-1)*screenWidth)+(u.sx+x)] = tilenum;
      }
    }
  }
  
  undoables.remove(undoables.size()-1);
  
}

void addCurrentBlock() {

  int[] savedBlock = new int[gridFrame.h*gridFrame.w];
  int tileCounter = 0;

  for (int y = 0; y < gridFrame.h; y++) {
    for (int x = 0; x < gridFrame.w; x++) {
      if ((screenX+x) < screenWidth) {
        int tilenum = ((y+gridFrame.y)*tilemapWidth)+(x+gridFrame.x);

	if(!blockOn) {
		if (currentLayer == 0) {
		  savedBlock[tileCounter] = screenBG[currentScreen][((screenY+y-1)*screenWidth)+(screenX+x)];
		  screenBG[currentScreen][((screenY+y-1)*screenWidth)+(screenX+x)] = tilenum;
		  screenBlocks[currentScreen][((screenY+y-1)*screenWidth)+(screenX+x)] = 0;
		}
		else if (currentLayer == 1) {
		  savedBlock[tileCounter] = screenFG[currentScreen][((screenY+y-1)*screenWidth)+(screenX+x)];
		  screenFG[currentScreen][((screenY+y-1)*screenWidth)+(screenX+x)] = tilenum;
		}
	} else {
	  savedBlock[tileCounter] = screenFG[currentScreen][((screenY+y-1)*screenWidth)+(screenX+x)];

	  int curBlock = screenBlocks[currentScreen][((screenY+y-1)*screenWidth)+(screenX+x)];
          screenBlocks[currentScreen][((screenY+y-1)*screenWidth)+(screenX+x)] = curBlock == 1 ? 0 : 1;
	}

        tileCounter++;

      }
    }
  }
  
  Undoable u = new Undoable(gridFrame, currentLayer,screenX,screenY,savedBlock,tileCounter);
  undoables.add(u);
}

boolean collectedMana() {
	if (gotMana) { gotMana = false; return true; }
	return false;
}
boolean didDie() {
	if (died) { died = false; return true; }
	return false;
}

void setrestart() {
	if (showingGameover) {
		showingGameover = false; 
	}
	resetGameToStart();
}

boolean setholdingJump(int on) {
   if (on == 0) {
	holdingJump = false;
   }
   if (on == 1 && !showingMessage && messageCoolOff == 0) {
	holdingJump = true;
	if (playerJumping || playerFalling || showingMessage) return false;
	return true;
   } else if (on == 1 && (showingMessage || showingEnd)) {
	if (messageCounter < messageLength && !showingEnd && !showingWin && !showingGameover) { 
		messageCounter = messageLength;
		messageCoolOff = 50;
		return false;
	}
	else if (messageCounter == messageLength) {
		if (messageCoolOff == 0) {
			showingMessage = false;
			if (showingEnd) {showingEnd = false; currentScreen = 0; messageCounter = 0; resetPlayer(); playerSprite.wx = 2; playerSprite.wy = 8; } 
			messageCoolOff = 50;
			return false;
		}
	}
   }
   
   return false;

}

boolean setholdingAction(int on) {
   if (on == 0) holdingAction = false;
   if (on == 1 && !showingMessage  && messageCoolOff == 0) {
	holdingAction = true;
	if (playerJumping || playerFalling || showingMessage || mana == 0) return false;
	return true;
   } else if (on == 1 && (showingMessage || showingEnd)) {
	if (messageCounter < messageLength && !showingEnd && !showingWin && !showingGameover) { 
		messageCounter = messageLength;
		messageCoolOff = 50;
		return false;
	}
	else if (messageCounter == messageLength) {
		if (messageCoolOff == 0) {
			showingMessage = false; 
			if (showingEnd) {showingEnd = false; currentScreen = 0; resetPlayer(); } 
			messageCoolOff = 50;
			return false;
		}
	}
   }
   
   return false;
}

void setholdingLeft(int on) {
	if (on == 0) holdingLeft = false;
	if (on == 1) holdingLeft = true;
}

void setholdingRight(int on) {
	if (on == 0) holdingRight = false;
	if (on == 1) holdingRight = true;
}

void setholdingDown(int on) {
	if (on == 0) holdingDown = false;
	if (on == 1) holdingDown = true;
}

void inputHandler() {
  if (editormode == EDITORMODE_EDIT && showTilemap == 1) {
    if (mousePressed == true) {
      gridX = (int)((mouseX/2)/8);
      gridY = (int)((mouseY/2)/8);
      if (gridY <= 0) gridY = 1;
    }
     /*
    if (key == '1') { gridW = 1; gridH = 1; }
    else if (key == '2') { gridW = 2; gridH = 1; }
    else if (key == '3') { gridW = 2; gridH = 2; }
    else if (key == '3') { gridW = 2; gridH = 2; }
    else if (key == '4') { gridW = 2; gridH = 3; }
    else if (key == '5') { gridW = 4; gridH = 4; }
    else if (key == '6') { gridW = 6; gridH = 6; }
    else if (key == '7') { gridW = 4; gridH = 1; }
    */
  }
  
  gridFrame.x = gridX;
  gridFrame.y = gridY-1;
  gridFrame.w = gridW;
  gridFrame.h = gridH;
 
  pScreenX = screenX;
  pScreenY = screenY;
  screenX = (int)((mouseX/2)/8);
  screenY = (int)((mouseY/2)/8);
  if (screenY <= 0) screenY = 1;
  if (screenY >= screenHeight) screenY = screenHeight;

  if (editormode == EDITORMODE_EDIT && showTilemap != 1 && showEnemies == -1) {

    if (pScreenX != screenX) addedBlock=false;
    if (pScreenY != screenY) addedBlock=false;

    if (mousePressed == true && addedBlock == false && mouseButton == LEFT) {
      addCurrentBlock();
      addedBlock = true;
    } else if (mousePressed == true && mouseButton == RIGHT) {
	
	gridW = 1;
	gridH = 1;

	if (currentLayer == 0) {
		gridX = screenBG[currentScreen][((screenY-1)*screenWidth)+screenX] % tilemapWidth;
		gridY = (int)Math.floor(screenBG[currentScreen][((screenY-1)*screenWidth)+screenX] / tilemapWidth)+1;
	} else {
		gridX = screenFG[currentScreen][((screenY-1)*screenWidth)+screenX] % tilemapWidth;
		gridY = (int)Math.floor(screenFG[currentScreen][((screenY-1)*screenWidth)+screenX] / tilemapWidth)+1;
	}
    }
    
    if (mousePressed == false) {
      addedBlock = false;
    }
  }
}


void renderEditor() {
  if (editormode == EDITORMODE_EDIT) {
    if (showTilemap == 1) {
      drawTileset();
      drawGrid(gridX, gridY, gridW, gridH);
    }
    else {
      if (showEnemies == -1) drawFrame(screenX, screenY, gridFrame);
      else {
      	enemyFrame.x = screenEnemies[0][0].tx;
      	enemyFrame.y = screenEnemies[0][0].ty;
      	enemyFrame.w = screenEnemies[0][0].tw;
      	enemyFrame.h = screenEnemies[0][0].th;
      	drawFrame(screenX, screenY, enemyFrame);
      }
      drawGrid(screenX, screenY, gridW, gridH);
    }
	  renderEditorGUI();
  }

}

boolean jumpStarting = false;
boolean playerGrounded = false;

void playerPhysics() {


    playerHSpeed = dt*0.035;

    if (playerSprite.wy < 0 && screenExit[currentScreen].n == -1) { playerJumping = false; playerFalling = true; playerGrounded = false; }

    if (holdingLeft && !showingMessage) playerLeft();
    else if (holdingRight && !showingMessage) playerRight();

  if (holdingJump && playerGrounded && !playerJumping && !showingMessage) playerJump();

  if (playerJumping) {
        playerGrounded = false;
        holdingJump = false;
        float slowJump = 0;
        if (playerJumpTimer > 3 && playerJumpTimer < 3.5) slowJump = (playerJumpTimer-3)*0.5;
        playerVSpeed = dt*(0.055-slowJump);
        if (playerJumpTimer >= 3.5 && playerJumpTimer < 4) playerVSpeed = 0;
        playerSprite.wy-=playerVSpeed;
        playerJumpTimer+=dt*0.055;
        if (playerJumpTimer > 4) { holdingJump = false; playerFalling = true; playerJumping = false; }
  }

   if (currentScreen == 39 && playerSprite.wx > 30 && manaTotal >= winMana && !showingWin) {
        showingWin = true;
	speedRunEnd = true;
        pg.background(255,255,255);
   }

   if (holdingAction && !playerJumping && !playerFalling && magicCoolOff == 0) {
        playerMagic();
        holdingAction = false;
   }

   if(magicCoolOff > 0) magicCoolOff-=dt*0.95;
   if(magicCoolOff < 0) magicCoolOff = 0;

   if(messageCoolOff > 0) messageCoolOff-=dt*0.95;
   if(messageCoolOff < 0) messageCoolOff = 0;

 if (playerFalling == false && !playerJumping) {
    playerVSpeed = 0;

    if (playerCheckBounds(playerSprite.wx, playerSprite.wy) && (holdingLeft || holdingRight)) { playerFalling = true; playerVSpeed = 0.5; }
  } else if (playerFalling == true && !playerJumping) {
    playerGrounded = false;
    if (playerCheckBounds(playerSprite.wx, playerSprite.wy+playerVSpeed)) { playerSprite.wy+=playerVSpeed; if (playerVSpeed < 3) playerVSpeed+=0.004*dt; }
    else { playerGrounded = true; if (!justChangedScreen) playerFalling = false; justChangedScreen = false; }
  }
}

void enemyPhysics() {
	for (int i = 0; i < enemiesPerScreen; i++) {
		if (screenEnemies[currentScreen][i].alive && screenEnemies[currentScreen][i].type != -1) {
			screenEnemies[currentScreen][i].tick(dt);
			if (playerSprite.wx+1 >= screenEnemies[currentScreen][i].sprite.wx && playerSprite.wx <= screenEnemies[currentScreen][i].sprite.wx+screenEnemies[currentScreen][i].tw) {
				if (playerSprite.wy+1 >= screenEnemies[currentScreen][i].sprite.wy && playerSprite.wy <= screenEnemies[currentScreen][i].sprite.wy+screenEnemies[currentScreen][i].th) {
					if (!screenEnemies[currentScreen][i].corrupting) killPlayer();
				}
			} 
		}
	}
}

void physics() {
  if (editormode == EDITORMODE_EDIT) return;

  if (!showingGameover && !showingWin) {
	  playerPhysics();
	  if (!showingMessage) enemyPhysics();
  }
}

float speedStartTime = 0;
float speedTimer = 0;

boolean fontinit = false;

void draw() {
  st = millis();

  background(0);
  
  pg.beginDraw();
  if (!fontinit) {
    pg.textFont(createFont("Shaston320.ttf",8));
    fontinit = true;
  }

  pg.background(0);
  
  inputHandler();
  physics();
  
  renderGame();
  renderEditor();
  
  pg.endDraw();


  pushMatrix();
  imageMode(CENTER);
  postShader.set("iGlobalTime", (float)(millis()*1000.));
  postShader.set("iResolution", (float)320*5, (float)240*5);
  shader(postShader);
  translate(width/2,height/2);
  scale(5.0);
  image(pg,0,0);
  popMatrix();
 
  et = millis();
  speedTimer+=(et-st);
  dt = 8;
}
class Undoable {
  Frame frame;
  int layer;
  int sx;
  int sy;
  int[] savedBlock;
  int tileCount;
  
  Undoable(Frame f, int l, int _sx, int _sy, int[] sb, int numTiles) {
    frame = new Frame();
    frame.x = f.x;
    frame.y = f.y;
    frame.w = f.w;
    frame.h = f.h;
    layer = l;
    sx = _sx;
    sy = _sy;
    
    tileCount = numTiles;
    
    savedBlock = new int[numTiles];
    for (int i = 0; i < numTiles; i++) 
    savedBlock[i] = sb[i];
  }
}

class Exit {

	int n;
	int e;
	int w;
	int s;

	Exit(int _n,int _e,int _w, int _s) {
		n = _n;
		e = _e;
		w = _w;
		s = _s;
	}

	void set(int _n,int _e,int _w, int _s) {
		n = _n;
		e = _e;
		w = _w;
		s = _s;
	}
	
	String asData() {
		return "" + n + "," + e + "," + w + "," + s;
	}
	
	String getN() {
		if (n == -2) return "N: DEATH";
		if (n == -1) return "N: BLOCK";
		return "N: "+n;
	}
	String getE() {
		if (e == -2) return "E: DEATH";
		if (e == -1) return "E: BLOCK";
		return "E: "+e;
	}
	String getW() {
		if (w == -2) return "W: DEATH";
		if (w == -1) return "W: BLOCK";
		return "W: "+w;
	}
	String getS() {
		if (s == -2) return "S: DEATH";
		if (s == -1) return "S: BLOCK";
		return "S: "+s;
	}
}

void setDefaultScreens() {

//----------------- SCREENDATA 0
screenBG[0] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,44,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,70,71,72,73,74,75,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,102,103,104,105,106,107,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,134,135,136,137,138,139,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,430,431,510,510,510,510,510,510,510,510,510,510,166,167,168,169,170,171,510,510,510,510,510,510,510,510,510,510,510,510,510,511,510,510,510,510,510,510,510,510,432,433,510,510,510,510,510,510,510,510,510,510,198,199,200,201,202,203,510,510,510,510,510,510,510,510,510,510,510,510,510,511,510,510,510,510,510,510,510,510,428,429,510,510,510,510,510,510,510,510,510,510,230,231,232,233,234,235,510,510,510,510,510,401,402,510,510,510,510,510,92,93,112,113,510,510,510,510,510,400,426,427,399,510,510,510,510,510,510,510,510,510,40,397,510,510,40,397,40,424,425,430,431,403,404,424,425,40,510,510,94,95,114,115,510,510,510,510,510,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,581,582,510,510,510,426,427,432,433,405,406,426,427,397,40,397,397,510,397,32,397,397,397,510,407,377,378,379,380,397,40,397,32,397,397,40,397,397,510,510,510,510,510,510,510,510,254,249,250,140,141,254,247,249,589,590,591,246,247,592,246,245,254,246,247,368,369,370,366,367,156,157,367,368,368,367,368,369,140,140,140,140,140,140,140,140,140,140,140,140,141,140,141,140,140,140,141,140,141,140,140,140,140,141,140,141,148,149,152,153,156,157,152,153,152,153,152,153,160,160,192,193,160,160,160,161,160,160,192,193,160,160,160,161,160,160,160,160,192,193,161,160,160,161,160,160,160,160,161,192,193,161,160,160,160,161,160,161,160,160,161,160,160,160,192,193,160,160,161,160,160,161,160,192,193,160,161,160,160,160,160,161,160,160,160,192,193,510,160,160,161,160,160,161,160,160,160,161,510,510,510,510,510,510,510,510,476,508,508,509,508,508,509,510,476,477,510,510,510,510,508,509,508,508,510,510,510,510,509,476,508,508,509,510,510,510,510,510,510,510,510,510,510,510,510,476,508,509,508,509,508,509,510,510,508,509,510,510,476,477,510,476,477,510,508,476,477,476,477,508,509,508,509,510,510,510,510,510,510,510,510,510,510,510,476,476,476,476,477,508,509,510,510,510,510,510,510,510,508,509,510,508,509,510,508,508,509,508,509,508,508,508,476,477,510,510,510,510,510,510,510,510,510,476,476,477,476,508,509,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,508,509,510,510,510,510,510,510,510,510,476,476,477,476,508,509,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,508,476,476,508,509,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,476,476,476,476,476,508,508,509,509,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,508,476,477,508,476,477,476,477,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,476,508,509,476,476,476,508,509,476,477,476,477,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,508,476,477,508,508,508,509,476,477,509,476,477,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,508,508,509,508,509,477,510,508,509,510,508,509,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[0] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,45,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,46,47,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,237,238,581,585,249,239,240,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,245,246,247,248,249,246,247,246,247,249,367,368,368,369,366,367,369,367,368,247,246,367,368,248,249,246,247,367,368,366,367,368,369,366,367,369,370,367,368,246,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[0] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[0][0] = null;
screenEnemies[0][0] = new Enemy(0,0,0,0);
screenEnemies[0][0].swx = 0;
screenEnemies[0][0].swy = 0;
screenEnemies[0][0].sdir = 0;
screenEnemies[0][0].setEnemyType(-1);
screenEnemies[0][1] = null;
screenEnemies[0][1] = new Enemy(0,0,0,0);
screenEnemies[0][1].swx = 0;
screenEnemies[0][1].swy = 0;
screenEnemies[0][1].sdir = 0;
screenEnemies[0][1].setEnemyType(-1);
screenEnemies[0][2] = null;
screenEnemies[0][2] = new Enemy(0,0,0,0);
screenEnemies[0][2].swx = 0;
screenEnemies[0][2].swy = 0;
screenEnemies[0][2].sdir = 0;
screenEnemies[0][2].setEnemyType(-1);
screenEnemies[0][3] = null;
screenEnemies[0][3] = new Enemy(0,0,0,0);
screenEnemies[0][3].swx = 0;
screenEnemies[0][3].swy = 0;
screenEnemies[0][3].sdir = 0;
screenEnemies[0][3].setEnemyType(-1);
screenEnemies[0][4] = null;
screenEnemies[0][4] = new Enemy(0,0,0,0);
screenEnemies[0][4].swx = 0;
screenEnemies[0][4].swy = 0;
screenEnemies[0][4].sdir = 0;
screenEnemies[0][4].setEnemyType(-1);
screenExit[0].set(-1,1,-1,-2);
//----------------- SCREENDATA 1
screenBG[1] = new int[] {
510,510,510,510,510,510,510,40,40,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,510,510,510,510,510,510,510,510,40,40,40,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,40,510,510,510,44,510,510,44,510,510,40,40,40,41,41,41,41,41,41,41,41,41,41,41,41,40,41,41,41,41,41,41,41,41,41,41,41,41,41,40,40,510,510,510,510,510,510,510,510,510,40,40,40,40,40,40,41,41,41,41,41,41,41,41,41,41,41,41,41,41,40,40,40,41,41,41,41,40,40,40,40,510,510,510,510,510,510,44,510,510,510,40,40,40,40,40,40,33,34,40,41,41,41,41,40,33,36,40,40,40,40,40,40,40,40,40,40,40,40,40,510,510,510,510,510,510,510,510,510,510,510,510,40,40,40,40,43,37,34,40,40,40,40,40,43,37,38,39,40,40,40,510,510,40,40,35,38,39,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,40,35,36,40,40,40,40,40,40,35,36,40,40,510,510,510,510,510,510,33,34,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,35,36,510,510,40,40,510,510,33,34,510,510,510,510,44,510,510,43,37,36,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,33,34,510,510,510,510,510,510,35,36,510,510,510,510,510,510,510,510,33,34,510,510,44,510,510,510,510,510,510,510,510,48,49,510,510,510,510,510,510,510,33,38,39,510,510,510,510,510,33,34,510,510,510,510,510,510,510,510,33,34,510,510,510,510,510,510,510,510,510,48,49,50,51,510,48,49,510,52,53,510,35,36,510,510,510,510,510,510,35,36,510,510,510,510,510,510,510,510,42,34,510,510,510,510,510,510,52,53,510,50,51,510,510,510,50,51,510,54,55,510,35,36,510,510,510,510,510,510,35,36,510,510,510,510,510,510,510,510,35,36,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,33,34,510,510,510,510,510,510,33,34,510,510,510,510,510,510,510,510,35,36,510,510,510,510,245,246,245,245,246,245,246,510,510,510,510,510,510,510,510,249,250,510,254,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,92,93,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,94,95,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,407,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,108,109,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,110,111,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,399,400,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[1] = new int[] {
510,510,510,510,510,510,510,510,510,41,41,41,41,41,41,41,41,41,41,41,41,41,41,510,41,510,41,510,41,41,41,41,41,41,41,41,41,41,41,41,510,510,510,510,510,510,510,510,510,510,510,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,510,41,41,41,510,510,510,510,510,510,510,510,510,510,510,510,510,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,41,41,41,41,41,41,41,41,41,41,41,41,41,41,510,510,510,41,41,41,41,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,41,41,41,41,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,245,246,367,368,245,367,368,245,367,368,367,368,246,367,368,510,510,367,254,254,368,367,367,368,367,368,367,368,367,368,368,367,368,367,368,367,368,368,367,245,146,146,245,582,582,582,582,583,510,510,510,253,254,253,254,254,254,254,253,254,582,582,583,582,583,510,510,510,510,582,583,582,583,583,582,583,582,583,583,245,193,129,146,245,582,582,583,510,510,510,510,510,253,253,253,254,254,253,253,254,582,582,582,582,582,583,510,254,583,582,583,510,510,510,582,582,583,582,583,245,228,193,194,146,254,510,510,510,510,510,510,510,510,253,254,254,246,253,254,510,510,510,510,582,582,583,582,582,582,254,583,510,510,510,510,582,246,582,583,590,510,193,194,146,245,510,510,510,510,510,510,510,253,253,254,254,253,253,254,510,510,510,510,510,582,582,582,583,582,583,510,510,510,510,510,510,582,582,583,590,510,510,129,146,245,510,510,510,510,510,510,510,253,253,254,253,254,254,510,510,510,510,510,510,510,510,582,582,583,510,510,510,510,510,510,510,510,582,583,590,129,510,510,226,146,245,367,368,367,368,367,367,368,367,367,368,367,367,368,367,367,368,367,367,368,367,368,367,368,367,367,368,510,510,510,367,368,367,368,368,510,510,510,510,129,146,245,582,582,254,583,582,583,582,583,583,582,582,583,582,583,583,583,583,582,246,583,583,583,582,583,583,510,510,510,510,510,510,510,245,510,193,194,226,510,228,146,245,245,582,246,510,510,510,582,583,254,246,246,246,254,582,582,583,582,246,582,582,246,582,582,510,510,510,510,510,510,582,583,245,510,510,129,510,510,193,194,146,245,246,510,510,510,510,510,582,254,254,254,254,582,582,583,510,510,510,510,582,246,582,583,510,510,510,378,379,582,582,583,245,510,510,510,510,228,228,194,146,245,510,510,510,510,510,510,582,246,246,582,583,510,510,510,510,510,510,510,510,510,510,582,582,510,510,510,510,582,582,583,245,510,226,510,510,510,510,228,146,245,245,510,510,510,510,510,582,583,582,583,510,510,510,510,510,510,510,510,510,510,510,510,582,583,510,510,582,583,582,583,245,228,510,129,510,228,510,193,194,146,245,245,245,245,368,368,367,368,368,367,368,367,368,367,368,367,368,367,368,367,368,367,367,368,367,368,367,368,367,367,368,510,510,510,510,510,510,510,510,228,146,146,146,146,145,146,145,146,145,146,145,146,146,145,146,145,146,145,146,145,146,146,145,146,145,159,159,159,146,145,146,129,510,510,510,129,510,510,510,510,129,193,193,129,227,228,193,194,228,227,129,194,227,129,227,228,228,193,129,228,193,194,228,193,194,226,193,194,193,194,129,510,226,510,510,510,510,228,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[1] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[1][0] = null;
screenEnemies[1][0] = new Enemy(0,0,0,0);
screenEnemies[1][0].swx = 0;
screenEnemies[1][0].swy = 0;
screenEnemies[1][0].sdir = 0;
screenEnemies[1][0].setEnemyType(-1);
screenEnemies[1][1] = null;
screenEnemies[1][1] = new Enemy(0,0,0,0);
screenEnemies[1][1].swx = 0;
screenEnemies[1][1].swy = 0;
screenEnemies[1][1].sdir = 0;
screenEnemies[1][1].setEnemyType(-1);
screenEnemies[1][2] = null;
screenEnemies[1][2] = new Enemy(0,0,0,0);
screenEnemies[1][2].swx = 0;
screenEnemies[1][2].swy = 0;
screenEnemies[1][2].sdir = 0;
screenEnemies[1][2].setEnemyType(-1);
screenEnemies[1][3] = null;
screenEnemies[1][3] = new Enemy(0,0,0,0);
screenEnemies[1][3].swx = 0;
screenEnemies[1][3].swy = 0;
screenEnemies[1][3].sdir = 0;
screenEnemies[1][3].setEnemyType(-1);
screenEnemies[1][4] = null;
screenEnemies[1][4] = new Enemy(0,0,0,0);
screenEnemies[1][4].swx = 0;
screenEnemies[1][4].swy = 0;
screenEnemies[1][4].sdir = 0;
screenEnemies[1][4].setEnemyType(-1);
screenExit[1].set(-1,2,0,-2);

level2();

}

void level2() {
//----------------- SCREENDATA 2
screenBG[2] = new int[] {
41,40,40,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,40,40,40,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,40,40,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,44,45,510,510,510,510,40,510,510,510,510,510,510,44,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,46,47,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,245,246,247,248,248,249,253,254,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,246,247,248,249,253,254,255,510,240,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,700,701,703,702,703,702,700,701,702,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,61,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,13,14,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,702,701,701,703,701,702,703,700,703,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,397,359,361,362,362,363,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,397,362,363,362,360,359,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,397,359,361,363,362,363,510,108,109,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,397,361,359,510,8,510,510,110,111,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,397,360,362,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,397,362,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,225,226,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[2] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,254,255,247,248,249,249,249,240,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,248,248,254,255,248,249,248,585,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,245,245,245,245,245,245,245,245,245,245,245,245,245,245,510,510,510,510,13,14,13,14,13,14,13,14,13,14,13,14,13,14,13,14,13,14,13,14,13,14,510,510,510,510,510,510,510,510,510,596,597,598,602,603,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,583,587,510,510,510,510,510,510,510,510,411,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,248,510,510,510,510,510,510,510,510,510,410,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,581,510,510,510,510,510,510,510,510,510,412,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,6,8,12,247,510,510,510,510,510,510,510,510,510,412,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,19,13,9,247,240,510,510,510,510,373,374,375,376,412,510,510,510,510,373,374,375,376,510,510,510,373,374,375,376,510,510,510,510,373,374,375,376,510,510,19,20,8,12,485,486,485,486,485,486,485,486,485,486,412,485,486,485,486,485,486,485,486,485,486,485,486,485,486,485,486,485,486,485,486,486,485,485,485,485,485,485,485,486,225,195,196,98,196,225,226,225,225,226,412,195,196,225,98,225,195,196,226,226,98,195,196,226,195,98,226,195,196,226,98,195,98,226,195,196,98,195,196,98,510,510,510,510,510,510,510,510,510,510,412,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[2] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,1,1,1,1,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[2][0] = null;
screenEnemies[2][0] = new Enemy(0,0,0,0);
screenEnemies[2][0].swx = 0;
screenEnemies[2][0].swy = 0;
screenEnemies[2][0].sdir = 0;
screenEnemies[2][0].setEnemyType(-1);
screenEnemies[2][1] = null;
screenEnemies[2][1] = new Enemy(0,0,0,0);
screenEnemies[2][1].swx = 0;
screenEnemies[2][1].swy = 0;
screenEnemies[2][1].sdir = 0;
screenEnemies[2][1].setEnemyType(-1);
screenEnemies[2][2] = null;
screenEnemies[2][2] = new Enemy(0,0,0,0);
screenEnemies[2][2].swx = 0;
screenEnemies[2][2].swy = 0;
screenEnemies[2][2].sdir = 0;
screenEnemies[2][2].setEnemyType(-1);
screenEnemies[2][3] = null;
screenEnemies[2][3] = new Enemy(0,0,0,0);
screenEnemies[2][3].swx = 0;
screenEnemies[2][3].swy = 0;
screenEnemies[2][3].sdir = 0;
screenEnemies[2][3].setEnemyType(-1);
screenEnemies[2][4] = null;
screenEnemies[2][4] = new Enemy(0,0,0,0);
screenEnemies[2][4].swx = 0;
screenEnemies[2][4].swy = 0;
screenEnemies[2][4].sdir = 0;
screenEnemies[2][4].setEnemyType(-1);
screenExit[2].set(-1,3,1,-2);
//----------------- SCREENDATA 3
screenBG[3] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,381,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,381,510,510,510,510,510,510,510,510,44,45,510,510,510,510,510,44,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,381,510,510,510,510,510,510,510,510,510,46,47,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,381,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,381,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,381,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,10,12,510,510,510,371,371,371,371,371,371,371,371,371,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,6,7,510,510,16,16,17,16,17,16,17,16,16,16,16,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,371,371,371,371,371,371,371,371,371,371,16,16,16,16,16,16,16,16,16,16,16,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,16,16,16,16,16,16,16,16,16,16,16,17,16,17,16,16,17,16,16,16,17,16,16,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,16,16,16,16,16,16,17,16,16,16,16,16,17,369,369,369,368,366,367,369,369,370,595,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,16,17,16,16,17,16,16,16,16,16,16,17,16,16,16,369,369,510,510,368,369,510,510,369,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,245,367,368,369,369,366,366,369,366,366,368,369,247,369,369,366,510,510,369,369,510,510,595,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,366,510,510,369,369,366,368,369,368,369,369,366,595,369,369,369,369,369,369,368,369,368,369,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,366,510,510,366,369,366,510,510,368,369,366,368,247,369,369,369,369,369,369,369,369,369,369,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,369,245,369,369,366,368,510,510,366,366,367,367,255,369,366,368,369,369,368,369,368,366,255,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,417,459,510,168,504,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,359,360,359,363,364,360,359,510,510,510,510,510,510,510,510,510,5,112,113,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,364,19,510,361,360,359,362,359,360,363,360,510,510,510,510,510,510,510,510,5,114,115,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,112,113,510,19,510,359,360,359,360,363,360,359,361,361,510,510,510,510,510,510,510,5,510,510,510,363,361,360,359,360,361,361,363,361,359,361,363,359,360,360,114,115,510,19,510,6,7,6,7,359,360,362,360,361,360,510,510,510,510,510,510,5,510,359,363,362,361,363,359,363,359,361,360,362,363,361,363,359,360,362,359,360,510,19,510,10,11,7,6,6,7,359,362,361,361,360,510,510,510,510,510,5,363,359,363,363,362,359,363,362,363,363,362,363,359,362,363,362,362,363,361,361,359,19,510,6,7,10,7,6,7,19,20,510,510,510,510,510,510,510,510,9,19,9,19,9,9,19,19,9,9,19,9,19,9,19,19,9,10,19,9,9,10,19,510,142,149,150,142,143,149,149,150,142,143,149,150,150,142,149,150,149,150,150,149,150,142,143,149,150,149,150,142,143,149,150,150,142,143,143,149,150,142,143,142,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[3] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,511,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,60,60,60,60,60,59,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,13,14,13,13,14,13,14,13,14,13,14,14,13,14,14,13,14,13,14,13,14,14,13,14,13,14,14,13,14,14,14,13,14,13,14,13,14,13,14,14,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,379,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,22,23,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,24,25,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,226,130,226,163,193,128,193,193,226,128,163,128,193,226,130,193,226,128,163,128,130,128,226,128,128,163,163,193,226,130,226,193,128,128,163,128,130,128,163,130,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[3] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[3][0] = null;
screenEnemies[3][0] = new Enemy(0,0,0,0);
screenEnemies[3][0].swx = 0;
screenEnemies[3][0].swy = 0;
screenEnemies[3][0].sdir = 0;
screenEnemies[3][0].setEnemyType(-1);
screenEnemies[3][1] = null;
screenEnemies[3][1] = new Enemy(0,0,0,0);
screenEnemies[3][1].swx = 0;
screenEnemies[3][1].swy = 0;
screenEnemies[3][1].sdir = 0;
screenEnemies[3][1].setEnemyType(-1);
screenEnemies[3][2] = null;
screenEnemies[3][2] = new Enemy(0,0,0,0);
screenEnemies[3][2].swx = 0;
screenEnemies[3][2].swy = 0;
screenEnemies[3][2].sdir = 0;
screenEnemies[3][2].setEnemyType(-1);
screenEnemies[3][3] = null;
screenEnemies[3][3] = new Enemy(0,0,0,0);
screenEnemies[3][3].swx = 0;
screenEnemies[3][3].swy = 0;
screenEnemies[3][3].sdir = 0;
screenEnemies[3][3].setEnemyType(-1);
screenEnemies[3][4] = null;
screenEnemies[3][4] = new Enemy(0,0,0,0);
screenEnemies[3][4].swx = 0;
screenEnemies[3][4].swy = 0;
screenEnemies[3][4].sdir = 0;
screenEnemies[3][4].setEnemyType(-1);
screenExit[3].set(-1,4,2,-2);

level3();
}

void level3() {
//----------------- SCREENDATA 4
screenBG[4] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,44,45,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,46,47,510,510,44,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[4] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,14,377,378,379,379,379,379,379,379,379,377,379,379,379,379,379,379,379,377,379,379,379,379,379,379,377,379,379,379,379,379,379,377,379,379,379,379,379,379,379,380,412,510,510,510,510,510,510,510,510,412,510,510,510,510,510,510,510,412,510,510,510,510,510,510,412,510,510,510,510,510,510,412,510,510,510,510,510,510,510,412,412,510,510,510,510,510,510,510,510,412,510,510,510,510,510,510,510,412,510,510,510,510,510,510,412,510,510,510,510,510,510,412,510,510,510,510,510,510,510,412,412,510,510,510,510,510,510,510,510,412,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,412,510,510,510,510,510,510,510,412,412,510,510,510,510,510,510,510,510,412,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,412,510,510,510,510,510,510,510,412,412,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,412,480,481,480,480,480,480,480,480,480,480,480,480,481,480,481,480,481,480,481,480,481,480,481,480,480,480,480,480,480,480,480,480,480,480,480,480,480,480,481,480,98,131,132,97,164,165,98,98,193,194,98,98,98,195,196,98,98,99,100,98,132,133,196,197,98,98,99,193,194,98,97,98,98,98,97,98,98,98,160,161,412,510,510,412,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[4] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[4][0] = null;
screenEnemies[4][0] = new Enemy(0,0,0,0);
screenEnemies[4][0].swx = 0;
screenEnemies[4][0].swy = 0;
screenEnemies[4][0].sdir = 0;
screenEnemies[4][0].setEnemyType(-1);
screenEnemies[4][1] = null;
screenEnemies[4][1] = new Enemy(0,0,0,0);
screenEnemies[4][1].swx = 0;
screenEnemies[4][1].swy = 0;
screenEnemies[4][1].sdir = 0;
screenEnemies[4][1].setEnemyType(-1);
screenEnemies[4][2] = null;
screenEnemies[4][2] = new Enemy(0,0,0,0);
screenEnemies[4][2].swx = 0;
screenEnemies[4][2].swy = 0;
screenEnemies[4][2].sdir = 0;
screenEnemies[4][2].setEnemyType(-1);
screenEnemies[4][3] = null;
screenEnemies[4][3] = new Enemy(0,0,0,0);
screenEnemies[4][3].swx = 0;
screenEnemies[4][3].swy = 0;
screenEnemies[4][3].sdir = 0;
screenEnemies[4][3].setEnemyType(-1);
screenEnemies[4][4] = null;
screenEnemies[4][4] = new Enemy(0,0,0,0);
screenEnemies[4][4].swx = 0;
screenEnemies[4][4].swy = 0;
screenEnemies[4][4].sdir = 0;
screenEnemies[4][4].setEnemyType(-1);
screenExit[4].set(-1,5,3,-2);

  //----------------- SCREENDATA 5
screenBG[5] = new int[] {
510,510,510,510,44,510,510,510,510,40,40,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,40,510,510,510,510,510,510,510,510,510,510,510,510,510,510,40,40,40,40,41,41,41,41,41,41,41,41,41,41,40,41,41,41,41,41,41,41,41,41,40,40,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,40,40,40,40,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,40,40,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,40,40,40,40,41,41,41,41,41,41,41,41,41,41,41,41,41,41,40,40,40,40,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,40,40,40,40,40,40,40,41,41,40,40,40,40,40,40,40,40,40,40,40,40,40,40,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,40,40,40,40,40,40,40,40,40,40,40,34,40,40,40,40,40,40,40,40,40,708,708,708,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,40,40,40,40,40,40,40,40,40,34,510,40,40,40,40,40,40,40,40,510,708,708,708,510,510,510,510,510,510,510,44,510,510,510,510,510,510,44,510,510,510,40,40,40,40,40,40,40,35,506,40,510,40,40,40,40,40,40,510,708,708,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,40,40,40,35,506,34,40,40,40,40,40,40,708,708,708,708,708,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,43,36,34,506,708,510,510,708,510,510,708,506,506,708,708,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,508,33,506,36,39,510,510,708,510,510,506,506,506,506,708,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,508,33,34,36,38,510,510,708,708,510,510,708,510,708,44,506,506,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,43,33,477,34,510,510,510,510,510,510,510,510,708,708,708,510,506,506,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,33,509,34,510,510,510,510,510,510,510,510,510,510,510,510,506,506,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,33,510,34,510,510,510,510,510,510,510,510,510,510,510,510,510,506,506,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,506,507,33,34,36,510,510,510,44,506,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,44,510,510,510,506,506,507,33,509,36,510,510,510,506,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,476,477,510,510,510,510,510,510,510,510,510,506,507,33,509,36,510,510,510,506,506,510,510,510,510,510,510,510,510,510,510,510,708,708,708,708,708,510,510,510,508,509,477,510,510,510,510,510,510,510,510,506,507,33,509,36,510,510,510,506,506,510,510,510,510,510,510,510,510,510,510,510,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,14,508,33,509,36,510,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,379,379,379,379,379,379,379,379,379,379,379,379,379,379,379,379,379,379,379,377,14,33,509,36,11,379,379,379,379,379,379,379,379,379,379,379,379,379,379,379,510,510,510,510,506,510,510,510,508,509,510,510,510,510,510,510,510,506,510,510,380,33,708,36,39,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,506,33,708,36,38,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,506,43,35,708,36,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,237,238,239,240,510,510,33,37,36,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,237,238,576,245,246,245,246,245,246,245,246,35,708,36,239,240,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[5] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,140,141,140,141,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,131,68,130,131,130,131,130,130,130,68,162,68,131,131,130,162,131,131,131,131,131,130,68,131,162,68,131,131,131,131,162,131,130,131,130,131,162,162,68,131,510,510,64,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,131,130,131,131,510,131,510,131,131,131,131,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[5] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[5][0] = null;
screenEnemies[5][0] = new Enemy(0,0,0,0);
screenEnemies[5][0].swx = 0;
screenEnemies[5][0].swy = 0;
screenEnemies[5][0].sdir = 0;
screenEnemies[5][0].setEnemyType(-1);
screenEnemies[5][1] = null;
screenEnemies[5][1] = new Enemy(0,0,0,0);
screenEnemies[5][1].swx = 0;
screenEnemies[5][1].swy = 0;
screenEnemies[5][1].sdir = 0;
screenEnemies[5][1].setEnemyType(-1);
screenEnemies[5][2] = null;
screenEnemies[5][2] = new Enemy(0,0,0,0);
screenEnemies[5][2].swx = 0;
screenEnemies[5][2].swy = 0;
screenEnemies[5][2].sdir = 0;
screenEnemies[5][2].setEnemyType(-1);
screenEnemies[5][3] = null;
screenEnemies[5][3] = new Enemy(0,0,0,0);
screenEnemies[5][3].swx = 0;
screenEnemies[5][3].swy = 0;
screenEnemies[5][3].sdir = 0;
screenEnemies[5][3].setEnemyType(-1);
screenEnemies[5][4] = null;
screenEnemies[5][4] = new Enemy(0,0,0,0);
screenEnemies[5][4].swx = 0;
screenEnemies[5][4].swy = 0;
screenEnemies[5][4].sdir = 0;
screenEnemies[5][4].setEnemyType(-1);
screenExit[5].set(-1,6,4,-2);
//----------------- SCREENDATA 6
screenBG[6] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,373,374,375,376,373,374,375,376,403,404,507,507,507,507,507,507,507,53,53,53,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,373,374,375,376,374,403,404,507,507,507,507,507,507,507,507,507,53,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,373,374,375,376,373,374,375,376,403,404,507,507,507,507,507,507,507,507,507,507,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,373,374,375,376,374,403,404,507,507,507,507,507,507,507,52,507,507,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,373,374,375,376,373,374,375,376,403,404,507,507,507,507,507,507,507,507,507,53,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,373,374,375,376,374,403,404,507,507,507,507,507,507,507,507,507,52,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,373,374,375,376,373,374,375,376,403,404,507,507,507,507,507,507,507,53,53,52,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,373,374,375,376,374,403,404,507,507,507,507,507,507,507,53,52,53,507,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,373,374,375,376,373,374,375,376,403,404,507,507,507,507,507,507,507,507,507,53,507,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,373,374,375,376,374,403,404,507,507,507,507,507,507,507,507,507,507,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,373,374,375,376,373,374,375,376,403,404,506,507,507,509,509,510,510,507,507,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,401,373,374,375,376,373,374,375,376,374,403,404,506,507,508,509,509,510,510,510,510,510,510,510,510,510,510,510,506,507,508,509,508,509,510,510,510,510,510,401,89,50,373,374,375,376,373,374,375,376,403,404,506,506,507,508,509,510,510,510,510,510,510,510,510,510,510,510,510,506,507,508,509,510,510,510,510,510,401,89,510,510,510,510,510,510,510,510,510,510,510,510,506,507,508,509,510,510,510,510,510,510,510,510,510,510,510,510,510,506,506,507,508,509,510,510,510,401,89,510,510,510,510,510,510,510,510,510,510,510,510,510,506,507,508,509,509,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,401,89,510,510,510,510,510,510,510,510,510,510,510,510,510,510,506,507,508,509,509,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,401,89,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,506,507,508,509,509,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,401,89,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,506,507,508,509,509,510,510,54,55,54,55,510,510,510,510,510,510,510,510,510,510,401,89,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,506,506,507,508,509,54,55,54,55,54,55,13,13,13,13,13,13,380,60,60,60,60,60,60,60,60,60,60,60,373,374,375,376,373,374,375,376,374,403,404,54,55,54,55,54,55,54,55,54,55,54,379,379,379,379,379,379,506,506,412,510,510,510,510,412,510,510,510,510,50,373,374,375,376,373,374,375,376,403,404,55,54,55,54,55,54,55,54,55,54,55,510,510,510,510,510,510,510,510,412,510,510,510,510,412,510,510,510,510,373,374,375,376,373,374,375,376,374,403,404,54,55,54,55,54,55,54,55,54,55,54,510,510,510,510,510,510,510,510,412,510,510,510,510,412,510,510,510,510,50,373,374,375,376,373,374,375,376,403,404,55,54,55,54,55,54,55,54,55,54,55,510,510,510,510,510,510,510,510,412,510,510,510,510,412,510,510,510,510,373,374,375,376,373,374,375,376,374,403,404,54,55,54,55,54,55,54,55,54,55,54,510,510,510,510,510,510,510,510,510,510,510,510,510,412,510,510,510,510,50,373,374,375,376,373,374,375,376,403,404,55,54,55,54,55,54,55,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,412,510,510,510,510,373,374,375,376,373,374,375,376,374,403,404,54,55,54,55,54,55,54,55,54,55,54,140,141,142,143,142,140,141,142,143,142,143,140,141,142,143,140,141,142,50,373,374,375,376,373,374,375,376,403,404,55,54,55,54,55,54,55,54,55,54,55,161,161,161,162,163,164,164,164,163,164,164,164,164,164,164,164,163,164,373,374,375,376,373,374,375,376,374,403,404,54,55,54,55,54,55,54,55,54,55,54,510,161,161,161,161,162,163,164,510,510,510,510,510,161,162,163,164,164,373,374,375,376,510,510,510,510,510,403,404,405,406,406,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[6] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[6] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[6][0] = null;
screenEnemies[6][0] = new Enemy(0,0,0,0);
screenEnemies[6][0].swx = 0;
screenEnemies[6][0].swy = 0;
screenEnemies[6][0].sdir = 0;
screenEnemies[6][0].setEnemyType(-1);
screenEnemies[6][1] = null;
screenEnemies[6][1] = new Enemy(0,0,0,0);
screenEnemies[6][1].swx = 0;
screenEnemies[6][1].swy = 0;
screenEnemies[6][1].sdir = 0;
screenEnemies[6][1].setEnemyType(-1);
screenEnemies[6][2] = null;
screenEnemies[6][2] = new Enemy(0,0,0,0);
screenEnemies[6][2].swx = 0;
screenEnemies[6][2].swy = 0;
screenEnemies[6][2].sdir = 0;
screenEnemies[6][2].setEnemyType(-1);
screenEnemies[6][3] = null;
screenEnemies[6][3] = new Enemy(0,0,0,0);
screenEnemies[6][3].swx = 0;
screenEnemies[6][3].swy = 0;
screenEnemies[6][3].sdir = 0;
screenEnemies[6][3].setEnemyType(-1);
screenEnemies[6][4] = null;
screenEnemies[6][4] = new Enemy(0,0,0,0);
screenEnemies[6][4].swx = 0;
screenEnemies[6][4].swy = 0;
screenEnemies[6][4].sdir = 0;
screenEnemies[6][4].setEnemyType(-1);
screenExit[6].set(-1,7,5,-2);

level4();

}

void level4() {
  //----------------- SCREENDATA 7
screenBG[7] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,64,65,66,67,68,69,510,510,510,510,510,510,510,510,64,65,66,67,68,69,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,96,97,98,99,100,101,510,510,510,510,510,510,510,510,96,97,98,99,100,101,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,128,129,130,131,132,133,510,510,510,510,510,510,510,510,128,129,130,131,132,133,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,160,161,162,163,164,165,510,510,510,510,510,510,510,510,160,161,162,163,164,165,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,192,193,194,195,196,197,510,510,510,510,510,510,510,510,192,193,194,195,196,197,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,224,225,226,227,228,229,510,510,510,510,510,510,510,510,224,225,226,227,228,229,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,476,477,54,55,54,55,54,55,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,54,55,476,477,476,476,477,55,510,54,55,510,52,54,55,54,55,54,55,510,510,510,510,54,55,54,55,54,55,54,55,510,54,55,54,55,54,55,476,477,54,55,54,55,54,55,54,55,510,510,54,55,54,55,53,52,54,55,510,510,510,510,510,510,506,52,54,55,53,52,54,55,53,54,55,510,55,54,55,54,55,54,55,54,55,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,54,55,54,55,54,55,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,55,54,55,54,55,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,54,55,54,55,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,55,54,55,54,55,54,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,54,55,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,55,54,55,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,55,54,55,54,55,53,411,411,410,410,410,410,411,410,410,410,410,410,410,411,410,410,411,410,410,410,410,410,410,410,410,410,410,410,410,411,410,410,410,510,54,55,510,510,510,510,510,510,510,510,510,409,410,410,510,162,409,410,410,410,410,410,410,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[7] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[7] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1,1,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,0,0,1,0,0,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[7][0] = null;
screenEnemies[7][0] = new Enemy(0,0,0,0);
screenEnemies[7][0].swx = 24;
screenEnemies[7][0].swy = 16;
screenEnemies[7][0].sdir = 0;
screenEnemies[7][0].setEnemyType(3);
screenEnemies[7][1] = null;
screenEnemies[7][1] = new Enemy(0,0,0,0);
screenEnemies[7][1].swx = 0;
screenEnemies[7][1].swy = 0;
screenEnemies[7][1].sdir = 0;
screenEnemies[7][1].setEnemyType(-1);
screenEnemies[7][2] = null;
screenEnemies[7][2] = new Enemy(0,0,0,0);
screenEnemies[7][2].swx = 0;
screenEnemies[7][2].swy = 0;
screenEnemies[7][2].sdir = 0;
screenEnemies[7][2].setEnemyType(-1);
screenEnemies[7][3] = null;
screenEnemies[7][3] = new Enemy(0,0,0,0);
screenEnemies[7][3].swx = 0;
screenEnemies[7][3].swy = 0;
screenEnemies[7][3].sdir = 0;
screenEnemies[7][3].setEnemyType(-1);
screenEnemies[7][4] = null;
screenEnemies[7][4] = new Enemy(0,0,0,0);
screenEnemies[7][4].swx = 0;
screenEnemies[7][4].swy = 0;
screenEnemies[7][4].sdir = 0;
screenEnemies[7][4].setEnemyType(-1);
screenExit[7].set(-1,8,6,-2);
//----------------- SCREENDATA 8
screenBG[8] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,70,71,72,73,74,75,510,510,510,510,510,510,510,510,70,71,72,73,74,75,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,102,411,98,99,411,107,510,510,510,510,510,510,510,510,102,411,98,99,411,107,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,134,129,130,131,132,139,510,510,510,510,510,510,510,510,134,129,130,131,132,139,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,166,161,162,163,164,171,510,510,510,510,510,510,510,510,166,161,162,163,164,171,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,198,411,194,195,411,203,510,510,510,510,510,510,510,510,198,411,194,195,411,203,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,230,231,232,233,234,235,510,510,510,510,510,510,510,510,230,231,232,233,234,235,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,54,55,54,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,510,510,54,55,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,410,411,410,410,410,410,411,411,410,410,168,410,410,411,411,410,410,410,410,410,410,168,411,410,410,410,410,410,410,411,410,410,410,168,411,410,410,411,411,410,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,410,410,410,410,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[8] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[8] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[8][0] = null;
screenEnemies[8][0] = new Enemy(0,0,0,0);
screenEnemies[8][0].swx = 7;
screenEnemies[8][0].swy = 18;
screenEnemies[8][0].sdir = 0;
screenEnemies[8][0].setEnemyType(3);
screenEnemies[8][1] = null;
screenEnemies[8][1] = new Enemy(0,0,0,0);
screenEnemies[8][1].swx = 0;
screenEnemies[8][1].swy = 0;
screenEnemies[8][1].sdir = 0;
screenEnemies[8][1].setEnemyType(-1);
screenEnemies[8][2] = null;
screenEnemies[8][2] = new Enemy(0,0,0,0);
screenEnemies[8][2].swx = 0;
screenEnemies[8][2].swy = 0;
screenEnemies[8][2].sdir = 0;
screenEnemies[8][2].setEnemyType(-1);
screenEnemies[8][3] = null;
screenEnemies[8][3] = new Enemy(0,0,0,0);
screenEnemies[8][3].swx = 0;
screenEnemies[8][3].swy = 0;
screenEnemies[8][3].sdir = 0;
screenEnemies[8][3].setEnemyType(-1);
screenEnemies[8][4] = null;
screenEnemies[8][4] = new Enemy(0,0,0,0);
screenEnemies[8][4].swx = 0;
screenEnemies[8][4].swy = 0;
screenEnemies[8][4].sdir = 0;
screenEnemies[8][4].setEnemyType(-1);
screenExit[8].set(-1,9,7,-2);
//----------------- SCREENDATA 9
screenBG[9] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,476,477,477,510,476,477,510,510,510,510,510,510,510,510,510,510,510,476,477,477,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,508,509,509,476,477,509,477,510,510,510,510,510,510,510,64,476,476,477,509,509,477,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,476,477,476,477,477,476,477,510,510,510,510,510,510,510,476,477,477,477,508,509,509,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,508,509,476,477,509,508,509,477,510,510,510,510,510,476,510,509,509,509,477,477,509,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,476,510,508,509,476,477,508,509,510,510,510,510,510,508,476,477,477,508,509,509,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,508,509,477,509,508,509,510,476,477,510,510,510,510,476,508,509,476,477,477,509,477,510,510,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,476,477,477,509,508,509,477,508,509,510,510,510,510,476,477,508,508,509,509,509,509,510,54,55,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,476,477,476,476,477,508,509,510,476,477,510,476,477,508,476,477,476,508,509,508,509,510,510,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,508,476,477,508,509,509,476,476,508,509,510,508,509,510,476,476,508,509,509,508,509,510,54,55,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,224,476,476,476,476,477,508,508,509,510,510,510,510,510,508,508,509,476,508,508,509,510,510,54,55,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,508,508,508,508,509,510,510,510,510,510,510,510,510,510,508,508,508,508,509,510,510,510,510,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,108,109,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,110,111,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,510,510,54,374,375,375,375,376,510,510,510,510,510,510,510,510,510,373,374,375,374,375,376,510,510,510,510,510,510,373,374,375,375,375,375,376,55,54,55,510,510,510,510,54,55,506,507,510,373,374,375,374,374,374,375,374,374,374,375,374,374,374,374,374,374,374,374,374,374,374,374,374,374,374,374,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,53,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,52,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,54,55,54,55,54,55,510,510,54,55,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,54,55,54,55,54,55,54,55,54,55,54,55,54,55,411,410,168,410,410,411,168,410,401,402,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,54,55,54,55,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[9] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[9] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[9][0] = null;
screenEnemies[9][0] = new Enemy(0,0,0,0);
screenEnemies[9][0].swx = 0;
screenEnemies[9][0].swy = 0;
screenEnemies[9][0].sdir = 0;
screenEnemies[9][0].setEnemyType(-1);
screenEnemies[9][1] = null;
screenEnemies[9][1] = new Enemy(0,0,0,0);
screenEnemies[9][1].swx = 23;
screenEnemies[9][1].swy = 17;
screenEnemies[9][1].sdir = 0;
screenEnemies[9][1].setEnemyType(2);
screenEnemies[9][2] = null;
screenEnemies[9][2] = new Enemy(0,0,0,0);
screenEnemies[9][2].swx = 9;
screenEnemies[9][2].swy = 17;
screenEnemies[9][2].sdir = 0;
screenEnemies[9][2].setEnemyType(2);
screenEnemies[9][3] = null;
screenEnemies[9][3] = new Enemy(0,0,0,0);
screenEnemies[9][3].swx = 0;
screenEnemies[9][3].swy = 0;
screenEnemies[9][3].sdir = 0;
screenEnemies[9][3].setEnemyType(-1);
screenEnemies[9][4] = null;
screenEnemies[9][4] = new Enemy(0,0,0,0);
screenEnemies[9][4].swx = 0;
screenEnemies[9][4].swy = 0;
screenEnemies[9][4].sdir = 0;
screenEnemies[9][4].setEnemyType(-1);
screenExit[9].set(-1,10,8,-2);


level5();
}

void level5() {

    //----------------- SCREENDATA 10
screenBG[10] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,64,65,66,67,68,69,510,510,510,510,510,510,510,510,64,65,66,67,68,69,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,96,97,98,99,100,101,510,510,510,510,510,510,510,510,96,97,98,99,100,101,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,128,161,162,163,392,133,510,510,510,510,510,510,510,510,392,161,162,163,164,133,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,128,161,162,163,392,133,510,510,510,510,510,510,510,510,392,161,162,163,164,133,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,128,161,162,163,392,133,510,510,510,510,510,510,510,510,392,161,162,163,164,133,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,128,161,162,163,393,133,510,510,510,510,510,510,510,510,392,161,162,163,164,133,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,128,161,162,163,392,133,510,510,510,510,510,510,510,510,392,161,162,163,164,133,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,128,161,162,163,393,133,510,510,510,510,510,510,510,510,392,161,162,163,164,133,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,394,394,394,394,394,394,510,510,510,510,510,510,510,510,394,394,394,394,394,394,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,508,508,508,508,507,507,507,507,507,507,507,507,510,510,54,55,510,476,477,477,477,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,54,55,54,55,54,55,54,55,54,55,54,55,54,55,54,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,508,509,509,509,509,509,509,509,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,506,507,506,507,507,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,506,507,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,54,55,54,55,510,54,55,54,55,54,55,510,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,510,54,55,510,510,510,54,55,54,55,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,4,510,510,510,510,4,4,4,54,55,510,510,4,510,54,55,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,401,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[10] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[10] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[10][0] = null;
screenEnemies[10][0] = new Enemy(0,0,0,0);
screenEnemies[10][0].swx = 35;
screenEnemies[10][0].swy = 17;
screenEnemies[10][0].sdir = 0;
screenEnemies[10][0].setEnemyType(-1);
screenEnemies[10][1] = null;
screenEnemies[10][1] = new Enemy(0,0,0,0);
screenEnemies[10][1].swx = 35;
screenEnemies[10][1].swy = 17;
screenEnemies[10][1].sdir = 0;
screenEnemies[10][1].setEnemyType(5);
screenEnemies[10][2] = null;
screenEnemies[10][2] = new Enemy(0,0,0,0);
screenEnemies[10][2].swx = 27;
screenEnemies[10][2].swy = 9;
screenEnemies[10][2].sdir = 0;
screenEnemies[10][2].setEnemyType(-1);
screenEnemies[10][3] = null;
screenEnemies[10][3] = new Enemy(0,0,0,0);
screenEnemies[10][3].swx = 23;
screenEnemies[10][3].swy = 7;
screenEnemies[10][3].sdir = 0;
screenEnemies[10][3].setEnemyType(-1);
screenEnemies[10][4] = null;
screenEnemies[10][4] = new Enemy(0,0,0,0);
screenEnemies[10][4].swx = 20;
screenEnemies[10][4].swy = 6;
screenEnemies[10][4].sdir = 0;
screenEnemies[10][4].setEnemyType(-1);
screenExit[10].set(-1,11,9,-2);
//----------------- SCREENDATA 11
screenBG[11] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,390,391,510,510,510,510,510,510,510,510,510,390,391,510,510,510,510,510,510,510,510,510,510,390,391,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,392,393,510,510,510,510,510,510,510,510,510,392,393,510,510,510,510,510,510,510,510,510,510,392,393,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,392,393,510,510,510,510,510,510,510,510,510,392,393,510,510,510,510,510,510,510,510,510,510,392,393,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,392,393,510,510,510,510,510,510,510,510,510,392,393,510,510,510,510,510,510,510,510,510,510,392,393,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,392,393,510,510,510,510,510,510,510,510,510,392,393,510,510,510,510,510,510,510,510,510,510,392,393,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,392,393,510,510,510,510,510,510,510,510,510,392,393,510,510,510,510,510,510,510,510,510,510,392,393,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,392,393,510,510,510,510,510,510,510,510,510,392,393,510,510,510,510,510,510,510,510,510,510,392,393,510,510,510,510,510,510,510,510,510,510,510,510,510,510,394,394,394,394,510,510,510,510,510,510,510,394,394,394,394,510,510,510,510,510,510,510,510,394,394,394,394,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,54,55,506,506,506,507,54,55,54,55,506,506,506,507,54,55,54,55,507,507,507,508,54,55,510,510,510,510,510,510,510,510,510,510,54,55,510,54,55,510,54,55,508,508,508,508,54,55,54,55,508,508,508,508,54,54,55,55,508,508,508,508,54,55,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,54,4,4,4,4,55,510,510,54,4,4,4,4,55,510,54,55,4,4,4,4,54,55,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,510,510,510,510,54,55,54,55,510,510,510,54,55,54,55,54,55,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,401,402,410,410,410,410,410,410,410,410,410,410,410,410,410,410,410,410,410,410,410,410,410,410,410,410,410,410,410,410,410,410,410,410,410,410,410,410,410,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[11] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[11] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[11][0] = null;
screenEnemies[11][0] = new Enemy(0,0,0,0);
screenEnemies[11][0].swx = 0;
screenEnemies[11][0].swy = 0;
screenEnemies[11][0].sdir = 0;
screenEnemies[11][0].setEnemyType(-1);
screenEnemies[11][1] = null;
screenEnemies[11][1] = new Enemy(0,0,0,0);
screenEnemies[11][1].swx = 0;
screenEnemies[11][1].swy = 0;
screenEnemies[11][1].sdir = 0;
screenEnemies[11][1].setEnemyType(-1);
screenEnemies[11][2] = null;
screenEnemies[11][2] = new Enemy(0,0,0,0);
screenEnemies[11][2].swx = 0;
screenEnemies[11][2].swy = 0;
screenEnemies[11][2].sdir = 0;
screenEnemies[11][2].setEnemyType(-1);
screenEnemies[11][3] = null;
screenEnemies[11][3] = new Enemy(0,0,0,0);
screenEnemies[11][3].swx = 0;
screenEnemies[11][3].swy = 0;
screenEnemies[11][3].sdir = 0;
screenEnemies[11][3].setEnemyType(-1);
screenEnemies[11][4] = null;
screenEnemies[11][4] = new Enemy(0,0,0,0);
screenEnemies[11][4].swx = 0;
screenEnemies[11][4].swy = 0;
screenEnemies[11][4].sdir = 0;
screenEnemies[11][4].setEnemyType(-1);
screenExit[11].set(-1,12,10,-2);
//----------------- SCREENDATA 12
screenBG[12] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,364,360,360,360,362,362,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,64,65,66,67,68,69,510,510,510,510,510,510,510,510,510,510,510,510,64,65,66,67,68,69,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,96,97,98,99,100,101,510,510,510,510,510,510,510,510,510,510,510,510,96,97,98,99,100,101,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,128,129,130,131,132,133,510,510,510,510,510,510,510,510,510,510,510,510,128,129,130,131,132,133,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,160,161,162,163,164,165,510,510,510,510,510,510,510,510,510,510,510,510,160,161,162,163,164,165,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,192,193,194,195,196,197,510,510,510,510,510,510,510,510,510,510,510,510,192,193,194,195,196,197,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,224,225,226,227,228,229,510,510,510,510,510,510,510,510,510,510,510,510,224,225,226,227,228,229,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,54,55,54,55,510,54,55,510,510,510,510,54,55,510,510,510,510,54,55,510,510,510,54,55,510,510,510,54,55,510,54,55,510,510,510,510,510,510,510,510,510,510,506,507,506,507,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[12] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[12] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,1,1,0,1,1,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,1,1,0,0,0,1,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[12][0] = null;
screenEnemies[12][0] = new Enemy(0,0,0,0);
screenEnemies[12][0].swx = 14;
screenEnemies[12][0].swy = 17;
screenEnemies[12][0].sdir = 0;
screenEnemies[12][0].setEnemyType(3);
screenEnemies[12][1] = null;
screenEnemies[12][1] = new Enemy(0,0,0,0);
screenEnemies[12][1].swx = 19;
screenEnemies[12][1].swy = 17;
screenEnemies[12][1].sdir = 0;
screenEnemies[12][1].setEnemyType(3);
screenEnemies[12][2] = null;
screenEnemies[12][2] = new Enemy(0,0,0,0);
screenEnemies[12][2].swx = 24;
screenEnemies[12][2].swy = 17;
screenEnemies[12][2].sdir = 0;
screenEnemies[12][2].setEnemyType(3);
screenEnemies[12][3] = null;
screenEnemies[12][3] = new Enemy(0,0,0,0);
screenEnemies[12][3].swx = 0;
screenEnemies[12][3].swy = 0;
screenEnemies[12][3].sdir = 0;
screenEnemies[12][3].setEnemyType(-1);
screenEnemies[12][4] = null;
screenEnemies[12][4] = new Enemy(0,0,0,0);
screenEnemies[12][4].swx = 0;
screenEnemies[12][4].swy = 0;
screenEnemies[12][4].sdir = 0;
screenEnemies[12][4].setEnemyType(-1);
screenExit[12].set(-1,13,11,-2);

level6();
}

void level6() {
//----------------- SCREENDATA 13
screenBG[13] = new int[] {
360,359,360,359,360,360,359,360,359,360,359,359,360,360,360,359,360,359,360,360,360,359,360,359,360,360,360,359,360,360,360,360,360,359,359,359,359,360,360,360,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,374,376,510,510,510,510,373,376,510,510,510,510,374,374,510,510,510,510,374,374,510,510,510,510,374,374,510,510,510,510,373,55,510,510,510,510,54,55,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,460,461,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,373,374,54,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,460,461,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,437,76,77,436,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,54,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,466,467,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,435,510,510,434,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,54,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,54,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,55,510,510,510,510,510,510,510,510,510,510,508,509,509,509,509,509,509,509,509,509,509,509,509,509,509,509,509,509,510,510,510,510,510,510,510,510,510,373,374,54,376,510,510,510,510,510,510,510,59,510,29,29,21,29,30,21,30,30,21,30,30,21,30,30,21,30,30,510,59,510,510,510,510,510,510,510,510,510,373,376,510,510,510,510,510,510,510,510,60,59,510,510,56,510,510,56,510,510,56,510,510,56,510,510,56,510,510,60,61,510,510,510,510,510,510,510,510,373,374,378,378,377,377,377,377,8,8,6,7,8,9,6,7,8,9,8,8,8,8,8,6,7,8,9,8,8,8,8,8,6,7,8,380,380,380,378,378,378,378,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,51,51,51,51,51,53,53,51,51,51,51,51,510,51,51,510,51,51,51,51,510,51,51,51,510,51,51,51,51,51,51,51,51,510,510,510,510,51,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,51,51,51,51,51,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[13] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[13] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[13][0] = null;
screenEnemies[13][0] = new Enemy(0,0,0,0);
screenEnemies[13][0].swx = 15;
screenEnemies[13][0].swy = 22;
screenEnemies[13][0].sdir = 0;
screenEnemies[13][0].setEnemyType(2);
screenEnemies[13][1] = null;
screenEnemies[13][1] = new Enemy(0,0,0,0);
screenEnemies[13][1].swx = 33;
screenEnemies[13][1].swy = 22;
screenEnemies[13][1].sdir = 0;
screenEnemies[13][1].setEnemyType(0);
screenEnemies[13][2] = null;
screenEnemies[13][2] = new Enemy(0,0,0,0);
screenEnemies[13][2].swx = 27;
screenEnemies[13][2].swy = 22;
screenEnemies[13][2].sdir = 0;
screenEnemies[13][2].setEnemyType(1);
screenEnemies[13][3] = null;
screenEnemies[13][3] = new Enemy(0,0,0,0);
screenEnemies[13][3].swx = 21;
screenEnemies[13][3].swy = 22;
screenEnemies[13][3].sdir = 0;
screenEnemies[13][3].setEnemyType(0);
screenEnemies[13][4] = null;
screenEnemies[13][4] = new Enemy(0,0,0,0);
screenEnemies[13][4].swx = 8;
screenEnemies[13][4].swy = 23;
screenEnemies[13][4].sdir = 0;
screenEnemies[13][4].setEnemyType(5);
screenExit[13].set(-1,14,12,-2);

  //----------------- SCREENDATA 14
screenBG[14] = new int[] {
510,510,510,510,510,510,510,54,55,50,50,50,50,50,54,55,510,510,510,510,44,510,510,510,510,510,510,510,510,510,44,510,510,44,45,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,54,55,50,50,402,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,46,47,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,50,54,55,402,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,50,50,50,402,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,50,50,50,402,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,50,54,50,50,510,510,510,510,510,510,510,44,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,50,50,50,50,50,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,162,163,162,162,50,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,128,129,162,162,162,50,50,50,50,50,54,55,402,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,160,161,162,162,162,163,50,50,50,50,50,50,50,50,54,55,402,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,160,161,162,163,162,163,54,55,54,54,55,54,55,54,55,403,54,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,192,193,194,195,196,197,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,224,225,226,227,228,229,510,510,510,510,510,510,510,510,510,510,510,510,510,376,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,506,506,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,376,510,510,510,510,510,510,510,510,510,237,238,238,239,239,238,238,239,238,239,240,241,506,237,240,240,506,506,237,240,510,510,237,240,240,510,510,237,240,240,380,380,380,380,380,66,130,130,131,163,164,130,130,130,163,164,163,163,163,163,163,163,163,163,163,164,163,164,163,164,130,130,130,131,131,131,131,130,131,164,510,510,510,510,380,380,130,163,164,163,164,131,131,163,163,164,131,130,163,163,164,131,130,131,130,131,131,131,131,163,163,163,164,163,163,164,130,131,131,131,510,510,510,510,510,380,130,130,130,130,131,131,163,164,164,164,163,163,164,163,164,163,164,163,164,163,164,163,163,164,163,163,163,164,164,163,164,164,130,131,510,510,510,510,510,510,130,130,131,130,131,130,163,163,164,130,163,164,164,131,130,130,131,130,131,130,131,131,131,130,131,130,131,163,164,163,164,131,130,131,510,510,510,510,510,510,510,130,131,131,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,130,131,130,131,130,131,130,131,130,130,131,130,130,130,131,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[14] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[14] = new int[] {
0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,1,1,0,0,1,1,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[14][0] = null;
screenEnemies[14][0] = new Enemy(0,0,0,0);
screenEnemies[14][0].swx = 32;
screenEnemies[14][0].swy = 21;
screenEnemies[14][0].sdir = 0;
screenEnemies[14][0].setEnemyType(8);
screenEnemies[14][1] = null;
screenEnemies[14][1] = new Enemy(0,0,0,0);
screenEnemies[14][1].swx = 0;
screenEnemies[14][1].swy = 0;
screenEnemies[14][1].sdir = 0;
screenEnemies[14][1].setEnemyType(-1);
screenEnemies[14][2] = null;
screenEnemies[14][2] = new Enemy(0,0,0,0);
screenEnemies[14][2].swx = 14;
screenEnemies[14][2].swy = 21;
screenEnemies[14][2].sdir = 0;
screenEnemies[14][2].setEnemyType(8);
screenEnemies[14][3] = null;
screenEnemies[14][3] = new Enemy(0,0,0,0);
screenEnemies[14][3].swx = 26;
screenEnemies[14][3].swy = 22;
screenEnemies[14][3].sdir = 0;
screenEnemies[14][3].setEnemyType(-1);
screenEnemies[14][4] = null;
screenEnemies[14][4] = new Enemy(0,0,0,0);
screenEnemies[14][4].swx = 28;
screenEnemies[14][4].swy = 21;
screenEnemies[14][4].sdir = 0;
screenEnemies[14][4].setEnemyType(7);
screenExit[14].set(-1,15,13,-2);
//----------------- SCREENDATA 15
screenBG[15] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,55,54,55,54,55,55,55,510,510,510,510,510,510,510,44,510,510,510,44,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,44,510,510,510,510,55,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,55,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,55,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,55,55,55,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,55,55,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,55,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,55,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,55,55,55,55,55,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,55,55,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,55,55,55,55,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,377,378,379,380,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,377,378,379,380,510,510,510,510,510,510,377,378,379,380,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,507,508,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,376,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,376,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,376,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,376,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,238,576,253,369,369,367,367,368,367,367,367,367,367,368,367,367,369,510,510,510,510,510,373,374,376,54,55,510,510,510,510,240,240,240,510,510,510,237,238,576,246,246,253,370,370,370,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,376,54,55,510,510,510,510,510,163,164,164,164,163,164,51,51,52,51,51,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,163,163,164,164,163,164,101,101,101,101,101,52,51,51,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,164,164,164,164,163,67,67,164,67,67,67,101,510,52,51,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,164,164,163,163,163,164,164,164,164,164,68,67,67,68,52,51,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[15] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[15] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,0,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[15][0] = null;
screenEnemies[15][0] = new Enemy(0,0,0,0);
screenEnemies[15][0].swx = 4;
screenEnemies[15][0].swy = 17;
screenEnemies[15][0].sdir = 0;
screenEnemies[15][0].setEnemyType(7);
screenEnemies[15][1] = null;
screenEnemies[15][1] = new Enemy(0,0,0,0);
screenEnemies[15][1].swx = 10;
screenEnemies[15][1].swy = 20;
screenEnemies[15][1].sdir = 0;
screenEnemies[15][1].setEnemyType(8);
screenEnemies[15][2] = null;
screenEnemies[15][2] = new Enemy(0,0,0,0);
screenEnemies[15][2].swx = 17;
screenEnemies[15][2].swy = 17;
screenEnemies[15][2].sdir = 0;
screenEnemies[15][2].setEnemyType(8);
screenEnemies[15][3] = null;
screenEnemies[15][3] = new Enemy(0,0,0,0);
screenEnemies[15][3].swx = 27;
screenEnemies[15][3].swy = 17;
screenEnemies[15][3].sdir = 0;
screenEnemies[15][3].setEnemyType(3);
screenEnemies[15][4] = null;
screenEnemies[15][4] = new Enemy(0,0,0,0);
screenEnemies[15][4].swx = 22;
screenEnemies[15][4].swy = 16;
screenEnemies[15][4].sdir = 0;
screenEnemies[15][4].setEnemyType(7);
screenExit[15].set(-1,16,14,-2);

level7();
}

void level7() {
//----------------- SCREENDATA 16
screenBG[16] = new int[] {
510,510,510,510,510,510,510,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,376,510,510,510,510,510,510,510,510,510,510,373,376,510,510,510,510,510,510,510,54,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,376,510,510,510,510,510,510,510,54,510,373,374,373,374,373,374,376,507,507,507,507,507,507,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,510,510,506,506,506,507,509,55,507,507,507,507,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,510,510,506,507,507,507,510,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,510,510,510,510,510,510,510,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,510,510,510,510,510,510,510,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,510,510,510,510,510,510,510,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,510,510,510,510,510,510,510,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,510,510,510,510,510,510,510,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,510,510,510,510,510,510,510,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,510,510,510,510,510,510,510,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,510,510,510,510,510,510,510,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,510,510,510,510,510,510,510,55,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,406,406,54,510,510,510,510,510,510,510,510,510,510,510,510,510,405,405,405,405,405,406,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[16] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[16] = new int[] {
1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[16][0] = null;
screenEnemies[16][0] = new Enemy(0,0,0,0);
screenEnemies[16][0].swx = 0;
screenEnemies[16][0].swy = 0;
screenEnemies[16][0].sdir = 0;
screenEnemies[16][0].setEnemyType(-1);
screenEnemies[16][1] = null;
screenEnemies[16][1] = new Enemy(0,0,0,0);
screenEnemies[16][1].swx = 0;
screenEnemies[16][1].swy = 0;
screenEnemies[16][1].sdir = 0;
screenEnemies[16][1].setEnemyType(-1);
screenEnemies[16][2] = null;
screenEnemies[16][2] = new Enemy(0,0,0,0);
screenEnemies[16][2].swx = 0;
screenEnemies[16][2].swy = 0;
screenEnemies[16][2].sdir = 0;
screenEnemies[16][2].setEnemyType(-1);
screenEnemies[16][3] = null;
screenEnemies[16][3] = new Enemy(0,0,0,0);
screenEnemies[16][3].swx = 24;
screenEnemies[16][3].swy = 14;
screenEnemies[16][3].sdir = 0;
screenEnemies[16][3].setEnemyType(5);
screenEnemies[16][4] = null;
screenEnemies[16][4] = new Enemy(0,0,0,0);
screenEnemies[16][4].swx = 0;
screenEnemies[16][4].swy = 0;
screenEnemies[16][4].sdir = 0;
screenEnemies[16][4].setEnemyType(-1);
screenExit[16].set(16,17,15,16);
//----------------- SCREENDATA 17
screenBG[17] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,54,55,55,55,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,54,54,54,55,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,54,55,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,54,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,374,375,374,374,375,376,380,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,377,378,378,378,378,378,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,55,375,376,380,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,375,376,55,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,55,55,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,55,55,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,375,376,55,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,55,55,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,55,55,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,510,55,55,375,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,55,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,373,375,376,510,510,510,373,376,510,510,373,376,510,510,373,376,510,510,373,376,510,510,510,510,55,55,55,55,510,510,510,510,510,510,373,374,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,55,55,55,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,55,55,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,55,375,376,55,399,400,510,510,400,510,510,510,399,510,510,510,399,400,510,510,510,510,400,510,510,399,510,510,510,399,400,510,510,399,510,510,510,400,510,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,4,4,4,510,4,4,4,4,4,4,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[17] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[17] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,0,1,1,1,1,1,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[17][0] = null;
screenEnemies[17][0] = new Enemy(0,0,0,0);
screenEnemies[17][0].swx = 0;
screenEnemies[17][0].swy = 0;
screenEnemies[17][0].sdir = 0;
screenEnemies[17][0].setEnemyType(-1);
screenEnemies[17][1] = null;
screenEnemies[17][1] = new Enemy(0,0,0,0);
screenEnemies[17][1].swx = 0;
screenEnemies[17][1].swy = 0;
screenEnemies[17][1].sdir = 0;
screenEnemies[17][1].setEnemyType(-1);
screenEnemies[17][2] = null;
screenEnemies[17][2] = new Enemy(0,0,0,0);
screenEnemies[17][2].swx = 0;
screenEnemies[17][2].swy = 0;
screenEnemies[17][2].sdir = 0;
screenEnemies[17][2].setEnemyType(-1);
screenEnemies[17][3] = null;
screenEnemies[17][3] = new Enemy(0,0,0,0);
screenEnemies[17][3].swx = 0;
screenEnemies[17][3].swy = 0;
screenEnemies[17][3].sdir = 0;
screenEnemies[17][3].setEnemyType(-1);
screenEnemies[17][4] = null;
screenEnemies[17][4] = new Enemy(0,0,0,0);
screenEnemies[17][4].swx = 0;
screenEnemies[17][4].swy = 0;
screenEnemies[17][4].sdir = 0;
screenEnemies[17][4].setEnemyType(-1);
screenExit[17].set(-2,18,16,-2);
//----------------- SCREENDATA 18
screenBG[18] = new int[] {
510,510,44,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,44,54,55,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,54,55,510,510,44,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,54,55,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,54,55,510,510,510,510,510,510,510,510,510,54,55,510,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,54,55,54,55,54,55,510,54,55,54,55,510,54,55,510,510,54,55,54,55,54,55,54,55,510,510,54,55,510,54,55,510,54,55,54,55,510,510,54,55,510,510,54,55,510,510,54,55,54,55,510,510,510,510,510,510,510,510,54,55,510,54,55,510,54,55,510,54,55,510,54,55,510,54,55,54,55,54,55,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,54,55,510,54,55,510,510,510,54,55,510,510,510,54,55,510,54,55,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,510,510,510,510,54,55,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,51,51,51,51,51,51,51,51,51,51,54,55,51,51,51,51,51,54,55,51,51,51,51,51,51,54,55,51,51,51,51,51,51,54,55,51,51,51,51,51,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,510,53,510,510,510,510,510,510,510,53,510,510,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,510,53,510,510,510,510,510,510,510,53,510,510,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,510,53,510,510,510,510,510,510,510,53,510,510,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,510,53,510,510,510,510,510,510,510,53,510,510,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,510,53,510,510,510,510,510,510,510,53,510,510,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,510,53,510,510,510,510,510,510,510,53,510,510,510,510,510,510,510,53,510,510,510,373,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,510,53,510,510,510,510,510,510,52,510,510,510,510,510,510,510,52,53,510,510,510,510,374,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,510,52,510,510,510,510,510,510,510,52,510,510,510,510,510,510,373,374,374,376,510,510,510,510,510,373,376,510,510,510,510,510,373,376,510,510,510,510,510,510,373,376,510,510,510,510,510,510,373,376,510,510,510,510,510,510,510,510,510,52,53,51,51,51,51,510,510,53,51,51,51,51,510,510,53,51,51,51,51,51,510,510,53,51,51,51,51,51,510,510,53,51,51,51,51,510,510,510,510,52,53,510,52,53,510,510,510,53,510,510,510,510,510,510,53,510,510,510,510,510,510,510,53,510,510,510,510,510,510,510,53,510,510,510,510,510,510,510,510,52,53,510,510,510,510,510,510,53,510,510,510,510,510,510,53,510,510,510,510,510,510,510,53,510,510,510,510,510,510,510,53,510,510,510,510,510,510,510,510,52,53,510,510,510,510,510,510,53,510,510,510,510,510,510,53,510,510,510,510,510,510,510,53,510,510,510,510,510,510,510,53,510,510,510,510,510,400,399,510,52,53,510,510,400,510,510,52,510,510,400,510,510,510,399,53,400,510,510,399,400,510,52,510,510,400,510,399,510,510,52,510,399,510,400,510,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[18] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[18] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[18][0] = null;
screenEnemies[18][0] = new Enemy(0,0,0,0);
screenEnemies[18][0].swx = 7;
screenEnemies[18][0].swy = 21;
screenEnemies[18][0].sdir = 0;
screenEnemies[18][0].setEnemyType(7);
screenEnemies[18][1] = null;
screenEnemies[18][1] = new Enemy(0,0,0,0);
screenEnemies[18][1].swx = 14;
screenEnemies[18][1].swy = 20;
screenEnemies[18][1].sdir = 0;
screenEnemies[18][1].setEnemyType(3);
screenEnemies[18][2] = null;
screenEnemies[18][2] = new Enemy(0,0,0,0);
screenEnemies[18][2].swx = 21;
screenEnemies[18][2].swy = 20;
screenEnemies[18][2].sdir = 0;
screenEnemies[18][2].setEnemyType(3);
screenEnemies[18][3] = null;
screenEnemies[18][3] = new Enemy(0,0,0,0);
screenEnemies[18][3].swx = 29;
screenEnemies[18][3].swy = 20;
screenEnemies[18][3].sdir = 0;
screenEnemies[18][3].setEnemyType(3);
screenEnemies[18][4] = null;
screenEnemies[18][4] = new Enemy(0,0,0,0);
screenEnemies[18][4].swx = 31;
screenEnemies[18][4].swy = 19;
screenEnemies[18][4].sdir = 0;
screenEnemies[18][4].setEnemyType(8);
screenExit[18].set(-1,19,17,-2);
 
 level8();

}

void level8() {

//----------------- SCREENDATA 19
screenBG[19] = new int[] {
54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,476,476,476,476,476,476,476,476,476,476,476,476,476,476,476,476,476,510,510,510,54,54,55,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,108,109,510,510,108,109,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,54,55,110,111,108,109,110,111,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,110,111,510,62,63,510,510,510,510,510,510,510,54,54,55,62,63,510,510,510,510,510,510,510,510,510,510,510,510,510,62,63,510,510,510,510,54,55,510,510,510,510,510,392,393,510,510,510,510,510,510,510,54,54,55,392,393,510,510,510,510,510,510,510,510,510,510,54,55,510,392,393,510,510,510,54,54,55,54,54,55,55,54,55,393,510,510,510,510,510,510,510,54,54,55,392,393,510,510,510,510,510,510,510,510,510,510,510,510,510,392,393,510,510,510,510,54,510,510,510,510,50,54,55,393,510,510,54,55,510,510,510,54,54,55,392,393,510,54,55,510,510,510,510,510,510,510,510,510,510,392,393,510,510,510,54,54,510,510,510,510,510,54,55,393,510,510,510,54,55,510,510,54,54,55,392,393,510,510,510,510,510,510,510,510,510,510,510,510,510,392,393,510,510,510,510,54,510,510,510,510,510,50,54,55,54,55,54,55,510,54,55,54,54,55,392,393,510,510,510,510,510,510,510,510,510,510,510,510,510,392,393,510,510,510,373,374,510,510,510,510,510,510,392,393,510,510,510,510,510,510,510,54,54,55,392,393,510,54,55,53,510,510,510,510,510,510,510,510,510,392,393,510,510,510,510,510,510,510,510,510,510,510,392,393,510,510,510,510,510,510,510,54,54,55,392,393,510,510,510,510,510,510,510,510,510,510,510,510,510,392,393,510,510,510,510,510,510,510,510,510,510,394,394,394,394,510,510,510,510,54,55,54,54,55,394,394,394,510,510,510,510,510,510,510,510,510,510,510,394,394,394,394,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,54,55,510,510,510,54,55,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,374,510,510,510,54,55,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,510,510,510,510,510,54,55,54,55,54,55,54,55,54,55,54,55,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,510,510,510,510,510,510,54,55,54,55,54,55,54,54,55,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,510,510,510,510,510,510,510,510,54,55,54,55,54,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,54,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,510,510,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,54,55,66,67,54,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,98,99,54,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,54,55,130,131,54,510,510,510,510,510,510,510,510,510,510,510,510,510,510,4,4,4,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[19] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[19] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,1,1,0,0,0,1,1,0,0,0,1,1,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,1,1,1,1,1,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[19][0] = null;
screenEnemies[19][0] = new Enemy(0,0,0,0);
screenEnemies[19][0].swx = 7;
screenEnemies[19][0].swy = 7;
screenEnemies[19][0].sdir = 0;
screenEnemies[19][0].setEnemyType(7);
screenEnemies[19][1] = null;
screenEnemies[19][1] = new Enemy(0,0,0,0);
screenEnemies[19][1].swx = 8;
screenEnemies[19][1].swy = 6;
screenEnemies[19][1].sdir = 0;
screenEnemies[19][1].setEnemyType(8);
screenEnemies[19][2] = null;
screenEnemies[19][2] = new Enemy(0,0,0,0);
screenEnemies[19][2].swx = 27;
screenEnemies[19][2].swy = 9;
screenEnemies[19][2].sdir = 0;
screenEnemies[19][2].setEnemyType(3);
screenEnemies[19][3] = null;
screenEnemies[19][3] = new Enemy(0,0,0,0);
screenEnemies[19][3].swx = 27;
screenEnemies[19][3].swy = 15;
screenEnemies[19][3].sdir = 0;
screenEnemies[19][3].setEnemyType(3);
screenEnemies[19][4] = null;
screenEnemies[19][4] = new Enemy(0,0,0,0);
screenEnemies[19][4].swx = 27;
screenEnemies[19][4].swy = 20;
screenEnemies[19][4].sdir = 0;
screenEnemies[19][4].setEnemyType(3);
screenExit[19].set(20,30,18,31);
//----------------- SCREENDATA 20
screenBG[20] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,401,373,373,373,373,373,402,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,373,390,391,373,390,391,373,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,392,393,373,392,393,373,510,510,510,510,510,510,510,510,510,510,510,510,44,45,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,44,510,510,373,392,393,373,392,393,373,510,510,510,510,510,510,510,510,510,510,510,510,46,47,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,394,394,373,394,394,373,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,52,373,375,376,373,374,375,376,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,374,375,376,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,373,375,376,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,52,373,374,375,376,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,373,375,376,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,52,373,375,376,373,374,375,376,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,373,374,375,376,374,375,376,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,375,376,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,52,373,374,375,376,374,375,376,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,375,376,373,374,375,376,510,510,375,376,373,374,375,376,373,374,375,376,373,374,375,376,373,374,375,376,373,374,375,376,373,374,375,376,373,374,375,376,373,374,375,376,373,374,375,376,373,374,373,374,375,376,373,374,375,376,373,374,375,376,373,374,375,376,373,374,375,376,373,374,375,376,373,374,375,376,373,374,375,376,373,374,375,376,373,374,375,376,510,373,374,375,376,373,374,375,376,379,379,379,510,510,510,510,510,510,379,379,379,379,379,379,510,510,510,510,510,510,510,510,510,510,510,379,379,379,379,379,510,510,379,373,374,375,376,379,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,379,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,379,379,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,54,55,54,55,54,55,54,55,54,55,54,55,54,55,54,55,365,365,54,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[20] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[20] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[20][0] = null;
screenEnemies[20][0] = new Enemy(0,0,0,0);
screenEnemies[20][0].swx = 0;
screenEnemies[20][0].swy = 0;
screenEnemies[20][0].sdir = 0;
screenEnemies[20][0].setEnemyType(-1);
screenEnemies[20][1] = null;
screenEnemies[20][1] = new Enemy(0,0,0,0);
screenEnemies[20][1].swx = 0;
screenEnemies[20][1].swy = 0;
screenEnemies[20][1].sdir = 0;
screenEnemies[20][1].setEnemyType(-1);
screenEnemies[20][2] = null;
screenEnemies[20][2] = new Enemy(0,0,0,0);
screenEnemies[20][2].swx = 0;
screenEnemies[20][2].swy = 0;
screenEnemies[20][2].sdir = 0;
screenEnemies[20][2].setEnemyType(-1);
screenEnemies[20][3] = null;
screenEnemies[20][3] = new Enemy(0,0,0,0);
screenEnemies[20][3].swx = 0;
screenEnemies[20][3].swy = 0;
screenEnemies[20][3].sdir = 0;
screenEnemies[20][3].setEnemyType(-1);
screenEnemies[20][4] = null;
screenEnemies[20][4] = new Enemy(0,0,0,0);
screenEnemies[20][4].swx = 25;
screenEnemies[20][4].swy = 26;
screenEnemies[20][4].sdir = 0;
screenEnemies[20][4].setEnemyType(5);
screenExit[20].set(-2,25,-1,-1);
//----------------- SCREENDATA 21
screenBG[21] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,45,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,46,47,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,108,109,510,510,510,510,510,510,510,510,112,113,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,110,111,510,510,510,510,510,510,510,510,114,115,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,10,7,6,9,12,6,9,12,510,510,10,9,9,7,6,9,9,20,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,6,12,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,10,9,20,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,10,9,20,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,10,9,20,510,510,510,510,510,510,510,510,510,10,12,6,12,20,510,510,510,510,510,10,12,6,12,20,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,6,7,6,9,12,510,510,510,510,510,6,7,6,9,12,510,510,510,510,510,510,510,10,9,20,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,5,6,7,6,20,510,510,510,510,510,5,6,7,6,20,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,10,12,6,12,20,6,7,6,9,12,10,12,6,12,20,20,9,6,9,12,10,12,6,12,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,6,7,6,9,12,10,12,6,12,20,6,7,6,9,12,10,12,6,12,20,6,7,6,9,12,10,12,6,12,510,6,7,6,9,12,5,510,11,6,20,5,6,7,6,20,6,7,6,9,12,5,6,7,6,20,12,510,510,510,510,5,6,7,6,20,7,510,510,510,510,10,510,510,510,510,510,510,510,510,510,6,7,6,9,12,5,6,7,6,20,6,7,6,9,12,510,510,112,113,510,6,7,20,510,510,256,257,510,510,510,510,510,510,510,510,510,510,510,510,510,10,12,6,12,20,6,7,6,9,12,10,12,6,12,20,510,510,114,115,510,510,12,6,12,20,288,289,510,510,510,5,510,510,510,510,510,510,510,510,510,6,7,6,9,12,10,12,6,12,20,6,7,6,9,12,510,510,510,510,510,510,7,6,9,12,320,321,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[21] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,11,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,5,11,7,11,20,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,6,7,6,9,12,510,510,11,12,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,10,12,11,12,20,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,12,510,510,510,6,5,6,7,6,20,7,6,9,9,12,10,12,6,12,20,9,7,6,9,12,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,20,510,510,510,10,7,7,20,510,510,11,7,6,9,12,6,7,6,9,12,10,12,6,12,20,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,5,6,6,12,20,5,6,7,6,20,5,6,7,11,20,6,7,6,9,12,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,6,6,12,9,6,7,5,6,9,510,6,7,6,9,12,20,7,6,9,12,5,6,7,6,20,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[21] = new int[] {
1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[21][0] = null;
screenEnemies[21][0] = new Enemy(0,0,0,0);
screenEnemies[21][0].swx = 7;
screenEnemies[21][0].swy = 6;
screenEnemies[21][0].sdir = 0;
screenEnemies[21][0].setEnemyType(6);
screenEnemies[21][1] = null;
screenEnemies[21][1] = new Enemy(0,0,0,0);
screenEnemies[21][1].swx = 34;
screenEnemies[21][1].swy = 21;
screenEnemies[21][1].sdir = 0;
screenEnemies[21][1].setEnemyType(2);
screenEnemies[21][2] = null;
screenEnemies[21][2] = new Enemy(0,0,0,0);
screenEnemies[21][2].swx = 0;
screenEnemies[21][2].swy = 0;
screenEnemies[21][2].sdir = 0;
screenEnemies[21][2].setEnemyType(-1);
screenEnemies[21][3] = null;
screenEnemies[21][3] = new Enemy(0,0,0,0);
screenEnemies[21][3].swx = 0;
screenEnemies[21][3].swy = 0;
screenEnemies[21][3].sdir = 0;
screenEnemies[21][3].setEnemyType(-1);
screenEnemies[21][4] = null;
screenEnemies[21][4] = new Enemy(0,0,0,0);
screenEnemies[21][4].swx = 0;
screenEnemies[21][4].swy = 0;
screenEnemies[21][4].sdir = 0;
screenEnemies[21][4].setEnemyType(-1);
screenExit[21].set(-1,22,29,-1);

level9();
}

void level9() {
//----------------- SCREENDATA 22
screenBG[22] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,6,7,6,12,20,510,510,510,409,410,510,510,510,510,409,409,510,510,510,510,410,409,510,510,5,510,44,510,510,510,510,510,510,510,510,510,44,510,510,510,5,6,7,6,12,510,510,510,410,409,510,510,510,510,409,410,510,510,510,510,409,409,510,510,5,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,6,7,6,7,12,510,510,510,510,510,510,510,510,510,108,109,510,510,510,510,510,510,510,510,5,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,10,12,6,9,20,510,510,510,510,510,510,510,510,510,110,111,510,510,510,510,510,510,510,510,5,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,6,7,6,12,12,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,407,510,510,510,5,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,5,6,7,6,20,365,365,365,365,365,365,365,365,365,365,365,365,365,365,365,365,510,510,510,5,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,6,7,6,9,12,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,5,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,10,12,6,9,20,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,5,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,6,7,6,12,12,510,510,379,379,510,510,510,510,510,410,409,510,510,510,510,409,409,510,510,5,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,5,6,7,6,20,510,510,510,510,510,510,510,510,510,409,409,510,510,510,510,409,410,510,510,5,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,6,7,6,9,12,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,5,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,10,12,6,9,20,510,510,379,379,510,510,510,510,510,108,109,510,510,510,510,510,510,510,510,5,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,6,7,6,12,12,510,510,510,510,510,510,510,510,510,110,111,510,510,510,510,510,510,510,510,5,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,5,6,7,6,20,510,510,510,510,510,399,510,510,510,510,510,510,510,510,510,510,510,510,510,5,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,6,7,6,9,12,510,510,510,510,510,365,365,365,365,365,365,365,365,365,365,365,365,365,365,5,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,10,12,6,9,20,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,5,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,6,7,6,12,12,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,5,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,5,6,7,6,20,510,510,510,409,409,510,510,510,510,409,410,510,510,510,510,510,379,379,510,5,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,410,409,510,510,510,510,409,409,510,510,510,510,510,510,510,510,5,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,5,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,379,379,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,22,23,510,22,23,510,22,23,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,24,25,510,24,25,510,24,25,510,510,510,510,510,510,510,510,510,6,7,6,12,10,12,12,20,6,7,6,9,12,5,6,7,6,20,6,7,6,9,12,6,7,6,9,12,10,12,6,12,12,510,510,510,510,510,510,510,10,12,6,12,20,6,7,9,12,5,6,7,20,6,7,6,9,12,10,12,6,12,20,5,6,7,6,20,5,6,7,6,6,7,510,510,510,510,510,510,6,7,6,12,5,6,6,7,6,20,6,7,6,9,12,10,12,6,12,20,6,7,6,20,6,9,7,6,7,6,12,6,7,6,12,510,510,510,510,510,7,6,12,7,6,7,6,7,6,20,12,6,7,6,7,6,12,20,10,6,12,6,7,6,12,10,12,7,6,7,6,9,12,9,7,6,20,6,7,6,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[22] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,12,12,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,5,6,7,6,20,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,52,52,52,52,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,52,52,52,52,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,52,52,52,52,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,52,52,52,52,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,52,52,52,52,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[22] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[22][0] = null;
screenEnemies[22][0] = new Enemy(0,0,0,0);
screenEnemies[22][0].swx = 22;
screenEnemies[22][0].swy = 4;
screenEnemies[22][0].sdir = 0;
screenEnemies[22][0].setEnemyType(5);
screenEnemies[22][1] = null;
screenEnemies[22][1] = new Enemy(0,0,0,0);
screenEnemies[22][1].swx = 36;
screenEnemies[22][1].swy = 13;
screenEnemies[22][1].sdir = 0;
screenEnemies[22][1].setEnemyType(5);
screenEnemies[22][2] = null;
screenEnemies[22][2] = new Enemy(0,0,0,0);
screenEnemies[22][2].swx = 0;
screenEnemies[22][2].swy = 0;
screenEnemies[22][2].sdir = 0;
screenEnemies[22][2].setEnemyType(-1);
screenEnemies[22][3] = null;
screenEnemies[22][3] = new Enemy(0,0,0,0);
screenEnemies[22][3].swx = 0;
screenEnemies[22][3].swy = 0;
screenEnemies[22][3].sdir = 0;
screenEnemies[22][3].setEnemyType(-1);
screenEnemies[22][4] = null;
screenEnemies[22][4] = new Enemy(0,0,0,0);
screenEnemies[22][4].swx = 0;
screenEnemies[22][4].swy = 0;
screenEnemies[22][4].sdir = 0;
screenEnemies[22][4].setEnemyType(-1);
screenExit[22].set(-1,23,21,-1);

//----------------- SCREENDATA 23
screenBG[23] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,414,510,64,65,66,67,68,69,510,510,64,65,66,67,68,69,510,510,414,510,510,510,510,510,510,510,510,401,402,510,510,510,510,510,510,510,510,510,510,510,414,510,96,97,98,99,100,101,510,510,96,97,98,99,100,101,510,510,414,510,510,510,510,510,510,510,510,403,404,510,510,510,510,510,510,510,510,510,510,76,77,510,128,129,130,131,132,133,510,510,128,129,130,131,132,133,510,76,77,510,510,510,510,510,510,510,510,403,404,510,510,510,510,510,510,510,510,510,510,78,79,510,160,161,162,163,164,165,510,510,160,161,162,163,164,165,510,78,79,510,510,510,510,510,510,510,510,403,404,510,510,510,510,510,510,510,510,510,510,510,510,510,192,193,194,195,196,197,510,510,192,193,194,195,196,197,510,510,510,510,510,510,510,510,510,510,510,403,404,510,510,510,510,510,510,510,510,510,510,510,510,510,224,225,226,227,228,229,510,510,224,225,226,227,228,229,510,510,510,510,510,510,510,510,510,510,510,403,404,510,510,510,510,510,510,510,510,510,70,71,72,73,74,75,510,510,70,71,72,73,74,75,510,510,70,71,72,73,74,75,510,510,510,510,510,510,510,403,404,510,510,510,510,510,510,510,510,510,102,103,104,105,106,107,510,510,102,103,104,105,106,107,510,510,102,103,104,105,106,107,108,109,510,108,109,510,510,403,404,510,510,510,510,510,510,510,510,510,134,135,136,137,138,139,510,510,134,135,136,137,138,139,510,510,134,135,136,137,138,139,110,111,510,110,111,510,510,403,404,510,510,510,510,510,510,510,510,510,166,167,168,169,170,171,510,510,166,167,168,169,170,171,510,510,166,167,168,169,170,171,377,378,378,379,378,380,510,403,404,510,112,113,510,510,510,510,510,510,198,199,200,201,202,203,510,510,198,199,200,201,202,203,377,380,198,199,200,201,202,203,510,510,510,510,510,510,510,403,404,510,114,115,510,510,510,377,379,380,230,231,232,233,234,377,379,379,380,231,232,233,234,235,510,510,230,231,232,233,234,235,510,510,510,510,510,510,510,403,404,510,373,375,376,510,64,65,66,67,68,69,510,510,70,71,72,73,74,75,510,510,70,71,72,73,74,75,510,510,64,65,66,67,68,69,510,510,510,403,404,510,377,379,380,510,96,97,98,99,100,101,510,510,102,103,104,105,106,107,510,510,102,103,104,105,106,107,510,510,96,97,98,99,100,101,510,510,510,403,404,510,510,510,510,510,128,129,130,131,132,133,510,510,134,135,136,137,138,139,510,510,134,135,136,137,138,139,510,510,128,129,130,131,132,133,510,510,510,403,404,510,510,510,510,377,379,380,162,163,164,165,510,510,166,167,168,169,170,171,510,510,166,167,168,169,170,171,510,510,160,161,162,163,164,165,510,510,510,403,404,510,510,510,510,510,192,193,194,195,196,197,510,510,198,199,200,201,202,203,510,510,198,199,200,201,202,203,510,510,192,193,194,195,196,197,510,510,510,403,404,510,510,510,510,510,224,225,226,227,228,377,379,380,230,231,232,233,234,235,510,510,230,231,232,233,234,235,510,510,224,225,226,227,228,229,510,510,510,403,404,510,64,65,66,67,68,69,510,510,64,65,66,67,68,69,510,510,70,377,379,380,74,75,510,510,64,65,66,67,68,69,377,378,379,380,66,67,68,403,404,510,96,97,98,99,100,101,510,510,96,97,98,99,100,101,510,510,102,103,104,105,106,107,510,510,96,97,98,99,100,101,510,510,96,97,98,99,100,403,404,510,128,129,130,131,132,133,420,421,128,129,130,131,132,133,510,510,134,135,136,137,138,139,510,510,377,378,379,380,132,133,510,510,128,129,130,131,132,403,404,510,160,161,162,163,164,165,94,95,160,161,162,163,164,165,510,510,166,167,168,169,170,171,510,510,160,161,162,163,164,165,510,510,160,161,162,163,164,403,404,510,192,193,194,195,196,197,510,510,192,193,194,195,196,197,401,402,198,199,200,201,202,203,401,402,192,193,194,195,196,197,510,510,192,193,194,195,196,403,404,510,224,225,226,227,228,377,378,379,380,225,226,227,228,229,403,404,230,231,232,233,234,235,403,404,224,225,226,227,228,377,378,379,380,225,226,227,228,403,404,510,510,510,510,510,510,510,510,510,510,510,510,377,379,380,403,404,377,378,379,379,379,380,403,404,377,379,380,510,510,510,397,510,510,510,510,510,510,403,404,510,510,510,510,510,510,510,510,510,510,510,510,510,397,510,403,404,510,510,510,510,510,510,403,404,510,510,510,510,510,510,397,510,510,510,510,510,510,403,404,377,380,510,510,510,510,510,510,510,510,510,510,510,397,510,405,406,510,510,399,400,510,510,405,406,510,510,510,510,510,510,397,510,510,510,510,510,510,405,406,13,14,13,14,13,14,13,14,13,14,13,14,13,14,13,14,13,14,13,14,13,14,13,14,13,14,13,14,13,14,13,14,13,14,13,14,13,14,13,14,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[23] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[23] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[23][0] = null;
screenEnemies[23][0] = new Enemy(0,0,0,0);
screenEnemies[23][0].swx = 0;
screenEnemies[23][0].swy = 0;
screenEnemies[23][0].sdir = 0;
screenEnemies[23][0].setEnemyType(-1);
screenEnemies[23][1] = null;
screenEnemies[23][1] = new Enemy(0,0,0,0);
screenEnemies[23][1].swx = 0;
screenEnemies[23][1].swy = 0;
screenEnemies[23][1].sdir = 0;
screenEnemies[23][1].setEnemyType(-1);
screenEnemies[23][2] = null;
screenEnemies[23][2] = new Enemy(0,0,0,0);
screenEnemies[23][2].swx = 0;
screenEnemies[23][2].swy = 0;
screenEnemies[23][2].sdir = 0;
screenEnemies[23][2].setEnemyType(-1);
screenEnemies[23][3] = null;
screenEnemies[23][3] = new Enemy(0,0,0,0);
screenEnemies[23][3].swx = 0;
screenEnemies[23][3].swy = 0;
screenEnemies[23][3].sdir = 0;
screenEnemies[23][3].setEnemyType(-1);
screenEnemies[23][4] = null;
screenEnemies[23][4] = new Enemy(0,0,0,0);
screenEnemies[23][4].swx = 0;
screenEnemies[23][4].swy = 0;
screenEnemies[23][4].sdir = 0;
screenEnemies[23][4].setEnemyType(-1);
screenExit[23].set(-1,24,22,-2);
//----------------- SCREENDATA 24
screenBG[24] = new int[] {
510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,377,378,379,380,377,378,379,380,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,377,378,379,380,510,510,510,510,510,510,510,510,377,378,379,380,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,377,378,379,380,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,377,378,379,380,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,377,378,379,380,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,377,378,379,380,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,377,378,379,380,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,377,378,379,380,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[24] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[24] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[24][0] = null;
screenEnemies[24][0] = new Enemy(0,0,0,0);
screenEnemies[24][0].swx = 23;
screenEnemies[24][0].swy = 25;
screenEnemies[24][0].sdir = 0;
screenEnemies[24][0].setEnemyType(6);
screenEnemies[24][1] = null;
screenEnemies[24][1] = new Enemy(0,0,0,0);
screenEnemies[24][1].swx = 30;
screenEnemies[24][1].swy = 22;
screenEnemies[24][1].sdir = 0;
screenEnemies[24][1].setEnemyType(4);
screenEnemies[24][2] = null;
screenEnemies[24][2] = new Enemy(0,0,0,0);
screenEnemies[24][2].swx = 25;
screenEnemies[24][2].swy = 23;
screenEnemies[24][2].sdir = 0;
screenEnemies[24][2].setEnemyType(8);
screenEnemies[24][3] = null;
screenEnemies[24][3] = new Enemy(0,0,0,0);
screenEnemies[24][3].swx = 13;
screenEnemies[24][3].swy = 26;
screenEnemies[24][3].sdir = 0;
screenEnemies[24][3].setEnemyType(7);
screenEnemies[24][4] = null;
screenEnemies[24][4] = new Enemy(0,0,0,0);
screenEnemies[24][4].swx = 31;
screenEnemies[24][4].swy = 26;
screenEnemies[24][4].sdir = 0;
screenEnemies[24][4].setEnemyType(6);
screenExit[24].set(-1,33,23,-2);

level10();
}

void level10() {
//----------------- SCREENDATA 25
screenBG[25] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,45,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,44,510,510,510,46,47,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,50,50,373,374,375,376,373,374,375,376,375,374,376,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,510,510,379,379,373,374,375,376,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,50,50,510,510,510,510,510,510,510,379,373,374,375,376,375,376,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,373,374,375,376,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,379,373,374,375,376,510,510,510,510,510,510,373,374,375,376,373,374,375,376,373,374,375,376,378,378,379,379,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,379,378,510,510,510,510,373,374,375,376,373,374,375,376,373,374,375,376,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,373,374,375,376,373,374,375,376,378,378,379,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,375,376,373,374,375,376,373,374,375,376,379,510,510,510,510,510,510,510,108,109,510,510,510,510,510,510,108,109,510,510,510,510,510,510,510,510,510,510,379,378,378,378,379,379,379,510,510,510,510,510,510,510,510,510,108,109,510,510,110,111,510,510,108,109,510,510,110,111,510,510,510,510,510,510,510,108,109,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,110,111,510,510,510,510,510,510,110,111,510,510,510,510,510,510,510,510,510,510,510,110,111,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,54,55,510,510,54,55,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,54,55,54,55,54,55,54,55,54,55,54,55,54,55,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[25] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[25] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[25][0] = null;
screenEnemies[25][0] = new Enemy(0,0,0,0);
screenEnemies[25][0].swx = 0;
screenEnemies[25][0].swy = 0;
screenEnemies[25][0].sdir = 0;
screenEnemies[25][0].setEnemyType(-1);
screenEnemies[25][1] = null;
screenEnemies[25][1] = new Enemy(0,0,0,0);
screenEnemies[25][1].swx = 0;
screenEnemies[25][1].swy = 0;
screenEnemies[25][1].sdir = 0;
screenEnemies[25][1].setEnemyType(-1);
screenEnemies[25][2] = null;
screenEnemies[25][2] = new Enemy(0,0,0,0);
screenEnemies[25][2].swx = 0;
screenEnemies[25][2].swy = 0;
screenEnemies[25][2].sdir = 0;
screenEnemies[25][2].setEnemyType(-1);
screenEnemies[25][3] = null;
screenEnemies[25][3] = new Enemy(0,0,0,0);
screenEnemies[25][3].swx = 0;
screenEnemies[25][3].swy = 0;
screenEnemies[25][3].sdir = 0;
screenEnemies[25][3].setEnemyType(-1);
screenEnemies[25][4] = null;
screenEnemies[25][4] = new Enemy(0,0,0,0);
screenEnemies[25][4].swx = 0;
screenEnemies[25][4].swy = 0;
screenEnemies[25][4].sdir = 0;
screenEnemies[25][4].setEnemyType(-1);
screenExit[25].set(0,26,20,-2);
//----------------- SCREENDATA 26
screenBG[26] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,45,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,46,47,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,44,510,510,510,44,510,510,510,510,44,510,510,510,510,510,510,510,44,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,373,374,375,376,50,373,374,375,376,50,373,374,375,376,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,44,373,374,375,376,373,374,375,373,374,375,376,374,375,376,373,374,375,376,50,510,510,510,510,510,510,44,510,510,510,510,510,50,510,50,50,510,510,510,50,373,374,375,376,373,374,375,376,373,374,375,373,374,375,376,374,375,376,373,374,375,376,53,510,510,510,510,510,510,510,373,373,374,375,376,373,374,375,376,373,374,375,376,373,374,375,373,374,375,376,510,510,373,374,375,376,373,374,375,376,373,374,375,376,510,510,510,510,510,510,373,374,375,376,373,374,375,376,373,374,375,376,378,378,379,510,510,510,510,510,510,510,510,379,379,373,374,375,376,373,374,375,376,373,374,375,376,53,510,510,373,373,374,375,376,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,373,374,375,376,50,50,510,510,510,510,373,374,375,376,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,379,378,373,374,375,376,373,374,375,376,53,510,510,379,378,378,378,378,379,379,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,54,55,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,55,510,510,510,44,510,510,510,510,510,510,510,510,510,54,55,54,55,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,54,55,510,510,510,510,510,510,510,510,510,510,54,55,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,55,510,510,510,510,510,510,510,510,510,54,55,54,55,54,55,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,55,510,510,54,55,54,55,54,55,54,55,54,55,54,55,54,55,510,510,510,108,109,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,374,375,376,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,110,111,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,373,374,375,376,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[26] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[26] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,1,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[26][0] = null;
screenEnemies[26][0] = new Enemy(0,0,0,0);
screenEnemies[26][0].swx = 0;
screenEnemies[26][0].swy = 0;
screenEnemies[26][0].sdir = 0;
screenEnemies[26][0].setEnemyType(-1);
screenEnemies[26][1] = null;
screenEnemies[26][1] = new Enemy(0,0,0,0);
screenEnemies[26][1].swx = 0;
screenEnemies[26][1].swy = 0;
screenEnemies[26][1].sdir = 0;
screenEnemies[26][1].setEnemyType(-1);
screenEnemies[26][2] = null;
screenEnemies[26][2] = new Enemy(0,0,0,0);
screenEnemies[26][2].swx = 0;
screenEnemies[26][2].swy = 0;
screenEnemies[26][2].sdir = 0;
screenEnemies[26][2].setEnemyType(-1);
screenEnemies[26][3] = null;
screenEnemies[26][3] = new Enemy(0,0,0,0);
screenEnemies[26][3].swx = 0;
screenEnemies[26][3].swy = 0;
screenEnemies[26][3].sdir = 0;
screenEnemies[26][3].setEnemyType(-1);
screenEnemies[26][4] = null;
screenEnemies[26][4] = new Enemy(0,0,0,0);
screenEnemies[26][4].swx = 0;
screenEnemies[26][4].swy = 0;
screenEnemies[26][4].sdir = 0;
screenEnemies[26][4].setEnemyType(-1);
screenExit[26].set(0,-1,25,27);
//----------------- SCREENDATA 27
screenBG[27] = new int[] {
54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,55,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,44,55,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,510,54,55,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,55,55,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,510,54,55,510,510,510,510,510,510,510,54,55,510,510,510,50,510,510,510,510,510,510,50,510,510,510,510,510,510,510,510,510,510,373,374,375,376,54,55,510,510,55,55,510,510,510,54,55,54,55,510,510,510,510,510,50,510,510,510,510,510,510,50,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,44,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,50,4,4,4,4,4,4,50,510,510,510,510,510,510,510,510,510,510,373,374,375,376,54,55,510,510,55,55,510,510,510,510,510,510,510,510,510,510,510,510,50,50,50,50,50,50,50,50,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,54,55,510,510,55,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,510,44,54,55,510,55,510,510,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,54,55,44,510,55,55,510,510,510,510,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,54,55,510,54,55,4,4,4,4,50,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,373,374,375,376,510,510,55,55,50,50,50,50,50,50,510,510,510,510,510,510,50,510,510,510,510,510,510,510,50,510,510,510,510,510,510,510,510,510,510,50,510,373,374,375,376,510,54,55,510,510,510,510,510,50,510,510,510,510,510,510,50,510,510,510,510,510,510,510,50,510,510,510,510,510,510,510,510,510,510,50,373,374,375,376,510,44,55,55,510,510,510,510,510,50,4,4,4,4,4,4,50,510,510,510,510,510,510,510,50,4,4,4,4,4,4,4,4,4,4,50,510,373,374,375,376,510,54,55,510,510,510,510,510,50,50,50,50,50,50,50,50,510,510,54,55,510,510,510,50,50,50,50,50,50,50,50,50,50,50,50,373,374,375,376,510,510,55,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,44,55,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,510,55,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,44,510,55,55,510,510,510,510,510,510,510,510,510,510,50,50,50,510,510,510,510,510,510,510,50,50,50,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,54,55,510,510,510,510,510,510,510,510,510,510,510,50,510,510,510,510,510,510,510,510,510,50,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,44,55,55,510,510,510,510,51,510,51,510,510,510,510,50,4,4,4,4,4,4,4,4,4,50,510,510,51,510,51,510,510,510,510,510,510,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[27] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[27] = new int[] {
1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,1,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,0,0,0,1,1,1,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,1,1,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[27][0] = null;
screenEnemies[27][0] = new Enemy(0,0,0,0);
screenEnemies[27][0].swx = 14;
screenEnemies[27][0].swy = 20;
screenEnemies[27][0].sdir = 0;
screenEnemies[27][0].setEnemyType(6);
screenEnemies[27][1] = null;
screenEnemies[27][1] = new Enemy(0,0,0,0);
screenEnemies[27][1].swx = 11;
screenEnemies[27][1].swy = 10;
screenEnemies[27][1].sdir = 0;
screenEnemies[27][1].setEnemyType(3);
screenEnemies[27][2] = null;
screenEnemies[27][2] = new Enemy(0,0,0,0);
screenEnemies[27][2].swx = 12;
screenEnemies[27][2].swy = 6;
screenEnemies[27][2].sdir = 0;
screenEnemies[27][2].setEnemyType(-1);
screenEnemies[27][3] = null;
screenEnemies[27][3] = new Enemy(0,0,0,0);
screenEnemies[27][3].swx = 26;
screenEnemies[27][3].swy = 20;
screenEnemies[27][3].sdir = 0;
screenEnemies[27][3].setEnemyType(6);
screenEnemies[27][4] = null;
screenEnemies[27][4] = new Enemy(0,0,0,0);
screenEnemies[27][4].swx = 3;
screenEnemies[27][4].swy = 20;
screenEnemies[27][4].sdir = 0;
screenEnemies[27][4].setEnemyType(6);
screenExit[27].set(-1,-1,-1,28);


level11();
}

void level11() {
//----------------- SCREENDATA 28
screenBG[28] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,50,50,50,50,50,50,50,50,50,50,50,510,510,510,510,510,510,510,510,510,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,510,510,510,510,54,55,510,510,54,55,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,54,55,510,510,510,373,374,375,376,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,54,55,510,510,373,374,375,376,510,510,4,4,4,4,4,4,4,4,4,4,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,4,4,4,4,4,4,4,4,373,374,375,376,510,510,510,365,365,365,365,365,365,365,365,54,55,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,54,55,365,365,365,365,365,365,34,36,16,17,2,2,5,510,510,510,510,510,510,510,52,54,55,510,510,51,510,510,510,510,510,510,51,510,510,510,510,510,54,55,53,510,510,510,510,510,510,34,36,16,16,16,5,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,36,36,16,5,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,51,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,34,36,5,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,53,510,510,510,510,510,510,510,510,5,6,9,20,510,510,510,510,510,510,510,510,54,55,510,510,510,51,510,510,510,510,510,510,510,510,51,510,510,54,55,510,510,510,510,510,510,510,510,510,5,6,7,20,510,510,510,510,510,510,510,52,54,55,510,510,510,510,510,510,510,510,510,510,51,510,510,510,510,54,55,53,510,510,510,510,510,510,510,510,5,6,12,20,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,53,510,510,510,510,510,510,510,510,5,7,9,20,510,510,510,510,510,510,510,510,54,55,510,51,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,53,510,510,510,510,510,510,510,510,5,12,12,20,510,510,510,510,510,510,510,52,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,5,12,12,20,510,510,510,510,510,510,510,52,54,55,510,510,510,510,510,51,510,510,510,510,510,510,510,510,51,54,55,510,510,510,510,510,510,510,510,510,5,7,12,20,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,51,510,510,510,510,510,54,55,53,510,510,510,510,510,510,510,510,5,6,5,20,510,510,510,510,510,510,510,510,54,55,510,51,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,5,7,12,20,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,51,510,54,55,510,510,510,510,510,510,510,510,510,5,12,12,20,510,510,510,510,510,510,510,52,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,5,12,9,20,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,51,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,5,9,7,20,510,510,510,510,510,510,510,510,54,55,510,510,51,510,510,510,510,510,510,510,510,510,51,510,510,54,55,510,510,510,510,510,510,510,510,510,5,9,12,20,510,510,510,510,510,510,510,52,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,53,510,510,510,510,510,510,510,510,5,7,9,20,510,510,510,510,510,510,510,52,54,55,510,510,510,510,510,510,510,510,510,510,51,510,510,510,510,54,55,53,510,510,510,510,510,510,510,510,5,7,12,20,510,510,510,510,510,510,510,510,54,55,510,510,510,510,51,510,510,510,510,510,510,510,510,510,510,54,55,53,510,510,510,510,510,510,510,510,5,6,9,20,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[28] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[28] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,1,1,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};

screenEnemies[28][0] = null;
screenEnemies[28][0] = new Enemy(0,0,0,0);
screenEnemies[28][0].swx = 10;
screenEnemies[28][0].swy = 10;
screenEnemies[28][0].sdir = 0;
screenEnemies[28][0].setEnemyType(6);
screenEnemies[28][1] = null;
screenEnemies[28][1] = new Enemy(0,0,0,0);
screenEnemies[28][1].swx = 22;
screenEnemies[28][1].swy = 22;
screenEnemies[28][1].sdir = 0;
screenEnemies[28][1].setEnemyType(6);
screenEnemies[28][2] = null;
screenEnemies[28][2] = new Enemy(0,0,0,0);
screenEnemies[28][2].swx = 19;
screenEnemies[28][2].swy = 19;
screenEnemies[28][2].sdir = 0;
screenEnemies[28][2].setEnemyType(6);
screenEnemies[28][3] = null;
screenEnemies[28][3] = new Enemy(0,0,0,0);
screenEnemies[28][3].swx = 16;
screenEnemies[28][3].swy = 16;
screenEnemies[28][3].sdir = 0;
screenEnemies[28][3].setEnemyType(6);
screenEnemies[28][4] = null;
screenEnemies[28][4] = new Enemy(0,0,0,0);
screenEnemies[28][4].swx = 13;
screenEnemies[28][4].swy = 13;
screenEnemies[28][4].sdir = 0;
screenEnemies[28][4].setEnemyType(6);
screenExit[28].set(-1,-1,-1,29);

//----------------- SCREENDATA 29
screenBG[29] = new int[] {
510,510,510,510,510,510,510,510,54,55,510,51,510,510,510,510,510,510,510,510,510,510,510,51,510,54,55,510,510,510,510,510,510,510,510,5,6,7,10,20,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,51,510,5,6,10,7,20,510,51,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,51,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,5,10,7,7,20,510,510,510,510,510,510,510,510,510,510,54,55,510,54,55,510,510,510,510,510,54,55,510,54,55,510,510,510,510,510,510,510,510,510,510,5,6,7,10,20,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,5,6,10,7,20,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,5,10,10,7,20,510,510,510,510,510,510,510,51,510,510,510,510,510,510,510,510,50,510,510,510,510,510,510,510,510,51,510,510,510,510,510,510,510,51,510,5,6,7,10,20,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,5,6,10,7,20,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,5,6,7,10,20,510,51,510,510,510,510,510,510,510,510,51,510,510,510,510,510,510,510,510,51,510,510,510,51,510,510,510,510,510,510,510,510,510,510,510,5,6,10,7,20,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,51,510,510,510,510,5,6,7,7,20,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,51,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,5,10,7,10,20,50,50,50,50,50,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,5,10,7,7,20,50,510,510,510,510,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,5,6,7,10,20,50,510,510,510,510,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,51,510,510,510,510,510,510,51,510,510,5,6,10,10,20,50,4,4,4,4,50,510,510,51,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,377,379,510,510,510,50,50,50,50,50,50,510,510,510,510,510,510,50,50,50,50,510,510,510,51,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,377,380,44,510,44,510,510,510,510,510,50,510,510,510,510,510,510,50,510,510,50,510,510,510,510,510,510,510,50,510,510,510,510,510,510,510,510,510,510,510,377,379,510,510,510,510,510,510,510,510,50,510,510,510,510,510,510,50,50,50,50,510,510,510,510,510,510,510,510,510,510,510,51,510,510,510,510,50,50,510,377,510,510,44,510,510,510,510,510,510,50,510,510,510,510,510,510,50,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,377,379,44,510,510,510,510,510,510,510,50,4,4,4,4,4,4,50,50,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,50,510,377,380,510,510,510,510,510,510,510,510,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,510,377,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,5,6,10,7,20,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,5,6,7,10,20,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,5,6,7,7,20,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,5,10,7,7,20,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,5,6,7,10,20,410,410,411,410,410,410,410,410,410,410,410,410,410,410,411,410,410,410,410,410,410,410,410,410,410,410,410,410,410,411,410,410,410,50,411,5,6,10,7,20,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,6,510,510,20,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[29] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[29] = new int[] {
0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,0,0,0,0,0,1,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[29][0] = null;
screenEnemies[29][0] = new Enemy(0,0,0,0);
screenEnemies[29][0].swx = 0;
screenEnemies[29][0].swy = 0;
screenEnemies[29][0].sdir = 0;
screenEnemies[29][0].setEnemyType(-1);
screenEnemies[29][1] = null;
screenEnemies[29][1] = new Enemy(0,0,0,0);
screenEnemies[29][1].swx = 0;
screenEnemies[29][1].swy = 0;
screenEnemies[29][1].sdir = 0;
screenEnemies[29][1].setEnemyType(-1);
screenEnemies[29][2] = null;
screenEnemies[29][2] = new Enemy(0,0,0,0);
screenEnemies[29][2].swx = 0;
screenEnemies[29][2].swy = 0;
screenEnemies[29][2].sdir = 0;
screenEnemies[29][2].setEnemyType(-1);
screenEnemies[29][3] = null;
screenEnemies[29][3] = new Enemy(0,0,0,0);
screenEnemies[29][3].swx = 0;
screenEnemies[29][3].swy = 0;
screenEnemies[29][3].sdir = 0;
screenEnemies[29][3].setEnemyType(-1);
screenEnemies[29][4] = null;
screenEnemies[29][4] = new Enemy(0,0,0,0);
screenEnemies[29][4].swx = 0;
screenEnemies[29][4].swy = 0;
screenEnemies[29][4].sdir = 0;
screenEnemies[29][4].setEnemyType(-1);
screenExit[29].set(-1,21,32,-2);
//----------------- SCREENDATA 30
screenBG[30] = new int[] {
510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,508,509,510,510,510,426,427,509,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,64,65,66,67,68,69,510,510,510,510,426,427,510,510,52,53,510,64,65,66,67,68,69,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,96,97,98,99,100,101,508,509,510,510,52,53,510,510,52,53,510,96,97,98,99,100,101,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,128,129,130,131,132,133,426,427,510,510,52,53,510,510,52,53,510,128,129,130,131,132,133,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,160,161,162,163,164,165,52,53,510,510,52,53,510,510,52,53,510,160,161,162,163,164,165,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,192,193,194,195,196,197,52,53,510,510,52,53,510,510,52,53,510,192,193,194,195,196,197,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,224,225,226,227,228,229,52,53,510,510,52,53,510,510,52,53,510,224,225,226,227,228,229,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,426,427,510,52,53,510,510,52,53,510,510,52,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,52,53,510,52,53,510,510,52,53,510,510,52,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,375,376,510,510,510,510,508,426,427,510,508,52,53,510,52,53,510,510,52,53,510,510,52,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,52,53,510,510,52,53,510,52,53,510,510,52,53,510,510,52,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,52,53,510,510,52,53,508,52,53,510,510,52,53,510,510,52,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,52,53,510,510,52,53,508,52,53,50,510,52,53,510,510,52,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,52,53,510,510,52,53,508,52,53,510,510,52,53,510,510,52,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,52,53,510,510,52,53,510,52,53,510,510,52,53,510,510,52,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,52,53,510,510,52,53,50,52,53,510,510,52,53,510,510,52,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,52,53,510,510,52,53,510,52,53,510,510,52,53,510,510,52,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,52,53,510,510,52,53,510,52,53,510,510,52,53,510,510,52,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,375,376,510,510,510,50,510,52,53,50,510,52,53,510,80,81,510,510,52,53,510,510,52,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,52,53,510,510,52,53,510,82,83,510,510,52,53,510,510,52,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,52,53,510,510,52,53,510,510,510,510,510,52,53,510,510,80,81,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,508,80,81,510,510,52,53,510,510,510,510,510,80,81,510,510,82,83,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,508,82,83,508,509,52,53,510,510,510,508,508,82,83,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,508,509,510,508,509,52,53,510,510,510,510,508,509,509,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,52,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,508,80,81,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,51,51,51,54,55,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,508,82,83,510,510,510,510,510,510,510,510,510,510,510,510,54,55,55,510,510,510,54,54,55,510,510,510,510,510,510,510,54,55,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,54,55,51,510,51,54,55,4,4,4,4,4,4,4,510,510,510,510,510,510,4,4,4,4,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[30] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[30] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1,1,0,0,0,0,0,0,1,0,0,1,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,1,1,1,0,0,0,0,0,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[30][0] = null;
screenEnemies[30][0] = new Enemy(0,0,0,0);
screenEnemies[30][0].swx = 7;
screenEnemies[30][0].swy = 11;
screenEnemies[30][0].sdir = 0;
screenEnemies[30][0].setEnemyType(8);
screenEnemies[30][1] = null;
screenEnemies[30][1] = new Enemy(0,0,0,0);
screenEnemies[30][1].swx = 22;
screenEnemies[30][1].swy = 2;
screenEnemies[30][1].sdir = 0;
screenEnemies[30][1].setEnemyType(7);
screenEnemies[30][2] = null;
screenEnemies[30][2] = new Enemy(0,0,0,0);
screenEnemies[30][2].swx = 18;
screenEnemies[30][2].swy = 3;
screenEnemies[30][2].sdir = 0;
screenEnemies[30][2].setEnemyType(8);
screenEnemies[30][3] = null;
screenEnemies[30][3] = new Enemy(0,0,0,0);
screenEnemies[30][3].swx = 14;
screenEnemies[30][3].swy = 5;
screenEnemies[30][3].sdir = 0;
screenEnemies[30][3].setEnemyType(7);
screenEnemies[30][4] = null;
screenEnemies[30][4] = new Enemy(0,0,0,0);
screenEnemies[30][4].swx = 11;
screenEnemies[30][4].swy = 9;
screenEnemies[30][4].sdir = 0;
screenEnemies[30][4].setEnemyType(7);
screenExit[30].set(-1,-2,19,32);

level12();
}

void level12() {
//----------------- SCREENDATA 31
screenBG[31] = new int[] {

510,510,510,510,510,510,510,510,510,510,510,510,51,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,51,51,54,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,54,510,373,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,51,510,510,510,510,54,55,51,510,54,510,510,510,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,51,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,54,510,510,510,510,373,374,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,54,510,510,510,510,510,510,510,510,510,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,54,510,510,510,510,510,510,510,510,510,510,510,510,373,374,373,374,375,376,510,510,510,510,510,510,510,51,510,510,510,510,510,510,510,510,510,54,55,510,51,54,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,54,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,54,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,54,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,54,510,510,510,510,510,510,40,40,41,510,510,510,44,510,510,510,510,510,510,510,510,373,374,375,376,510,510,510,510,510,510,510,510,510,510,54,55,510,510,54,510,510,510,510,510,510,40,40,40,41,41,510,510,510,510,510,510,510,510,373,374,375,376,376,376,510,510,510,510,510,510,51,510,510,510,54,55,51,510,54,510,510,510,510,510,40,40,40,40,41,41,510,510,510,510,510,510,373,374,375,376,373,374,375,376,510,510,510,510,510,510,510,510,510,510,54,55,510,510,54,510,510,510,510,510,40,40,40,40,41,41,41,510,510,510,510,510,510,373,374,375,373,374,375,376,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,40,40,40,40,41,41,41,510,510,510,510,510,510,510,510,510,373,374,375,376,375,376,510,510,510,510,510,510,510,510,54,55,510,51,510,510,44,510,510,510,40,40,40,40,40,41,510,510,510,510,44,510,510,510,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,40,40,41,41,510,510,510,510,510,510,510,510,510,373,374,373,374,375,376,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,33,34,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,510,510,510,51,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,33,34,510,510,510,510,510,510,510,510,510,510,510,373,373,373,374,375,376,510,510,510,510,510,510,510,510,510,54,55,54,55,54,510,510,510,510,510,510,510,33,34,510,510,510,510,510,510,510,510,510,373,374,375,376,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,33,34,510,44,510,510,510,510,510,510,510,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,33,34,510,510,510,510,510,510,510,44,510,510,510,373,374,375,376,376,510,510,510,51,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,33,34,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,51,510,510,510,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,3,373,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,17,16,16,16,16,16,16,16,16,16,17,16,16,16,16,17,16,16,17,17,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,16,16,16,17,16,17,16,16,16,16,16,16,17,16,16,16,16,16,16,373,374,375,376,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,16,16,16,16,16,16,16,16,16,17,16,16,16,16,16,16,16,16,16,17,373,374,375,376,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,16,16,510,510,373,374,375,376,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[31] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[31] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[31][0] = null;
screenEnemies[31][0] = new Enemy(0,0,0,0);
screenEnemies[31][0].swx = 0;
screenEnemies[31][0].swy = 0;
screenEnemies[31][0].sdir = 0;
screenEnemies[31][0].setEnemyType(-1);
screenEnemies[31][1] = null;
screenEnemies[31][1] = new Enemy(0,0,0,0);
screenEnemies[31][1].swx = 0;
screenEnemies[31][1].swy = 0;
screenEnemies[31][1].sdir = 0;
screenEnemies[31][1].setEnemyType(-1);
screenEnemies[31][2] = null;
screenEnemies[31][2] = new Enemy(0,0,0,0);
screenEnemies[31][2].swx = 0;
screenEnemies[31][2].swy = 0;
screenEnemies[31][2].sdir = 0;
screenEnemies[31][2].setEnemyType(-1);
screenEnemies[31][3] = null;
screenEnemies[31][3] = new Enemy(0,0,0,0);
screenEnemies[31][3].swx = 0;
screenEnemies[31][3].swy = 0;
screenEnemies[31][3].sdir = 0;
screenEnemies[31][3].setEnemyType(-1);
screenEnemies[31][4] = null;
screenEnemies[31][4] = new Enemy(0,0,0,0);
screenEnemies[31][4].swx = 0;
screenEnemies[31][4].swy = 0;
screenEnemies[31][4].sdir = 0;
screenEnemies[31][4].setEnemyType(-1);
screenExit[31].set(-2,32,-1,-2);
//----------------- SCREENDATA 32
screenBG[32] = new int[] {
54,55,54,55,54,55,54,55,54,55,54,55,54,55,54,55,54,55,54,55,54,55,54,55,54,54,55,55,510,510,510,54,54,55,55,54,55,510,54,55,54,55,510,510,54,55,510,510,54,55,510,510,54,55,510,510,54,55,510,510,54,55,510,510,54,55,54,55,51,510,510,54,55,54,55,54,55,54,55,510,510,412,413,510,510,510,510,510,412,413,510,510,510,510,510,510,412,413,510,510,510,412,510,510,510,54,55,55,510,510,510,54,54,55,510,510,510,412,510,510,510,412,413,510,510,510,510,510,412,413,510,510,510,510,510,510,412,413,51,510,510,412,510,510,510,510,54,55,510,51,510,54,55,510,510,510,510,412,510,510,510,412,413,510,510,510,510,510,412,413,510,510,510,510,510,510,412,413,510,510,510,412,510,510,510,510,412,413,510,510,510,510,412,413,510,510,510,412,510,510,510,412,51,510,510,510,510,510,412,413,510,510,510,510,510,510,412,413,510,510,510,412,510,510,510,510,412,413,510,510,510,510,412,413,510,510,510,510,510,510,510,412,413,510,510,510,510,510,412,413,510,510,510,510,51,510,412,413,510,510,510,412,510,510,510,510,412,413,510,510,51,510,412,413,510,510,510,510,510,510,510,412,413,510,510,510,510,510,412,413,510,510,510,510,510,510,412,413,510,510,510,412,510,510,51,510,412,413,510,510,510,510,412,413,510,510,510,510,510,510,510,412,413,510,510,510,510,510,412,413,510,510,510,510,510,510,412,413,510,510,510,412,510,510,510,510,412,413,510,510,510,510,510,510,510,51,510,510,510,510,510,412,413,510,510,510,510,510,412,413,510,510,510,510,510,510,412,413,510,510,510,510,510,510,510,510,412,413,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,412,413,510,510,510,510,510,510,412,413,510,510,510,510,510,510,510,510,413,413,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,412,413,510,510,510,510,510,510,510,510,413,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,51,510,510,510,510,510,510,510,510,510,510,510,510,413,510,510,510,510,510,510,510,510,510,413,510,510,510,510,510,510,510,510,510,510,50,510,510,510,510,510,510,510,510,510,510,510,510,51,510,510,510,510,510,510,510,510,510,510,51,510,510,510,510,510,510,510,510,510,510,510,510,510,510,51,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,50,4,4,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,50,50,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,50,510,510,510,510,50,510,510,510,510,50,510,510,510,510,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,54,55,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,51,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,51,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,51,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,51,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,51,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,411,410,410,410,410,410,410,410,411,410,410,410,410,410,410,410,410,410,411,410,410,410,410,410,410,411,410,410,410,410,410,410,410,410,410,411,410,410,410,410,510,410,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[32] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[32] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[32][0] = null;
screenEnemies[32][0] = new Enemy(0,0,0,0);
screenEnemies[32][0].swx = 7;
screenEnemies[32][0].swy = 8;
screenEnemies[32][0].sdir = 0;
screenEnemies[32][0].setEnemyType(3);
screenEnemies[32][1] = null;
screenEnemies[32][1] = new Enemy(0,0,0,0);
screenEnemies[32][1].swx = 12;
screenEnemies[32][1].swy = 4;
screenEnemies[32][1].sdir = 0;
screenEnemies[32][1].setEnemyType(3);
screenEnemies[32][2] = null;
screenEnemies[32][2] = new Enemy(0,0,0,0);
screenEnemies[32][2].swx = 34;
screenEnemies[32][2].swy = 13;
screenEnemies[32][2].sdir = 0;
screenEnemies[32][2].setEnemyType(3);
screenEnemies[32][3] = null;
screenEnemies[32][3] = new Enemy(0,0,0,0);
screenEnemies[32][3].swx = 17;
screenEnemies[32][3].swy = 24;
screenEnemies[32][3].sdir = 0;
screenEnemies[32][3].setEnemyType(3);
screenEnemies[32][4] = null;
screenEnemies[32][4] = new Enemy(0,0,0,0);
screenEnemies[32][4].swx = 12;
screenEnemies[32][4].swy = 17;
screenEnemies[32][4].sdir = 0;
screenEnemies[32][4].setEnemyType(3);
screenExit[32].set(-1,29,31,-2);

//----------------- SCREENDATA 33
screenBG[33] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,376,2,2,3,2,2,3,2,2,2,2,2,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,373,374,375,376,374,375,376,16,16,16,16,16,16,16,16,16,375,376,375,375,375,375,375,375,375,376,51,51,51,51,51,51,51,51,51,51,51,51,51,51,373,374,375,376,375,376,16,16,16,16,16,16,16,16,16,16,375,376,375,375,375,375,375,375,376,51,51,51,51,51,510,510,510,51,510,51,51,51,51,510,373,374,375,376,374,375,376,16,16,16,16,16,16,16,16,16,375,375,375,375,375,376,376,510,51,510,510,51,510,510,51,510,51,510,51,510,510,510,510,510,373,374,375,376,373,374,375,376,16,16,16,16,16,16,16,16,375,376,375,375,376,510,510,51,510,510,510,510,510,510,510,51,510,510,510,510,510,510,51,510,373,374,375,376,375,376,16,16,16,16,16,16,16,16,16,16,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,376,16,16,16,16,16,16,16,16,16,16,16,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,373,374,375,376,16,16,16,16,16,16,16,16,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,376,16,16,16,16,16,16,16,16,16,16,16,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[33] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[33] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[33][0] = null;
screenEnemies[33][0] = new Enemy(0,0,0,0);
screenEnemies[33][0].swx = 0;
screenEnemies[33][0].swy = 0;
screenEnemies[33][0].sdir = 0;
screenEnemies[33][0].setEnemyType(-1);
screenEnemies[33][1] = null;
screenEnemies[33][1] = new Enemy(0,0,0,0);
screenEnemies[33][1].swx = 0;
screenEnemies[33][1].swy = 0;
screenEnemies[33][1].sdir = 0;
screenEnemies[33][1].setEnemyType(-1);
screenEnemies[33][2] = null;
screenEnemies[33][2] = new Enemy(0,0,0,0);
screenEnemies[33][2].swx = 0;
screenEnemies[33][2].swy = 0;
screenEnemies[33][2].sdir = 0;
screenEnemies[33][2].setEnemyType(-1);
screenEnemies[33][3] = null;
screenEnemies[33][3] = new Enemy(0,0,0,0);
screenEnemies[33][3].swx = 0;
screenEnemies[33][3].swy = 0;
screenEnemies[33][3].sdir = 0;
screenEnemies[33][3].setEnemyType(-1);
screenEnemies[33][4] = null;
screenEnemies[33][4] = new Enemy(0,0,0,0);
screenEnemies[33][4].swx = 0;
screenEnemies[33][4].swy = 0;
screenEnemies[33][4].sdir = 0;
screenEnemies[33][4].setEnemyType(-1);
screenExit[33].set(-1,-2,24,34);

level13();
}

void level13() {
//----------------- SCREENDATA 34
screenBG[34] = new int[] {
375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,373,374,373,374,375,376,375,373,374,375,373,374,375,376,375,50,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,4,373,373,374,373,374,375,376,375,376,375,376,374,373,374,375,50,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,373,374,373,374,375,376,375,376,375,376,373,374,375,376,50,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,4,373,374,373,373,374,375,376,376,375,376,373,374,375,376,50,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,373,374,375,373,373,374,375,376,375,376,375,373,373,50,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,4,373,374,373,374,375,376,376,375,376,375,376,374,375,50,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,373,374,375,373,374,375,376,374,373,373,373,374,375,50,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,4,373,374,373,374,375,376,375,376,376,374,375,376,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,510,510,510,510,510,510,373,374,373,373,374,375,376,375,376,373,374,375,376,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,4,4,373,373,374,375,376,376,375,373,374,375,376,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,373,374,374,373,373,374,373,374,373,373,374,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,373,373,374,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,4,4,373,374,375,373,374,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,50,510,510,510,510,50,50,510,510,510,510,510,510,510,510,373,374,375,373,374,375,376,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,373,374,375,376,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,4,4,4,510,510,510,510,510,510,4,373,374,375,376,373,374,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,376,4,510,510,510,510,510,373,374,375,376,374,375,376,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,375,373,376,510,510,510,510,4,373,374,375,376,376,376,376,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,375,376,510,510,510,510,510,373,374,375,373,374,375,376,373,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,373,373,374,375,376,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,4,373,374,375,376,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,4,4,373,374,375,376,376,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,373,374,375,376,373,374,50,510,510,510,510,510,510,510,4,399,510,510,400,4,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,373,374,50,510,510,510,510,510,510,510,50,50,510,510,50,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,373,50,399,510,510,510,400,510,510,510,50,510,510,50,510,510,510,399,400,510,510,510,510,510,400,399,510,510,510,399,510,400,400,510,510,4,4,373,374,375,376,50,4,4,4,4,4,4,4,4,50,510,510,50,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,373,374,375,376,376,376,50,50,50,50,50,50,50,50,50,50,510,510,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[34] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[34] = new int[] {
1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[34][0] = null;
screenEnemies[34][0] = new Enemy(0,0,0,0);
screenEnemies[34][0].swx = 17;
screenEnemies[34][0].swy = 18;
screenEnemies[34][0].sdir = 0;
screenEnemies[34][0].setEnemyType(6);
screenEnemies[34][1] = null;
screenEnemies[34][1] = new Enemy(0,0,0,0);
screenEnemies[34][1].swx = 12;
screenEnemies[34][1].swy = 18;
screenEnemies[34][1].sdir = 0;
screenEnemies[34][1].setEnemyType(6);
screenEnemies[34][2] = null;
screenEnemies[34][2] = new Enemy(0,0,0,0);
screenEnemies[34][2].swx = 2;
screenEnemies[34][2].swy = 18;
screenEnemies[34][2].sdir = 0;
screenEnemies[34][2].setEnemyType(6);
screenEnemies[34][3] = null;
screenEnemies[34][3] = new Enemy(0,0,0,0);
screenEnemies[34][3].swx = 5;
screenEnemies[34][3].swy = 18;
screenEnemies[34][3].sdir = 0;
screenEnemies[34][3].setEnemyType(6);
screenEnemies[34][4] = null;
screenEnemies[34][4] = new Enemy(0,0,0,0);
screenEnemies[34][4].swx = 20;
screenEnemies[34][4].swy = 18;
screenEnemies[34][4].sdir = 0;
screenEnemies[34][4].setEnemyType(6);
screenExit[34].set(-1,-1,-1,35);
//----------------- SCREENDATA 35
screenBG[35] = new int[] {
510,510,510,510,510,510,510,510,510,50,510,510,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,50,510,510,510,510,510,510,510,510,50,50,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,50,510,510,510,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,510,510,510,510,510,50,510,510,510,510,510,510,510,510,510,510,510,50,510,50,4,4,4,4,4,4,4,4,4,4,4,4,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,50,50,50,50,50,50,50,50,50,50,50,50,50,510,510,510,510,510,510,510,510,4,4,4,4,510,510,510,510,4,4,4,510,510,510,510,510,510,50,510,510,510,510,510,510,510,510,510,510,510,510,510,50,4,4,4,4,510,510,510,510,50,50,50,50,510,510,510,510,50,50,50,4,510,510,510,4,4,50,510,510,510,510,510,510,510,510,510,510,510,510,510,50,50,50,50,50,510,510,510,510,50,510,510,50,4,4,4,4,50,510,50,50,510,510,510,50,50,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,4,4,4,4,50,510,510,50,50,50,50,50,50,510,510,50,510,510,510,50,510,510,510,510,510,510,510,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,510,510,50,510,510,510,510,510,510,510,50,510,510,510,50,510,510,510,510,510,510,510,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,50,50,50,50,50,50,50,50,510,510,510,50,50,50,510,510,510,510,510,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,510,50,50,50,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,510,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,510,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,510,50,4,4,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,510,50,50,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,510,510,510,50,510,510,510,510,510,510,510,510,510,510,510,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,510,510,510,50,510,510,510,510,510,50,510,510,510,510,510,50,510,510,510,510,510,510,510,510,50,50,50,50,50,50,50,50,50,510,510,510,510,510,50,510,510,510,510,50,510,510,510,510,510,50,510,510,510,510,510,50,4,4,4,4,4,4,4,4,50,510,510,510,510,510,510,510,50,510,510,510,510,510,50,510,510,510,510,50,510,510,510,510,510,50,4,4,4,4,4,50,50,50,50,50,50,50,50,50,50,4,4,4,4,4,4,4,50,4,4,4,4,4,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[35] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[35] = new int[] {
0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[35][0] = null;
screenEnemies[35][0] = new Enemy(0,0,0,0);
screenEnemies[35][0].swx = 12;
screenEnemies[35][0].swy = 20;
screenEnemies[35][0].sdir = 0;
screenEnemies[35][0].setEnemyType(6);
screenEnemies[35][1] = null;
screenEnemies[35][1] = new Enemy(0,0,0,0);
screenEnemies[35][1].swx = 32;
screenEnemies[35][1].swy = 20;
screenEnemies[35][1].sdir = 0;
screenEnemies[35][1].setEnemyType(6);
screenEnemies[35][2] = null;
screenEnemies[35][2] = new Enemy(0,0,0,0);
screenEnemies[35][2].swx = 35;
screenEnemies[35][2].swy = 4;
screenEnemies[35][2].sdir = 0;
screenEnemies[35][2].setEnemyType(6);
screenEnemies[35][3] = null;
screenEnemies[35][3] = new Enemy(0,0,0,0);
screenEnemies[35][3].swx = 8;
screenEnemies[35][3].swy = 19;
screenEnemies[35][3].sdir = 0;
screenEnemies[35][3].setEnemyType(6);
screenEnemies[35][4] = null;
screenEnemies[35][4] = new Enemy(0,0,0,0);
screenEnemies[35][4].swx = 32;
screenEnemies[35][4].swy = 2;
screenEnemies[35][4].sdir = 0;
screenEnemies[35][4].setEnemyType(6);
screenExit[35].set(-2,-1,-1,36);
//----------------- SCREENDATA 36
screenBG[36] = new int[] {
510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,167,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,167,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,167,510,510,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,167,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,167,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,167,510,510,510,510,510,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,167,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,167,510,510,510,510,510,167,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,50,510,510,510,510,510,50,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,50,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[36] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[36] = new int[] {
0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[36][0] = null;
screenEnemies[36][0] = new Enemy(0,0,0,0);
screenEnemies[36][0].swx = 0;
screenEnemies[36][0].swy = 0;
screenEnemies[36][0].sdir = 0;
screenEnemies[36][0].setEnemyType(-1);
screenEnemies[36][1] = null;
screenEnemies[36][1] = new Enemy(0,0,0,0);
screenEnemies[36][1].swx = 0;
screenEnemies[36][1].swy = 0;
screenEnemies[36][1].sdir = 0;
screenEnemies[36][1].setEnemyType(-1);
screenEnemies[36][2] = null;
screenEnemies[36][2] = new Enemy(0,0,0,0);
screenEnemies[36][2].swx = 0;
screenEnemies[36][2].swy = 0;
screenEnemies[36][2].sdir = 0;
screenEnemies[36][2].setEnemyType(-1);
screenEnemies[36][3] = null;
screenEnemies[36][3] = new Enemy(0,0,0,0);
screenEnemies[36][3].swx = 0;
screenEnemies[36][3].swy = 0;
screenEnemies[36][3].sdir = 0;
screenEnemies[36][3].setEnemyType(-1);
screenEnemies[36][4] = null;
screenEnemies[36][4] = new Enemy(0,0,0,0);
screenEnemies[36][4].swx = 0;
screenEnemies[36][4].swy = 0;
screenEnemies[36][4].sdir = 0;
screenEnemies[36][4].setEnemyType(-1);
screenExit[36].set(-1,-1,-1,37);

level14();
}

void level14() {
//----------------- SCREENDATA 37
screenBG[37] = new int[] {
510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,167,510,510,510,510,510,510,510,510,510,510,510,510,510,510,167,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,167,510,510,510,510,510,510,510,167,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,167,510,510,510,510,510,510,510,167,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,167,510,510,510,510,510,510,167,510,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,167,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,167,510,510,510,510,167,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,167,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,167,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,167,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,167,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,167,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,167,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,167,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,167,510,510,510,167,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,167,510,510,510,510,510,510,510,510,510,167,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[37] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[37] = new int[] {
0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[37][0] = null;
screenEnemies[37][0] = new Enemy(0,0,0,0);
screenEnemies[37][0].swx = 0;
screenEnemies[37][0].swy = 0;
screenEnemies[37][0].sdir = 0;
screenEnemies[37][0].setEnemyType(-1);
screenEnemies[37][1] = null;
screenEnemies[37][1] = new Enemy(0,0,0,0);
screenEnemies[37][1].swx = 0;
screenEnemies[37][1].swy = 0;
screenEnemies[37][1].sdir = 0;
screenEnemies[37][1].setEnemyType(-1);
screenEnemies[37][2] = null;
screenEnemies[37][2] = new Enemy(0,0,0,0);
screenEnemies[37][2].swx = 0;
screenEnemies[37][2].swy = 0;
screenEnemies[37][2].sdir = 0;
screenEnemies[37][2].setEnemyType(-1);
screenEnemies[37][3] = null;
screenEnemies[37][3] = new Enemy(0,0,0,0);
screenEnemies[37][3].swx = 0;
screenEnemies[37][3].swy = 0;
screenEnemies[37][3].sdir = 0;
screenEnemies[37][3].setEnemyType(-1);
screenEnemies[37][4] = null;
screenEnemies[37][4] = new Enemy(0,0,0,0);
screenEnemies[37][4].swx = 0;
screenEnemies[37][4].swy = 0;
screenEnemies[37][4].sdir = 0;
screenEnemies[37][4].setEnemyType(-1);
screenExit[37].set(-1,-1,-1,38);
//----------------- SCREENDATA 38
screenBG[38] = new int[] {
510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,167,510,510,510,510,510,231,169,169,169,169,169,169,169,169,169,169,169,169,169,169,169,169,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,231,169,169,169,169,169,169,169,169,169,169,169,169,169,169,169,510,510,510,510,53,510,510,510,510,510,53,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,231,169,169,169,169,169,169,169,169,169,169,169,169,169,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,231,169,169,169,169,169,169,169,169,169,169,169,169,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,167,510,510,510,510,510,510,167,510,510,510,510,510,231,169,169,169,169,169,169,169,169,169,169,169,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,169,169,169,169,169,169,169,169,169,169,169,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,169,169,169,169,169,169,169,169,169,169,169,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,231,169,169,169,169,169,169,169,169,169,169,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,167,510,510,510,169,169,169,169,169,169,169,169,169,169,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,167,510,510,510,510,510,510,510,510,510,510,510,510,231,233,169,169,169,169,169,169,169,169,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,231,169,169,169,233,169,169,169,169,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,167,510,510,510,510,510,510,510,231,169,169,169,233,169,169,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,231,232,232,233,233,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,167,510,510,510,510,510,510,510,510,510,510,167,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,375,375,375,375,375,376,510,510,373,374,374,376,510,510,373,375,375,376,510,510,510,510,373,375,375,376,510,510,510,510,373,375,375,376,510,410,410,373,374,375,373,374,375,376,375,376,410,410,373,374,375,376,410,411,373,374,375,376,410,411,411,411,373,374,375,376,411,410,411,410,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[38] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[38] = new int[] {
0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[38][0] = null;
screenEnemies[38][0] = new Enemy(0,0,0,0);
screenEnemies[38][0].swx = 0;
screenEnemies[38][0].swy = 0;
screenEnemies[38][0].sdir = 0;
screenEnemies[38][0].setEnemyType(-1);
screenEnemies[38][1] = null;
screenEnemies[38][1] = new Enemy(0,0,0,0);
screenEnemies[38][1].swx = 0;
screenEnemies[38][1].swy = 0;
screenEnemies[38][1].sdir = 0;
screenEnemies[38][1].setEnemyType(-1);
screenEnemies[38][2] = null;
screenEnemies[38][2] = new Enemy(0,0,0,0);
screenEnemies[38][2].swx = 0;
screenEnemies[38][2].swy = 0;
screenEnemies[38][2].sdir = 0;
screenEnemies[38][2].setEnemyType(-1);
screenEnemies[38][3] = null;
screenEnemies[38][3] = new Enemy(0,0,0,0);
screenEnemies[38][3].swx = 0;
screenEnemies[38][3].swy = 0;
screenEnemies[38][3].sdir = 0;
screenEnemies[38][3].setEnemyType(-1);
screenEnemies[38][4] = null;
screenEnemies[38][4] = new Enemy(0,0,0,0);
screenEnemies[38][4].swx = 0;
screenEnemies[38][4].swy = 0;
screenEnemies[38][4].sdir = 0;
screenEnemies[38][4].setEnemyType(-1);
screenExit[38].set(-1,39,-1,-2);

//----------------- SCREENDATA 39
screenBG[39] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,44,510,510,510,44,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,48,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,511,510,510,510,510,510,510,510,510,510,510,510,6,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,511,510,44,510,510,510,510,510,510,510,510,44,6,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,510,510,510,510,44,510,510,510,390,391,708,708,999,390,391,510,510,510,510,510,510,510,6,510,510,510,510,510,510,510,12,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,392,393,708,708,999,392,393,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,12,510,44,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,392,393,708,708,999,392,393,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,12,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,392,393,708,708,999,392,393,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,12,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,392,393,708,708,999,392,393,999,999,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,392,393,708,708,999,392,393,999,999,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,708,708,999,999,999,999,999,510,510,510,510,373,374,374,375,375,374,374,375,374,374,510,510,510,510,510,510,510,510,476,508,508,509,508,508,509,510,476,477,510,708,708,999,999,999,999,999,373,374,374,374,374,375,374,374,374,375,375,375,375,375,510,510,510,510,510,510,999,999,999,509,508,509,508,509,510,510,508,509,510,708,708,69,373,374,374,374,375,375,374,375,374,375,375,375,374,375,374,374,375,374,510,510,510,510,510,510,476,476,476,476,477,508,509,510,510,510,510,510,373,374,374,374,374,374,374,374,374,375,374,374,375,374,374,375,374,375,374,375,374,374,510,510,510,510,510,476,476,477,476,508,509,510,510,510,510,510,373,374,374,374,374,375,374,374,374,375,374,374,375,374,374,374,375,374,374,375,374,375,374,374,510,510,510,510,476,476,477,476,508,509,510,510,510,510,373,374,374,374,374,374,375,374,375,375,375,374,375,374,374,374,374,374,374,375,374,375,374,375,374,375,510,510,510,510,508,476,476,508,509,510,510,510,373,374,374,374,374,374,375,374,374,374,374,375,374,374,375,374,375,374,374,375,374,374,375,374,375,374,374,374,510,510,510,510,476,508,508,509,509,510,373,374,374,375,374,374,375,374,374,374,374,374,375,374,375,374,375,374,375,374,374,375,374,374,375,374,374,375,375,375,510,510,510,510,476,477,476,477,373,374,375,374,374,374,375,374,375,374,374,374,375,375,374,374,375,375,374,374,374,374,375,374,374,375,374,374,375,374,375,374,510,510,510,510,476,476,373,374,374,374,374,374,375,374,374,375,374,375,374,375,374,375,375,375,374,375,375,374,374,375,375,374,374,375,374,375,374,375,375,374,508,476,510,508,373,374,374,374,374,374,375,374,375,374,375,375,375,374,374,374,374,374,375,374,375,375,374,375,374,375,375,375,374,375,375,374,374,374,374,375,373,374,374,374,374,374,374,374,374,375,375,375,375,375,375,375,374,375,375,374,375,374,375,374,374,375,374,374,375,374,374,375,374,374,374,374,374,374,375,375,510,510,510,510,374,375,375,375,375,375,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,378,379,379,379,379,378,379,379,379,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenFG[39] = new int[] {
510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,44,45,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,46,47,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,424,425,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,426,427,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,373,374,375,376,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,6,9,9,7,6,7,6,7,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,6,7,71,72,73,74,11,12,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,6,12,102,103,104,105,106,107,6,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,6,12,134,135,136,137,138,139,6,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,6,12,166,167,168,169,170,171,6,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,6,12,198,199,200,201,202,203,6,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,6,12,231,232,233,234,11,12,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,6,7,13,14,13,14,6,7,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,510,};
screenBlocks[39] = new int[] {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
screenEnemies[39][0] = null;
screenEnemies[39][0] = new Enemy(0,0,0,0);
screenEnemies[39][0].swx = 25;
screenEnemies[39][0].swy = 12;
screenEnemies[39][0].sdir = 0;
screenEnemies[39][0].setEnemyType(9);
screenEnemies[39][1] = null;
screenEnemies[39][1] = new Enemy(0,0,0,0);
screenEnemies[39][1].swx = 0;
screenEnemies[39][1].swy = 0;
screenEnemies[39][1].sdir = 0;
screenEnemies[39][1].setEnemyType(-1);
screenEnemies[39][2] = null;
screenEnemies[39][2] = new Enemy(0,0,0,0);
screenEnemies[39][2].swx = 0;
screenEnemies[39][2].swy = 0;
screenEnemies[39][2].sdir = 0;
screenEnemies[39][2].setEnemyType(-1);
screenEnemies[39][3] = null;
screenEnemies[39][3] = new Enemy(0,0,0,0);
screenEnemies[39][3].swx = 0;
screenEnemies[39][3].swy = 0;
screenEnemies[39][3].sdir = 0;
screenEnemies[39][3].setEnemyType(-1);
screenEnemies[39][4] = null;
screenEnemies[39][4] = new Enemy(0,0,0,0);
screenEnemies[39][4].swx = 0;
screenEnemies[39][4].swy = 0;
screenEnemies[39][4].sdir = 0;
screenEnemies[39][4].setEnemyType(-1);
screenExit[39].set(-1,-1,-1,-1);

}
