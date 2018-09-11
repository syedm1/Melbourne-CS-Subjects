// Manually installed geomap library
import org.gicentre.geomap.*;
import org.gicentre.geomap.io.*;

import java.util.*;
import java.text.*;

import controlP5.*;

GeoMap geoMap;                // Declare the geoMap object.
ControlP5 cp5;
PImage img;

Table seifa;
color minColor, maxColor;
color[] minColors,maxColors;
int colorScheme;

int[] dataMax;
int dataType; // 2,4,6,8,9
boolean change;
int cur_id;
int old_id;

void setup()
{
  size(800, 500);
  init_cp5();
  geoMap = initGeoMap();
  initColorScheme();
  
  seifa = loadTable("SEIFA.csv");
  dataMax = parseData(seifa);

  change = false;
  old_id = 1;
  cur_id = -1;
  
  background(202, 226, 245);  // Ocean colour
  fill(lerpColor(minColor, maxColor, minColor));
  stroke(0, 40);               // Boundary colour
  geoMap.draw();
}

void draw(){ 
  cur_id = geoMap.getID(mouseX, mouseY);
  // Recover last area 
  if (cur_id != old_id){
    fill(lerpColor(minColor, maxColor, getColorById(old_id)));
    stroke(0,40);
    geoMap.draw(old_id);
  }
  // Highlight current area (mouse on)
  if (cur_id != -1){
    fill(lerpColor(minColor, maxColor, maxColor));
    stroke(100, 200);
    geoMap.draw(cur_id);
    old_id = cur_id;
    String name = geoMap.getAttributeTable().findRow(str(cur_id),0).getString("LGA_NAME11");
    inform(name);
  } else{
    // When mouse over the control penels
    if (mouseX<100 && mouseY<50){
      inform("Change Color Scheme");
    } else if (mouseX<100 && mouseY<100){
      inform("Index of Relative Socio-economic Disadvantage");
    } else if (mouseX<100 && mouseY<150){
      inform("Index of Economic Resources");
    } else if (mouseX<100 && mouseY<200){
      inform("Index of Education and Occupation");
    } else if (mouseX<100 && mouseY<250){
      inform("Usual Resident Population");
    } 
  }
  // If receive command, redraw whole map
  if (change){
    changeShow();
    setGradient(750, 20, 20, 150, minColor, maxColor);
    change = false;
    inform("Done");
  }
}

// Init control panels 
void init_cp5(){
  cp5 = new ControlP5(this);
  cp5.addButton("colorscheme") 
    .setCaptionLabel("Scheme")
    .setPosition(0, 0) 
    .setSize(100, 50);
  cp5.addButton("disadvantage") 
    .setCaptionLabel("IRSD")
    .setPosition(0, 50) 
    .setSize(100, 50);
  cp5.addButton("resources") 
    .setCaptionLabel("IER")
    .setPosition(0, 100) 
    .setSize(100, 50);
  cp5.addButton("occupation") 
    .setCaptionLabel("IEO")
    .setPosition(0, 150) 
    .setSize(100, 50);
  cp5.addButton("population") 
    .setCaptionLabel("URP")
    .setPosition(0, 200) 
    .setSize(100, 50);
}

// Control Panels list
public void colorscheme(){
  inform("Loading... (Please Wait)");
  colorScheme = (colorScheme+1)%4;
  minColor = minColors[colorScheme];
  maxColor = maxColors[colorScheme];
  change = true;
}
public void disadvantage(){ 
  inform("Loading... (Please Wait)");
  dataType = 2;
  change = true;
}
public void resources(){ 
  inform("Loading... (Please Wait)");
  dataType = 4;
  change = true;
}
public void occupation(){ 
  inform("Loading... (Please Wait)");
  dataType = 6;
  change = true;
}
public void population(){ 
  inform("Loading... (Please Wait)");
  dataType = 8;
  change = true;
}

// Init geomap
GeoMap initGeoMap(){
  geoMap = new GeoMap(this);  // Create the geoMap object.
  geoMap.readFile("LGA11aAust/LGA11aAust");   // Reads shapefile.
  
  return geoMap;
}
// Init Color Schemes
void initColorScheme(){
  minColors = new color[4];
  maxColors = new color[4];
  minColors[0] = color(229,245,249);
  maxColors[0] = color(44,162,95);
  minColors[1] = color(222,235,247);
  maxColors[1] = color(49,130,189);
  minColors[2] = color(255,237,160);
  maxColors[2] = color(240,59,32);
  minColors[3] = color(239,237,245);
  maxColors[3] = color(117,107,177);
  colorScheme = 0;
  minColor = minColors[colorScheme];
  maxColor = maxColors[colorScheme];
}


// Get the maximum for each row
int[] parseData(Table siefa){
  int cols = siefa.getColumnCount();
  int[] dataMax = new int [cols];
  for (int i=0;i<cols;i++){
    dataMax[i] = 0;
    for(TableRow row: siefa.rows()){
      dataMax[i] = max(dataMax[i], row.getInt(i));
    }
  }
  return dataMax;
}

// Control triggered
void changeShow(){
  background(202, 226, 245);  // Ocean colour
  fill(206, 173, 146);          // Land colour
  stroke(0, 40);               // Boundary colour
  for (int id : geoMap.getFeatures().keySet()){
    float normColor = getColorById(id);
    fill(lerpColor(minColor, maxColor, normColor));
    geoMap.draw(id); // Draw country
    saveFrame("cur.jpg");
  }
}
// Color for one specific area
float getColorById(int id){
  if (dataType == 0){
    return minColor;
  }
  float normColor=0.0;
  String areaCode = geoMap.getAttributeTable().findRow(str(id),0).getString("LGA_CODE11");
  TableRow dataRow = seifa.findRow(areaCode, 0);
  if (dataRow != null){
  normColor = dataRow.getFloat(dataType)/dataMax[dataType];
  }
  return normColor;
}

// Left bottum text box
void inform(String str){
  fill(255,237,160);
  rect(0,460,500,500);
  textSize(20);
  fill(0, 102, 153, 204);
  text(str, 10, 485);
}

// Draw color bar
void setGradient(int x, int y, float w, float h, color c1, color c2) {
  noFill();
  for (int i=y; i<=y+h; i++) {
    float inter = map(i, y, y+h, 0, 1);
    color c = lerpColor(c1, c2, inter);
    stroke(c);
    line(x, i, x+w, i);
  }
  for (int i=0; i<=10; i++){
    int yy = y + int(i*h/10);
    stroke(0,40);
    line(x,yy,x+w,yy);
    textSize(10);
    fill(50);
    text(str(i), x+w, yy+5); 
  }
}
