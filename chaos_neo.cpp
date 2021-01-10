#include <stdio.h>
#include <stdlib.h>
#include <cmath>
#include <SDL/SDL.h>
#include <SDL/SDL_image.h>
#include <SDL/SDL_mixer.h>
#include <SDL/SDL_ttf.h>
#include <string>
#include <vector>
#include <windows.h>

const int screenCount = 40;
const int screenWidth = 40; 
const int screenHeight = 30; 
const int enemiesPerScreen = 5; 

const int WIDTH = 320 * 5;
const int HEIGHT = 240 * 5;

const int width = WIDTH;
const int height = HEIGHT;

#include "screenbg.h"
#include "screenfg.h"
#include "screenBlocks.h"
#include "screenExits.h"

#define boolean bool

#define NONE -1
#define LEFT 0
#define CENTER 1
#define RIGHT 2

using namespace std;

boolean showingGameover = false;
boolean showingEnd = false;
boolean showingWin = false;

boolean jumpStarting = false;
boolean playerGrounded = false;

boolean speedRunMode = false;

boolean mousePressed = false;
float mouseX = 0.0;
float mouseY = 0.0;
int mouseButton = NONE;

float speedStartTime = 0;
float speedTimer = 0;
boolean fontinit = false;

float winTimer = 0;

SDL_Surface *tilemap;
SDL_Surface *tilemapalpha;
SDL_Surface **tiles;
SDL_Surface **tilesalpha;

void loadScreens();
void setDefaultScreens();
void newScreen();
void gameOver();
void setrestart();
void loadScreen(bool c);

boolean setholdingAction(int on);

float millisecs = 0;

float millis() {
  return millisecs;
}

void textAlign(int align) {

}

void imageMode(int align) {

}

void sfill(int c)
{
}

void sfill(int r, int g, int b)
{
}

void sfill(int c, int a)
{
}

void stroke(int c)
{
}

void stroke(int r, int g, int b, int a)
{
}

void stroke(int r, int g, int b)
{
}

void strokeWeight(int w) 
{
}

void background(int a)
{
}

void beginDraw() {
}

void endDraw() {
}

void background(int r, int g, int b)
{
}

void noStroke()
{
}

void noFill()
{
}

void image(SDL_Surface *image, int x, int y)
{
}

void image(SDL_Surface *image, float x, float y)
{
}

void rect(int x, int y, int w, int h)
{
}

void pushMatrix()
{
}

void popMatrix()
{
}

void text(string text, int x, int y) {

}

int key;

void drawTileNum(int x, int y, int tnum)
{
  if (tnum == 999)
    return;
  int fnum = 510;

  // tile animations
  int yy = y;
  int xx = x;
  if (tnum == 40)
  { // leaf 1
    if (rand() * 10000000 > 9995000)
    {
      fnum = 41;
    }

    else
      fnum = tnum;
  }
  else if (tnum == 41)
  { // leaf 2
    if (rand() * 10000000 > 9995000)
    {
      fnum = 40;
    }

    else
      fnum = tnum;
  }
  else if (tnum == 44)
  { // stars
    if (rand() * 10000000 > 9995000)
    {
      fnum = 510;
    }

    else
      fnum = tnum;
  }
  else if (tnum == 381)
  { // smoke
    if (rand() * 10000000 > 9035000)
    {
      fnum = 510;
    }

    else
      fnum = tnum;
  }
  else if ((tnum >= 103 && tnum <= 106) || (tnum >= 135 && tnum <= 138) || (tnum >= 167 && tnum <= 170) || (tnum >= 199 && tnum <= 202))
  { // red portal
    if (rand() * 10000000 >
        9415000 - abs(cos(millis() * 0.1) * 10000000))
    {
      fnum = (int)(rand() * 700);
    }

    else
      fnum = tnum;
  }
  else
  {
    fnum = tnum;
  }
  image(tiles[fnum], x * 8, y * 8);
}

void drawTileNumAlpha(int x, int y, int tnum)
{
  if (tnum == 999)
    return;
  int fnum = 510;

  // tile animations
  int yy = y;
  int xx = x;
  if (tnum == 40)
  { // leaf 1
    if (rand() * 10000000 > 9995000)
    {
      fnum = 41;
    }

    else
      fnum = tnum;
  }
  else if (tnum == 41)
  { // leaf 2
    if (rand() * 10000000 > 9995000)
    {
      fnum = 40;
    }

    else
      fnum = tnum;
  }
  else if (tnum == 44)
  { // stars
    if (rand() * 10000000 > 9995000)
    {
      fnum = 510;
    }

    else
      fnum = tnum;
  }
  else if (tnum == 381)
  { // smoke
    if (rand() * 10000000 > 9035000)
    {
      fnum = 510;
    }

    else
      fnum = tnum;
  }
  else if ((tnum >= 103 && tnum <= 106) || (tnum >= 135 && tnum <= 138) || (tnum >= 167 && tnum <= 170) || (tnum >= 199 && tnum <= 202))
  { // red portal
    if (rand() * 10000000 >
        9415000 - abs(cos(millis() * 0.1) * 10000000))
    {
      fnum = (int)(rand() * 700);
    }

    else
      fnum = tnum;
  }
  else
  {
    fnum = tnum;
  }
  image(tilesalpha[fnum], x * 8, y * 8);
}

string screenName[screenCount] =
    {"Chaos Portal exit                           The Ossuary",
     "The Forgotten Crypt", "The Boathouse", "Castle Courtyards", "On the Drawbridge",
     "The MegaTree?", "The Guardhouse Entrance", "Red Carpet", "Afterparty",
     "Second-hand Love", "Rattus Rattus", "Totally spiked", "The Day After", "Sunday Brunch",
     "Insect Island", "Shores of Hell", "Portal Process", "Mind the Gap", "Prison Cells",
     "The Three Stooges", "On the Attic", "Armed to the Teeth", "Wine Reserves",
     "The Church of Chaos", "Holy Steps", "Romance in Chaos", "Leap of Faith", "Comedown",
     "Don't misbeehave", "The Impossible Jump", "Graham's Nightmare", "Just out of reach",
     "Disco Inferno", "The Drop", "Into the Hive", "Clockworks", "Shaft",
     "Copy of shaft (1)", "No foreshadoing intended...",
     "Throne Room                  Chaos Portal entrance"};

int currentScreen = 0;
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
string layerNames[] = {"BG", "FG"};

int currentExit = 0;
boolean justChangedScreen = false;
int enemyTypeCount = 10;
int currentEnemy = 0;
int currentEnemyType = 0;
int tilemapWidth;
int tilemapHeight;
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


class Frame
{
public:
  int x;
  int y;
  int w;
  int h;
  Frame()
  {
    x = 0;
    y = 0;
    w = 0;
    h = 0;
  }

  Frame(int _x, int _y, int _w, int _h)
  {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }
};

Frame gridFrame;
Frame enemyFrame;

class Sprite
{
  public:
  std::vector<Frame> frames;
  int ox;
  int oy;
  int ow;
  int oh;
  float wx;
  float wy;
  int framecount;
  
  Sprite() {
 
  }

  Sprite(int _ox, int _oy, int _ow, int _oh, float _wx, float _wy, int _framecount)
  {
    ox = _ox;
    oy = _oy;
    ow = _ow;
    oh = _oh;
    wx = _wx;
    wy = _wy;
    framecount = _framecount;

    frames.resize(framecount);

    for (int i = 0; i < framecount; i++)
    {
      Frame f;
      f.x = ox + (i * ow);
      f.y = oy;
      f.w = ow;
      f.h = oh;
      frames.push_back(f);
    }
  }

  int sfl;
  int efl;
  int sfr;
  int efr;

  void setAnimationLeft(int startFrame, int endFrame)
  {
    sfl = startFrame;
    efl = endFrame;
    animframe = 0;
  }

  void setAnimationRight(int startFrame, int endFrame)
  {
    sfr = startFrame;
    efr = endFrame;
    animframe = 0;
  }

