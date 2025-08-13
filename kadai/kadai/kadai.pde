import processing.serial.*;

Serial myPort;      // シリアルポート
String val = "";    // 読み取った値

void setup() {
  size(400, 200);
  println(Serial.list());  // 利用可能なポート一覧を表示
  String portName = Serial.list()[0];  // 適切なポート番号に変更する（例: [1]や[2]など）
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');  // 改行まで読み取る
}

void draw() {
  background(255);
  fill(0);
  textSize(32);
  text("音センサの値: " + val, 20, 100);
}

void serialEvent(Serial myPort) {
  val = myPort.readStringUntil('\n');
  val = trim(val);  // 改行を除去
}
