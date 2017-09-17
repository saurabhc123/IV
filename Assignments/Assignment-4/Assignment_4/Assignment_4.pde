import java.util.Iterator; //<>// //<>// //<>//



Table inputTable;
float plotX1, plotY1, kde_plotY1, kde_plotY2,kde_plotY3;
float plotX2, plotY2;
int yearMin, yearMax;
int[] years;
float _min, _max = 0;
int _numberOfBins = 100;
int[] bins;
float barWidth = 5;
float labelX, labelY;
int _minBinValue = 100000;
int _maxBinValue=0;
double _sigma = 1.0;
float[] _distributionValues;
float _minKde = 10000.0;
float _maxKde = 0.0;
float _sumKde = 0.0;
float _sampleSize = 0.0;

void setup() 
{  
    size(720, 800);  
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
    plotY2 = height/2 - 20;  
    labelY = height/2 - 25;
    kde_plotY1 = height/2 + 20;
    kde_plotY2 = kde_plotY1 + 200; 
    kde_plotY3 = height - 20; 

    //float[] inputValues = new float[]{44.0, 20.0, 75.5, 95.9, 95.8,42.0,30.0,12.0,13.0,10.0};
    float[] inputValues = inputTable.getFloatList(0).values();
    _sampleSize = inputValues.length;        
    _distributionValues = generateKDEDistribution(inputValues);
    println("Finished proceessing KDE distribution. Min KDE:"+_minKde+ " Max KDE:"+_maxKde); //<>//
    //processKDEDataForThemeRiver();

    noLoop();
}

void draw()
{
    //noStroke(  );
    //rectMode(CORNERS); 
    //rect(10,50,100,5);
    drawDataBars();
    drawExp();
    drawThemeRiver();
    //drawDensityCurve();
}

void drawExp()
{
    //background(224);
    fill(0,0,255);
    stroke(#5679C1);
    //noFill(  );
    strokeWeight(0.5);
    beginShape(  );  
    int rowCount = _distributionValues.length;
    float themeRiverYCorrection = -_sumKde/(_sampleSize + 1);
    for (int row = 0; row < rowCount; row++) 
    {    
        float value = _distributionValues[row];      
        float x = map(row, 0, rowCount, plotX1, plotX2);      
        //float y = map(value, 0, 100.0, kde_plotY2, kde_plotY1);
        float y = map(value,_minKde, _maxKde, kde_plotY2  + kde_plotY2*themeRiverYCorrection, kde_plotY1);
        //float y = map(value, _min, _max, plotY2, plotY1);
        curveVertex(x, y);
        smooth();
        println("x:"+x+"   y:"+y);
    }  
    vertex(plotX2, kde_plotY2);  
    vertex(plotX1, kde_plotY2);  
    endShape(CLOSE);
    //endShape();
}

void drawThemeRiver()
{
    //background(224);
    fill(0,0,255);
    stroke(#5679C1);
    //noFill(  );
    strokeWeight(0.5);
    beginShape(  );  
    int rowCount = _distributionValues.length;
    float themeRiverYCorrection = -_sumKde/(_sampleSize + 1);
    for (int row = 0; row < rowCount; row++) 
    {    
        float value = _distributionValues[row];      
        float x = map(row, 0, rowCount, plotX1, plotX2);      
        //float y = map(value, 0, 100.0, kde_plotY2, kde_plotY1);
        float y = map(value,_minKde, _maxKde, kde_plotY2, kde_plotY3);
        //float y = map(value, _min, _max, plotY2, plotY1);
        curveVertex(x, y);
        smooth();
        println("x:"+x+"   y:"+y);
    }  
    vertex(plotX2, kde_plotY2);  
    vertex(plotX1, kde_plotY2);  
    endShape(CLOSE);
    //endShape();
}


void drawDensityCurve()
{
    drawKDEDistribution(_distributionValues);
}

float[] generateKDEDistribution(float[] inputValues)
{
    float[] result = new float[inputValues.length];
    for (int i =0; i<inputValues.length; i++)
    {
        result[i] = generateKDEValueForSample(inputValues[i], inputValues);
        _sumKde =+ result[i];
        println("Done iterating over i ->" + i + " KDE Value:" + result[i]);
    }

    return result;
}


float generateKDEValueForSample(float x, float[] inputValues)
{
    float result = 0.0;

    for (float val : inputValues)
    {
        result += getGaussian(x-val, _sigma);
    }

    if (result > _maxKde)
        _maxKde = result;
    if (result < _minKde)
        _minKde = result;

    return result;
}

public static double getGaussian(float x, double sigma) 
{
    return Math.exp(-(x*x) / (2*sigma)) / (Math.sqrt(2 * Math.PI)*sigma);
}

void drawKDEDistribution(float[] inputValues)
{
    //fill(0, 0, 255);
    //noFill();
    strokeWeight(2);
    beginShape(  );  
    int rowCount = inputValues.length;
    float themeRiverYCorrection = -_sumKde/(_sampleSize + 1);
    for (int row = 0; row < rowCount; row++) 
    {    
        float value = inputValues[row];      
        float x = map(row, 0, rowCount, plotX1, plotX2);      
        float y = map(value, 0, 80.0, kde_plotY2, kde_plotY1);
        //float y = map(value, _minKde, _maxKde, kde_plotY2, kde_plotY1);
        //float y = map(value, _min, _max, plotY2, plotY1);
        vertex(x, y);
    }  
    endShape(  );
}

void drawDataBars() {  
    noStroke(  );
    fill(0, 0, 255);
    rectMode(CORNERS);  
    barWidth = (plotX2 - plotX1)/_numberOfBins;
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
        //print("Iterating over i ->" + i);
        while (iterator.hasNext())
        {
            float iteratorValue = iterator.next();
            int y = 0;
            if (iteratorValue >= start && iteratorValue < start + partitionSize)
            {
                //println("Added ->" + iteratorValue + " Y->"+ y);
                binValues[i]++;
                y++;
            } else
            {
                break;
            }
        }
        //println("Done iterating over i ->" + i + " ItemCount:" + binValues[i]);
        if (binValues[i] < _minBinValue)
            _minBinValue = binValues[i];
        if (binValues[i] > _maxBinValue)
            _maxBinValue = binValues[i];
        start = start + partitionSize;
    }



    return binValues;
}