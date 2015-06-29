
#include <SoftwareSerial.h>

SoftwareSerial mySerial(3,4); // RX, TX
char a;
void setup() {
  
  //Declara os seriais
  Serial.begin(9600);
  mySerial.begin(9600);
  
  delay(100); 
  
  Serial.println("Setup done");
}

void loop() {
  // Verifica se recebeu algo
  if (mySerial.available()){ 
    Serial.print("Received data: ");
    
    //Enquanto tem caracteres ele continua lendo
    while (mySerial.available())  {
      a = (char) mySerial.read();
      
     Serial.print(a);
      if (a != NULL)
      {
        mySerial.write(a);  // loop back iOS
      }
    }
    
    Serial.println("");
    delay(1000);
  }
  
  delay(1000);
}
