Table table;
float dataMin, dataMax;
float plotX1, plotY1;
float plotX2, plotY2;
int yearMin, yearMax;
int[] years;

void setup(  ) {  
  size(720, 405);  
  table = loadTable("events-10K.csv","header");
   
  yearMin = years[0];  
  yearMax = years[years.length - 1];  
  dataMin = 0;  
  dataMax = data.getTableMax(  );  
  // Corners of the plotted time series  
  plotX1 = 50;  
  plotX2 = width - plotX1;  
  plotY1 = 60;  
  plotY2 = height - plotY1;
  smooth(  );
}