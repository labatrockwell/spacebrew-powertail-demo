import spacebrew.*;
import processing.serial.*;
import com.rockwellgroup.arduinoconnect.*;

String server="127.0.0.1";//"sandbox.spacebrew.cc";
String name="PowerSwitch_Lamp";
String description ="Lamp that blinks on and off";

Spacebrew spacebrewConnection;
Serial myPort;        // The serial port 

void setup() {
  size(600, 400);

  spacebrewConnection = new Spacebrew( this );
  
  // add each thing you publish to
 spacebrewConnection.addSubscribe( "Blink", "boolean" ); 
 spacebrewConnection.addPublish( "Blinked", true ); 

  // connect!
  spacebrewConnection.connect(server, name, description );

  int i = 0;
  for(String s : Serial.list()){
    println(Integer.toString(i) + ": " + s);
    i++;
  }
  //You may need to change the serial port that Processing
  //connects to. Look at the output in the Processing console
  //to determine which index your Arduino is at.
  //myPort = new Serial(this, Serial.list()[0], 9600);
  myPort = new Serial(this, ArduinoConnect.getSerialPortName("64935343233351500000"), 9600); 
  myPort.bufferUntil('\n');
}

void draw() {
}

void serialEvent (Serial myPort) {
  // get the ASCII string:
  String inString = new String(myPort.readBytesUntil('\n'));
  println(inString);
  spacebrewConnection.send( "Blinked", true);
}

void onBooleanMessage( String name, boolean value ){
  myPort.write('B');
}
