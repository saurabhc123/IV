// CS5764 InfoVis 
// Some sample code for HW6.
// You are free to use or modify as much of this as you want.

// data parameters:
int maxI = 1000000000;  // a big number

float[] data = new float[maxI];
float minD, maxD;
DataProcessor dp;

void setup() {
  size(1000, 800);
  // simulate some timeseries data, y = f(t)
  data[0] = 0.0;
  for (int i=1; i<maxI; i++)
    data[i] = data[i-1] + random(-1.0, 1.0);
  minD = min(data);
  maxD = max(data);
  dp = new DataProcessor(data);
}

void draw() {
  background(0);
  // very simple timeseries visualization, VERY slow
  float[] points = dp.getDataPoints();  
  synchronized(dp.processedData)
    {
          processBigData(points);
    }
  //dp.run();
  }


void processBigData(float[] pointsToRender)
{
  stroke(255);
  float min = min(pointsToRender);
  float max = max(pointsToRender);
  int lengthOfArray = pointsToRender.length;
  for (int i=0; i<lengthOfArray; i++) {
    float x = map(i, 0, lengthOfArray-1, 0, width-1);
    float y = map(pointsToRender[i], min, max, height-1, 0.0);
    point(x, y);
  }
}