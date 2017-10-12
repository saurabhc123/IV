import java.util.Arrays;

// CS5764 InfoVis 
// Some sample code for HW6.
// You are free to use or modify as much of this as you want.

// data parameters:
int maxI = 100000000;  // a big number. Keep modifying.
int skip_every_n = 1000;
int skip_reduction = 200;
int skip_every_n_details = 100;

float[] data = new float[maxI];
float minD, maxD;
DataProcessor dp;
DataProcessor detailsProcessor;

void setup() {
  size(1000, 800);
  // simulate some timeseries data, y = f(t)
  data[0] = 0.0;
  for (int i=1; i<maxI; i++)
    data[i] = data[i-1] + random(-1.0, 1.0);
  dp = new DataProcessor(data);
  
  //minD = min(data);
  //maxD = max(data);
  int startIndex = (int)(data.length *0.49);
  int endIndex = (int)(data.length *0.51);
  float[] newArray = Arrays.copyOfRange(data, startIndex, endIndex);
  detailsProcessor = new DataProcessor(newArray);
  //while(true)
  {
      float[] retrievedData = getData1();
      println("Got " + retrievedData.length + " items"); //<>//
  }
}

void draw() { //<>//
  background(0);
  // very simple timeseries visualization, VERY slow
  stroke(255);
  float[] retrievedData = getData(dp);
  renderOverview(retrievedData);
  renderDetails(data);
  dp.run();
  detailsProcessor.run();
}

void renderDetails(float[] retrievedData)
{
    retrievedData = getData(detailsProcessor);
    println("Details has " + retrievedData.length + " items");
    renderPoints(retrievedData, 0.0,height/2 + 20, width, height);
}

void renderOverview(float[] retrievedData)
{
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

float[] getData1()
{
    return data;
}