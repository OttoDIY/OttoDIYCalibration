// Otto Servo Calibration GUI V3
//
// Piers Kennedy July 2021
//

import controlP5.*; // library for sliders
import processing.serial.*; //library for serial connection
Serial myPort; //do not change
ControlP5 cp5; //create ControlP5 object

static final int ORIGINAL_HEIGHT = 1024;
int     prevWidth = 0;
int     prevHeight = 0;
float   scale = 1.0;

int LLeg, RLeg, LFoot, RFoot;

PImage OttoMain, USBsymbolblue, OttoRL, OttoLL, OttoRF, OttoLF, cross, tick, savedtick, OttoSmile;
PFont fnt;

int num_ports;
boolean USB_connected = false;
boolean save_clicked = false;
String[] port_list;
String detected_port = "";


int sync_time = 0; // Next timing to send latest value to serial;

void settings() {
  // Set size of GUI
  final int offset = 50;
  if (displayHeight >= 1024) {
    size(1024, 1024 - offset);
  } else {
     size(displayHeight, displayHeight - offset);
  }  
}

void setup() {  
  surface.setResizable(true); 
  fnt = createFont("Nunito Black", 22, true);  // change the default font to Nunito Black

  //println(Serial.list());
  num_ports = Serial.list().length;      // get the number of detected serial ports
  port_list = new String[num_ports];    // save the current list of serial ports
  for (int i = 0; i < num_ports; i++) {port_list[i] = Serial.list()[i];}

  // The image files must be in the data folder of the current sketch/exe to load successfully
  OttoMain = loadImage("OttoMain.jpg");
  OttoRL = loadImage("OttoRL.jpg");
  OttoLL = loadImage("OttoLL.jpg");
  OttoRF = loadImage("OttoRF.jpg");
  OttoLF = loadImage("OttoLF.jpg");
  OttoSmile = loadImage("OttoSmile.jpg");
  USBsymbolblue = loadImage("usbsymbolblue.png");
  cross = loadImage("cross.png");
  tick = loadImage("tick.png");
  savedtick = loadImage("savedtick.png");

  cp5 = new ControlP5(this);                 //do not change
  ControlFont font = new ControlFont(fnt);
  cp5.setFont(font);

  cp5.addSlider("RLeg")
  .setRange(0, 180) //slider range low, high
  .setValue(90) //start val
  .setCaptionLabel("")
  .setSliderMode(Slider.FLEXIBLE) // change sliderMode of the Slider object. The default is Slider.FIX
  .setColorBackground(color(45, 45, 100)) //top of slider colour r,g,b
  .setColorForeground(color(78, 208, 22)) //botom of slider colour r,g,b
  .setColorValue(color(45, 45, 100)) //val colour r,g,b
  .setColorLabel(color(45, 45, 100))
  .setColorActive(color(0, 255, 0)); //mouse over colour

  cp5.addSlider("LLeg")
  .setRange(0, 180) //slider range low, high
  .setValue(90) //start val
  .setCaptionLabel("")
  .setSliderMode(Slider.FLEXIBLE) // change sliderMode of the Slider object. The default is Slider.FIX
  .setColorBackground(color(45, 45, 100)) //top of slider colour r,g,b
  .setColorForeground(color(78, 208, 22)) //botom of slider colour r,g,b
  .setColorValue(color(45, 45, 100)) //val colour r,g,b
  .setColorLabel(color(45, 45, 100))
  .setColorActive(color(0, 255, 0)); //mouse over colour

  cp5.addSlider("RFoot")
  .setRange(0, 180) //slider range low, high
  .setValue(90) //start val
  .setCaptionLabel("")
  .setSliderMode(Slider.FLEXIBLE) // change sliderMode of the Slider object. The default is Slider.FIX
  .setColorBackground(color(45, 45, 100)) //top of slider colouur r,g,b
  .setColorForeground(color(78, 208, 22)) //botom of slider color r,g,b
  .setColorValue(color(45, 45, 100)) //val colour r,g,b
  .setColorLabel(color(45, 45, 100))
  .setColorActive(color(0, 255, 0)); //mouse over colour

  cp5.addSlider("LFoot")
  .setRange(0, 180) //slider range low,high
  .setValue(90) //start val
  .setCaptionLabel("")
  .setSliderMode(Slider.FLEXIBLE) // change sliderMode of the Slider object. The default is Slider.FIX
  .setColorBackground(color(45, 45, 100)) //top of slider colour r,g,b
  .setColorForeground(color(78, 208, 22)) //botom of slider colour r,g,b
  .setColorValue(color(45, 45, 100)) //val colour r,g,b
  .setColorLabel(color(45, 45, 100))
  .setColorActive(color(0, 255, 0)); //mouse over colour
}

