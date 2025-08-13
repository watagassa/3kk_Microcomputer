import processing.serial.*;
import cc.arduino.*;
Arduino arduino1,arduino2;

PFont myFont;
int OnOffPin = 3;
int DirPin = 5;
int X_PIN = 0;
int Y_PIN = 1;
int inputX, inputY;

boolean OnOffState = false;
boolean DirState = false;
boolean prevOnOffState = false;
boolean prevDirState = false;

void setup() {
  size(640, 480);
  myFont = loadFont("CourierNewPSMT-48.vlw");
  arduino1 = new Arduino (this, "/dev/cu.usbserial-14P54818");
  arduino2 = new Arduino (this, "/dev/cu.usbserial-14P50267");
  frameRate (30);
  arduino1.pinMode(OnOffPin, Arduino.OUTPUT);
  arduino1.pinMode(DirPin, Arduino.OUTPUT);
  arduino2.pinMode(X_PIN, Arduino.INPUT);
  arduino2.pinMode(Y_PIN, Arduino.INPUT);
  // 初期状態で両方のピンをLOWに設定
  arduino1.digitalWrite(OnOffPin, Arduino.LOW);
  arduino1.digitalWrite(DirPin, Arduino.LOW);
}

void draw() {
   background(255);
   fill(0); 
  textFont (myFont, 30);
  inputX = arduino2.analogRead(X_PIN);
  inputY = arduino2.analogRead(Y_PIN);
  text("x = " + inputX, 15, 30);
  text("y = " + inputY, 15, 70);
  // X軸が傾いているなら水平ではない
  
  if(inputX < 400){
     text(">",15,100);
  }else if(inputX > 600){
     text("<",15,100);
  }else if(inputY < 400){
     OnOffState = true;
     DirState = true;
     text("^",15,100);
  }else if(inputY > 600){
    OnOffState = true;
    DirState = false;
     text("V",15,100);
  } else if(inputY < 550 && inputY > 450){
    OnOffState = false;
    DirState = false;
  }
  
    if (OnOffState && OnOffState!=prevOnOffState) {
      arduino1.digitalWrite(OnOffPin, Arduino.HIGH);
    }else if(!OnOffState){
      arduino1.digitalWrite(OnOffPin, Arduino.LOW);
    }
    if (DirState && DirState!= prevDirState) {
      arduino1.digitalWrite(DirPin, Arduino.HIGH);
    } else if(!DirState){
      arduino1.digitalWrite(DirPin, Arduino.LOW);
    }
    
    prevOnOffState = OnOffState;
    prevDirState = DirState;
    delay(10);
}
