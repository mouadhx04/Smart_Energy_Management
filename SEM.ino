//LIBRERIS WE NEED .

#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include <addons/TokenHelper.h>
#include "DHT.h"
#include "EmonLib.h" 

// DIFINEING MQ MH GAS SENSOR.
#define SENSOR 34

// DIFINEING DH11 SENSOR.
#define DHTPIN 4 
#define DHTTYPE DHT11 

//WIFI SETTINGS.
#define WIFI_SSID "******" //WIFE NAME.
#define WIFI_PASSWORD "******" //WIFE PASS.

//FIREBASE SETTINGS.
#define USER_EMAIL "******" //USER NAME FROM FIREBASE ATHANTICTION.
#define USER_PASSWORD "******" //USER PASS FROM FIREBASE ATHANTICTION.

#define API_KEY "******" //API KEY FROM FIREBASE.
#define FIREBASE_PROJECT_ID "******" //PROJECT ID FROM FIREBASE.

//DEFINEING.

DHT dht(DHTPIN, DHTTYPE);

EnergyMonitor emon1;

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

unsigned long dataMillis = 0;
int count = 0;
bool taskcomplete = false;

int led = 26; //PIN
int buzzer = 12; //PIN

float sensorValue;
int gas = 0; 

double humidity = 0 ;
double temperature = 0 ;

double watts = 0;

void setup()
{
    Serial.println("Sensor start");
    pinMode(buzzer, OUTPUT);
    pinMode(led, OUTPUT);
    emon1.current(32, 4.75);
    dht.begin();
    Serial.begin(115200);

    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    Serial.print("Connecting to Wi-Fi");
    while (WiFi.status() != WL_CONNECTED)
    {
        Serial.print(".");
        delay(300);
    }
    Serial.println();
    Serial.print("Connected with IP: ");
    Serial.println(WiFi.localIP());
    Serial.println();

    Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

    config.api_key = API_KEY;


    auth.user.email = USER_EMAIL;
    auth.user.password = USER_PASSWORD;


    config.token_status_callback = tokenStatusCallback;

    Firebase.begin(&config, &auth);
    
    Firebase.reconnectWiFi(true);
}

void loop()
{
  
   // DH11 sensor function .
   
  Serial.println("------------------------------------");
  Serial.println("Reading Sensor data ...");

  humidity = dht.readHumidity();
  temperature = dht.readTemperature();

  if (isnan(temperature) || isnan(humidity)) {
    Serial.println(F("Failed to read from DHT sensor!"));
     delay(500);
    return;
  }
  Serial.printf("Temperature reading: %.2f \n", temperature);
  Serial.printf("Humidity reading: %.2f \n", humidity);
  delay(500);
  
  // HW-66 watts sensor function .
 
  double Irms = emon1.calcIrms(1480);
  watts = Irms * 220.0;
  Serial.printf("watts: %.2f \n", watts);
  delay(500);
  
 // MQ MH gas sensor function .
 
 sensorValue= analogRead(SENSOR);
   
 gas = sensorValue/100.0;
 if ((gas)<=(20))
 {
  Serial.printf("gas reading:  air is safe \n");
  delay (500);
 }
  else 
  {
  Serial.printf("DANGER \n gas reading:%d \n", gas);

  // alarm settings led and buzzer.
  
  digitalWrite(buzzer, HIGH);
     delay(20);
  digitalWrite(buzzer, LOW);
     delay(10);
  digitalWrite(buzzer, HIGH);
     delay(20);
  digitalWrite(led, HIGH);
     delay(500);
  digitalWrite(buzzer, LOW);
     delay(10);
  digitalWrite(led, LOW);
     delay(500);
  

  }delay (300);
  
  //Firebase: creating a document in firestore and paching in every change .
  
    if (Firebase.ready() && (millis() - dataMillis > 60000 || dataMillis == 0))
    {
        dataMillis = millis();
        FirebaseJson content;
        String documentPath = "House/room";
        if (!taskcomplete)
        {
            taskcomplete = true;
            
            content.clear();
            content.set("fields/humidity/stringValue", String(humidity).c_str());
            content.set("fields/temperature/stringValue", String(temperature).c_str());
            content.set("fields/watts/stringValue", String(watts).c_str());
            content.set("fields/gas/stringValue", String(watts).c_str());
         

            Serial.print("Create a document... ");

            if (Firebase.Firestore.createDocument(&fbdo, FIREBASE_PROJECT_ID, "", documentPath.c_str(), content.raw()))
                Serial.printf("ok\n%s\n\n", fbdo.payload().c_str());
            else {
                Serial.println(fbdo.errorReason());
            }
        }

        content.clear();
        content.set("fields/humidity/stringValue", String(humidity).c_str());
        content.set("fields/temperature/stringValue", String(temperature).c_str());
        content.set("fields/watts/stringValue", String(watts).c_str());
        content.set("fields/gas/stringValue", String(watts).c_str());


        Serial.print("Update a document... ");

        if (Firebase.Firestore.patchDocument(&fbdo, FIREBASE_PROJECT_ID, "", documentPath.c_str(), content.raw(), "temperature,humidity,watts,gas"))
            Serial.printf("ok\n%s\n\n", fbdo.payload().c_str());
        else
            Serial.println(fbdo.errorReason());
    }
}