int ax(float cx) {
  return int(cx * scale + width/2);
}

int ay(float y) {
  return int(y * scale);
}

int as(float s) {
  return int(s * scale);
}

void draw(){
  if (prevWidth != width || prevHeight != height) {
    prevWidth = width;
    prevHeight = height;
    scale =  float(height) / ORIGINAL_HEIGHT;
  }
  
  background(233,234,236);   
  ((Slider)cp5.getController("RLeg"))
  .setPosition(ax(-300), ay(300)) //x and y upper left corner
  .setSize(as(20),as(180)).getValueLabel().align(ControlP5.LEFT, ControlP5.LEFT).setPaddingX(as(30));
  
  
  ((Slider)cp5.getController("LLeg"))
  .setPosition(ax(280), ay(300)) //x and y upper left corner
  .setSize(as(20), as(180)).getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT).setPaddingX(as(30));
  
  ((Slider)cp5.getController("RFoot"))
  .setPosition(ax(-360), ay(625)) //x and y upper left corner
  .setSize(as(20), as(180)).getValueLabel().align(ControlP5.LEFT, ControlP5.LEFT).setPaddingX(as(30));

  
  ((Slider)cp5.getController("LFoot"))
  .setPosition(ax(340), ay(625)) //x and y upper left corner
  .setSize(as(20), as(180)).getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT).setPaddingX(as(30));
  
  if(overRect(ax(-310), ay(255), as(40), as(270))){image(OttoRL, ax(-306), ay(232), as(600), as(600));}
  else if (overRect(ax(270) , ay(255), as(40), as(270))){image(OttoLL, ax(-306), ay(232), as(600), as(600));}
  else if (overRect(ax(-370) , ay(580), as(40), as(270))){image(OttoRF, ax(-306), ay(232), as(600), as(600));}
  else if (overRect(ax(330) , ay(580), as(40), as(270))){image(OttoLF, ax(-306), ay(232), as(600), as(600));}
  else{image(OttoMain, ax(-306), ay(232), as(600), as(600)); }         // Draw Otto coordinate (206, 232) at size 600 x 600

  textFont(fnt, as(90));
  fill(45, 45, 100);
  text("Servo Calibration", ax(-382), ay(100));

  // Right Leg Controls
  fill(78, 208, 22);
  ellipse(ax(- 290) , ay(275), as(40), as(40));
  ellipse(ax(- 290), ay(505), as(40), as(40));
  fill(255);
  textFont(fnt, as(35));
  text("+", ax(- 300), ay(285));
  text("-", ax(- 297), ay(515));
  textFont(fnt, as(22));
  fill(45, 45, 100);
  text("0°", ax(- 330), ay(480));
  text("180°", ax(- 355), ay(310));
  textFont(fnt, as(30));
  text("Right Leg", ax(- 470), ay(400));

  // Left Leg Controls
  fill(78, 208, 22);
  ellipse(ax(290) , ay(275), as(40), as(40));
  ellipse(ax(290) , ay(505), as(40), as(40));
  fill(255);
  textFont(fnt, as(35));
  text("+", ax(280), ay(285));
  text("-", ax(283), ay(515));
  textFont(fnt, as(22));
  fill(45, 45, 100);
  text("0°", ax(310), ay(480));
  text("180°", ax(308), ay(310));
  textFont(fnt, as(30));
  text("Left Leg", ax(330), ay(400));

  // Right Foot Controls
  fill(78, 208, 22);
  ellipse(ax(-350) , ay(600), as(40), as(40));
  ellipse(ax(-350) , ay(830), as(40), as(40));
  fill(255);
  textFont(fnt, as(35));
  text("+", ax(-360), ay(610));
  text("-", ax(-357), ay(840));
  textFont(fnt, as(22));
  fill(45, 45, 100);
  text("0°", ax(-390), ay(805));
  text("180°", ax(-415), ay(635));
  textFont(fnt, as(30));
  text("Right", ax(-470), ay(710));
  text("Foot", ax(-470), ay(740));

  // Left Foot Controls
  fill(78, 208, 22);
  ellipse(ax(350) , ay(600), as(40), as(40));
  ellipse(ax(350) , ay(830), as(40), as(40));
  fill(255);
  textFont(fnt, as(35));
  text("+", ax(340), ay(610));
  text("-", ax(343), ay(840));
  textFont(fnt, as(22));
  fill(45, 45, 100);
  text("0°", ax(370), ay(805));
  text("180°", ax(368), ay(635));
  textFont(fnt, as(30));
  text("Left", ax(390), ay(710));
  text("Foot", ax(390), ay(740));

  // USB button
  //fill(45, 45, 100);
  //rect(ax(- 120, 145, 240, 60, 30);
  //fill(255);
  fill(45, 45, 100);
  textFont(fnt, as(40));
  text("USB", ax(-32), ay(190));
  image(USBsymbolblue, ax(-103), ay(146), as(58), as(58));
  if(!USB_connected){image(cross, ax(70), ay(156), as(40), as(40));}
  else{image(tick, ax(61), ay(150), as(50), as(50));}

  // Walk Test button
  if(overRect(ax(-310), ay(880), as(240), as(60))){
    fill(255);
    rect(ax(-310), ay(880), as(240), as(60), as(30));
    fill(78, 208, 22);
    textFont(fnt, as(40));
    text("Walk test", ax(-288), ay(922));
  }
  else{
    fill(78, 208, 22);
    rect(ax(-310), ay(880), as(240), as(60), as(30));
    fill(255);
    textFont(fnt, as(40));
    text("Walk test", ax(-288), ay(922));
  }

  // Save button
  if(overRect(ax(70), ay(880), as(240), as(60))){
    fill(255);
    rect(ax(70), ay(880), as(240), as(60), as(30));
    fill(253, 88, 0);
    textFont(fnt, as(40));
    text("Save", ax(145), ay(922));
  }
  else {
    fill(253, 88, 0);
    rect(ax(70), ay(880), as(240), as(60), as(30));
    fill(255);
    textFont(fnt, as(40));
    text("Save", ax(145), ay(922));
  }
  if(save_clicked){
    image(savedtick, ax(340), ay(880), as(60), as(60));
    image(OttoSmile, ax(410), ay(870), as(80), as(80));
  }
  if(!USB_connected){COM_select();}

  else{
    if (sync_time < millis()) {
      sync_time = millis() + 50;

      // Send values to serial
      myPort.write(LLeg+"a");
      myPort.write(RLeg+"b");
      myPort.write(LFoot+"c");
      myPort.write(RFoot+"d");
    }
  }
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width &&
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}

