import java.io.*;

ArrayList<button> buttons = new ArrayList<button>();
ArrayList<slider> sliders = new ArrayList<slider>();
ArrayList<textDisplay> displays = new ArrayList<textDisplay>();

public void updateAll()
{
  for(button i : buttons)
  {
    i.update();
    i.display();
  }
  for(slider i : sliders)
  {
    i.update();
    i.display();
  }
  for(textDisplay i : displays)
  {
    i.display();
  }
}

public void load(String file, String fontAddress)
{
  try{
    BufferedReader input = new BufferedReader(new FileReader(file));
    PFont font = createFont(fontAddress,16);
    int iter = Integer.parseInt(input.readLine());
    int  i = 0;
    while (i < iter)
    {
      if(input.ready())
      {
        String line = input.readLine();
        String[] tokens = line.split(" ");
        switch(tokens[0])
        {
          case "b":
            buttons.add(new button(pv(Float.parseFloat(tokens[1]),Float.parseFloat(tokens[2])),pv(Float.parseFloat(tokens[3]),Float.parseFloat(tokens[4])),(int)(0xFF000000 | (0xFFFFFFFF & unhex(tokens[5]))),(int)(0xFF000000 | (0xFFFFFFFF & unhex(tokens[6]))),tokens[7].replace(";"," "),font));
            break;
          case "s":
            sliders.add(new slider(pv(Float.parseFloat(tokens[1]),Float.parseFloat(tokens[2])),pv(Float.parseFloat(tokens[3]),Float.parseFloat(tokens[4])),(int)(0xFF000000 | (0xFFFFFFFF & unhex(tokens[5]))),tokens[6].replace(";"," "),font));
            break;
          case "t":
            displays.add(new textDisplay(pv(Float.parseFloat(tokens[1]),Float.parseFloat(tokens[2])),pv(Float.parseFloat(tokens[3]),Float.parseFloat(tokens[4])),(int)(0xFF000000 | (0xFFFFFFFF & unhex(tokens[5]))),tokens[6].replace(";"," "),font));
            break;
        }
        i++;
      }
    }
    input.close();
  } catch (Exception e){System.out.println("ERROR DETECTED IN UI LOADING: " + e); return;}
}

class ui
{
  PFont font;
  PVector pos;
  PVector dim;
  color col;
  String label;
  boolean visable = true;
  public ui (PVector pos, PVector dim, color col, String label, PFont font)
  {
    this.pos = pos;
    this.dim = dim;
    this.col = col;
    this.label = label;
    this.font = font;
  }
  
  void display()
  {
    if(!visable){return;}
    textFont(font, (dim.x / 7 + dim.y / 7)/2);
    strokeWeight(8);
    fill(70);
    stroke(col);
    rect(pos.x,pos.y,dim.x,dim.y,10);
    fill(col);
    textAlign(CENTER, CENTER);
    text(label, pos.x + dim.x / 2, pos.y + dim.y / 2);
  }
}

class button extends ui
{
  color seccol;
  color maincol;
  public button (PVector pos, PVector dim, color col1,color col2, String label, PFont font)
  {
    super(pos,dim,col1,label, font);
    maincol = col1;
    seccol = col2;
  }
  
  boolean update ()
  {
    if(mouseX < pos.x+dim.x && mouseX > pos.x && mouseY < pos.y+dim.y && mouseY > pos.y)
    {
      if(mousePressed)
      {
        col = seccol;
        return true;
      }
    }
    col = maincol;
    return false;
  }
}

class textDisplay extends ui
{
  public textDisplay (PVector pos, PVector dim, color col, String label, PFont font)
  {
    super(pos,dim,col,label,font);
  }
  
  void update (String value)
  {
    label = value;
  }
}

class slider extends ui
{
  float value;
  boolean sliding = false;
  public slider (PVector pos, PVector dim, color col, String label, PFont font)
  {
    super(pos,dim,col,label,font);
    value = 100;
  }
  @Override
  void display()
  {
    if(!visable){return;}
    textFont(font, (dim.x / 8 + dim.y / 8)/2);
    strokeWeight(8);
    fill(70);
    stroke(col);
    rect(pos.x,pos.y,dim.x,dim.y,10);
    fill(col);
    textAlign(CENTER, CENTER);
    text(label, pos.x + dim.x / 3, pos.y + dim.y / 3);
    rect(pos.x+dim.x*0.14, pos.y+dim.y*0.59,dim.x*0.72,dim.y*0.05,dim.y*0.5);
    fill(200);
    noStroke();
    ellipse(pos.x+dim.x*0.14+map(value,0,100,0,dim.x*0.7),pos.y+dim.y*0.61,dim.y*0.2,dim.y*0.2);
  }
  void update()
  {
    boolean sliding = false;
    if (sqrt(pow(pos.x+dim.x*0.14+map(value,0,100,0,dim.x*0.7)-mouseX,2)+pow(pos.y+dim.y*0.61-mouseY,2)) <= 10)
    {
      if (mouseX >= pos.x+dim.x*0.14 && mouseX <= pos.x+dim.x*0.14+dim.x*0.7)
      {
        if (mousePressed)
        {
          sliding = true;
        }
      }
    } else if(!mousePressed)
    {
      sliding = false;
    }
    if (sliding)
    {
      float temp = mouseX-(pos.x+dim.x*0.14);
      value = map(temp,0,dim.x*0.7,0,100);
    }
  }
  float give()
  {
    return value;
  }
}
PVector pv(float a, float b, float c)
{
  return new PVector(a,b,c);
}
