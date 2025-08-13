import processing.serial.*;
import cc.arduino.*;

Arduino arduino;

PFont myFont;

int[] waveform = new int[640];  // 横640ピクセル分の波形データを保持

void setup() {
  size(640, 480);

  println(Arduino.list());
  arduino = new Arduino(this, "/dev/cu.usbserial-14P54821");

  frameRate(60);  // 波形更新速度（なるべく速く）

  myFont = loadFont("CourierNewPSMT-48.vlw");
  textFont(myFont, 16);
}

void draw() {
  background(255);

  // 新しい音センサの値（0〜1023）
  int sensorValue = arduino.analogRead(7);

  // 配列を1つずつ左にシフトして最新値を右端に追加
  for (int i = 0; i < waveform.length - 1; i++) {
    waveform[i] = waveform[i + 1];
  }
  waveform[waveform.length - 1] = sensorValue;

  // 波形を描画
  stroke(0);
  noFill();
  beginShape();
  for (int x = 0; x < waveform.length; x++) {
    float y = map(waveform[x], 0, 1023, height, 0);  // 上が大きな音
    vertex(x, y);
  }
  endShape();

  // 現在値を表示
  fill(0);
  text("sensor:" + sensorValue, 10, height - 20);
}
