// writeFile
// command + T でコード整形できる
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
int natCount = 0;

int[] arrayValue = {350, 460, 517, 579};
int count = 0;


void setup() {
  size(800, 500);
  // arduino = new Arduino (this, "/dev/cu.usbserial-14P54818");
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

  ////ここからコピペして使える
  text(mouseX, 0, 340);
  text(mouseY, 0, 380);
  //長さが変わる線
  rect(0, 390, mouseX, 10);
  float amt = float(mouseX) / width;
  text(lerp(0, 255, amt), 0, 430);
  input0 = mouseX;
  //
  // input0 = arduino.analogRead(usePin0);
  // 座標15,30に文字表示
  text("Ain-OuFu" + input0, 15, 30);
  noStroke(); //図形の枠線非表示
  // 座標235,10に長方形を描写
  rect (235, 10, input0/4, 20);
  // 線の色を緑に
  stroke (255, 0, 0);
  // 垂直線を引く
  line (235, 5, 235, 125);
  line (490, 5, 490, 125);
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
  count = natCounter(input0, arrayValue,count);
  text("count = "+ count, 100, 100);
}

// natの数を数える関数
int natCounter(int input, int[] natValues ,int prevCount) {

  for (int i=1; i<natValues.length-1; i++) {
    int diff0 = (natValues[i] - natValues[i - 1]) / 3;
    int diff1 = (natValues[i+1] - natValues[i]) / 3;
    // natValues[i] +- diff　の区間以外が不感帯
    if (input > natValues[i] - diff0 && input < natValues[i] + diff1) {
      text(natValues[i] - diff0 +"   "+ (natValues[i]+diff1) +"   "+ diff0 + " " + diff1, 300, 400);
      return i;
    }
  }
    int diffS = (natValues[0] - natValues[1]) / 3;
    int diffE = (natValues[natValues.length-1] - natValues[natValues.length-2]) / 3;
  //  最後だけはfor文から抜け出す
  if(input < natValues[0] - diffS){
    return 0;
  }
  if(input > natValues[natValues.length-1] - diffE){
    return natValues.length-1;
  }
  // 不感帯の場合は前の入力が戻り値
  return prevCount;
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