  int animframe = 0;
  int animtimer = 0;
  int dir = 0;

  void setDir(int d)
  {
    dir = d;
  }

  void animate(int animspeed, float dt)
  {
    animtimer += (int)dt;
    if (animtimer > animspeed)
    {
      animtimer = 0;
      animframe++;
    }
    if (animframe > 1)
      animframe = 0;
  }

  Frame* getAnimFrame()
  {
    int i = 0;
    if (dir == 0)
      i = sfl + animframe;

    else if (dir == 1)
      i = sfr + animframe;
    return &frames[i];
  }

  Frame* getFrame(int frameIndex)
  {
    return &frames[frameIndex];
  }
};

void drawTileXY(int x, int y, int tx, int ty)
{
  image(tiles[(ty * tilemapWidth) + tx], x * 8, y * 8);
}

void drawTileXYAlpha(int x, int y, int tx, int ty)
{
  image(tilesalpha[(ty * tilemapWidth) + tx], x * 8, y * 8);
}

void drawFrame(int x, int y, Frame frame)
{
  for (int fy = 0; fy < frame.h; fy++)
  {
    for (int fx = 0; fx < frame.w; fx++)
    {
      drawTileXY(x + fx, y + fy, frame.x + fx, frame.y + fy);
    }
  }
}

void drawFrameAlpha(int x, int y, Frame frame)
{
  for (int fy = 0; fy < frame.h; fy++)
  {
    for (int fx = 0; fx < frame.w; fx++)
    {
      drawTileXYAlpha(x + fx, y + fy, frame.x + fx, frame.y + fy);
    }
  }
}

void drawFrameGlitch(int x, int y, Frame frame)
{
  for (int fy = 0; fy < frame.h; fy++)
  {
    for (int fx = 0; fx < frame.w; fx++)
    {
      int corr = (int)(rand() % 3);
      if (corr != 1)
        drawTileXY(x + fx, y + fy, frame.x + fx, frame.y + fy);

      else
        drawTileNum(x + fx, y + fy, 135 + (int)(rand() % 4));
    }
  }
}


class Enemy
{
public:
  int tx;
  int ty;
  int tw;
  int th;
  int type = -1;
  float speedmod;
  boolean alive;
  boolean corrupting;
  Sprite* sprite = NULL;
  Sprite* sprite2 = NULL;
  Frame frame;
  int frames;
  int swx;
  int swy;
  int sdir;

  Enemy() 
  {

  }

  Enemy(int _tx, int _ty, int _tw, int _th)
  {
    tx = _tx;
    ty = _ty;
    tw = _tw;
    th = _th;
    alive = false;
    type = -1;
    frames = 4;
    frame = Frame(tx, ty, tw, th);
    corrupting = false;
  }

  void reset()
  {
    if (sprite != NULL)
    {
      sprite->wx = swx;
      sprite->wy = swy;
      sprite->dir = sdir;
    }
    if (sprite2 != NULL)
    {
      sprite2->wx = swx;
      sprite2->wy = swy + 4;
      sprite2->dir = 0;
      sprite->dir = 0;
    }
  }
  void resurrect()
  {
    alive = true;
    reset();
  }
  void setStartPos(int x, int y, int d)
  {
    swx = x;
    swy = y;
    sdir = d;
  }
  void setEnemyType(int _type)
  {
    type = _type;
    if (type == 0)
    {
      tx = 0;
      ty = 8;
      tw = 2;
      th = 3;
      frames = 4;
      speedmod = 0.5;
    }

    else if (type == 1)
    {
      tx = 8;
      ty = 8;
      tw = 2;
      th = 3;
      frames = 4;
      speedmod = 0.75;
    }

    else if (type == 2)
    {
      tx = 16;
      ty = 8;
      tw = 2;
      th = 3;
      frames = 4;
      speedmod = 0.85;
    }

    else if (type == 3)
    {
      tx = 24;
      ty = 8;
      tw = 2;
      th = 3;
      frames = 4;
      speedmod = 1;
    }

    else if (type == 4)
    {
      tx = 20;
      ty = 19;
      tw = 2;
      th = 3;
      frames = 4;
      speedmod = 0.85;
    }

    else if (type == 5)
    {
      tx = 12;
      ty = 5;
      tw = 2;
      th = 2;
      frames = 4;
      speedmod = 0.9;
    }

    else if (type == 6)
    {
      tx = 8;
      ty = 16;
      tw = 2;
      th = 2;
      frames = 4;
      speedmod = 0.7;
    }

    else if (type == 7)
    {
      tx = 20;
      ty = 5;
      tw = 2;
      th = 2;
      frames = 2;
      speedmod = 0.7;
    }

    else if (type == 8)
    {
      tx = 24;
      ty = 5;
      tw = 2;
      th = 2;
      frames = 2;
      speedmod = 0.7;
    }

    else if (type == 9)
    {
      tx = 0;
      ty = 22;
      tw = 4;
      th = 3;
      frames = 2;
      speedmod = 0.7;
      sprite2 = NULL;
      sprite2 = new Sprite(tx + tw, ty, tw, th, (int)swx, (int)swy, frames);
    }
    sprite = NULL;
    sprite = new Sprite(tx, ty, tw, th, (int)swx, (int)swy, frames);
    if (type >= 0 && type < 7)
    { // guard
      sprite->setAnimationLeft(0, 1);
      sprite->setAnimationRight(2, 3);
      sprite->setDir(0);
    }
    else if (type >= 7 && type <= 8)
    {
      sprite->setAnimationLeft(0, 1);
      sprite->setAnimationRight(0, 1);
      sprite->setDir(type == 7 ? 0 : 1);
    }
    else if (type == 9)
    {
      sprite->setAnimationLeft(0, 1);
      sprite->setAnimationRight(0, 1);
      sprite2->setAnimationLeft(0, 1);
      sprite2->setAnimationRight(0, 1);
      sprite->setDir(0);
      sprite2->setDir(0);
    }
    alive = true;
  }
  void checkCorruption(float nx, float ny)
  {
    for (int y = 0; y < 3; y++)
    {
      for (int x = 0; x < 2; x++)
      {
        float newx = nx + (x);
        float newy = ny - (y - 1);
        if (screenBG[currentScreen]
                    [((int)(newy)*screenWidth) + (int)newx] >= 135 &&
            screenBG[currentScreen][((int)(newy)*screenWidth) +
                                    (int)newx] <= 138)
        {
          corrupting = true;
        }
      }
    }
  }
  boolean passable(float nx, float ny)
  {
    boolean bg = false;
    for (int y = 0; y < 1; y++)
    {
      for (int x = 0; x < 2; x++)
      {
        float newx = nx + (x);
        float newy = ny - (y - 1);
        if (th == 2)
        {
          newy -= 1;
        }
        if (screenBG[currentScreen]
                    [((int)(newy)*screenWidth) + (int)newx] >= 135 &&
            screenBG[currentScreen][((int)(newy)*screenWidth) +
                                    (int)newx] <= 138)
        {
          corrupting = true;
        }
        if (screenBlocks[currentScreen]
                        [((int)(newy)*screenWidth) + (int)newx] == 1)
        {
          return false;
        }
      }
    }
    return true;
  }
  void tick(float _dt)
  {
    if (type == -1)
      return;
    sprite->animate(50, _dt);
    if (sprite2 != NULL)
      sprite2->animate(50, _dt);
    float hSpeed = _dt * 0.035 * speedmod;
    float vSpeed = _dt * 0.035 * speedmod;
    if (type >= 0 && type < 7 && type != 3)
    { // guard type
      if (sprite->wx <= 0)
        sprite->dir = 1;

      else if (sprite->wx >= screenWidth - 2)
        sprite->dir = 0;

      else if (!passable(sprite->wx - tw / 2, sprite->wy) || !passable(sprite->wx + tw / 2, sprite->wy))
      {
        if (sprite->dir == 0)
          sprite->dir = 1;

        else
          sprite->dir = 0;
      }
      if (sprite->dir == 0)
        sprite->wx -= hSpeed;

      else
        sprite->wx += hSpeed;
      checkCorruption(sprite->wx, sprite->wy);
    }
    else if (type >= 7 && type <= 8 || type == 3)
    { // spider type
      if (sprite->wy <= 1)
        sprite->dir = 1;

      else if (sprite->wy >= screenHeight - 3)
        sprite->dir = 0;

      else if (!passable(sprite->wx, sprite->wy + 1) || !passable(sprite->wx, sprite->wy - 1))
      {
        if (sprite->dir == 0)
          sprite->dir = 1;

        else
          sprite->dir = 0;
      }
      if (sprite->dir == 0)
        sprite->wy -= vSpeed;

      else
        sprite->wy += vSpeed;
      checkCorruption(sprite->wx, sprite->wy);
    }
  }
  void draw()
  {
    if (type == -1)
      return;
    Frame* pf = sprite->getAnimFrame();
    if (!corrupting)
    {
      if (type != 9)
      {
        drawFrameAlpha((int)sprite->wx, (int)sprite->wy, *pf);
      }
      else
      {
        Frame* pf2 = sprite2->getAnimFrame();
        int yp1 = (int)sprite->wy;
        int yp2 = (int)sprite->wy + 3;
        if (pf != NULL)
          drawFrameAlpha((int)sprite->wx,
                         sprite->animframe == 0 ? yp1 : yp2, *pf);
        if (pf2 != NULL)
          drawFrameAlpha((int)sprite->wx,
                         sprite->animframe == 0 ? yp2 : yp1, *pf2);
      }
    }
    else
    {
      drawFrameGlitch((int)sprite->wx, (int)sprite->wy, *pf);
    }
  }
};

