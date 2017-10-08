
float _sum = 240;
ArrayList<Rect> _resultRectantangles = new ArrayList<Rect>();

void setup()
{
    //size(100,240);
    FloatList values = new FloatList();
    //values.append(new float[]{60,60,60,60});
    size(60,40);
    values.append(new float[]{6.0,6.0,4.0,3.0,2.0,2.0,1.0});
    //size(30,40);
    //values.append(new float[]{4.0,3.0,2.0,2.0,1.0});
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
    float sum = values.sum();
    //Handle the first case when row is empty
    if(row == null || row._rectangles.isEmpty()) //<>//
    {
        row = new Row();
        float val = (float)values.get(0);
        float newRectWidth,newRectHeight=0.0;
        if(input.getWidth() > input._height) //Width is more, so do a slice/vertical partition
        {
            row._alignment = Alignment.VERTICAL;
            newRectWidth = (val*input.getWidth()/sum);
            newRectHeight = input.getHeight();
        }
        else
        {
            row._alignment = Alignment.HORIZONTAL;
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
    //temp +=1;
    float proposedRowWidth = row._alignment == Alignment.HORIZONTAL? row.getWidth(): (temp*inputWidth)/sum + row.getWidth();
    float proposedRowHeight = row._alignment == Alignment.VERTICAL? row.getHeight(): (temp*input.getHeight())/sum + row.getHeight();
    float proposedMaxItemWidth = row._alignment == Alignment.HORIZONTAL? (row._maxValue/(val + row.getSumValues())) * proposedRowWidth : proposedRowWidth;
    float proposedMaxItemHeight = row._alignment == Alignment.VERTICAL? (row._maxValue/(val + row.getSumValues())) * proposedRowHeight : proposedRowHeight;
    
    float newRectWidth = row._alignment == Alignment.HORIZONTAL? (val/(val + row.getSumValues())) * proposedRowWidth : proposedRowWidth;
    float newRectHeight = row._alignment == Alignment.VERTICAL? (val/(val + row.getSumValues())) * proposedRowHeight : proposedRowHeight;
    
    if(getAspect(proposedMaxItemHeight, proposedMaxItemWidth) <= getAspect(row.getMaxHeight(), row.getMaxWidth()))
    {
        row._height = proposedRowHeight;
        row._width = proposedRowWidth;
        row.add(new Rect(row._originX + newRectWidth, row._originY + newRectHeight ,newRectWidth, newRectHeight, val));
        values.remove(0);
        squarify(values, row,new Rect(row._originX + proposedRowWidth, row._originY + proposedRowWidth ,width, height,0));
    }
    else
    {
         _resultRectantangles.addAll(row._rectangles);
         float remainingRectOriginX = row._alignment == Alignment.VERTICAL?  row.getWidth() : width - row.getWidth();
         float remainingRectOriginY = row._alignment == Alignment.VERTICAL ? height - row.getHeight() : row.getHeight();
         squarify(values, null, new Rect(remainingRectOriginX, remainingRectOriginY, width - remainingRectOriginX, height - remainingRectOriginY, val));
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
    float _width, _height = 0.0f;
    float _originX, _originY,_maxValue;
    
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
        return _width;
        //return _alignment == Alignment.HORIZONTAL? getSumWidths(): getMaxWidth();
    }
    float getHeight()
    {
        return _height;
        //return _alignment == Alignment.VERTICAL? getSumHeights() : getMaxHeight();
    }
    
    void add(Rect r)
    {
        if(_rectangles.isEmpty())
        {
            _originX = r._originX;
            _originY = r._originY;
            _maxValue = r._value;
            _width = r._width;
            _height = r._height;
        }
        else
        {
            //_width += _alignment == Alignment.VERTICAL ? r._width:0.0f;
            //_height += _alignment == Alignment.VERTICAL ? 0.0f : r._height;
        }
        
        //_width += _alignment == Alignment.VERTICAL ? r._width:0.0f;
        //_height += _alignment == Alignment.VERTICAL ? 0.0f : r._height;
        
        _rectangles.add(r);
        _lastAddedRectangle = r;

        reshapeRectangles();
    }
    
    void add(float value, float newWidth, float newHeight)
    {
        if(_rectangles.isEmpty())
        {
            //_originX = r._originX;
            //_originY = r._originY;
            _maxValue = value;
        }
        Rect r = new Rect(0,0,0,0,value);
        _rectangles.add(r);
        _lastAddedRectangle = r;
        _width = _alignment == Alignment.VERTICAL ? newWidth: 0.0f;
        _height = _alignment == Alignment.HORIZONTAL ? newHeight: 0.0f;
        reshapeRectangles();
    }
    
    void reshapeRectangles()
    {
        float originXOffset = _originX; 
        float originYOffset = _originY;
        float sum = getSumValues();
        for(Rect r : _rectangles)
        {
            r._originX = originXOffset;
            r._originY = originYOffset;
            r._width = _alignment == Alignment.HORIZONTAL ? originXOffset + (r._value / sum)*_width : _width;
            r._height = _alignment == Alignment.VERTICAL ? originYOffset + (r._value / sum)*_height : _height;
            originXOffset = _alignment == Alignment.HORIZONTAL ? originXOffset + r._width : r._originX;
            originYOffset = _alignment == Alignment.VERTICAL ? originYOffset + r._height : r._originY;
        }
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