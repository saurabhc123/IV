// CS5764 InfoVis 
// Some sample code for HW6.
// You are free to use or modify as much of this as you want.

// data parameters:
int maxI = 10000000;  // a big number. Keep modifying.
int skip_every_n = 10000;
int skip_reduction = 50;

float[] data = new float[maxI];
float minD, maxD;
DataProcessor dp;

void setup() {
  size(1000, 800);
  // simulate some timeseries data, y = f(t)
  data[0] = 0.0;
  for (int i=1; i<maxI; i++)
    data[i] = data[i-1] + random(-1.0, 1.0);
  dp = new DataProcessor(data);
  //minD = min(data);
  //maxD = max(data);
  
  //while(true)
  {
      float[] retrievedData = getData1();
      println("Got " + retrievedData.length + " items"); //<>//
  }
}

void draw() {
  background(0);
  // very simple timeseries visualization, VERY slow
  stroke(255);
  float[] retrievedData = getData1();
  minD = min(retrievedData);
  maxD = max(retrievedData);
  println("Got " + retrievedData.length + " items");
  for (int i=0; i<retrievedData.length; i++)  //<>//
  {
    float x = map(i, 0, retrievedData.length-1, 0, width-1);
    float y = map(retrievedData[i], minD, maxD, height-1, 0.0);
    point(x, y);
  }
}

float[] getData1()
{
    //DataProcessor dp = new DataProcessor();
    float[] retrievedData = dp.getDataPoints();
    return retrievedData;
}

float[] getData()
{
    return data;
}