import java.util.*; 
import java.text.*;
import controlP5.*;

int cx, cy;
int minutes; 
String minsString; 
long currentTime; 
boolean digital;

int radius;
float minutesHand; 
float hoursHand;

int interval;
ControlP5 cp5;
CColor controlsColours;
int speed;
long startTime;
long previousUpdate;

void setup(){
  size(450, 720);
  
  cx = 225;
  cy = 300;
  minutes = 0;

  currentTime = new Date().getTime(); 
  digital = true;
  
  radius = 120;
  minutesHand = radius * 0.80; 
  hoursHand = radius * 0.65;
  
  interval = 1000;
  speed = 0;
  startTime = currentTime; 
  previousUpdate = 0;
  controlsColours = new CColor(0x99ffffff, 0x55ffffff, 0xffffffff, 0xffffffff, 0xffffffff);
  
  cp5 = new ControlP5(this);
  cp5.addButton("digital") 
  .setPosition(50, 650) 
  .setSize(150, 50)
  ;
  cp5.addButton("analog") 
  .setPosition(250, 650) 
  .setSize(150, 50)
  .setColor(controlsColours)
  ;
  cp5.addButton("analog") 
  .setPosition(250, 650) 
  .setSize(150, 50)
  .setColor(controlsColours)
  ;
  cp5.addSlider("speed") 
  .setPosition(50,140) 
  .setSize(20,100) 
  .setRange(0,10) 
  .setNumberOfTickMarks(10) 
  .setColor(controlsColours)
  ;
  cp5.addSlider("timeline") 
  .setPosition(50,600) 
  .setSize(350,20) 
  .setRange(0,1000) 
  .setColor(controlsColours) 
  ;
}
void draw(){ 
  background(50);

  Date time = new Date(currentTime);

  if(digital){
    // Digital clock drawn here 
    fill(0, 255, 0, 0); 
    strokeWeight(4); 
    stroke(255); 
    rectMode(CENTER);
    rect(cx, cy, 270, 170);
    
    DateFormat ddf = new SimpleDateFormat("HH:mm"); 
    String digitalDate = ddf.format(time);
    
    fill(200);
    PFont digitalFont = createFont("OCRAStd", 70); 
    textFont(digitalFont);
    textAlign(CENTER);
    text(digitalDate, cx, cy);
  }
  else{
    // Analog clock drawn here
    int minutes = (int)((currentTime / 1000) / 60) % 60;
    int hours = (int)(((currentTime / 1000) / 60) / 60) % 24;
    
    float m = map(minutes, 0, 60, 0, TWO_PI) - HALF_PI;
    float h = map(hours + norm(minutes, 0, 60), 0, 24, 0, 2 * TWO_PI) - HALF_PI;
    
    // drawing minute and hour clock hands
    stroke(255);
    strokeWeight(4);
    line(cx, cy, cx + cos(m) * minutesHand, cy + sin(m) * minutesHand); 
    strokeWeight(6);
    line(cx, cy, cx + cos(h) * hoursHand, cy + sin(h) * hoursHand);
    
    // drawing clock ticks strokeWeight(2); beginShape(POINTS);
    for(int a = 0; a < 360; a += 6){
      float angle = radians(a);
      float x = cx + cos(angle) * radius; 
      float y = cy + sin(angle) * radius; 
      vertex(x, y);
    }
    endShape();
  }
  
  // Getting the AM or PM text
  DateFormat apFormat = new SimpleDateFormat("a"); 
  String ap = apFormat.format(time);
  
  PFont legendFont = createFont("Century Gothic", 30); 
  textFont(legendFont);
  text(ap, cx, cy + 60);
  
  // Displaying header and footer texts
  PFont header = createFont("Century Gothic", 50);
  
  textFont(header); 
  textAlign(CENTER);
  text("Simple clock", 225, 100);
  
  DateFormat df = new SimpleDateFormat("EEEE MM/dd/yyyy HH:mm"); 
  String reportDate = df.format(time);
  
  textFont(legendFont); 
  text(reportDate, 225, 550);
  
  currentTime += interval*speed; 
  if(currentTime - previousUpdate > 60000){ 
    cp5.getController("timeline").setValue((currentTime - startTime) / 60000); 
    previousUpdate = currentTime;
}
}


public void digital() { digital = true;
}
public void analog() { digital = false;
}
public void timeline(int value){
currentTime = (value * 60000) + startTime;
}
