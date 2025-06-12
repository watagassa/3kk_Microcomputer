import processing.serial.*;
import cc.arduino.*;
Arduino arduino;

PFont myFont;
int OnOffPin = 3;
int DirPin = 5;

boolean OnOffState = false;
boolean DirState = false;

void setup() {
  size(640, 480);
  arduino = new Arduino (this, "/dev/cu.usbserial-14P54818");
  frameRate (30);
  arduino.pinMode(OnOffPin, Arduino.OUTPUT);
  arduino.pinMode(DirPin, Arduino.OUTPUT);
  // 初期状態で両方のピンをLOWに設定
  arduino.digitalWrite(OnOffPin, Arduino.LOW);
  arduino.digitalWrite(DirPin, Arduino.LOW);
}

void draw() {
  myFont = loadFont("CourierNewPSMT-48.vlw");
  textFont (myFont, 30);
}
void mousePressed() {
  // On Offの切り替え
  if (mouseButton == LEFT) {
    OnOffState = !OnOffState;
    if (OnOffState) {
      arduino.digitalWrite(OnOffPin, Arduino.HIGH);
    } else {
      arduino.digitalWrite(OnOffPin, Arduino.LOW);
    }
  }
  // 電流の方向の切り替え
  if (mouseButton == RIGHT) {
    DirState = !DirState;
    if (DirState) {
      arduino.digitalWrite(DirPin, Arduino.HIGH);
    } else {
      arduino.digitalWrite(DirPin, Arduino.LOW);
    }
  }
  
}
