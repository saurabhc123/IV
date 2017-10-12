import java.lang.Exception;
import java.util.Collections;


public class DataProcessor implements Runnable 
{  
  
  boolean locked = false;
  //int multiplier = 1;
  int sampleSize = 0;
  float[] processedData = null;//new float[sampleSize];
  float[] inputData;
  boolean skipDataEveryN;
  
  public DataProcessor(float[] inputData) 
  {    
    this(inputData, true);
  }
  
  public DataProcessor(float[] inputData, boolean skipData) 
  {    
    this.skipDataEveryN = skipData;
    this.inputData = inputData;
    Thread thread = new Thread(this);    
    thread.start();
    this.run();
  }
  
  public boolean isLocked()
  {
      return locked;
  }
  
  public void run() 
  {    
    if(skip_every_n <= 0){
        println("Processed all data.");
        return;
    }
    
    //Not that useful as it gets very granular for this.
    //if(skip_every_n <= skip_reduction)
    //{
        //skip_reduction /= 10;
    //}
    
    if(this.skipDataEveryN)
    {
        sampleSize = this.inputData.length / skip_every_n;
    }
    else
    {
        sampleSize = this.inputData.length;
    }
      
    //https://beginnersbook.com/2013/12/how-to-synchronize-arraylist-in-java-with-example/
    
    processedData = new float[sampleSize];
    //multiplier = inputData.length/(sampleSize);
    //synchronized(processedData)
    {
        println("Generating data");
        processedData = new float[sampleSize];
        processedData[0] = 0.0;
        for (int i=1; i<sampleSize; i++)
        {
            if(this.skipDataEveryN)
                processedData[i] =  getSampleData(i,skip_every_n);//data[i * skip_every_n];
            else
                processedData[i] =  getSampleData(i,skip_every_n_details);
        }
        println(processedData.length);
        println(processedData[processedData.length/2]);
        println("Sample size: "+ sampleSize);
        println("Skipping every "+ skip_every_n + " samples.");
        //println("Done generating data");
        if(this.skipDataEveryN)
        {
            skip_every_n -= skip_reduction; 
            //skip_every_n /= 2; 
        }
    }
  }
  
  
  float getSampleData(int index, int skip_value)
  {
     float sum = 0.0;
     for(int i = index * skip_value; i< (index + 1) * skip_value;i++)
         sum = this.inputData[i];
     return sum/(skip_value);
  }
  
  float getDataAtIndex(int index)
  {
     return this.inputData[index];
  }
  
  public float[] getDataPoints()
  {
    //this.run();
    //synchronized(processedData)
    {
        println("Asked for data");      
        return processedData;
    }
  }
}


public class DataPoint
{
  float x,y=0.0f;
  
  DataPoint(float x, float y)
  {
    this.x = x;
    this.y = y;
  }
}