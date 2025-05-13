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

boolean isRecording = false;

void setup() {
  size(640, 480);
  //arduino = new Arduino (this, "/dev/cu.usbserial-14P54818");
  frameRate (30);
  // 初期位置を画面中央に
  posX = width / 2;
  posY = height / 2;
}

void draw() {
  myFont = loadFont("CourierNewPSMT-48.vlw");
  textFont (myFont, 30);
  //inputX = arduino.analogRead(usePin0);
  //inputY = arduino.analogRead(usePin1);
  //inputZ = arduino.analogRead(usePin2);

  //ここからコピペして使える
  inputX = mouseX * 1024 / width;
  inputY = mouseY *1024 / height;
  inputZ = mouseY *1024 / width;
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
  int dx = 0;
  int dy = 0;

  if (inputX < 400) {
    dx = dx - 10;
  }

  if (600 < inputX) {
    dx = dx + 10;
  }

  if (inputY < 400) {
    dy = dy - 10;
  }

  if (600 < inputY) {
    dy = dy + 10;
  }

  if (inputX>400 && 600>inputX && inputY>400 && 600>inputY) {
    posX = width / 2;
    posY = height / 2;
  }

  // o を描画
  posX = posX +dx;
  posY = posY +dy;
  ellipse(posX, posY, 10, 10);

  if (isRecording) {
    // 入力値の記録
    array0 = append(array0, inputX);
    array1 = append(array1, inputY);
    array2 = append(array2, inputZ);
    text("Recording...", 40, 180);
    text("Press any key to End Recording", 40, 210);
    if (second() % 2 == 1) {
      fill(255, 0, 0);
      ellipse(25, 170, 9, 9);
    }
  } else {
    // 録画していないときの表示
    text("Press ESC key to Exit", 40, 180);
    text("Press any key to Record", 40, 210);
  }
}

void keyPressed() {
  if (isRecording) {
    // 記録終了 → CSVファイルの内容を作成
    String[] lines = new String[array0.length + 1];
    lines[0] = "Steps," + label0 + "," + label1 + "," + label2;
    for (int i = 0; i < array0.length; i++) {
      lines[i + 1] = (i + 1) + "," + array0[i] + "," + array1[i] + "," + array2[i];
    }

    // CSVファイル書き出し
    saveStrings("recorded_data.csv", lines);

    // 初期化
    array0 = expand(array0, 0);
    array1 = expand(array1, 0);
    array2 = expand(array2, 0);
    isRecording = false;
  } else {
    // 記録開始
    isRecording = true;
  }
}
