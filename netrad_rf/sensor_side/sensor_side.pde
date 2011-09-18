/*********************************************************/
//
// Stripped down version of netrad ethernet shield code
// 
// This version will broadcast its readings on the chibi 
// radio for all to hear along with its sensorID.
//
// author (modifications): Rick Knowles
// date: 2011/9/15
//
/*********************************************************/

#include <avr/eeprom.h>
#include <chibi.h>
#include "PrivateSettings.h"

static char VERSION[] = "0.1-rf";

// Sensor states
enum State {
    NORMAL = 0,
    RESET = 1
};

typedef unsigned short SensorID;

typedef struct {
  SensorID sensorID; // stored in the eeprom
  float conversionCoefficient; // The conversion coefficient from cpm to µSv/h (determined by tube model)

  // working values
  State state; // does the device need a reset
  int count;// Value to store counts per minute
  volatile boolean hasEvent; // Event flag signals when a geiger event has occurred
  unsigned long lastPublishMillis; // The next time to feed
  unsigned long nextPublishMillis; // The next time to feed
} device_t;

// this holds the info for the device
static device_t dev;

void setup() {
    // init command line parser
    chibiCmdInit(57600);
    chibiInit();
    
    // get the sensor id from eeprom
    eeprom_read_block(&dev.sensorID, 0, sizeof(SensorID));
    
    // add in the commands to the command table
    chibiCmdAdd("setsensor", cmdSetSensorID);  
    chibiCmdAdd("publishnow", cmdPublishNow);  
    chibiCmdAdd("stat", cmdStat);   

    // initialize device structure    
    setup_initializeTube();
    dev.lastPublishMillis = millis();
    dev.nextPublishMillis = dev.lastPublishMillis + (publishIntervalInMinutes * 60000);
    dev.state = NORMAL;
    dev.count = 0;
    dev.hasEvent = false;

    // Attach an interrupt to the digital pin 3 and start counting
    attachInterrupt(1, onPulse, interruptMode); 
    
    // Welcome tune
    welcomeTune();

    // report configuration
    cmdStat(0,0);
}

void loop() {
    // poll the command line for any input
    chibiCmdPoll();    

    // if any data is received, then print it to the terminal
    if (chibiDataRcvd() == true) {
      byte buf[CHB_MAX_PAYLOAD];  // store the received data in here
      chibiGetData(buf);
      // The data consists of ASCII characters in byte (unsigned char) format. The print
      // function requires ASCII characters be in char format so we need to inform the function
      // that its okay to convert the format from unsigned char to char. 
      Serial.print((char *)buf);
    }
    
    // Add any geiger event handling code here
    if (dev.hasEvent) {
      dev.hasEvent = false;    // clear the event flag for later use
      speakerTone(20, 1580, true);
    }
    
    // check if its time to update server. elapsedTime function will take into account
    // counter rollover.
    if (isTimeForPublish()) {
      endOfCountCycle();
    }
}

/**************************************************************************/
/*!
    On each falling edge of the Geiger counter's output,
    increment the counter and signal an event. The event 
    can be used to do things like pulse a buzzer or flash an LED
*/
/**************************************************************************/
void onPulse() {
  dev.count++;
  dev.hasEvent = true;  
}

/**************************************************************************/
//    Send data to server
/**************************************************************************/
void updateDataStream(float countsPerMinute) {
  // Try to connect to the server
  Serial.println();

  // Convert from cpm to µSv/h with the pre-defined coefficient
  float microsievertPerHour = countsPerMinute * dev.conversionCoefficient;

  String csvData = "";
  csvData = dev.sensorID;
  csvData += ",2\r\n";
  csvData += "CPM,";
  appendFloatValueAsString(csvData, countsPerMinute);
  csvData += "\r\n";
  csvData += "uSv/hr,";
  appendFloatValueAsString(csvData, microsievertPerHour);
  csvData += "\r\n";
  
  int len = csvData.length();
  char out[len];
  csvData.toCharArray(out, len);

  Serial.println("Sending to Server...");
  Serial.println(csvData);

  chibiTx(BROADCAST_ADDR, (byte *) out, len);
}

/**************************************************************************/
/*!
// Since "+" operator doesn't support float values,
// convert a float value to a fixed point value
*/
/**************************************************************************/
void appendFloatValueAsString(String& outString,float value) {
  int integerPortion = (int)value;
  int fractionalPortion = (value - integerPortion + 0.0005) * 1000;

  outString += integerPortion;
  outString += ".";

  if (fractionalPortion < 10) {
    // e.g. 9 > "00" + "9" = "009"
    outString += "00";
  }
  else if (fractionalPortion < 100) {
    // e.g. 99 > "0" + "99" = "099"
    outString += "0";
  }

  outString += fractionalPortion;
}

