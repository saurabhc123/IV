import java.util.Arrays;
// CS5764 InfoVis 
// Some sample code for HW6.
// You are free to use or modify as much of this as you want.

// data parameters:
int maxI = 1000000000;  // a big number. Keep modifying.
//int skip_every_n = 10000;
//int skip_reduction = 200;

float[] data = new float[maxI];
float minD, maxD;
int detailsStartIndex = 0;
int detailsEndIndex = maxI;
PFont f;
boolean rectInProgress = false;

float selectedOriginX, selectedOriginY, selectedOriginXTemp, selectedOriginYTemp, selectedEndX, selectedEndY;

float[] pointsToDraw = new float[10000];
int overviewSamplingRate;
int skipIndex;
int pointsToRenderInDetails;
float[] overViewData;

void setup() {
    size(1000, 800);
    f = createFont("Arial", 16, true); // STEP 2 Create Font
    // simulate some timeseries data, y = f(t)
    data[0] = 0.0;
    for (int i=1; i<maxI; i++)
        data[i] = data[i-1] + random(-1.0, 1.0);
        
    overviewSamplingRate = data.length / (width / 3);
    skipIndex = data.length / width;
    pointsToRenderInDetails = width; //<>//
    overViewData = GetOverviewData();
    
     //<>// //<>// //<>//
}
//<>//
void draw() { //<>// //<>//
    background(255);
    textFont(f, 8);                  // STEP 3 Specify font to be used
    // very simple timeseries visualization, VERY slow
    stroke(5);


    renderOverview();
    renderDetails(); //<>//
    fill(0, 0, 220, 100);
    rect(selectedOriginX, selectedOriginY, selectedEndX + 50, selectedEndY);
     //<>// //<>//
}

void renderOverview()
{
    //float[] retrievedData = GetOverviewData();
    fill(0, 0, 255);                         // STEP 4 Specify font color 
    //text("Processed points:" + retrievedData.length, 5.0, 20.0);
    //text("Total points:" + dp.getInputSize(), 5.0, 30.0);
    renderPoints(overViewData, 0.0, 0.0, width, height/2 - 20);
}

void renderDetails()
{
    float[] retrievedData = GetDetailsData();
    fill(0, 0, 255);                         // STEP 4 Specify font color 
    //text("Processed points:" + retrievedData.length, 5.0, 20.0);
    //text("Total points:" + dp.getInputSize(), 5.0, 30.0);
    float baseHeight = height/2 + 20;
    text("Start Index:" + detailsStartIndex ,5.0, baseHeight);
    text("End Index:" + detailsEndIndex ,5.0, baseHeight + 20);
    text("Total Points:" + (detailsEndIndex - detailsStartIndex) ,5.0, baseHeight + 40);
    renderPoints(retrievedData, 0.0, height/2 + 20, width, height - 20);
}

float[] GetDetailsData()
{
    println("Have to render details from " + detailsStartIndex + " to " + detailsEndIndex + " to process "+ (detailsEndIndex - detailsStartIndex) + " items.");
    if(skipIndex < 1)
        skipIndex = 1;
    pointsToRenderInDetails = (detailsEndIndex - detailsStartIndex) / skipIndex;
    float[] overviewData = new float[pointsToRenderInDetails];
    for(int i = 0; i< pointsToRenderInDetails ;i++)
    {
        overviewData[i] = data[detailsStartIndex + i*skipIndex];
    }
    //print(overviewData[60]);
    if(skipIndex / 10 > 100)
        skipIndex /= 10;
    else
    {
        if(skipIndex >=2)
            skipIndex -= 1;
    }
    return overviewData;
}
void mouseMoved()
{
    if (mouseX > 5.0 && mouseX < width - 10 && mouseY > height/2 + 10 && mouseY < height - 20)
    {
        int proportionX = (int)map(mouseX, 0, width, 0, data.length);
        int proportionY = (int)map(mouseY, height - 20, height/2 - 20, 0, proportionX / height);
        skipIndex = (detailsEndIndex - detailsStartIndex) / width;
        pointsToRenderInDetails = width;
        int nPointsToShow = detailsEndIndex - detailsStartIndex;
        //if (proportionX < 0)
        //    proportionX = 0;
        //if (proportionX > data.length - nPointsToShow)
        //    proportionX = data.length - nPointsToShow;
        int startIndex = (int)map(mouseX, 0, width, 0, data.length);;
        int endIndex = proportionX + proportionY;

        println("Have to render from " + startIndex + " to " + endIndex + " to process "+ (endIndex - startIndex) + " items.");
        detailsStartIndex = startIndex;
        detailsEndIndex = endIndex;
        selectedOriginX = map(proportionX, 0, data.length, 0, width);
        selectedOriginY = 0;
        //selectedEndX = map(width * (proportionY), startIndex, endIndex, 0, width);
        selectedEndX = map((detailsEndIndex - detailsStartIndex), 0, data.length, 0, width);
        selectedEndY = height/2;
    }

}


float[] GetOverviewData()
{
    int proportion = 10;
    int overviewSamplingRate = data.length / (width/proportion);
    float[] overviewData = new float[width*proportion];
    for(int i =0; i< width*proportion;i++)
    {
        overviewData[i] =  getSampleData(i + overviewSamplingRate);//data[i + overviewSamplingRate];
        //overviewData[i] =  data[i + overviewSamplingRate];
    }
    
    return overviewData;
}

float getSampleData(int index)
  {
     float sum = 0.0;
     for(int i = 0; i< overviewSamplingRate;i++)
         sum = data[i + index];
      
      return sum/(overviewSamplingRate);
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