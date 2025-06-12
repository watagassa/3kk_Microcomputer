import processing.serial.*;
import cc.arduino.*;
Arduino arduino;

PFont myFont;
int usePin0 = 0;
int usePin1 = 1;
int usePin2 = 2;

int inputX, inputY, inputZ;
int[] inputArr = new int[3];
boolean[] isFastArr = new boolean[2];
int[] fastFCArr = new int[3];
int stopFC=0;
// o の座標
float posX, posY;
float[] posArr = new float[2];
int[] inputPM = new int[]{1, -1};


void setup() {
  size(640, 480);
  arduino = new Arduino (this, "/dev/cu.usbserial-14P54818");
  frameRate (30);
  // 初期位置を画面中央に
  posX = width / 2;
  posY = height / 2;
  posArr = new float[]{width / 2, height / 2};
}

void draw() {
  myFont = loadFont("CourierNewPSMT-48.vlw");
  textFont (myFont, 30);
  inputX = arduino.analogRead(usePin0);
  inputY = arduino.analogRead(usePin1);
  inputZ = arduino.analogRead(usePin2);
  //
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

  // 800以上か200以下の値を検出した場合，その方向に動かす
  // 動きを検知したあと，0.5秒間はその方向に動かない(重複と揺り戻し対策)
  // 5秒動きを検知しない場合，円が初期位置に戻る
  inputArr = new int[]{inputX, inputY};
  for (int i=0; i<inputArr.length; i++) {

    if (inputArr[i] > 800 && isFastArr[i] == false && fastFCArr[i]==0) {
      isFastArr[i] = true;
      posArr[i] = posArr[i] + 20*inputPM[i];
    }
    if (inputArr[i] < 200 && isFastArr[i] == false && fastFCArr[i]==0) {
      isFastArr[i] = true;
      posArr[i] = posArr[i] - 20*inputPM[i];
    }

    // 一度動きを検知すると，15fのインターバルで検知しない
    if (isFastArr[i]) {
      fastFCArr[i]++;
    }
    if (fastFCArr[i] >= 15) {
      fastFCArr[i] = 0;
      isFastArr[i] = false;
    }
    
    // 動きを検知すると，インターバルをリセット
    for (boolean b : isFastArr) {
      if (b) {
        stopFC = 0;
        break;
      }
    }
    // 5秒以上動きを検知していない場合，円を中央に描写
    stopFC++;
    if (stopFC >= 30*5) {
      stopFC = 0;
      posArr = new float[]{width / 2, height / 2};
    }
  }
  text(stopFC, 10, 120);
  ellipse(posArr[0], posArr[1], 20, 20);
}