class RoomExit

{
  public:
  int n;
  int e;
  int w;
  int s;

  RoomExit() 
  {

  }

  RoomExit(int _n, int _e, int _w, int _s)
  {
    n = _n;
    e = _e;
    w = _w;
    s = _s;
  }
  void set(int _n, int _e, int _w, int _s)
  {
    n = _n;
    e = _e;
    w = _w;
    s = _s;
  }
  string asData()
  {
    return "" + to_string(n) + "," + to_string(e) + "," + to_string(w) + "," + to_string(s);
  }
  string getN()
  {
    if (n == -2)
      return "N: DEATH";
    if (n == -1)
      return "N: BLOCK";
    return "N: " + to_string(n);
  }
  string getE()
  {
    if (e == -2)
      return "E: DEATH";
    if (e == -1)
      return "E: BLOCK";
    return "E: " + to_string(e);
  }
  string getW()
  {
    if (w == -2)
      return "W: DEATH";
    if (w == -1)
      return "W: BLOCK";
    return "W: " + to_string(w);
  }
  string getS()
  {
    if (s == -2)
      return "S: DEATH";
    if (s == -1)
      return "S: BLOCK";
    return "S: " + to_string(s);
  }
};

RoomExit screenExit[screenCount];// exits
Enemy screenEnemies[screenCount][enemiesPerScreen]; // enemies

TTF_Font *font;
Sint16 *music_mix_stream;
int music_mix_len;

void music_mix_callback(void *udata, Uint8 *stream, int len)
{
  music_mix_stream = (Sint16 *)stream;
  music_mix_len = len;
}

void setup();
void draw();

/////////////////////////////////////////////////////////////// MAIN
int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE, PWSTR pCmdLine, int nCmdShow)
{
  SDL_Surface *screen;
  SDL_Surface *dblbuf;
  int done = 0;
  int i, k;
  float ss, sa, a, s;
  int x0, y0;
  SDL_Color colors[255];
  SDL_Event event;
  Uint8 *keystate;

  /* Initialize SDL */
  if (SDL_Init(SDL_INIT_VIDEO) < 0)

  {
    fprintf(stderr, "Couldn't initialize SDL: %s\n", SDL_GetError());
    exit(1);
  }
  atexit(SDL_Quit);
  if (Mix_OpenAudio(44100, AUDIO_S16, 2, 512) < 0)

  {
    fprintf(stderr, "Couldn't initialize SDL audio: %s\n",
            SDL_GetError());
    exit(1);
  }
  Mix_Music *music = Mix_LoadMUS("data\\music.ogg");
  if (music == NULL)
    fprintf(stderr, "Couldn't load music: %s\n", Mix_GetError());

  //Mix_SetPostMix(music_mix_callback,0);
  screen = SDL_SetVideoMode(WIDTH, HEIGHT, 32, (SDL_HWSURFACE | SDL_SRCALPHA)); //|SDL_FULLSCREEN
  if (screen == NULL)

  {
    fprintf(stderr, "Couldn't init video mode: %s\n", SDL_GetError());
    exit(1);
  }
  SDL_ShowCursor(0);
  Uint32 rmask, gmask, bmask, amask;

  /* SDL interprets each pixel as a 32-bit number, so our masks must depend
       on the endianness (byte order) of the machine */
#if SDL_BYTEORDER == SDL_BIG_ENDIAN
  rmask = 0xff000000;
  gmask = 0x00ff0000;
  bmask = 0x0000ff00;
  amask = 0x000000ff;

#else /*  */
  rmask = 0x000000ff;
  gmask = 0x0000ff00;
  bmask = 0x00ff0000;
  amask = 0xff000000;

#endif /*  */
  dblbuf =
      SDL_CreateRGBSurface(SDL_SWSURFACE | SDL_SRCALPHA, WIDTH, HEIGHT, 32,
                           rmask, gmask, bmask, amask);
  if (dblbuf == NULL)

  {
    fprintf(stderr, "CreateRGBSurface failed: %s\n", SDL_GetError());
    exit(1);
  }

  ////////////////////////////////// LOAD TIMELAPSE IMAGES
  setup();
  float t = 0.0;
  float dt = 1 / 60.0f;
  float currentTime = SDL_GetTicks();
  float deltaTime = 0.0;
  printf("le main routine...\n");
  int frame = 0;
  while (!done)
  {


    //    if (!Mix_PlayingMusic()) Mix_PlayMusic(music, 0);
    float newTime = SDL_GetTicks();
    float frameTime = newTime - currentTime;
    currentTime = newTime;
    millisecs += frameTime;

    while (frameTime > 0.0f)

    {
      deltaTime = fmin(frameTime, dt);
      draw();

      SDL_BlitSurface(tilemap,NULL,screen,NULL);
      frameTime -= deltaTime;
      t += deltaTime;
    }
    SDL_Flip(screen);
    frame++;

    /* User input */
    while (SDL_WaitEvent(&event) >= 0)
    {
        switch (event.type) {
            case SDL_ACTIVEEVENT: {
                if ( event.active.state & SDL_APPACTIVE ) {
                    if ( event.active.gain ) {
                        printf("App activated\n");
                    } else {
                        printf("App iconified\n");
                    }
                }
            }
            break;
 	
    	    case SDL_KEYUP: 
	    {
		switch ( event.key.keysym.sym ) 
            	{
        	    case SDLK_ESCAPE: 
	            case SDLK_q: 
			    printf("Bye bye...\n");
			    exit(0);
                	break;
		}
	    }
	    break;

            case SDL_MOUSEBUTTONDOWN: {
                printf("Mouse button pressed\n");
            }
            break;

            case SDL_QUIT: {
                printf("Quit requested, quitting.\n");
                exit(0);
            }
            break;
        }
    }
  }
  exit(0);
}


float dt;

float st;
float et;

boolean getEditorMode()
{
  return editormode == EDITORMODE_EDIT;
}

void setupEditor()
{
  showTilemap = 1;
  showExits = -1;
  showEnemies = -1;
  gridX = 0;
  gridY = 9;
  gridW = 2;
  gridH = 3;
  Frame g;
  gridFrame = g;
  gridFrame.x = gridX;
  gridFrame.y = gridY;
  gridFrame.w = gridW;
  gridFrame.h = gridH;
  Frame e;
  enemyFrame = e;
}
void

