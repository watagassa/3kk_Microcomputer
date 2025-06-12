import processing.serial.*;
import cc.arduino.*;

// 変数定義
Arduino arduino;
PFont myFont;
int usePin0 = 0; // 焦電センサのピン
int ledPin = 13; // LEDのピン(arduinoの左端と連動)
int input0;
boolean isMove = false; // 動きを検知したかどうか
boolean ledOn = false;
int fc = 0; // フレーム数を数える

// csv保存用
String label0 = "array0";
int[] array0 = new int[0];
boolean isRecording = false;


void setup() {
  size(800, 500);
  arduino = new Arduino (this, "/dev/cu.usbserial-14P54818");
  myFont = loadFont("CourierNewPSMT-48.vlw");
  textFont (myFont, 30);
  frameRate (30);
}
// キーボードでテストできる
// inputされているアナログ入力変数をmouseに置き換える
//
void draw() {
  // グレー(120)
  background(120);
  // 白で塗りつぶし
  fill(255);

  input0 = arduino.analogRead(usePin0);
  arduino.pinMode(ledPin, Arduino.OUTPUT); // ピンを出力に使う

  // 不感帯等
  if (input0 > 700) {
    isMove = true;
    ledOn = true;
    arduino.digitalWrite(ledPin, Arduino.HIGH);
  }
  if (500 > input0) {
    isMove = false;
  }

  // フレームレートの2倍(2秒)
  if (fc <= 60 && ledOn) {
    fc++;
    text("ledPinisHIGH", 0, 400);
  } else {
    arduino.digitalWrite(ledPin, Arduino.LOW);
    ledOn = false;
    fc = 0;
  }


  // 座標15,30に文字表示
  text("pyroelectric = " + input0, 15, 30);
  if (isRecording) {
    // 入力値の記録
    array0 = append(array0, input0);
    text("Recording...", 40, 180);
    text ("Press any key to End Recording", 40, 210);
    if (second() % 2 == 1) {
      fill(255, 0, 0);
      // 楕円 = ellipse 直径9*9
      ellipse(25, 170, 9, 9);
    }
  } else {
    // 記録中でないときは使い方を表示
    text("Press Esc_key_to_Exit", 40, 180);
    text("Press_any_key_to_Record", 40, 210);
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
    String filename = "Rec_"+ year() + nf(month(), 2) + nf(day(), 2) + "_" +nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2) + ".csv";
    // ファイルの書き出し
    saveStrings (filename, lines);
    // 初期化
    array0 = expand (array0, 0);
    isRecording = false;
  } else {
    // 記錄開始
    isRecording = true;
  }
}
