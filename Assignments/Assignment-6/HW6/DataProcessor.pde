import java.lang.Exception;
import java.util.Collections;



public class DataProcessor implements Runnable 
{  
  
  boolean locked = false;
  //int multiplier = 1;
  int sampleSize = 0;
  float[] processedData = null;//new float[sampleSize];
  float[] inputData;
  int skip_every_n, skip_reduction;
  int inputStartIndex, inputEndIndex;
  
  public DataProcessor(float[] inputData) 
  {    
    this.inputData = inputData;
    this.inputStartIndex = 0;
    this.inputEndIndex = this.inputData.length;
    skip_every_n = this.inputData.length/10000;
    skip_reduction = skip_every_n/50;
    Thread thread = new Thread(this);    
    thread.start();
    this.run();
  }
  
  public DataProcessor(float[] inputData, int inputStart, int inputEnd) 
  {    
    if(this.inputData == null)
        return;
    this.inputData = inputData;
    this.inputStartIndex = inputStart;
    this.inputEndIndex = inputEnd;
    int powOf10 = (int)(log(getInputSize())/log(10));
    println("Power: "+ powOf10);
    skip_every_n = (this.inputEndIndex - this.inputStartIndex)/pow(10, (int)powOf10 - 5);
    skip_reduction = 8*skip_every_n/(pow(10, powOf10-6));
    if(skip_every_n <1){
        
        skip_reduction = 1;
    }
    Thread thread = new Thread(this);    
    thread.start();
    this.run();
  }
  
  int pow (int a, int b)
{
    if ( b == 0)        return 1;
    if ( b == 1)        return a;
    if (b%2 == 0)    return     pow ( a * a, b/2); //even a=(a^2)^b/2
    else                return a * pow ( a * a, b/2); //odd  a=a*(a^2)^b/2

}
  
  public boolean isLocked()
  {
      return locked;
  }
  
  public void run(  ) 
  {    
    //println("skip_every_n: "+ skip_every_n);
    //println("skip_reduction: "+ skip_reduction);
    if(skip_every_n <= 4){
        println("Processed all data.");
        return;
    }

    
    //Not that useful as it gets very granular for this.
    //if(skip_every_n <= skip_reduction)
    {
        //skip_reduction /= 10;
    }
    
    sampleSize = (this.inputEndIndex - this.inputStartIndex) / skip_every_n;
      
    //https://beginnersbook.com/2013/12/how-to-synchronize-arraylist-in-java-with-example/
    
    processedData = new float[sampleSize];
    //multiplier = inputData.length/(sampleSize);
    //synchronized(processedData)
    {
        //println("Generating data");
        processedData = new float[sampleSize];
        processedData[0] = 0.0;
        for (int i=1; i<sampleSize; i++)
            processedData[i] =  getSampleData(i);//data[i * skip_every_n];
        //println(processedData.length);
        //println(processedData[processedData.length/2]);
        //println("Sample size: "+ sampleSize);
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
         sum = inputData[this.inputStartIndex + i];
      
      return sum/(skip_every_n);
  }
  
  int getInputSize()
  {
    return (this.inputEndIndex - this.inputStartIndex);
  }
  
  public float[] getDataPoints()
  {
    //this.run();
    //synchronized(processedData)
    {
        //println("Asked for data");      
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