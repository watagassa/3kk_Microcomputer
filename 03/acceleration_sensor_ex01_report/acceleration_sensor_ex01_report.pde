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

// o の座標
float posX, posY;

void setup() {
  size(640, 480);
  arduino = new Arduino (this, "/dev/cu.usbserial-14P54818");
  frameRate (30);
  // 初期位置を画面中央に
  posX = width / 2;
  posY = height / 2;
}

void draw() {
  myFont = loadFont("CourierNewPSMT-48.vlw");
  textFont (myFont, 30);
  inputX = arduino.analogRead(usePin0);
  inputY = arduino.analogRead(usePin1);
  inputZ = arduino.analogRead(usePin2);

  // o を描画
  posX = width / 2 -(inputX - 512)/2;
  posY = height / 2 + (inputY  - 512)/2;
  ellipse(posX, posY, 10, 10);
  line(width / 2 - 10, height / 2, width / 2 + 10, height / 2);
  line(width / 2, height / 2 - 10, width / 2, height / 2 + 10);
}
