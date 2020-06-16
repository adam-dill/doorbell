// https://www.bluetooth.com/specifications/gatt/characteristics/

#include <ArduinoBLE.h>

BLEService doorbellService("1101");
BLEUnsignedCharCharacteristic doorbellPress("2A56", BLERead | BLENotify); // standard Digital

int buttonPin = 2;
int ledPin = 3;

void setup() {
  //Serial.begin(9600);
  //while(!Serial);
  
  pinMode(buttonPin, INPUT);
  pinMode(ledPin, OUTPUT);

  if (!BLE.begin()) {
    //Serial.println("starting BLE failed.");
    while(1);
  }

  BLE.setLocalName("Doorbell");
  BLE.setAdvertisedService(doorbellService);
  doorbellService.addCharacteristic(doorbellPress);
  BLE.addService(doorbellService);

  BLE.advertise();
  //Serial.println("Bluetooth device active, waiting for connections...");
}

void loop() {  
  BLEDevice central = BLE.central();

  if (central) {
    digitalWrite(ledPin, HIGH);

    while(central.connected()) {
      int input = digitalRead(buttonPin);
      int value = doorbellPress.value();
      if(input == HIGH && value == false) {
        //Serial.println("Ding...");
        doorbellPress.writeValue(true);
      } else if(input == LOW && value == true) {
        //Serial.println("Dong.");
        doorbellPress.writeValue(false);
      }
    }
  }
  digitalWrite(ledPin, LOW);
}
