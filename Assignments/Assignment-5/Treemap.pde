// CS5764 HW5 Treemap sample code.
// Make a tree structure out of a categorical csv data table.

TreeNode root;

void setup(){
  root = new TreeNode("treemap-stocks.csv", 3, 5);
  //root = new TreeNode("treemap-counties.csv", 3, 4);
  println(root.size, root.children[0].size, root.children[0].children[0].size, 
    root.children[0].children[0].children[0].size);
  //root.slicemeup() ?
}
void draw() {
  //root.drawme() ?
}


int numLevels=0, sizeColIdx=0;  // Data file parameters

public class TreeNode implements Comparable<TreeNode> {
  public int level;          // my level in the tree, 0=root
  public String name;        // my name
  public Table data;         // table of data for all my leaf descendents
  public float size;         // my total size, computed from size data column
  public boolean isLeaf;     // am i a leaf?
  public TreeNode[] children;// my list of children nodes

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
    }
    return childs;
  }
  
  // slicing, drawing, ...?
}