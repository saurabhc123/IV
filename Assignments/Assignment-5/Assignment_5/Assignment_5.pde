
float _sum = 240;
ArrayList<Rect> _resultRectantangles = new ArrayList<Rect>();

void setup()
{
    size(240,100);
    FloatList values = new FloatList();
    values.append(new float[]{60,60,60,60});
    squarify(values,null,new Rect(0,0,width,height,values.sum()));
}

void draw()
{
    
}

float getAspect(float value1, float value2)
{
    return value1 > value2 ? value1/value2: value2/value1;
}

void squarify(FloatList values, Row row, Rect input)
{
    float sum = values.sum(); //<>//
    //Handle the first case when row is empty
    if(row == null || row._rectangles.isEmpty())
    {
        row = new Row();
        float val = (float)values.get(0);
        if(input.getWidth() > input.getHeight()) //Width is more, so do a slice/vertical partition
        {
            row._alignment = Alignment.HORIZONTAL;
            row.add(new Rect(input._originX, input._originY, (val*input.getWidth()/sum),input.getHeight(),val));
        }
        else
        {
            row._alignment = Alignment.VERTICAL;
            row.add(new Rect(input._originX, input._originY, input.getWidth(),(val*input.getHeight()/sum),val));
        }
        values.remove(0);
    }
    
    if(values.size() == 0)
    {
        _resultRectantangles.addAll(row._rectangles);
        return;
    }
    
    float val = (float)values.get(0);
    float temp = row.getSumValues() + val;
    //float temp = val;
    //temp +=1;
    float proposedWidth = row._alignment == Alignment.HORIZONTAL? (((temp)*input.getWidth()))/_sum:row.getWidth();
    float proposedHeight = row._alignment == Alignment.VERTICAL? (((row.getSumValues() + val)*input.getHeight()))/_sum:row.getHeight();
    if(getAspect(row.getMaxHeight(),row.getMaxWidth()) > getAspect(proposedWidth,proposedHeight))
    {
        float newRectWidth = (val / (row.getSumValues() + val)) * proposedWidth;
        float newRectHeight = (val / row.getSumValues()) * proposedHeight;
        float newRectOriginX = row._alignment == Alignment.HORIZONTAL? row._lastAddedRectangle._originX + row._lastAddedRectangle._width : row._lastAddedRectangle._originX;
        float newRectOriginY = row._alignment == Alignment.VERTICAL? row._lastAddedRectangle._originY + row._lastAddedRectangle._height : row._lastAddedRectangle._originY;
        row._rectangles.add(new Rect(newRectOriginX, 
                                     newRectOriginY,
                                     newRectOriginX + newRectWidth, 
                                     newRectOriginY + newRectHeight, val));
        values.remove(0);
        squarify(values, row,new Rect(newRectOriginX + newRectWidth, newRectOriginY,width, height,val));
    }
    else
    {
         _resultRectantangles.addAll(row._rectangles);
         squarify(values,null, new Rect(input._originX + row.getWidth(), input._originY + row.getHeight(), width, height,val));
    }
}

public class Rect
{
    public float _originX, _originY, _width, _height, _value = 0.0;
    boolean _finalized = false;
    
    float getWidth()
    {
        return _width - _originX;
    }
    float getHeight()
    {
        return _height - _originY;
    }
    
    public Rect(float originX, float originY, float w, float h, float value)
    {
        _originX = originX;
        _originY = originY;
        _width = w;
        _height = h;
        _value = value;
    }
}

public enum Alignment
{ 
    HORIZONTAL, VERTICAL
}

public class Row
{

    private ArrayList<Rect> _rectangles = new ArrayList<Rect>();
    Alignment _alignment;
    Rect _lastAddedRectangle;
    
    public float getMaxWidth()
    {
        float w =_rectangles.get(0).getWidth();
        return w;
    }
    
    float getMaxHeight()
    {
        return _rectangles.get(0).getHeight();
    }
    float getWidth()
    {
        return _alignment == Alignment.HORIZONTAL? getSumWidths(): getMaxWidth();
    }
    float getHeight()
    {
        return _alignment == Alignment.VERTICAL? getSumHeights() : getMaxHeight();
    }
    
    void add(Rect r)
    {
        _rectangles.add(r);
        _lastAddedRectangle = r;
    }
    
    float getSumWidths()
    {
        float result = 0f;
        for(Rect r : _rectangles)
        {
            result += r._width;
        }
        
        return result;
    }
    
    float getSumHeights()
    {
        float result = 0f;
        for(Rect r : _rectangles)
        {
            result += r._height;
        }
        
        return result;
    }
    
    float getSumValues()
    {
        float result = 0f;
        for(Rect r : _rectangles)
        {
            result += r._value;
        }
        
        return result;
    }
}