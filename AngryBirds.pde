 //<>//
import de.voidplus.leapmotion.*;

import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.callbacks.ContactListener;
import org.jbox2d.callbacks.ContactImpulse;

// A reference to our box2d world
Box2DProcessing box2d;
// Leap motion control
LeapMotion leapMotion;

// Game scene
Scene scene;

// Resources
PImage imgCatapultLeft;
PImage imgCatapultRight;
  
PImage imgOpenHand;
PImage imgCloseHand;

PImage imgWoodH;
PImage imgWoodV;

PImage imgRedBird;
  
PImage imgPig;
PImage imgPigDying;
    
boolean fullScreen = false;

void setup()
{
  fullScreen(P2D);
  //size(1000,800);
  smooth();
  
  leapMotion = new LeapMotion(this);

  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.listenForCollisions();
  box2d.setGravity(0, -20);
  
  imgOpenHand = loadImage("handcursor_open.png");
  imgCloseHand = loadImage("handcursor_close.png");
  
  imgCatapultLeft = loadImage("catapult_left.png");
  imgCatapultRight = loadImage("catapult_right.png");
  
  imgWoodH = loadImage("wood_h.png");
  imgWoodV = loadImage("wood_v.png");
  imgRedBird = loadImage("redbird.png");
  imgPig = loadImage("pig.png");
  imgPigDying = loadImage("pig_dying.png");

  // Initialize the game scene
  scene = new Scene();

  scene.addBox(new Wood(width / 2, height - 150, 30, 300));
  scene.addBox(new Wood(width / 2 + 200, height - 150, 30, 300));
  scene.addBox(new Wood(width / 2 + 100, height - 300 - 15, 30 + 400, 30));

  scene.addBox(new Wood(width / 2 + 20, height - 300 - 80, 30, 160));
  scene.addBox(new Wood(width / 2 + 20 + 160, height - 300 - 80, 30, 160));
  scene.addBox(new Wood(width / 2 + 20 + 80, height - 300 - 160 - 15, 160, 30));

  scene.addPig(new NormalPig(width / 2 + 100, height - 30));
  scene.addPig(new NormalPig(width / 2 + 100, height - 300 - 15 - 30));
  scene.addPig(new NormalPig(width / 2 + 200 + 80, height - 30));

  int numOfBirds = 3;
  for(int i = 0; i < numOfBirds; i++){
    RedBird b = new RedBird();
    scene.addBird(b);
  }
  
}

void draw() {
  background(255);
  scene.onDraw();
}

void mouseDragged()
{
  scene.onCursorDragged(mouseX, mouseY);
}

void mouseReleased()
{
  scene.onCursorReleased(mouseX, mouseY);
}

void beginContact(Contact contact) { /* handle begin event */ }
void endContact(Contact contact) { /* handle end event */ }
void preSolve(Contact contact, Manifold oldManifold) { /* handle end event */ }

void postSolve(Contact contact, ContactImpulse impulse)
{
  HitBody bodyA = (HitBody)contact.getFixtureA().getBody().getUserData();
  HitBody bodyB = (HitBody)contact.getFixtureB().getBody().getUserData();
  if(bodyA != null && bodyA.m_enableCollision) bodyA.onImpulseCollision(impulse);
  if(bodyB != null && bodyB.m_enableCollision) bodyB.onImpulseCollision(impulse);
}
  
void leapOnInit() { /*Leap Motion Init*/ }
void leapOnConnect() { /*Leap Motion Connect*/ }
void leapOnFrame() { /*Leap Motion Frame*/ }
void leapOnDisconnect() { /*Leap Motion Disconnect*/ }
void leapOnExit() { /*Leap Motion Exit*/ }
