
float[] buttonX = { 50, 140, 230, 320 };
float buttonY = 240;
float buttonW = 80;
float buttonH = 40;

void buttonUI() {
  // 数字を表示

  text("kind = "+sensorKind[sensorIndex], 400,300);
  // ボタンを描画
  textSize(20);
  for (int i = 0; i < 4; i++) {
    fill(200);
    rect(buttonX[i], buttonY, buttonW, buttonH, 10);
    fill(0);
    
    text(sensorKind[i], buttonX[i], buttonY + buttonH/2);
  }
  textSize(30);
}

void mousePressed() {
  for (int i = 0; i < 4; i++) {
    if (mouseX > buttonX[i] && mouseX < buttonX[i] + buttonW &&
        mouseY > buttonY && mouseY < buttonY + buttonH) {
      sensorIndex = i;
    }
  }
}
