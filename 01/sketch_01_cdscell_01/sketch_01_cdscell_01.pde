// writeFile
import processing.serial.*;
import cc.arduino.*;

// 変数定義
Arduino arduino;
PFont myFont;
int usePin0 = 0;
int input0;

// 初期設定
void setup() {
  size(400, 200);
  arduino = new Arduino (this, "/dev/cu.usbserial-14P54818");
  myFont = loadFont("CourierNewPSMT-48.vlw");
  textFont (myFont, 30);
  frameRate (30);
}
// ウィンドウ描写
void draw() {
  background(120);
  fill(255);
  input0 = arduino.analogRead(usePin0);
  text("Ain-OuFu" + input0, 15, 30);
}
