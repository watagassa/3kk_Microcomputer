import processing.serial.*;
import cc.arduino.*;
Arduino arduino;

PFont myFont;
int OnOffPin = 3;

boolean OnOffState = false;

void setup() {
  size(640, 480);
  arduino = new Arduino (this, "/dev/cu.usbserial-14P54818");
  frameRate (30);
  arduino.pinMode(OnOffPin, Arduino.OUTPUT);
  arduino.digitalWrite(OnOffPin, Arduino.LOW);
}

void draw() {
  myFont = loadFont("CourierNewPSMT-48.vlw");
  textFont (myFont, 30);

}
void mousePressed(){
   // Pin 0 の状態をトグル
  OnOffState = !OnOffState; // 現在の状態を反転
  if (OnOffState) {
    arduino.digitalWrite(OnOffPin, Arduino.HIGH);
  } else {
    arduino.digitalWrite(OnOffPin, Arduino.LOW);
  }
}
