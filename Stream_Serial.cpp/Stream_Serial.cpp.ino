//#include <PinChangeInt.h>
#defin NO_HB100

#define F_0_OUT_PIN 5
#define V_0_OUT_PIN A0
#define F_1_OUT_PIN 6
#define V_1_OUT_PIN A1
#define F_2_OUT_PIN 7
#define V_2_OUT_PIN A2
#define F_3_OUT_PIN 8
#define V_3_OUT_PIN A3

//int FOutPWMPin = 3;
//int VOutAnalogPin = A1;
int FOutVal = 0;
int VOutVal = 0;
int F1OutVal = 0;
int V1OutVal = 0;
int FOutVal = 0;
int VOutVal = 0;
int F1OutVal = 0;
int V1OutVal = 0;
//int pwm_period_microseconds;

// Setup PWM Interrupts
//volatile int pwm_value = 0;
//volatile int prev_time = 0;
//uint8_t latest_interrupted_pin;
//
//// Implement interrupts
//void rising()
//{
//  latest_interrupted_pin=PCintPort::arduinoPin;
//  PCintPort::attachInterrupt(latest_interrupted_pin, &falling, FALLING);
//  prev_time = micros();
//}
// 
//void falling() {
//  latest_interrupted_pin=PCintPort::arduinoPin;
//  PCintPort::attachInterrupt(latest_interrupted_pin, &rising, RISING);
//  pwm_value = micros()-prev_time;
//  Serial.println(pwm_value);
//}

void setup() {

  pinMode(F_0_OUT_PIN, INPUT_PULLUP);
  pinMode(F_1_OUT_PIN, INPUT_PULLUP);
  pinMode(V_0_OUT_PIN, INPUT); 
  pinMode(V_1_OUT_PIN, INPUT);
  
  Serial.begin(115200);
//  PCintPort::attachInterrupt(F_OUT_PIN, &rising, RISING);
  
  Serial.println("0FOut,0VOut,1FOut,1VOut");  //  CSV Header
 
}

void loop() {

  // Get vOut values
  VOutVal = analogRead(V_0_OUT_PIN);
//  FOutVal = pulseIn(F_OUT_PIN, HIGH);
  V1OutVal = analogRead(V_1_OUT_PIN);
//  
//  // Get pwm 0frequency
//  noInterrupts();
//  pulseIn(0_F_OUT_PIN, HIGH);
//  unsigned int pulse_length = 0;
//  for (x = 0; x < AVERAGE; x++)
//  {
//    pulse_length = pulseIn(0_F_OUT_PIN, HIGH); 
//    pulse_length += pulseIn(0_F_OUT_PIN, LOW);    
//    samples[x] =  pulse_length;
//  }
//  interrupts();
  
  Serial.print(VOutVal);
  Serial.print("\t");
  Serial.println(V1OutVal);

  // Calculate and print rms values
  // calculate and print freq values
}
