
float _sum = 240;
ArrayList<Rect> _resultRectantangles = new ArrayList<Rect>();

void setup()
{
    size(240,100);
    FloatList values = new FloatList();
    values.append(new float[]{60,60,60,60});
    squarify(values,null,new Rect(0,0,width,height));
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
        if(input.getWidth() > input.getHeight()) //Width is more, so do a slice/vertical partition
        {
            row._alignment = Alignment.VERTICAL;
            row._rectangles.add(new Rect(input._originX, input._originY, (val*input.getWidth()/sum),input.getHeight()));
        }
        else
        {
            row._alignment = Alignment.HORIZONTAL;
            row._rectangles.add(new Rect(input._originX, input._originY, input.getWidth(),(val*input.getHeight()/sum)));
        }
        values.remove(0);
    }
    
    if(values.size() == 0)
    {
        _resultRectantangles.addAll(row._rectangles);
        return;
    }
    
    float val = (float)values.get(0);
    float proposedWidth = row._alignment == Alignment.HORIZONTAL? (((row.getWidth() + val)*input._width))/_sum:row.getWidth();
    float proposedHeight = row._alignment == Alignment.VERTICAL? (((row.getHeight() + val)*input._height))/_sum:row.getHeight();
    if(getAspect(row.getMaxHeight(),row.getMaxWidth()) > getAspect(proposedWidth,proposedHeight))
    {
        row._rectangles.add(new Rect(input._originX , input._originY,proposedWidth, proposedHeight));
        values.remove(0);
        squarify(values, row,new Rect(input._originX - proposedWidth, input._originY - proposedHeight,width, height));
    }
    else
    {
         _resultRectantangles.addAll(row._rectangles);
         squarify(values,null, new Rect(input._originX + row.getWidth(), input._originY + row.getHeight(), width, height));
    }
}

public class Rect
{
    public float _originX, _originY, _width, _height = 0.0;
    boolean _finalized = false;
    
    float getWidth()
    {
        return _width - _originX;
    }
    float getHeight()
    {
        return _height - _originY;
    }
    
    public Rect(float originX, float originY, float w, float h)
    {
        _originX = originX;
        _originY = originY;
        _width = w;
        _height = h;
    }
}

public enum Alignment
{ 
    HORIZONTAL, VERTICAL
}

public class Row
{

    ArrayList<Rect> _rectangles = new ArrayList<Rect>();
    Alignment _alignment;
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
        return _alignment == Alignment.HORIZONTAL? getMaxHeight(): getSumWidths();
    }
    float getHeight()
    {
        return _alignment == Alignment.VERTICAL? getMaxWidth(): getSumHeights() ;
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
}