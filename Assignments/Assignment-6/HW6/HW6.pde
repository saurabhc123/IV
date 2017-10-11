// CS5764 InfoVis 
// Some sample code for HW6.
// You are free to use or modify as much of this as you want.

// data parameters:
int maxI = 1000;  // a big number

float[] data = new float[maxI];
float minD, maxD;
ArrayList<DataPoint> datapoints = new ArrayList<DataPoint>();;

void setup() {
  size(1000, 800);
  // simulate some timeseries data, y = f(t)
  data[0] = 0.0;
  for (int i=1; i<maxI; i++)
    data[i] = data[i-1] + random(-1.0, 1.0);
  minD = min(data);
  maxD = max(data);
}

void draw() {
  background(0);
  // very simple timeseries visualization, VERY slow
  stroke(255);
  
  //ArrayList<DataPoint> datapoints = readData();
  //while(datapoints == null || datapoints.size() != maxI)
  {
    //datapoints =
    readData();
  }
}

void readData()
{
  DataProcessor dataProcessor = new DataProcessor();
  
  if( !dataProcessor.isLocked()) //<>//
  {
      println("Inside the lock:Max is " + maxI);
      ArrayList<DataPoint> datapoints =  dataProcessor.getDataPoints();
      if(datapoints != null)
      {
      synchronized(datapoints)
      {
      if(datapoints != null)
          {
            for(DataPoint datapoint:datapoints)
            {
              point(datapoint.x, datapoint.y);
            }
            
          }
      }
      }
  }

}

//Challenges
//1. How to process data in the background and update the display https://www.safaribooksonline.com/library/view/visualizing-data/9780596514556/ch06.html
//2. How to support zoom in
//3. How to support panning left or right