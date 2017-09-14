// simple scatterplot example

int x[] = {100, 200, 300};
int y[] = {10, 200, 30};
Table table;

void setup(){
  //println("hello world");
  size(500,500);
  table = loadTable("states.csv", "header"); 
  println(table.getRowCount());
}

void draw(){
  background(0,0,0);
  fill(70,130,180, 200);  //steelblue
  //stroke(0,255,0);
  //ellipse(200,100,30,30);
  //ellipse(mouseX,mouseY,30,30);
  //for(int i=0; i<3; i++)
  //  ellipse(x[i],500-y[i], 30,30);
  for(TableRow r: table.rows())
    ellipse(
      map(r.getInt("IncomeperCapita"), 
        min(table.getIntColumn("IncomeperCapita")),
        max(table.getIntColumn("IncomeperCapita")), 30,470),
      map(r.getFloat("CollegeGrad"), 0,50.0, 500,0),
      30,30);
}