
float _sum = 240;
ArrayList<Rect> _resultRectantangles = new ArrayList<Rect>();

void setup()
{
    size(100,240);
    FloatList values = new FloatList();
    values.append(new float[]{60,60,60,60});
    squarify(values,null,new Rect(0,0,width,height,values.sum()));
}

void draw()
{
    
}

float getAspect(float value1, float value2)
{
    return value1 < value2 ? value1/value2: value2/value1;
}

void squarify(FloatList values, Row row, Rect input)
{
    float sum = values.sum(); //<>//
    //Handle the first case when row is empty
    if(row == null || row._rectangles.isEmpty())
    {
        row = new Row();
        float val = (float)values.get(0);
        float newRectWidth,newRectHeight=0.0;
        if(input.getWidth() > input.getHeight()) //Width is more, so do a slice/vertical partition
        {
            row._alignment = Alignment.HORIZONTAL;
            newRectWidth = (val*input.getWidth()/sum);
            newRectHeight = input.getHeight();
        }
        else
        {
            row._alignment = Alignment.VERTICAL;
            newRectWidth = input.getWidth();
            newRectHeight = (val*input.getHeight()/sum);
        }
        row.add(new Rect(input._originX, input._originY, newRectWidth , newRectHeight,val));
        values.remove(0);
        sum = values.sum();
        squarify(values, row,new Rect(input._originX + newRectWidth, input._originY + newRectHeight, width, height,0));
    }
    
    if(values.size() == 0)
    {
        _resultRectantangles.addAll(row._rectangles);
        return;
    }
    
    float val = (float)values.get(0);
    //float temp = row.getSumValues() + val;
    float temp = val;
    float inputWidth = input.getWidth();
    float rowWidth = row.getWidth();
    println(rowWidth);
    float p = (temp*inputWidth)/sum + row.getWidth();
    println(p);
    //temp +=1;
    float proposedRowWidth = row._alignment == Alignment.HORIZONTAL? (temp*inputWidth)/sum + row.getWidth():row.getWidth();
    float proposedRowHeight = row._alignment == Alignment.VERTICAL? (temp*input.getHeight())/sum + row.getHeight():row.getHeight();
    float newRectWidth = (row._alignment == Alignment.HORIZONTAL? (val / (row.getSumValues() + val)):1) * proposedRowWidth;
    float newRectHeight = (row._alignment == Alignment.VERTICAL? (val / (row.getSumValues() + val)):1) * proposedRowHeight;
    float newRectOriginX = row._alignment == Alignment.HORIZONTAL? row._lastAddedRectangle._originX + row._lastAddedRectangle.getWidth() : row._lastAddedRectangle._originX;
    float newRectOriginY = row._alignment == Alignment.VERTICAL? row._lastAddedRectangle._originY + row._lastAddedRectangle.getHeight() : row._lastAddedRectangle._originY;
        
    if(getAspect(newRectWidth,newRectHeight) >= getAspect(row.getMaxHeight(), row.getMaxWidth()))
    {
        row.add(new Rect(newRectOriginX, 
                                     newRectOriginY,
                                     newRectOriginX + newRectWidth, 
                                     newRectOriginY + newRectHeight, val));
        values.remove(0);
        squarify(values, row,new Rect(newRectOriginX + newRectWidth, newRectOriginY + newRectHeight ,width, height,0));
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
            result += r._width - r._originX;
        }
        
        return result;
    }
    
    float getSumHeights()
    {
        float result = 0f;
        for(Rect r : _rectangles)
        {
            result += r._height - r._originY;
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