/**************************************************************************/
// calculate elapsed time. this takes into account rollover.
/**************************************************************************/
boolean isTimeForPublish() {
  unsigned long now = millis();
  return (now >= dev.nextPublishMillis);
}

/**************************************************************************/
// mark the end of a count cycle, and then update
/**************************************************************************/
void endOfCountCycle() {
  unsigned long now = millis();
  float minsSinceLastPublish = (float) ((now - dev.lastPublishMillis) / 60000);
      
  float countsPerMinute = (float)dev.count / minsSinceLastPublish;
  dev.count = 0;
      
  dev.lastPublishMillis = now;
  dev.nextPublishMillis = dev.lastPublishMillis + (publishIntervalInMinutes * 60000);
    
  updateDataStream(countsPerMinute);
}

/**************************************************************************/
// play a tune on startup to announce we're active
/**************************************************************************/
void welcomeTune() {
    // Mary had a lightly radiated little lamb
    speakerTone(500, 1318, false);
    speakerTone(125, 1175, false);
    speakerTone(250, 1047, false);
    speakerTone(230, 1175, false);
    delay(20);
    speakerTone(230, 1318, false);
    delay(20);
    speakerTone(230, 1318, false);
    delay(20);
    speakerTone(250, 1318, false);
    delay(250);
}

/**************************************************************************/
// Play a speaker tone for a given length
/**************************************************************************/
void speakerTone(long length, int pitch, boolean led) {
    tone(pinSpkr, pitch);      // beep the piezo speaker

    if (led) {
      digitalWrite(pinLED, HIGH); // flash the LED
    }
    delay(length);
    if (led) {
      digitalWrite(pinLED, LOW);
    }
      
    noTone(pinSpkr);          // turn off the speaker pulse
}

/**************************************************************************/
// Get the current sensor ID
/**************************************************************************/
void cmdGetSensorID(int arg_cnt, char **args) {
  Serial.print("Sensor_ID: ");
  Serial.println(dev.sensorID);
}

/**************************************************************************/
// Set sensor ID
/**************************************************************************/
void cmdSetSensorID(int arg_cnt, char **args) {
  dev.sensorID = strtol(args[1], NULL, 10);
  eeprom_write_block(&dev.sensorID, 0, sizeof(SensorID));
  Serial.print("Sensor_ID set to ");
  Serial.println(dev.sensorID);
}

void GetFirmwareVersion() {
  Serial.print("Firmware_ver: ");
  Serial.println(VERSION);
}

/**************************************************************************/
// force a publish now
/**************************************************************************/
void cmdPublishNow(int arg_cnt, char **args) {
  Serial.println("Forcing immediate publish of sensor results");
  endOfCountCycle();
}


/**************************************************************************/
// Print out the current status info
/**************************************************************************/
void cmdStat(int arg_cnt, char **args) {
  cmdGetSensorID(arg_cnt, args);
  GetFirmwareVersion();
}

/**************************************************************************/
// Initializes the conversion information for the specific tube model
/**************************************************************************/
void setup_initializeTube() {
    // Set the conversion coefficient from cpm to µSv/h
    switch (tubeModel) {
    case LND_712:
      // Reference:
      // http://www.lndinc.com/products/348/
      //
      // 1,000CPS ≒ 0.14mGy/h
      // 60,000CPM ≒ 140µGy/h
      // 1CPM ≒ 0.002333µGy/h
      dev.conversionCoefficient = 0.002333;
      Serial.println("Sensor model: LND 712");
      break;
    case SBM_20:
      // Reference:
      // http://www.libelium.com/wireless_sensor_networks_to_control_radiation_levels_geiger_counters
      // using 25 cps/mR/hr for SBM-20. translates to 1 count = .0067 uSv/hr 
      dev.conversionCoefficient = 0.0067;
      Serial.println("Sensor model: SBM-20");
      Serial.println("Conversion factor: 150 cpm = 1 uSv/Hr");
      break;
    case INSPECTOR:
      Serial.println("Sensor Model: Medcom Inspector");
      Serial.println("Conversion factor: 310 cpm = 1 uSv/Hr");
      dev.conversionCoefficient = 0.0029;
      break;
    default:
      Serial.println("Sensor model: UNKNOWN!");
      break;
    }
}


