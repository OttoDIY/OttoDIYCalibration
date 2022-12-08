#include <Otto.h>
Otto Otto;
#include <EEPROM.h>

int v;
int ch;
int i;

  int positions[] = {90, 90, 90, 90};
  int8_t trims[4] = {0,0,0,0};

#define LeftLeg 2 // left leg pin, servo[0]
#define RightLeg 3 // right leg pin, servo[1]
#define LeftFoot 4 // left foot pin, servo[2]
#define RightFoot 5 // right foot pin, servo[3]
#define Buzzer 13 //buzzer pin


void readChar(char ch) {
  switch (ch) {
  case '0'...'9':
    v = (v * 10 + ch) - 48;
    break;
   case 'a':
    trims[0] = v-90;
    setTrims();
    v = 0;
    break;
   case 'b':
    trims[1] = v-90;
    setTrims();
    v = 0;
    break;
   case 'c':
    trims[2] = v-90;
    setTrims();
    v = 0;
    break;
   case 'd':
    trims[3] = v-90;
    setTrims();
    v = 0;
    break;
   case 'w':
    for (int count=0 ; count<4 ; count++) {
      Otto.walk(1,1000,1); // FORWARD
    }
    break;
   case 's':
    for (i=0 ; i<=3 ; i=i+1) {
      EEPROM.write(i,trims[i]);
    }
    delay(500);
    Otto.sing(S_superHappy);
    Otto.crusaito(1, 1000, 25, -1);
    Otto.crusaito(1, 1000, 25, 1);
    Otto.sing(S_happy_short);
    break;
  }
}

void setTrims() {
  Otto.setTrims(trims[0],trims[1],trims[2],trims[3]);
   Otto._moveServos(10, positions);}


void setup() {
  Otto.init(LeftLeg, RightLeg, LeftFoot, RightFoot, true, Buzzer);
Otto.home();

  Serial.begin(9600);

    // To calibrate Otto, you will first need to upload this code to Otto. Once the uploading is complete, unplug the USB connection to Otto.
  //
  // Servo Calibration GUI
  // You will now need to run the Servo Calibration software from ottodiy.com. Make sure that the USB is unplugged. Depending on your Windows platform, you will need to run either the 32- or 64- bit executable file contained in its relevant folder. Please leave the file in its folder - the program will not run if it does not have access to the data files.
  //
  // On start up you should see a red cross by the USB label at the top of the interface. Plug the USB into Otto and the red cross should turn into a green tick when the program has recognized that the USB connection has been made (this might take a second or two). If you forgot to unplug the USB, you will need to close the program, unplug the USB and start the program again. Then plug in the USB. You can now calibrate the servo positions so the the legs and feet are correctly aligned. The slider allows for large changes in the angle and the +/- buttons much finer control on the position of each servo.
  //
  // When the servos on Otto are correctly aligned, click on 'Walk Test' to see how Otto moves. If further fine adjustments are required, they should be done now and the walk test repeated. Be careful that the USB cable does not interfere with Otto's movement.
  //
  // When you are happy that everything is aligned, click 'Save'. A tick and properly aligned Otto will appear on the interface. Your Otto will produce a happy sound (if you have connected the buzzer) and dance.
  //
  // CONGRATULATIONS!! You have successfully calibrated Otto's servos. The positions have been saved to Otto and will not need to be calibrated again unless you change the Nano or any of the servos.
  v = 0;

}

void loop() {
  // You have carefully followed the instructions on how to build Otto and have made sure that all the servos are centralized (set at 90 degrees) before you attach the horns. You are now at the very exciting moment where you check to see how Otto moves and dances and so you upload your first simple Blockly code.
  //
  // :( What happened? Why did the legs and feet move out of position? Otto doesn’t look right and doesn’t move smoothly.
  //
  // Do not be disappointed and do not worry! This is completely normal and happens in every Otto build. This is the stage where you need to adjust the central positions of the servos using a simple process called calibration. This will only need to be done once and then the correct positions will be remembered every time you turn on your Otto.

    if (Serial.available()) {
      readChar((Serial.read()));
    }

}