void mousePressed() {
  if (overCircle(ax(-290) , ay(275), as(40))) {
    cp5.getController("RLeg").setValue(RLeg + 1);
  }
  else if (overCircle(ax(-290) , ay(505), as(40))) {
    cp5.getController("RLeg").setValue(RLeg - 1);
  }
  else if (overCircle(ax(290) , ay(275), as(40))) {
    cp5.getController("LLeg").setValue(LLeg + 1);
  }
  else if (overCircle(ax(290) , ay(505), as(40))) {
    cp5.getController("LLeg").setValue(LLeg - 1);
  }
  else if (overCircle(ax(-350) , ay(600), as(40))) {
    cp5.getController("RFoot").setValue(RFoot + 1);
  }
  else if (overCircle(ax(-350) , ay(830), as(40))) {
    cp5.getController("RFoot").setValue(RFoot - 1);
  }
  else if (overCircle(ax(350) , ay(600), as(40))) {
    cp5.getController("LFoot").setValue(LFoot + 1);
  }
  else if (overCircle(ax(350) , ay(830), as(40))) {
    cp5.getController("LFoot").setValue(LFoot - 1);
  }
  else if (overRect(ax(-310), ay(880), as(240), as(60))) {
    if(USB_connected){myPort.write("w");}
  }
  else if (overRect(ax(70), ay(880), as(240), as(60))) {
    if(USB_connected){myPort.write("s");
    save_clicked = true;
  }
  }
}

void COM_select() {
  // see if Arduino or serial device was plugged in
  if ((Serial.list().length != num_ports) && !USB_connected) {
    // determine which port the device was plugged into
    if (num_ports == 0) {
      detected_port = Serial.list()[0];
      myPort = new Serial(this, detected_port, 9600); //connect to Arduino port
      USB_connected = true;
    }
    else {
      // go through the current port list
      for (int i = 0; i < Serial.list().length; i++) {
        // go through the saved port list
        for (int j = 0; j < num_ports; j++) {
          if (Serial.list()[i].equals(port_list[j])) {
            break;
          }
          if (j == (num_ports - 1)) {
            detected_port = Serial.list()[i];
            try {
              myPort = new Serial(this, detected_port, 9600); //connect to Arduino port
              USB_connected = true;
            } catch (RuntimeException e) {
              println("Opening serial port for '" + detected_port + "' failed.  \nReason:\n" + e);
            }
          }
        }
      }
    }
    if (!USB_connected) {
      // Failed to connect all existing ports. Update the port list, so we don't try to connect them again.
      num_ports = Serial.list().length;      // get the number of detected serial ports
      port_list = new String[num_ports];    // save the current list of serial ports
      for (int i = 0; i < num_ports; i++) {port_list[i] = Serial.list()[i];}
      delay(500);
    }
  }
}
