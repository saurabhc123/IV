import java.util.Arrays;
// CS5764 InfoVis 
// Some sample code for HW6.
// You are free to use or modify as much of this as you want.

// data parameters:
int maxI = 1000000;  // a big number. Keep modifying.
//int skip_every_n = 10000;
//int skip_reduction = 200;

float[] data = new float[maxI];
float minD, maxD;
DataProcessor dp;
DataProcessor detailsProcessor;
PFont f;
boolean rectInProgress = false;

float selectedOriginX, selectedOriginY,selectedOriginXTemp, selectedOriginYTemp, selectedEndX, selectedEndY;

void setup() {
  size(1000, 800);
  f = createFont("Arial",16,true); // STEP 2 Create Font
  // simulate some timeseries data, y = f(t)
  data[0] = 0.0;
  for (int i=1; i<maxI; i++)
    data[i] = data[i-1] + random(-1.0, 1.0);
  dp = new DataProcessor(data);
  detailsProcessor =  new DataProcessor(data);
  //minD = min(data);
  //maxD = max(data);
  
  //while(true)
  {
      float[] retrievedData = getData(dp);
      println("Got " + retrievedData.length + " items"); //<>// //<>//
  }
}
 //<>//
void draw() { //<>// //<>//
  background(255);
  textFont(f,8);                  // STEP 3 Specify font to be used
  // very simple timeseries visualization, VERY slow
  stroke(0); //<>//
  float[] retrievedData = getData(dp);
  float[] detailedData = getData(detailsProcessor);
  renderOverview(retrievedData);
  renderDetails(detailedData);
  //if (frameCount % 59 == 0) 
  {
    //thread("processBigData");
  }
  processBigData();
  stroke(0);
  fill(0,0,220,100);
  if(!rectInProgress)
      rect(selectedOriginX, selectedOriginY, selectedEndX, selectedEndY); 
  println("Details Processor has " + detailsProcessor.getInputSize() + " items.");
  dp.run();
}

void processBigData()
{

 //while(true)
 detailsProcessor.run();
}

void mousePressed() 
{
  //println("Mouse dragged from "+ pmouseX + "," + pmouseY + "to" + mouseX + "," + mouseY);
  rectInProgress = true;
  selectedOriginXTemp = mouseX;
  selectedOriginYTemp = mouseY;
}

void mouseDragged()
{
    rectInProgress = true;
    selectedEndX = mouseX;
    selectedEndY = mouseY;
    stroke(0);
    fill(0,0,220,100);
    rect(selectedOriginXTemp, selectedOriginYTemp, selectedEndX - selectedOriginXTemp, selectedEndY-selectedOriginYTemp);
    //rectInProgress = false;
}

void mouseReleased() 
{
  //println("Mouse dragged from "+ pmouseX + "," + pmouseY + "to" + mouseX + "," + mouseY);
  selectedOriginX = selectedOriginXTemp < mouseX ? selectedOriginXTemp:mouseX;
  selectedOriginY = 0;
  selectedEndX = selectedOriginXTemp < mouseX ? mouseX - selectedOriginX : selectedOriginXTemp - mouseX;
  selectedEndY = height/2 - 20;
  int startIndex = (int)(data.length * (selectedOriginX/width));
  int endIndex = (int)(data.length * ((selectedEndX + selectedOriginX)/width));
  println("Have to render from " + startIndex + " to " + endIndex + "to process "+ (endIndex - startIndex) + " items.");
  //float[] newArray = Arrays.copyOfRange(data, startIndex, endIndex);
  detailsProcessor =  new DataProcessor(data,startIndex, endIndex);
  detailsProcessor.run();
  rectInProgress = false;
}

void renderDetails(float[] retrievedData)
{
    //retrievedData = getData(detailsProcessor);
    println("Details has " + retrievedData.length + " items");
    
    fill(255,0,0);                         // STEP 4 Specify font color 
    text("Processed points:" + retrievedData.length ,5.0, height/2 - 15);
    text("Total points:" + detailsProcessor.getInputSize() ,5.0, height/2);
    renderPoints(retrievedData, 0.0,height/2 + 20, width, height);
}

void renderOverview(float[] retrievedData)
{
    fill(0,0,255);                         // STEP 4 Specify font color 
    text("Processed points:" + retrievedData.length ,5.0, 20.0);
    text("Total points:" + dp.getInputSize() ,5.0, 30.0);
    renderPoints(retrievedData, 0.0,0.0, width, height/2 - 20);
}

void renderPoints(float[] retrievedData, float originX, float originY, float w, float h)
{
  float min = min(retrievedData);
  float max = max(retrievedData);
  //println("Got " + retrievedData.length + " items");
  for (int i=0; i<retrievedData.length; i++) 
  {
    float x = map(i, 0, retrievedData.length-1, originX, w-1);
    float y = map(retrievedData[i], min, max, h-1, originY);
    point(x, y);
  }
}

float[] getData(DataProcessor d)
{
    //DataProcessor dp = new DataProcessor();
    float[] retrievedData = d.getDataPoints();
    return retrievedData;
}

float[] getData()
{
    return data;
}