import java.lang.Exception;
import java.util.Collections;


public class DataProcessor implements Runnable 
{  
  ArrayList<DataPoint> datapoints = null;//= new ArrayList<DataPoint>();
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
    
    
    synchronized(datapoints)
    {
        if(!locked)
        {
            locked = true;
            datapoints = new ArrayList<DataPoint>();
            float[] data1 = new float[maxI];
            println("Starting "+ maxI + " items");
            for (int i=0; i< maxI ; i++) 
            {
              float x = map(i, 0, maxI-1, 0, width-1);
              float y = map(data1[i], minD, maxD, height-1, 0.0);
              //point(x, y);
              //println("X:%f, Y:%f",x,y);
              datapoints.add(new DataPoint(x,y));
            }
            //println("X:%f, Y:%f",x,y);
            println("Processed "+ maxI + " items");
            //multiplier = multiplier * 10;
            maxI = maxI ;//* 10;
            locked = false;
        }
    }
  }
  
  public ArrayList<DataPoint> getDataPoints()
  {
      
      return datapoints;  
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