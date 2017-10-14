import java.util.Arrays;
// CS5764 InfoVis 
// Some sample code for HW6.
// You are free to use or modify as much of this as you want.

// data parameters:
int maxI = 100000000;  // a big number. Keep modifying.
//int skip_every_n = 10000;
//int skip_reduction = 200;

float[] data = new float[maxI];
float minD, maxD;
DataProcessor dp;
DetailsDataProcessor detailsProcessor;
PFont f;
boolean rectInProgress = false;

float selectedOriginX, selectedOriginY, selectedOriginXTemp, selectedOriginYTemp, selectedEndX, selectedEndY;

float[] pointsToDraw = new float[10000];

void setup() {
    size(1000, 800);
    f = createFont("Arial", 16, true); // STEP 2 Create Font
    // simulate some timeseries data, y = f(t)
    data[0] = 0.0;
    for (int i=1; i<maxI; i++)
        data[i] = data[i-1] + random(-1.0, 1.0);
    dp = new DataProcessor(data);
    detailsProcessor =  new DetailsDataProcessor(data);
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
    textFont(f, 8);                  // STEP 3 Specify font to be used
    // very simple timeseries visualization, VERY slow
    stroke(0); //<>//
    float[] retrievedData = getData(dp);
    float[] detailedData = getData(detailsProcessor);
    renderOverview(retrievedData);
    
    //if (frameCount % 15 == 0) 
    {
        //thread("processBigData");
    }

    stroke(0);
    fill(0, 0, 220, 100);
    if (!rectInProgress)
        rect(selectedOriginX, selectedOriginY, selectedEndX, selectedEndY); 
    //println("Details Processor has " + detailsProcessor.getInputSize() + " items.");
    dp.run();
    processBigData();
    float min = min(pointsToDraw);
    float max = max(pointsToDraw);
    if(max == 0.0 && min == 0.0)
    {
        renderDetails(detailedData);
    }
    for (int i=0; i<pointsToDraw.length; i++) 
    {
        float value = pointsToDraw[i];
        float x = map(i, 0, pointsToDraw.length, 0, width-1);
        float y = map(value, min, max, height/2, height - 1);
        point(x, y);
    }
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

void mouseMoved()
{
    if (mouseX > 0.0 && mouseX < width && mouseY > height/2 && mouseY < height)
    {
        int proportionY = (int)map(mouseY, height/2, height, 0, data.length);
        println("proportionY: ", proportionY);
        int startIndex = proportionY - 5000;
        int endIndex = proportionY + 5000; //<>//
        println("Have to render from " + startIndex + " to " + endIndex + " to process "+ (endIndex - startIndex) + " items.");
        //detailsProcessor =  new DetailsDataProcessor(data,startIndex, endIndex);
        //detailsProcessor.run(); //<>//
        //rectInProgress = false;
        //text("Start: " + startIndex + " End: " + endIndex + "Total: "+ (endIndex - startIndex) + " items." ,5.0, 500.0);


        //println("Got " + retrievedData.length + " items");
        for (int i=startIndex; i<endIndex; i++) 
        {
            float value = data[i];
            pointsToDraw[i - startIndex] = value;
        }
    }
}

void mouseDragged()
{
    rectInProgress = true;
    selectedEndX = mouseX;
    selectedEndY = mouseY;
    stroke(0);
    fill(0, 0, 220, 100);
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
    detailsProcessor =  new DetailsDataProcessor(data, startIndex, endIndex);
    detailsProcessor.run(); //<>//
    rectInProgress = false;
}

void renderDetails(float[] retrievedData)
{
    //retrievedData = getData(detailsProcessor);
    if (retrievedData == null)
        return;
    println("Details has " + retrievedData.length + " items");

    fill(255, 0, 0);                         // STEP 4 Specify font color 
    text("Processed points:" + retrievedData.length, 5.0, height/2 - 15);
    text("Total points:" + detailsProcessor.getInputSize(), 5.0, height/2);
    renderPoints(retrievedData, 0.0, height/2 + 20, width, height);
}

void renderOverview(float[] retrievedData)
{
    fill(0, 0, 255);                         // STEP 4 Specify font color 
    text("Processed points:" + retrievedData.length, 5.0, 20.0);
    text("Total points:" + dp.getInputSize(), 5.0, 30.0);
    renderPoints(retrievedData, 0.0, 0.0, width, height/2 - 20);
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


float[] getData(DetailsDataProcessor d)
{
    //DataProcessor dp = new DataProcessor();
    float[] retrievedData = d.getDataPoints();
    return retrievedData;
}

float[] getData()
{
    return data;
}