dumpData()
{
}
void

resetScreens()
{
  for (int j = 0; j < screenCount; j++)
  {
    for (int i = 0; i < screenWidth * screenHeight; i++)
      screenBG[j][i] = 510;
    for (int i = 0; i < screenWidth * screenHeight; i++)
      screenFG[j][i] = 510;
    for (int i = 0; i < screenWidth * screenHeight; i++)
      screenBlocks[j][i] = 0;
  }
  textAlign(CENTER);
  loadScreens();
  setDefaultScreens();
  currentScreen = 0;
}
Sprite playerSprite;

void resetPlayer()
{
  playerSprite = Sprite(16, 22, 2, 3, screenStartX, screenStartY, 8);
  playerSprite.setAnimationLeft(0, 1);
  playerSprite.setAnimationRight(4, 5);
  playerSprite.setDir(prevExitDir == 2 ? 0 : prevExitDir == 1 ? 1 : 1);
  playerJumping = false;
  playerFalling = true;
  playerVSpeed = 0.0;
  playerHSpeed = 0;
}
void

resetEnemies()
{
  for (int i = 0; i < enemiesPerScreen; i++)
  {
    screenEnemies[currentScreen][i].reset();
  }
}
void

setupGame()
{
  resetScreens();
  resetPlayer();
}
void

