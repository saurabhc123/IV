
import java.util.*;


float _sum = 240;
ArrayList<Rect> _resultRectantangles = new ArrayList<Rect>();
TreemapLayout algorithm;
RectEvaluator mapModel;
Mappable[] category1Rectangles ;
Mappable[]  category2Rectangles;
Mappable[]  leafRectangles;
 //<>//
// CS5764 HW5 Treemap sample code.
// Make a tree structure out of a categorical csv data table.

TreeNode root;

void setup(){
    
    size(1200,800);
    FloatList values = new FloatList();
    //values.append(new float[]{60,60,60,60});
    //size(60,40);
    values.append(new float[]{6.0,6.0,4.0,3.0,2.0,2.0,1.0});
    int w = width;
    int h = height;

    Rect bounds = new Rect(0, 0, w, h);
    algorithm = new TreemapLayout();
    mapModel = new RectEvaluator(new int[] {6, 6, 4, 3, 2, 2, 1}, w, h);
    algorithm.layout(mapModel, bounds);
    root = new TreeNode("treemap-stocks.csv", 3, 5);
    //root = new TreeNode("treemap-counties.csv", 3, 4);
    println(root.size, root.children[0].size, root.children[0].children[0].size, 
    root.children[0].children[0].children[0].size);
    
    //Calculate the Category-1 rectangles
    Rect category1Bounds = new Rect(0,0,width, height);
    
    RectEvaluator category1Evaluator = new RectEvaluator(root.children, w, h,null);
    algorithm.layout(category1Evaluator, category1Bounds);
    root.rectangles = category1Evaluator.items;
    
       
    //Calculate the Category-2 rectangles
    for(int i = 0; i< root.children.length; i++) //<>//
    {
        Rect currentCategory2Bounds = root.rectangles[i].getBounds();
        RectEvaluator category2Evaluator = new RectEvaluator(root.children[i].children, currentCategory2Bounds.w , currentCategory2Bounds.h, root.children[i]);
        algorithm.layout(category2Evaluator, currentCategory2Bounds);  
        root.children[i].rectangles = category2Evaluator.items;
        
        EvaluateRectanglesForChild(root.children[i]);
        
    }
    
    //Calculate the leaf rectangles
    
  //root.slicemeup() ?
}

void EvaluateRectanglesForChild(TreeNode node)
{
    
    for(int i = 0; i< node.children.length; i++)
    {
        Rect currentCategory2Bounds = node.rectangles[i].getBounds();
        RectEvaluator category2Evaluator = new RectEvaluator(node.children[i].children, currentCategory2Bounds.w , currentCategory2Bounds.h, node.children[i]);
        algorithm.layout(category2Evaluator, currentCategory2Bounds);  
        node.children[i].rectangles = category2Evaluator.items;
    }

}

void draw() {
  //root.drawme() ?
  DrawCategoryRects(root.rectangles);
  for(int i = 0; i< root.children.length; i++)
  {
       DrawCategoryRects(root.children[i].rectangles);
       
       for(int j = 0; j< root.children[i].rectangles.length; j++)
       {
           Mappable[] nodes = root.children[i].children[j].rectangles;
           DrawLeafRects(nodes, root.children[i].children[j].minChange, root.children[i].children[j].maxChange);
       }
  }
  
}

void DrawLeafRects(Mappable[] nodes, float minChange, float maxChange)
{
    
    noStroke(  );
    fill(152, 25, 25);
    rectMode(CORNERS);
    color c;
    float hue = 50;
    float brightness = 60;
    for(int i = 0; i< nodes.length; i++)
    {
        c = color(hue, 80, 80);
        Rect nodeBounds = nodes[i].getBounds();
        //print(nodes[i].getChange());
        
        if(nodes[i].getChange() > 0)
        {
            //colorMode(HSB, 360, 255, 200);
            //fill(c);
            //colorMode(RGB, 0, 255, 0);
            fill(0, 255, 0);
        }
        else
        {
            //colorMode(HSB, 360, 255, 200);
            //fill(c);
            //colorMode(RGB, 255, 0, 0);
            fill(255, 0, 0);
        }
        rect((float) nodeBounds.x,(float)  nodeBounds.y,(float) (nodeBounds.x + nodeBounds.w), (float) (nodeBounds.y + nodeBounds.h));      
    }
}

void DrawCategoryRects(Mappable[] nodes)
{
    
    //noStroke(  );
    fill(0, 0, 255);
    rectMode(CORNERS);
    for(int i = 0; i< nodes.length; i++)
    {
        Rect nodeBounds = nodes[i].getBounds();
        rect((float) nodeBounds.x,(float)  nodeBounds.y,(float) (nodeBounds.x + nodeBounds.w), (float) (nodeBounds.y + nodeBounds.h));      
    }
}



int numLevels=0, sizeColIdx=0;  // Data file parameters

public class TreeNode implements Comparable<TreeNode> {
  public int level;          // my level in the tree, 0=root
  public String name;        // my name
  public Table data;         // table of data for all my leaf descendents
  public float size, change, maxChange, minChange;         // my total size, computed from size data column
  public boolean isLeaf;     // am i a leaf?
  public TreeNode[] children;// my list of children nodes
  public Mappable[] rectangles;

