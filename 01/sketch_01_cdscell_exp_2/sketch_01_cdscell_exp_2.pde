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
  noStroke();
  rect (235, 10, input0/4, 20);
  stroke (255, 0, 0);
  line (235, 5, 235, 125);
  line (490, 5, 490, 125);
  if (isRecording) {
    // 入力値の記録
    array0 = append(array0, input0);
    text("Recording...", 40, 180);
    text ("Press any key to End Recording", 40, 210);
    if (second() % 2 == 1) {
      fill(255, 0, 0);
      ellipse(25, 170, 9, 9);
    }
  } else {
    // 記録中でないときは使い方を表示
    text("Press Esc_key_to_Exit", 40, 180);
    text("Press_any_key_to_Record", 40, 210);
  }
  // 不感帯を実装
  if (input0 >= 700) {
    isHigh = true;
  } else if (input0 <= 500) {
    isHigh = false;
  }
  // 画面に「bright」「dark」表示
  if (isHigh == true) {
    text("bright", 60, 240);
  } else {
    text("dark", 60, 240);
  }
}

void keyPressed() {
  if (isRecording) {
    // CSV ファイルの内容を作成
    String[] lines = new String[array0.length + 1];
    lines[0] = "Steps," + label0;
    for (int i = 0; i < array0.length; i++) {
      lines[i+1] = (i+1) + "," + array0[i];
    }
    // ファイル名の作成
    String filename = "Rec_" + year() + nf(month(), 2) + nf(day(), 2) + "_" +nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2) + ".csv";
    // ファイルの書き出し
    saveStrings (filename, lines);
    // 初期化
    array0 = expand(array0, 0);
    isRecording = false;
  } else {
    // 記錄開始
    isRecording = true;
  }
}
