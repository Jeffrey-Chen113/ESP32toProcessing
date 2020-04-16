//ESP32toProcessing
//By Jeffrey Chen

import processing.serial.*;    

// Initializing a vairable named 'myPort' for serial communication
Serial myPort;      

// Data coming in from the data fields
// data[0] = "1" or "0"                  -- BUTTON
// data[1] = 0-4095, e.g "2049"          -- POT VALUE
// data[2] = 0-4095, e.g. "1023"        -- LDR value
String [] data;

int switchValue = 0;
//I don't have a potentiometer so this will remain at 0 during the entire program
int potValue = 0;
int ldrValue = 0;

// Change to appropriate index in the serial list — YOURS MIGHT BE DIFFERENT
int serialIndex = 2;

//LDR Parameters for mapping

//Low LDR range since im in a fairly dim room
int minLDRValue = 0;
int maxLDRValue = 500;
//0-255 for colour range
int minAlphaValue = 0;
int maxAlphaValue = 255;

int buttonCounter=0;
int buttonState=0;
int lastButtonState=0;

float alphaValue = map(ldrValue, minLDRValue, maxLDRValue, minAlphaValue, maxAlphaValue);

float red=255;
float green=255;
float blue=255;
float opacity=255;

void setup ( ) {
  size (800,  600);    
  
  // List all the available serial ports
  printArray(Serial.list());
  
  // Set the com port and the baud rate according to the Arduino IDE
  //-- use your port name
  myPort  =  new Serial (this, "COM5",  115200); 
} 


// We call this to get the data 
void checkSerial() {
  while (myPort.available() > 0) {
    String inBuffer = myPort.readString();  
    
    print(inBuffer);
    
    //println(buttonCounter);
    //println("State:"+ buttonState);
    //println("Last State:" + lastButtonState);
    
    // This removes the end-of-line from the string 
    inBuffer = (trim(inBuffer));
    
    // This function will make an array of TWO items, 1st item = switch value, 2nd item = potValue
    data = split(inBuffer, ',');
   
   // we have THREE items — ERROR-CHECK HERE
   if( data.length >= 3 ) {
      switchValue = int(data[0]);           // first index = switch value 
      potValue = int(data[1]);               // second index = pot value
      ldrValue = int(data[2]);               // third index = LDR value
   }
  }
} 

//-- change background to red if we have a button
void draw() {  
  // every loop, look for serial information
  checkSerial();
  
  //draws the background as well as the word
  background(100,100,100);
  textSize(100);
  fill(red, green, blue, opacity);
  textAlign(CENTER);
  text("word",400,300);
  buttonState();
  
} 


void buttonState() {
  //Checks if the last button state is the same as the current one after the user presses the switch
  //This prevents auto incrementing when the user holds down on the button.
  buttonState=switchValue;
  if(buttonState != lastButtonState){
    if(switchValue==1){
      buttonCounter++;
    }
  }
  lastButtonState=buttonState; 
  
  //Different States for controlling the word colour and opacity
  if (buttonCounter==1){
    changeRed();
  }
  else if (buttonCounter==2){
    changeGreen();
  }
  else if (buttonCounter==3){
    changeBlue();
  }
  else if (buttonCounter==4){
    changeOpacity();
  }
  else if (buttonCounter==5){
    buttonCounter=0;
  }
}

//Changes the red part of the fill
void changeRed(){
  red=alphaValue;
}
//Changes the blue part of the fill
void changeBlue(){
  blue=alphaValue;
}
//Changes the green part of the fill
void changeGreen(){
  green=alphaValue;
}

//Changes the opacity of the fill
void changeOpacity(){
  opacity=alphaValue;
}