  // Create a tree from csv file, 
  // with lvls number of categoral levels starting at column index 1
  // and using column index sz for the leaf node size data.
  // Uses recursion to build the tree.
  TreeNode(String file, int lvls, int sz) {  // other params needed ...?
    numLevels = lvls;
    sizeColIdx = sz;
    data = loadTable(file, "header"); 
    println(data.getRowCount(), data.getColumnCount()); 
    init(0, "Root", data);
  }
  TreeNode(int lev, String nm, Table d) {
    init(lev, nm, d);
  }
  public int compareTo(TreeNode n) {  //Comparable, useful for Arrays.sort(children)
    return (name.compareTo(n.name));   // sort by name or some other attribute?
  }

  private void init(int lev, String nm, Table d) {
    level = lev;
    name = nm; 
    data = d;
    size = getSize();
    isLeaf = (level >= numLevels);  
    children = getChildrenList();
  }
  private float getSize() {  // compute size of this node from leaf data
    float sum=0.0;
    for (float e : data.getFloatColumn(sizeColIdx))
      sum += e;
    return(sum);
  }
  private String[] getChildrenNames() {  // find names of children of this node from next level column of data
    return(data.getUnique(level+1));
  }
  private Table getChildData(String childname) {  // filter data for a given child
    return(new Table(data.findRows(childname, level+1)));
  }
  private TreeNode[] getChildrenList() {  // setup a list of children
    if (isLeaf) return null;
    String[] childNames = getChildrenNames();
    TreeNode[] childs = new TreeNode[childNames.length];
    for (int i=0; i<childNames.length; i++) {
      childs[i] = new TreeNode(level+1, childNames[i], getChildData(childNames[i]));  // Recursion happens here.
      minChange = data.getFloatList("Change").min();
      maxChange = data.getFloatList("Change").max();
      if(childs[i].isLeaf)
      {
          //print(data.getFloatColumn("Change")[i]);
          childs[i].change = data.getFloatColumn("Change")[i];
          //minChange = data.getFloatList("Change").min();
          //maxChange = data.getFloatList("Change").max();
      }
    }
    return childs;
  }
  
  // slicing, drawing, ...?
}

 //<>//


public class Rect {
    public double x, y, w, h;

    public Rect() {
        this(0,0,1,1);
    }

    public Rect(Rect r) {
        setRect(r.x, r.y, r.w, r.h);
    }

    public Rect(double x, double y, double w, double h) {
        setRect(x, y, w, h);
    }

    public double aspectRatio() {
        return Math.max(w/h, h/w);
    }

    public void setRect(double x, double y, double w, double h) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }
}


public enum Alignment
{ 
    HORIZONTAL, VERTICAL
}


public interface Mappable
{
    public double getSize();
    public void   setSize(double size);
    public Rect   getBounds();
    public void   setBounds(Rect bounds);
    public void   setBounds(double x, double y, double w, double h);
    public int    getOrder();
    public void   setOrder(int order);
    public int    getDepth();
    public void   setDepth(int depth);
    public String getName();
    public void   setName(String name);
    public String getParentName();
    public void   setParentName(String name);
    public TreeNode[] getChildren();
    public void   setChildren(TreeNode[] children);
    public double getChange();
    public void   setChange(double change);
}

public interface MapModel
{
    /**
     * Get the list of items in this model.
     *
     * @return An array of the Mappable objects in this MapModel.
     */
    public Mappable[] getItems();
}

public class MapItem implements Mappable {
    double size, change;
    Rect bounds;
    int order = 0;
    int depth;
    String name;
    String parentName;
    TreeNode[] children;

    public void setDepth(int depth) {
        this.depth = depth;
    }

    public int getDepth() {
        return depth;
    }

    public MapItem() {
        this(1, 0);
    }

    public MapItem(double size, int order) {
        this.size = size;
        this.order = order;
        bounds = new Rect();
    }

    public double getSize() {
        return size;
    }

    public void setSize(double size) {
        this.size = size;
    }
    
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
    
    public String getParentName() {
        return parentName;
    }

    public void setParentName(String parentName) {
        this.parentName = parentName;
    }

    public Rect getBounds() {
        return bounds;
    }

    public void setBounds(Rect bounds) {
        this.bounds = bounds;
    }

    public void setBounds(double x, double y, double w, double h) {
        bounds.setRect(x, y, w, h);
    }

    public int getOrder() {
        return order;
    }

    public void setOrder(int order) {
        this.order = order;
    }
    
    public TreeNode[] getChildren()
    {
        return children;
    }
    
    public void setChildren(TreeNode[] children)
    {
        this.children = children;
    }
    
    public double getChange() {
        return change;
    }

    public void setChange(double change) {
        this.change = change;
    }
}

public class RectEvaluator implements MapModel {

    Mappable[] items;
    
