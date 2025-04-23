// writeFile
import processing.serial.*;
import cc.arduino.*;

// 変数定義
Arduino arduino;
PFont myFont;
int usePin0 = 0;
String label0 = "array0";
int[] array0 = new int[0];
int input0;
boolean isRecording = false;
// 光センサの読み取り値が高いか低いか
boolean isHigh = false;

void setup() {
  size(800, 500);
  arduino = new Arduino (this, "/dev/cu.usbserial-14P54818");
  myFont = loadFont("CourierNewPSMT-48.vlw");
  textFont (myFont, 30);
  frameRate (30);
}

void draw() {
  background(120);
  fill(255);
  input0 = arduino.analogRead(usePin0);
  text("Ain-OuFu" + input0, 15, 30);
  // 不感帯を実装
  if (input0 >= 600) {
    isHigh = true;
  } else if (input0 <= 400) {
    isHigh = false;
  }
  // 画面に「bright」「dark」表示
  if (isHigh == true) {
    text("bright", 60, 240);
  } else {
    text("dark", 60, 240);
  }
}
