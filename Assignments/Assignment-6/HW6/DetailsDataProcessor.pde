import java.lang.Exception;
import java.util.Collections;



public class DetailsDataProcessor implements Runnable 
{  
  
  boolean locked = false;
  //int multiplier = 1;
  int sampleSize = 0;
  float[] processedData = null;//new float[sampleSize];
  float[] inputData;
  int numberOfItemsToBeSkipped;
  int numberOfItemsToIncreaseEachSkip = 0;
  int inputStartIndex, inputEndIndex;
  
  public DetailsDataProcessor(float[] inputData) 
  {    
    this.inputData = inputData;
    this.inputStartIndex = 0;
    this.inputEndIndex = getInputSize();
    numberOfItemsToBeSkipped = getInputSize()/1000;
    Thread thread = new Thread(this);    
    thread.start();
    this.run();
  }
  
  public DetailsDataProcessor(float[] inputData, int inputStart, int inputEnd) 
  {    
    this.inputData = inputData;
    this.inputStartIndex = inputStart;
    this.inputEndIndex = inputEnd;
    int powOf10 = (int) (log(getInputSize())/log(10));
    println("Power: "+ powOf10);
    int divider = 10000;
    numberOfItemsToBeSkipped = (this.inputEndIndex - this.inputStartIndex)/divider;
    numberOfItemsToIncreaseEachSkip = numberOfItemsToBeSkipped / 10;
    Thread thread = new Thread(this);    
    thread.start();
    this.run();
  }
  
  
  public boolean isLocked()
  {
      return locked;
  }
  
  public void run(  ) 
  {    
    //println("numberOfItemsToBeSkipped: "+ numberOfItemsToBeSkipped);
    if(numberOfItemsToBeSkipped <= 1){
        
        //println("Processed all details.");
        return;
    }
    
    if(numberOfItemsToBeSkipped <= 2){
        numberOfItemsToBeSkipped = 1;
    }

    sampleSize = (this.inputEndIndex - this.inputStartIndex) / numberOfItemsToBeSkipped;

      
    //https://beginnersbook.com/2013/12/how-to-synchronize-arraylist-in-java-with-example/
    
    processedData = new float[sampleSize];
    //multiplier = inputData.length/(sampleSize);
    //synchronized(processedData)
    {
        //println("Generating data");
        processedData = new float[sampleSize];
        processedData[0] = 0.0;
        for (int i=1; i<sampleSize; i++)
            processedData[i] =  getSampleData(i);//data[i * numberOfItemsToBeSkipped];
        //println(processedData.length);
        //println(processedData[processedData.length/2]);
        //println("Sample size: "+ sampleSize);
        println("Skipping every "+ numberOfItemsToBeSkipped + " samples.");
        //println("Done generating data");
        //numberOfItemsToBeSkipped -= numberOfItemsToIncreaseEachSkip; 
        //numberOfItemsToBeSkipped /= 10; 
        if(numberOfItemsToBeSkipped <= numberOfItemsToIncreaseEachSkip)
        {
            //numberOfItemsToIncreaseEachSkip = numberOfItemsToBeSkipped / 10;
        }
    }
  }
  
  
  float getSampleData(int index)
  {
     float sum = 0.0;
     for(int i = index * numberOfItemsToBeSkipped; i< (index + 1) * numberOfItemsToBeSkipped;i++)
         sum = inputData[this.inputStartIndex + i];
      
      return sum/(numberOfItemsToBeSkipped);
  }
  
  float getSampleData1(int index)
  {
     return inputData[this.inputStartIndex + index];
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