import java.lang.Exception;
import java.util.Collections;


public class DataProcessor implements Runnable 
{  
  float[] processedData = new float[10];
  boolean locked = false;
  int multiplier = 1;
  
  
  public DataProcessor() 
  {    
    
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
    
    
    synchronized(processedData)
    {
        println("Generating data");
        processedData = new float[maxI * multiplier];
        processedData[0] = 0.0;
        for (int i=1; i<processedData.length; i++)
            processedData[i] = processedData[i-1] + random(-1.0, 1.0);
        println(processedData.length);
        println(processedData[processedData.length/2]);
        println("Done generating data");
        multiplier *= 2; 
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