resetGameToStart()
{
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

void setup()
{

  IMG_Init(IMG_INIT_JPG | IMG_INIT_PNG);
  tilemap = IMG_Load("data\\tilemapsmall.png");
  tilemapalpha = IMG_Load("data\\tilemapsmall_alpha.png");

  //  SDL_SetAlpha(iso1, SDL_SRCALPHA, 4);
  TTF_Init();
  font = TTF_OpenFont("data\\Shaston320.ttf", 8);
  SDL_Color fColor;
  fColor.r = fColor.g = fColor.b = 255;

  //  text1 = TTF_RenderText_Solid(font, "biflotrip", fColor);
  tilemapWidth = (int)(tilemap->w / 8);
  tilemapHeight = (int)(tilemap->h / 8);
  tiles = new SDL_Surface *[tilemapWidth * tilemapHeight];
  tilesalpha = new SDL_Surface *[tilemapWidth * tilemapHeight];
  Uint32 rmask, gmask, bmask, amask;

  /* Define masks for 32bit surface */
#if SDL_BYTEORDER == SDL_BIG_ENDIAN
  rmask = 0xff000000;
  gmask = 0x00ff0000;
  bmask = 0x0000ff00;
  amask = 0x000000ff;

#else /*  */
  rmask = 0x000000ff;
  gmask = 0x0000ff00;
  bmask = 0x00ff0000;
  amask = 0xff000000;

#endif /*  */
  for (int y = 0; y < tilemapHeight; y++)
  {
    for (int x = 0; x < tilemapWidth; x++)
    {
      SDL_Surface *tile =
          SDL_DisplayFormatAlpha(SDL_CreateRGBSurface(SDL_SWSURFACE, 8, 8, 32, rmask, gmask,
                                                      bmask, amask));
      SDL_Surface *tilealpha =
          SDL_DisplayFormatAlpha(SDL_CreateRGBSurface(SDL_SWSURFACE, 8, 8, 32, rmask, gmask,
                                                      bmask, amask));
      SDL_Rect src;
      src.x = x * 8;
      src.y = y * 8;
      src.w = 8;
      src.h = 8;
      SDL_BlitSurface(tilemap, &src, tile, NULL);
      SDL_BlitSurface(tilemapalpha, &src, tilealpha, NULL);
      tiles[(y * tilemapWidth) + x] = tile;
      tilesalpha[(y * tilemapWidth) + x] = tilealpha;
    }
  }
  //  noSmooth();
  //  frameRate(30);
  //  imageMode(CORNERS);
  setupEditor();
  setupGame();
}
void

drawTileset()
{
  sfill(0);
  noStroke();
  rect(0, 8, tilemapWidth * 8, tilemapHeight * 8);
  image(tilemap, 0, 8);
}
void

drawGrid(int x, int y, int w, int h)
{
  pushMatrix();
  sfill(0, 64);
  if (showEnemies == -1)
    stroke(0, 255, 0, 255);

  else
    stroke(0, 255, 255, 255);
  rect(x * 8, y * 8, w * 8, h * 8);
  popMatrix();
}

void drawTileNumP(int x, int y, int tnum)
{
  if (tnum == 999)
    return;
  if (x < 0)
    return;
  if (x > screenWidth - 1)
    return;
  int fnum = 510;

  // tile animations
  int yy = y;
  int xx = x;
  if ((tnum >= 103 && tnum <= 106) || (tnum >= 135 && tnum <= 138) || (tnum >= 167 && tnum <= 170) || (tnum >= 199 && tnum <= 202))
  { // red portal
    if (rand() * 10000000 >
        9415000 - abs(cos(millis() * 0.1) * 10000000))
    {
      fnum = (int)(rand() * 700);
    }

    else
      fnum = tnum;
  }
  else
  {
    fnum = tnum;
  }
  screenBG[currentScreen][(y * screenWidth) + x] = fnum;
  screenFG[currentScreen][(y * screenWidth) + x] = fnum;
}


void

drawMessage(string msgtext)
{
/*
  int lines = msgtext.split("\n").length;
  messageLength = msgtext.length();
  messageSpeed -= dt * 12.5;
  if (messageSpeed <= 0)
  {
    messageSpeed = 20;
    messageCounter++;
    if (messageCounter > messageLength)
      messageCounter = messageLength;
  }
  noStroke();
  sfill(0, 192);
  rect(0, 0, width, height);
  sfill(0);
  stroke(128);
  strokeWeight(8);
  int sh = (8 - lines) * 8;
  rect(32, 64 + sh, width - 64, height - (128 + sh * 2));
  textAlign(CENTER);
  noStroke();
  sfill(255);
  text(msgtext.substring(0, messageCounter), (width / 2),
       (height / 2) - 32);
  textAlign(LEFT);
*/
}
void

renderEditorGUI()
{
  noStroke();
  sfill(0);
  rect(0, 0, width, 8);
  sfill(255, 255);
  if (editormode == EDITORMODE_EDIT && showTilemap == 1)
  if (editormode == EDITORMODE_EDIT && showTilemap == -1)
  if (editormode == EDITORMODE_EDIT && showTilemap == -1 && showEnemies == -1)
  {
    drawFrame((int)(width / 8) - gridW, 0, gridFrame);
  }
  if (editormode == EDITORMODE_EDIT && showExits == 1 && showTilemap == -1)
  {
    sfill(255, 0, 0);
    if (currentExit == 0)
      sfill(0, 255, 0);
    text(screenExit[currentScreen].getN(), width / 2, 16);
    sfill(255, 0, 0);
    if (currentExit == 1)
      sfill(0, 255, 0);
    text(screenExit[currentScreen].getE(), width - 64, height / 2);
    sfill(255, 0, 0);
    if (currentExit == 3)
      sfill(0, 255, 0);
    text(screenExit[currentScreen].getW(), 16, height / 2);
    sfill(255, 0, 0);
    if (currentExit == 2)
      sfill(0, 255, 0);
    text(screenExit[currentScreen].getS(), width / 2, height - 16);
  }
}

boolean bgCached = false;
boolean fgCached = false;
void drawBG()
{
  for (int y = 0; y < screenHeight; y++)
  {
    for (int x = 0; x < screenWidth; x++)
    {
      drawTileNum(x, y + 1,
                  screenBG[currentScreen][(y * screenWidth) + x]);
    }
  }
}
void

drawFG()
{
  for (int y = 0; y < screenHeight; y++)
  {
    for (int x = 0; x < screenWidth; x++)
    {
      if (screenBlocks[currentScreen][(y * screenWidth) + x] == 0 && key == 'f')
        continue;
      if (screenFG[currentScreen][(y * screenWidth) + x] == 52 || screenFG[currentScreen][(y * screenWidth) + x] == 53)
        drawTileNumAlpha(x, y + 1,
                         screenFG[currentScreen][(y * screenWidth) + x]);

      else
        drawTileNum(x, y + 1,
                    screenFG[currentScreen][(y * screenWidth) + x]);
    }
  }
  if (editormode == EDITORMODE_EDIT && blockOn)
  {
    for (int y = 0; y < screenHeight; y++)
    {
      for (int x = 0; x < screenWidth; x++)
      {
        stroke(255, 0, 0);
        noFill();
        if (screenBlocks[currentScreen][(y * screenWidth) + x] == 1)
          rect(x * 8, (y + 1) * 8, 8, 8);
      }
    }
  }
}

boolean isBGTileInPos(int x, int y)
{
  if (y > screenHeight)
    return false;
  if (screenBG[currentScreen][(y * screenWidth) + x] != 510)
    return true;

  else
    return false;
}

boolean isFGTileInPos(int x, int y)
{
  if (y > screenHeight)
    return false;
  if (screenFG[currentScreen][(y * screenWidth) + x] != 510)
    return true;

  else
    return false;
}

void killPlayer()
{
  resetPlayer();
  resetEnemies();
  background(255, 0, 0);
  if (editormode == EDITORMODE_PLAY)
  {
    if (lives == 0)
      gameOver();

    else
      lives--;
    died = true;
  }
}

void gameOver()
{
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
void playerTileHitBG(int tilenum, int x, int y)
{
  if (tilenum == TILENUM_SPIKES)
  {
    killPlayer();
  }

  else if (tilenum == TILENUM_MSG1 || tilenum == TILENUM_MSG2)
  {
    showingMessage = true;
    screenBG[currentScreen][y * screenWidth + x] = 510;
    screenBG[currentScreen][y * screenWidth + (x + 1)] = 510;
    screenBG[currentScreen][(y - 1) * screenWidth + (x)] = 510;
    screenBG[currentScreen][(y - 1) * screenWidth + (x + 1)] = 510;
  }

  else if (tilenum == TILENUM_BIGHEART || tilenum == TILENUM_SMALLHEART)
  {
    screenBG[currentScreen][y * screenWidth + x] = 510;
    screenBG[currentScreen][y * screenWidth + (x + 1)] = 510;
    screenBG[currentScreen][(y - 1) * screenWidth + (x)] = 510;
    screenBG[currentScreen][(y - 1) * screenWidth + (x + 1)] = 510;
    if (tilenum == TILENUM_BIGHEART)
    {
      mana += 2;
      manaTotal += 2;
    }

    else
    {
      mana += 1;
      manaTotal += 1;
    }
    background(0, 255, 0);
    gotMana = true;
  }

  else if (tilenum == TILENUM_END && showingEnd == false)
  {
    if (manaTotal < winMana)
    {
      showingEnd = true;
      showingMessage = true;
      messageCounter = 0;
      endCount++;
      screenBG[0][(10) * screenWidth + (34)] = 92;
      screenBG[0][(10) * screenWidth + (35)] = 93;
      screenBG[0][(11) * screenWidth + (34)] = 94;
      screenBG[0][(11) * screenWidth + (35)] = 95;
    }
  }
}

void playerTileHitFG(int tilenum, int x, int y)
{
  if (tilenum == TILENUM_SPIKES)
  {
    killPlayer();
  }

  else if (tilenum == TILENUM_MSG1 || tilenum == TILENUM_MSG2)
  {
    showingMessage = true;
    screenFG[currentScreen][y * screenWidth + x] = 510;
    screenFG[currentScreen][y * screenWidth + (x + 1)] = 510;
    screenFG[currentScreen][(y - 1) * screenWidth + (x)] = 510;
    screenFG[currentScreen][(y - 1) * screenWidth + (x + 1)] = 510;
  }

  else if (tilenum == TILENUM_BIGHEART || tilenum == TILENUM_SMALLHEART)
  {
    screenFG[currentScreen][y * screenWidth + x] = 510;
    screenFG[currentScreen][y * screenWidth + (x + 1)] = 510;
    screenFG[currentScreen][(y - 1) * screenWidth + (x)] = 510;
    screenFG[currentScreen][(y - 1) * screenWidth + (x + 1)] = 510;
    if (tilenum == TILENUM_BIGHEART)
    {
      mana += 2;
      manaTotal += 2;
    }

    else
    {
      mana += 1;
      manaTotal += 1;
    }
    background(0, 255, 0);
    gotMana = true;
  }
}

int prevScreen = 0;
void exitScreenLeft()
{
  prevScreen = currentScreen;
  if (screenExit[currentScreen].w == -2)
  {
    killPlayer();
    return;
  }

  else if (screenExit[currentScreen].w == -1)
    return;

  else
    currentScreen = screenExit[currentScreen].w;
  justChangedScreen = true;
  playerSprite.wx = screenWidth - 2;
  screenStartX = (int)playerSprite.wx;
  screenStartY = (int)playerSprite.wy;
  prevExitDir = 2;
  newScreen();
}
void

exitScreenRight()
{
  prevScreen = currentScreen;
  if (screenExit[currentScreen].e == -2)
  {
    killPlayer();
    return;
  }

  else if (screenExit[currentScreen].e == -1)
    return;

  else
    currentScreen = screenExit[currentScreen].e;
  justChangedScreen = true;
  playerSprite.wx = 0;
  playerFalling = true;
  screenStartX = (int)playerSprite.wx;
  screenStartY = (int)playerSprite.wy;
  prevExitDir = 1;
  newScreen();
}
void

exitScreenTop()
{
  prevScreen = currentScreen;
  if (screenExit[currentScreen].n == -2)
  {
    killPlayer();
    return;
  }

  else if (screenExit[currentScreen].n == -1)
    return;

  else
    currentScreen = screenExit[currentScreen].n;
  justChangedScreen = true;
  playerSprite.wy = screenHeight - 1;
  playerFalling = true;
  screenStartX = (int)playerSprite.wx;
  screenStartY = (int)playerSprite.wy;
  prevExitDir = 0;
  newScreen();
}
void

exitScreenBottom()
{
  prevScreen = currentScreen;
  if (screenExit[currentScreen].s == -2)
  {
    killPlayer();
    return;
  }

  else if (screenExit[currentScreen].s == -1)
    return;

  else
    currentScreen = screenExit[currentScreen].s;
  justChangedScreen = true;
  playerSprite.wy = 1;
  playerFalling = true;
  screenStartX = (int)playerSprite.wx;
  screenStartY = (int)playerSprite.wy;
  prevExitDir = 3;
  newScreen();
}
void

newScreen()
{
  messageCounter = 0;
  if (prevScreen != currentScreen)
    resetEnemies();
  if (manaTotal >= winMana && currentScreen == 39)
  {
    screenEnemies[39][0].type = -1;
  }
}

boolean playerCheckBounds(float nx, float ny)
{
  int ii = 0;
  for (int y = 0; y < 3; y++)
  {
    for (int x = 0; x < 2; x++)
    {
      float newx = nx + x;
      float newy = ny + y;
      if (newx < -1)
      {
        exitScreenLeft();
        return false;
      }
      if (newx > screenWidth)
      {
        exitScreenRight();
        return false;
      }
      if (newy < -2)
      {
        exitScreenTop();
        return false;
      }
      if (newy > screenHeight)
      {
        exitScreenBottom();
        return false;
      }
      ii++;
      if (isFGTileInPos((int)newx, (int)(newy)))
      {
        playerTileHitFG(screenFG[currentScreen]
                                [((int)newy * screenWidth) + (int)newx],
                        (int)newx, (int)newy);
      }
      if (isBGTileInPos((int)newx, (int)(newy)))
      {
        playerTileHitBG(screenBG[currentScreen]
                                [((int)newy * screenWidth) + (int)newx],
                        (int)newx, (int)newy);
      }
    }
  }
  for (int y = 0; y < 1; y++)
  {
    for (int x = 0; x < 2; x++)
    {
      float newx = nx + (1 - x);
      float newy = ny - (y - 1);
      if (newx < -1)
        return false;
      if (newx > screenWidth)
        return false;
      if (newy < -2)
        return false;
      if (newy > screenHeight)
        return false;
      if (screenBlocks[currentScreen]
                      [((int)(newy)*screenWidth) + (int)newx] == 1)
      {
        playerFalling = true;
        return false;
      }
    }
  }
  return true;
}

void playerLeft()
{
  if (playerCheckBounds(playerSprite.wx - playerHSpeed, playerSprite.wy))
    playerSprite.wx -= playerHSpeed;
  playerSprite.setDir(0);
}

void playerRight()
{
  if (playerCheckBounds(playerSprite.wx + playerHSpeed, playerSprite.wy))
    playerSprite.wx += playerHSpeed;
  playerSprite.setDir(1);
}

void playerJump()
{
  if (playerJumping)
    return;
  playerOY = playerSprite.wy;
  playerVSpeed = 1;
  playerJumpTimer = 0;
  jumpStarting = true;
  playerJumping = true;
}

int mx, my = 0;
void playerMagic()
{
  if (mana <= 0)
    return;
  if (mx < 0)
    return;
  if (mx > screenWidth - 1)
    return;
  if (mx == pMagicX && my == pMagicY)
    return;
  if (editormode == EDITORMODE_PLAY)
  {
    mana--;
  }
  magicCoolOff = 100;
  pMagicX = mx;
  pMagicY = my;
  for (int y = my; y < my + ggh; y++)
  {
    for (int x = mx; x < mx + ggw; x++)
    {
      screenFG[currentScreen][y * screenWidth + x] = 510;
      screenBG[currentScreen][y * screenWidth + x] =
          135 + (int)(rand() * 4);
      screenBlocks[currentScreen][y * screenWidth + x] = 0;
    }
  }
  playerFalling = true;
  playerJumping = false;
}
int playerWalkSpeed = 55;

void drawPlayer()
{
  if (holdingLeft || holdingRight)
    playerSprite.animate(playerWalkSpeed, dt);
  Frame* pf;
  if (!playerJumping)
    pf = playerSprite.getAnimFrame();

  else
  {
    pf = playerSprite.getFrame(2 + playerSprite.dir * 4);
  }
  drawFrameAlpha((int)((playerSprite.wx * 8) / 8),
                 (int)((playerSprite.wy * 8) / 8), *pf);
}
void

drawEnemies()
{
  for (int i = 0; i < enemiesPerScreen; i++)
  {
    if (screenEnemies[currentScreen][i].alive)
      screenEnemies[currentScreen][i].draw();
  }
}

void renderMagic()
{
  if (winTimer > 0)
    return;
  mx = (int)playerSprite.wx;
  my = (int)playerSprite.wy - 1;
  if (!holdingDown)
  {
    if (playerSprite.dir == 0)
    {
      mx -= 1;
      ggw = 1;
      ggh = 3;
    }

    else if (playerSprite.dir == 1)
    {
      mx += 2;
      ggw = 1;
      ggh = 3;
    }
  }
  else
  {
    my += 3;
    ggw = 2;
    ggh = 1;
  }
  noFill();
  stroke(0, 255, 0);
  strokeWeight(1);
  if (mx >= 0 && mx <= screenWidth - 1)
    rect(((int)(mx)) * 8, ((int)(my + 1)) * 8, ggw * 8, ggh * 8);
}
string MsToTime(int s)
{
  int ms = s % 1000;
  s = (s - ms) / 1000;
  int secs = s % 60;
  string sec_Str = "" + secs;
  s = (s - secs) / 60;
  int mins = s % 60;
  string min_Str = "" + mins;
  int hrs = (s - mins) / 60;
  if (sec_Str.length() == 1)
    sec_Str = "0" + sec_Str;
  if (min_Str.length() == 1)
    min_Str = "0" + min_Str;
  string ms_str = "" + ms;
  if (ms_str.length() == 1)
    ms_str = "0" + ms_str;
  return hrs + ":" + min_Str + ":" + sec_Str;
}

float speedRunTime = 0;
boolean speedRunEnd = false;
void drawScreenUI()
{
  noStroke();
  sfill(0);
  rect(0, 0, width, 8);
  rect(0, height - 8, width, 8);
  sfill(255);
  textAlign(CENTER);
  text(screenName[currentScreen], (int)(width / 2) + 0.5, height - 1);
  speedTimer = millis();
  if (!speedRunEnd)
    speedRunTime = (speedTimer - speedStartTime);
  if (editormode == EDITORMODE_TEST)
    text("play test", width / 2, 8);
//  if (editormode == EDITORMODE_PLAY && !speedRunMode)
//    text("lives: " + lives + " - mana: " + mana + " (mana collected: " +
//             manaTotal + "/" + winMana + ")",
//         width / 2 + 1.5, 7);

//  else if (editormode == EDITORMODE_PLAY && speedRunMode)
//    text("speedrun mode l: " + lives + " m: " + mana + " (" + manaTotal +
//             "/" + winMana + ") [" + MsToTime((int)speedRunTime) + "]",
//         width / 2 + 1.5, 7);
  textAlign(LEFT);
}
void

drawMessages()
{
  if (showingMessage && !showingEnd && !showingGameover)
  {
    if (currentScreen == 0 && endCount == 0)
      drawMessage("Ouch! Hmm, another close escape?\nLittle do they know, that\nduring years of exhaustive study\nI had hidden away the secret\nof ancient chaos magic...\n\nPress action to corrupt world.\nYou can do this left, right & down.");

    else if (currentScreen == 0 && endCount > 0)
      drawMessage("I seem to be able to retain\nbits and pieces of memories of my\ntrips through the chaos portal.\nThe essence of magic is seeping\nthrough our reality and is\nrepresented by heart emblems.\nI must collect them all to seal\nthe portal in the Throne Room.");
    if (currentScreen == 1)
      drawMessage("\n\nSmall hearts yield 1 mana.\nBig hearts yield 2 mana.\nI can use mana for the\nchaotic corruption magic.");
    if (currentScreen == 3)
      drawMessage("\n\nAbandoned houses...\nNobody around...\nThey must have left in a hurry.\nI wonder why?");
    if (currentScreen == 23)
      drawMessage("\n\nExcerpt from The Book of Chaos\n- Will of The Corruption -\n\"It's useless to pain and ache,\ntry what forms shall Chaos take.\"");
    if (currentScreen == 39)
      drawMessage("\n\nTHE WORLD IS CHAOS.\nALL IS CHAOS.\nCONGRATULATIONS!\nYOU WIN.");
  }
  if (showingEnd)
  {
    drawMessage("And here we are again,\nat the beginning of the end.\nThe hero with a thousand faces\ncompletes another cycle\nwith minute variation.\nWe both know what must be done.\nI wonder who the real monster is\nin this endless thread of stories?");
  }
  if (showingGameover)
  {
    drawMessage("\n\nGAME OVER\nRest in peace\nRequiescat in pace\npress R or start to try again");
  }
}

void drawTileRect(int x, int y, int w, int h)
{
  for (int i = x; i < x + w; i++)
  {
    int tn = (int)(rand() * 3) + 135;
    drawTileNumP(i, y, tn);
  }
  for (int i = x; i < x + w; i++)
  {
    int tn = (int)(rand() * 3) + 135;
    drawTileNumP(i, y + h, tn);
  }
  for (int i = y; i < y + h; i++)
  {
    int tn = (int)(rand() * 3) + 135;
    drawTileNumP(x, i, tn);
  }
  for (int i = y; i < y + h; i++)
  {
    int tn = (int)(rand() * 3) + 135;
    drawTileNumP(x + w, i, tn);
  }
}
float messageTimer = 0;

void drawWin()
{
  winTimer += dt;
  float ss = winTimer * 0.02;
  drawTileRect((int)(screenWidth - 5 - ss * 1.2),
               (int)((screenHeight / 2 - 3) - ss), (int)(ss * 2),
               (int)(ss * 2));
  if (winTimer > 2000)
  {
    showingMessage = true;
    messageTimer = 0;
  }
}

void renderGame()
{
  if (!showingGameover)
  {
    drawBG();
    drawEnemies();
    drawPlayer();
    drawFG();
    if (showingWin)
      drawWin();
  }
  if (editormode != EDITORMODE_EDIT)
    renderMagic();
  drawScreenUI();
  drawMessages();
}

void keyPressed()
{
  if (key == '4')
    holdingLeft = true;
  if (key == '6')
    holdingRight = true;
  if (key == '5')
    holdingDown = true;
  if (key == '8')
    holdingJump = true;
  if (key == ' ')
    setholdingAction(1);
  if (key == 't' && editormode == EDITORMODE_EDIT)
  {
    editormode = EDITORMODE_TEST;
    showingGameover = false;
//    saveScreen();
    resetPlayer();
    mana = 1;
  }
  if (key == 't' && editormode == EDITORMODE_PLAY)
  {
    editormode = EDITORMODE_PLAY;
    showingGameover = false;
    resetGameToStart();
    speedRunMode = true;
    speedTimer = 0;
    speedStartTime = millis();
    speedRunEnd = false;
  }
  if (key == 'p' && editormode != EDITORMODE_PLAY)
  {
    editormode = EDITORMODE_PLAY;
    showingGameover = false;
    resetGameToStart();
    speedRunMode = false;
  }
  if (key == 'e' && editormode != EDITORMODE_EDIT)
  {
    editormode = EDITORMODE_EDIT;
    showingGameover = false;
//    loadScreen(false);
    resetPlayer();
    resetEnemies();
    showTilemap = -1;
  }

  else if (key == 'e' && editormode == EDITORMODE_EDIT && showTilemap == -1)
  {
    showExits = -showExits;
  }
  if (key == 'r' && editormode == EDITORMODE_PLAY)
  {
    setrestart();
    speedRunMode = false;
  }
  if (editormode == EDITORMODE_EDIT)
  {
    if (key == 'v')
    {
      showEnemies = -showEnemies;
      if (showEnemies == 1)
      {
        blockOn = false;
        showTilemap = -1;
      }
    }
    if (key == 'l')
    {
      loadScreen(true);
    }
    if (key == 's')
    {
      //saveScreen();
    }
    if (key == 'd')
    {
      dumpData();
    }
  }
  if (editormode == EDITORMODE_EDIT && showExits == -1 && showEnemies == -1)
  {
    if (key == ' ')
    {
      showTilemap = -showTilemap;
      if (showTilemap == 1)
      {
        blockOn = false;
        showEnemies = -1;
      }
    }
    if (key == 'z')
    {
      currentLayer--;
      if (currentLayer < 0)
        currentLayer = 0;
    }
    if (key == 'x')
    {
      currentLayer++;
      if (currentLayer >= layerCount - 1)
        currentLayer = layerCount - 1;
    }
    if (key == 'n')
    {
      currentScreen--;
      if (currentScreen < 0)
        currentScreen = 0;
      resetEnemies();
      newScreen();
    }
    if (key == 'm')
    {
      currentScreen++;
      if (currentScreen >= screenCount - 1)
        currentScreen = screenCount - 1;
      resetEnemies();
      newScreen();
    }
    if (key == 'b')
    {
      if (blockOn)
        blockOn = false;

      else
      {
        blockOn = true;
        showTilemap = -1;
        showEnemies = -1;
      }
    }
    if (key == 'u')
    {
//      undo();
    }
    if (key == '8')
    {
      gridY -= gridH;
      if (gridY < 1)
        gridY = 1;
    }

    else if (key == '5')
    {
      gridY += gridH;
      if (gridY + gridH > (int)(tilemap->h / 8) - 6)
        gridY = (int)(tilemap->h / 8) - 7;
    }

    else if (key == '4')
    {
      gridX -= gridW;
      if (gridX < 0)
        gridX = 0;
    }

    else if (key == '6')
    {
      gridX += gridW;
      if (gridX + gridW > (int)(tilemap->w / 8))
        gridX = (int)(tilemap->w / 8);
    }
  }

  else if (editormode == EDITORMODE_EDIT && showExits == 1)
  {
    int modval = 0;
    if (key == '8')
    {
      modval -= 1;
    }

    else if (key == '5')
    {
      modval += 1;
    }

    else if (key == '4')
    {
      currentExit--;
      if (currentExit < 0)
        currentExit = 3;
    }

    else if (key == '6')
    {
      currentExit++;
      if (currentExit > 3)
        currentExit = 0;
    }
    if (currentExit == 0)
      screenExit[currentScreen].n += modval;

    else if (currentExit == 1)
      screenExit[currentScreen].e += modval;

    else if (currentExit == 3)
      screenExit[currentScreen].w += modval;

    else if (currentExit == 2)
      screenExit[currentScreen].s += modval;
  }
  else if (editormode == EDITORMODE_EDIT && showEnemies == 1)
  {
    if (key == '5')
    {
      currentEnemyType--;
      if (currentEnemyType < -1)
        currentEnemyType = enemyTypeCount - 1;
      screenEnemies[currentScreen][currentEnemy].setStartPos(screenX,
                                                             screenY,
                                                             0);
      screenEnemies[currentScreen][currentEnemy].setEnemyType(currentEnemyType);
      screenEnemies[currentScreen][currentEnemy].alive =
          currentEnemyType != -1;
    }

    else if (key == '8')
    {
      currentEnemyType++;
      if (currentEnemyType >= enemyTypeCount)
        currentEnemyType = -1;
      screenEnemies[currentScreen][currentEnemy].setStartPos(screenX,
                                                             screenY,
                                                             0);
      screenEnemies[currentScreen][currentEnemy].setEnemyType(currentEnemyType);
      screenEnemies[currentScreen][currentEnemy].alive =
          currentEnemyType != -1;
    }

    else if (key == '4')
    {
      currentEnemy--;
      if (currentEnemy < 0)
        currentEnemy = enemiesPerScreen - 1;
    }

    else if (key == '6')
    {
      currentEnemy++;
      if (currentEnemy >= enemiesPerScreen)
        currentEnemy = 0;
    }
  }
}

void keyReleased()
{
  if (key == '8')
    holdingJump = false;
  if (key == ' ')
    setholdingAction(0);
  if (key == '4')
    holdingLeft = false;
  if (key == '6')
    holdingRight = false;
  if (key == '5')
    holdingDown = false;
}


void loadScreens()
{
  for (int i = 0; i < screenCount; i++)
  {
    currentScreen = i;
    loadScreen(false);
  }
}
void

loadScreen()
{
  loadScreen(true);
}
void

loadScreen(boolean verbose)
{
  int iter = 0;
  int iter2 = 0;
  int iter3 = 0;

  /*
       if (localStorage["scrdata"+currentScreen+".dat"] == null) return;
     */
  return;

  /*
       
       string lines[] = loadstrings("scrdata"+currentScreen+".dat");
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

void saveScreen()
{
}

void addCurrentBlock()
{
}
boolean collectedMana()
{
  if (gotMana)
  {
    gotMana = false;
    return true;
  }
  return false;
}

boolean didDie()
{
  if (died)
  {
    died = false;
    return true;
  }
  return false;
}

void setrestart()
{
  if (showingGameover)
  {
    showingGameover = false;
  }
  resetGameToStart();
}

boolean setholdingJump(int on)
{
  if (on == 0)
  {
    holdingJump = false;
  }
  if (on == 1 && !showingMessage && messageCoolOff == 0)
  {
    holdingJump = true;
    if (playerJumping || playerFalling || showingMessage)
      return false;
    return true;
  }
  else if (on == 1 && (showingMessage || showingEnd))
  {
    if (messageCounter < messageLength && !showingEnd && !showingWin && !showingGameover)
    {
      messageCounter = messageLength;
      messageCoolOff = 50;
      return false;
    }

    else if (messageCounter == messageLength)
    {
      if (messageCoolOff == 0)
      {
        showingMessage = false;
        if (showingEnd)
        {
          showingEnd = false;
          currentScreen = 0;
          messageCounter = 0;
          resetPlayer();
          playerSprite.wx = 2;
          playerSprite.wy = 8;
        }
        messageCoolOff = 50;
        return false;
      }
    }
  }
  return false;
}

boolean setholdingAction(int on)
{
  if (on == 0)
    holdingAction = false;
  if (on == 1 && !showingMessage && messageCoolOff == 0)
  {
    holdingAction = true;
    if (playerJumping || playerFalling || showingMessage || mana == 0)
      return false;
    return true;
  }
  else if (on == 1 && (showingMessage || showingEnd))
  {
    if (messageCounter < messageLength && !showingEnd && !showingWin && !showingGameover)
    {
      messageCounter = messageLength;
      messageCoolOff = 50;
      return false;
    }

    else if (messageCounter == messageLength)
    {
      if (messageCoolOff == 0)
      {
        showingMessage = false;
        if (showingEnd)
        {
          showingEnd = false;
          currentScreen = 0;
          resetPlayer();
        }
        messageCoolOff = 50;
        return false;
      }
    }
  }
  return false;
}

void setholdingLeft(int on)
{
  if (on == 0)
    holdingLeft = false;
  if (on == 1)
    holdingLeft = true;
}

void setholdingRight(int on)
{
  if (on == 0)
    holdingRight = false;
  if (on == 1)
    holdingRight = true;
}

void setholdingDown(int on)
{
  if (on == 0)
    holdingDown = false;
  if (on == 1)
    holdingDown = true;
}

void inputHandler()
{
  if (editormode == EDITORMODE_EDIT && showTilemap == 1)
  {
    if (mousePressed == true)
    {
      gridX = (int)((mouseX / 2) / 8);
      gridY = (int)((mouseY / 2) / 8);
      if (gridY <= 0)
        gridY = 1;
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
  gridFrame.y = gridY - 1;
  gridFrame.w = gridW;
  gridFrame.h = gridH;
  pScreenX = screenX;
  pScreenY = screenY;
  screenX = (int)((mouseX / 2) / 8);
  screenY = (int)((mouseY / 2) / 8);
  if (screenY <= 0)
    screenY = 1;
  if (screenY >= screenHeight)
    screenY = screenHeight;
  if (editormode == EDITORMODE_EDIT && showTilemap != 1 && showEnemies == -1)
  {
    if (pScreenX != screenX)
      addedBlock = false;
    if (pScreenY != screenY)
      addedBlock = false;
    if (mousePressed == true && addedBlock == false && mouseButton == LEFT)
    {
      addCurrentBlock();
      addedBlock = true;
    }
    else if (mousePressed == true && mouseButton == RIGHT)
    {
    }
    if (mousePressed == false)
    {
      addedBlock = false;
    }
  }
}

void renderEditor()
{
  if (editormode == EDITORMODE_EDIT)
  {
    if (showTilemap == 1)
    {
      drawTileset();
      drawGrid(gridX, gridY, gridW, gridH);
    }

    else
    {
      if (showEnemies == -1)
        drawFrame(screenX, screenY, gridFrame);

      else
      {
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

void playerPhysics()
{
  playerHSpeed = dt * 0.035;
  if (playerSprite.wy < 0 && screenExit[currentScreen].n == -1)
  {
    playerJumping = false;
    playerFalling = true;
    playerGrounded = false;
  }
  if (holdingLeft && !showingMessage)
    playerLeft();

  else if (holdingRight && !showingMessage)
    playerRight();
  if (holdingJump && playerGrounded && !playerJumping && !showingMessage)
    playerJump();
  if (playerJumping)
  {
    playerGrounded = false;
    holdingJump = false;
    float slowJump = 0;
    if (playerJumpTimer > 3 && playerJumpTimer < 3.5)
      slowJump = (playerJumpTimer - 3) * 0.5;
    playerVSpeed = dt * (0.055 - slowJump);
    if (playerJumpTimer >= 3.5 && playerJumpTimer < 4)
      playerVSpeed = 0;
    playerSprite.wy -= playerVSpeed;
    playerJumpTimer += dt * 0.055;
    if (playerJumpTimer > 4)
    {
      holdingJump = false;
      playerFalling = true;
      playerJumping = false;
    }
  }
  if (currentScreen == 39 && playerSprite.wx > 30 && manaTotal >= winMana && !showingWin)
  {
    showingWin = true;
    speedRunEnd = true;
    background(255, 255, 255);
  }
  if (holdingAction && !playerJumping && !playerFalling && magicCoolOff == 0)
  {
    playerMagic();
    holdingAction = false;
  }
  if (magicCoolOff > 0)
    magicCoolOff -= dt * 0.95;
  if (magicCoolOff < 0)
    magicCoolOff = 0;
  if (messageCoolOff > 0)
    messageCoolOff -= dt * 0.95;
  if (messageCoolOff < 0)
    messageCoolOff = 0;
  if (playerFalling == false && !playerJumping)
  {
    playerVSpeed = 0;
    if (playerCheckBounds(playerSprite.wx, playerSprite.wy) && (holdingLeft || holdingRight))
    {
      playerFalling = true;
      playerVSpeed = 0.5;
    }
  }
  else if (playerFalling == true && !playerJumping)
  {
    playerGrounded = false;
    if (playerCheckBounds(playerSprite.wx, playerSprite.wy + playerVSpeed))
    {
      playerSprite.wy += playerVSpeed;
      if (playerVSpeed < 3)
        playerVSpeed += 0.004 * dt;
    }

    else
    {
      playerGrounded = true;
      if (!justChangedScreen)
        playerFalling = false;
      justChangedScreen = false;
    }
  }
}

void enemyPhysics()
{
  for (int i = 0; i < enemiesPerScreen; i++)
  {
    if (screenEnemies[currentScreen][i].alive && screenEnemies[currentScreen][i].type != -1)
    {
      screenEnemies[currentScreen][i].tick(dt);
      if (playerSprite.wx + 1 >=
              screenEnemies[currentScreen][i].sprite->wx &&
          playerSprite.wx <=
              screenEnemies[currentScreen][i].sprite->wx +
                  screenEnemies[currentScreen][i].tw)
      {
        if (playerSprite.wy + 1 >=
                screenEnemies[currentScreen][i].sprite->wy &&
            playerSprite.wy <=
                screenEnemies[currentScreen][i].sprite->wy +
                    screenEnemies[currentScreen][i].th)
        {
          if (!screenEnemies[currentScreen][i].corrupting)
            killPlayer();
        }
      }
    }
  }
}

void physics()
{
  if (editormode == EDITORMODE_EDIT)
    return;
  if (!showingGameover && !showingWin)
  {
    playerPhysics();
    if (!showingMessage)
      enemyPhysics();
  }
}

void draw()
{
  printf("draw()\n");
  st = millis();
  background(0);
  beginDraw();
  background(0);
  inputHandler();
  physics();
  renderGame();
  renderEditor();
  endDraw();
  et = millis();
  speedTimer += (et - st);
  dt = 8;
}

void
setDefaultScreens()
{
	for (int i=0;i<screenCount;i++) {
		RoomExit e = RoomExit(
				screenExits[i][0],
				screenExits[i][1],
				screenExits[i][2],
				screenExits[i][3]);

		screenExit[i] = e;
	}
}
