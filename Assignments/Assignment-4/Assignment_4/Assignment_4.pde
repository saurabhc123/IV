import java.util.Iterator; //<>//


Table inputTable;
float plotX1, plotY1;
float plotX2, plotY2;
int yearMin, yearMax;
int[] years;
float _min, _max = 0;
int _numberOfBins = 40;
int[] bins;
float barWidth = 10;
float labelX, labelY;
int _minBinValue = 100000;
int _maxBinValue=0;

void setup() 
{  
    size(720, 405);  
    inputTable = loadTable("events-10K.csv");
    println(inputTable.getRowCount());  
    _min = inputTable.getFloatList(0).min();
    _max = inputTable.getFloatList(0).max();
    smooth();
    print(_max, _min);
    bins = loadDataInBins(inputTable);
  
    // Corners of the plotted time series  
    plotX1 = 120;  
    plotX2 = width - 80;  
    labelX = 50;  
    plotY1 = 60;  
    plotY2 = height - 70;  
    labelY = height - 25;
    noLoop();
}

void draw()
{
    //noStroke(  );
    //rectMode(CORNERS); 
    //rect(10,50,100,5);
    drawDataBars();
}



void drawDataBars() {  
    //noStroke(  );
    fill(0, 0, 255);
    rectMode(CORNERS);  
    for (int row = 0; row < _numberOfBins; row++) 
    {    
        float value = bins[row];      
        float x = map(row, 0, _numberOfBins, plotX1, plotX2);      
        float y = map(value, _minBinValue, _maxBinValue, plotY2, plotY1);
        //println("X:"+x+" Y:"+y);
    
        rect(x-barWidth/2, plotY2, x+barWidth/2, y);
    }
}


int[] loadDataInBins(Table tableParam)
{
    int[] binValues = new int[_numberOfBins];
    float partitionSize = (_max - _min)/_numberOfBins;
    float start = _min;
  
    Iterator<Float> iterator = tableParam.getFloatList(0).iterator();
    for (int i =0; i< _numberOfBins; i++)
    {
        print("Iterating over i ->" + i);
        while (iterator.hasNext())
        {
            float iteratorValue = iterator.next();
            int y = 0;
            if (iteratorValue >= start && iteratorValue < start + partitionSize)
            {
                //println("Added ->" + iteratorValue + " Y->"+ y);
                binValues[i]++;
                y++;
            } 
            else
            {
              break;
            }
        }
        println("Done iterating over i ->" + i + " ItemCount:" + binValues[i]);
        if (binValues[i] < _minBinValue)
            _minBinValue = binValues[i];
        if (binValues[i] > _maxBinValue)
            _maxBinValue = binValues[i];
        start = start + partitionSize;
    }
  
  
  
    return binValues;
}