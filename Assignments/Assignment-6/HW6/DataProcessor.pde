import java.lang.Exception;
import java.util.Collections;


public class DataProcessor implements Runnable 
{  
  
  boolean locked = false;
  //int multiplier = 1;
  int sampleSize = 0;
  float[] processedData = null;//new float[sampleSize];
  float[] inputData;
  
  public DataProcessor(float[] inputData) 
  {    
    this.inputData = inputData;
    Thread thread = new Thread(this);    
    thread.start(  );
  }
  
  public boolean isLocked()
  {
      return locked;
  }
  
  public void run(  ) 
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
    
    sampleSize = data.length / skip_every_n;
      
    //https://beginnersbook.com/2013/12/how-to-synchronize-arraylist-in-java-with-example/
    
    processedData = new float[sampleSize];
    //multiplier = inputData.length/(sampleSize);
    synchronized(processedData)
    {
        println("Generating data");
        processedData = new float[sampleSize];
        processedData[0] = 0.0;
        for (int i=1; i<sampleSize; i++)
            processedData[i] =  getSampleData(i);//data[i * skip_every_n];
        println(processedData.length);
        println(processedData[processedData.length/2]);
        println("Sample size: "+ sampleSize);
        println("Skipping every "+ skip_every_n + " samples.");
        //println("Done generating data");
        skip_every_n -= skip_reduction; 
        //skip_every_n /= 2; 
    }
  }
  
  
  float getSampleData(int index)
  {
     float sum = 0.0;
     for(int i = index * skip_every_n; i< (index + 1) * skip_every_n;i++)
         sum = data[i];
      
      return sum/(skip_every_n);
  }
  
  public float[] getDataPoints()
  {
    this.run();
    synchronized(processedData)
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