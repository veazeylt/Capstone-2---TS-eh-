#define echoPin 2 //white/yellow
#define trigPin 3 //green

long duration;
int distance;

int buttonPin = 13;

void setup() {
  // put your setup code here, to run once:
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(buttonPin, INPUT_PULLUP);
  Serial.begin(9600);

}

void loop() {
  // put your main code here, to run repeatedly:
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH);
  distance = duration * 0.034 / 2;
  int sensor1 = distance;
  int sensor2 = digitalRead(buttonPin);

  Serial.print(sensor1);
  Serial.print(",");
  Serial.print(sensor2);
  Serial.println("");
  delay(10);

}
