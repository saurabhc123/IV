import java.lang.Exception;
import java.util.Collections;


public class DataProcessor implements Runnable 
{  
  
  boolean locked = false;
  int multiplier = 1;
  int sampleSize = 1;
  float[] processedData = new float[sampleSize];
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
    //https://beginnersbook.com/2013/12/how-to-synchronize-arraylist-in-java-with-example/
    if(sampleSize > inputData.length){
        println("Processed all data.");
        return;
    }
    
    multiplier = inputData.length/(sampleSize);
    synchronized(processedData)
    {
        println("Generating data");
        processedData = new float[sampleSize];
        processedData[0] = 0.0;
        for (int i=1; i<sampleSize; i++)
            processedData[i] = data[i* multiplier];
        println(processedData.length);
        println(processedData[processedData.length/2]);
        println("Done generating data");
        sampleSize += 100000; 
    }
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