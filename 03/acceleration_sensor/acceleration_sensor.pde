import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
PFont myFont;
int usePin0 = 0;
int usePin1 = 1;
int usePin2 = 2;

String label0 = "array0";
String label1 = "array1";
String label2 = "array2";

int[] array0 = new int[0];
int[] array1 = new int[0];
int[] array2 = new int[0];

int inputX, inputY, inputZ;

void setup() {
  size(640, 480);
  arduino = new Arduino (this, "/dev/cu.usbserial-14P54818");
  frameRate (30);
}

void draw() {
  myFont = loadFont("CourierNewPSMT-48.vlw");
  textFont (myFont, 30);
  inputX = arduino.analogRead(usePin0);
  inputY = arduino.analogRead(usePin1);
  inputZ = arduino.analogRead(usePin2);
  
  background(120);
  fill(255);
  text("x = " + inputX, 15, 30);
  text("y = " + inputY, 15, 60);
  text("z = " + inputZ, 15, 90);

  noStroke();
  rect(235, 10, inputX / 4, 20);
  rect(235, 40, inputY / 4, 20);
  rect(235, 70, inputZ / 4, 20);

  stroke(255, 0, 0);
  line(235, 5, 235, 125);
  line(490, 5, 490, 125);
}