    public RectEvaluator(TreeNode[] itemRatio,double width, double height, TreeNode parentNode) {
        this.items = new MapItem[itemRatio.length];
        double totalArea = width * height;
        //double sum = IntStream.of(itemRatio).sum();
        
        double sum = 0.0;
        for (int i = 0; i < itemRatio.length; i++) {
            sum += itemRatio[i].size;
        }

        for (int i = 0; i < items.length; i++) {
            items[i] = new MapItem(totalArea / sum * itemRatio[i].size, 0);
            items[i].setName(itemRatio[i].name);
            items[i].setChildren(itemRatio[i].children);
            items[i].setChange(itemRatio[i].change);
            if(parentNode != null)
            {
               items[i].setParentName(parentNode.name); 
            }
            
        }
    }

    public RectEvaluator(int[] itemRatio,int width, int height) {
        this.items = new MapItem[itemRatio.length];
        double totalArea = width * height;
        
        double sum = 0.0;
        for (int i = 0; i < itemRatio.length; i++) {
            sum += itemRatio[i];
        }

        for (int i = 0; i < items.length; i++) {
            items[i] = new MapItem(totalArea / sum * itemRatio[i], 0);
            
        }
    }

    @Override
    public Mappable[] getItems() {
        return items;
    }


}

public interface Layout
{
   public void layout(MapModel model, Rect bounds);
}

public class TreemapLayout implements Layout {

    private int mid = 0;

    public void layout(MapModel model, Rect bounds) {
        layout(model.getItems(), bounds);
    }

    public void layout(Mappable[] items, Rect bounds)
    {
        layout(sortDescending(items),0,items.length-1,bounds);
    }

    public Mappable[] sortDescending(Mappable[] items) {
        if (items == null || items.length == 0) {
            return null;
        }
        Mappable[] inputArr = new Mappable[items.length];
        System.arraycopy(items, 0, inputArr, 0, items.length);
        int length = inputArr.length;

        quickSortDesc(inputArr, 0, length - 1);

        return inputArr;
    }

    public void layout(Mappable[] items, int start, int end, Rect bounds)
    {
        if (start>end) {
            return;
        }
        if(start == end) {
            items[start].setBounds(bounds);
        }

        this.mid = start;
        while (mid < end) {
            if (highestAspect(items, start, mid, bounds) > highestAspect(items, start, mid+1, bounds) ) {
                mid++;
            } else {
                Rect newBounds = layoutRow(items, start, mid, bounds);
                layout(items, mid+1, end, newBounds);
            }
        }
    }

    public double highestAspect(Mappable[] items, int start, int end, Rect bounds) {
        layoutRow(items, start, end, bounds);
        double max = Double.MIN_VALUE;
        for (int i = start; i <= end; i++) {
            if (items[i].getBounds().aspectRatio() > max) {
                max = items[i].getBounds().aspectRatio();
            }
        }
        return max;
    }

    public Rect layoutRow(Mappable[] items, int start, int end, Rect bounds) {
        boolean isHorizontal = bounds.w > bounds.h;
        double total = bounds.w * bounds.h; //totalSize(items, 0, items.length-1);
        double rowSize = totalSize(items, start, end);
        double rowRatio = rowSize / total;
        double offset=0;

        for (int i = start; i <= end; i++) {
            Rect r=new Rect();
            double ratio=items[i].getSize() / rowSize;

            if (isHorizontal) {
                r.x = bounds.x;
                r.w = bounds.w * rowRatio;
                r.y = bounds.y + bounds.h * offset;
                r.h = bounds.h * ratio;
            } else {
                r.x = bounds.x + bounds.w * offset;
                r.w = bounds.w * ratio;
                r.y = bounds.y;
                r.h = bounds.h * rowRatio;
            }
            items[i].setBounds(r);
            offset+=ratio;
        }
        if (isHorizontal) {
            return new Rect(bounds.x + bounds.w * rowRatio, bounds.y, bounds.w - bounds.w * rowRatio, bounds.h);
        } else {
            return new Rect(bounds.x, bounds.y + bounds.h * rowRatio, bounds.w, bounds.h - bounds.h * rowRatio);
        }
    }


    public  double totalSize(Mappable[] items) {
        return totalSize(items, 0, items.length - 1);
    }

    public double totalSize(Mappable[] items, int start, int end) {
        double sum = 0;
        for (int i = start; i <= end; i++)
            sum += items[i].getSize();
        return sum;
    }

    private void quickSortDesc(Mappable[] inputArr, int lowerIndex, int higherIndex) {

       int i = lowerIndex;
       int j = higherIndex;
       // calculate pivot number
       double pivot = inputArr[lowerIndex+(higherIndex-lowerIndex)/2].getSize();
       // Divide into two arrays
       while (i <= j) {
           while (inputArr[i].getSize() > pivot) {
               i++;
           }
           while (inputArr[j].getSize() < pivot) {
               j--;
           }
           if (i <= j) {
               Mappable temp = inputArr[i];
               inputArr[i] = inputArr[j];
               inputArr[j] = temp;

               i++;
               j--;
           }
       }
       if (lowerIndex < j)
           quickSortDesc(inputArr, lowerIndex, j);
       if (i < higherIndex)
           quickSortDesc(inputArr, i, higherIndex);
   }
}