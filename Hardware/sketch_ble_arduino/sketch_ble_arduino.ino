
#include <SoftwareSerial.h>

//Variaveis constantes com configuracoes do Register Shifter
int clock = 8;
int latch = 9;
int data = 10;



int digito = 0;

SoftwareSerial mySerial(3,4); // RX, TX
char a;
void setup() {
  
  //Inicializa os seriais
  Serial.begin(9600);
  mySerial.begin(9600);
  
  //Inicializa as entradas do Register Shifter
  pinMode(clock, OUTPUT);
  pinMode(latch, OUTPUT);
  pinMode(data, OUTPUT);
  
  delay(100); 
  
  
  Serial.println("Configuracoes Carregadas");
}

void loop() {
  // Verifica se recebeu algo
  if (mySerial.available()){ 
    Serial.print("Received data: ");
    
    digitalWrite(latch, LOW);
    //Enquanto tem caracteres ele continua lendo
    while (mySerial.available())  {
      
      //Le do BLE
      a = (char) mySerial.read();
      
      //Converte para inteiro
      digito = int(a) - 48;
     
      Serial.println(digito); // Imprime pra ver se est;a ok
      Serial.println("Poxa");
      //Verifica se o binario esta aceso ou apagado
      if(digito == 1){
    
         digitalWrite(data, HIGH);  
      }else{
        digitalWrite(data, LOW);
      }
      digitalWrite(latch, HIGH);
      if (a != NULL)
      {
        mySerial.write(a);  // Devolve para o iOS 
      }
    }
    
    
    delay(1000);
  }
  
  delay(1000);
}
