ArrayList<button> rbuttons = new ArrayList<button>();
ArrayList<slider> rsliders = new ArrayList<slider>();
ArrayList<textDisplay> rdisplays = new ArrayList<textDisplay>();

PFont font;
Stringin in = new Stringin();
ui generic;
boolean placing = false;
boolean stop = true;
int mode = 0;
textDisplay modeDisplay;

void upload (String address)
{
  try{
    BufferedWriter output = new BufferedWriter(new FileWriter(address));
    int size = buttons.size() + sliders.size() + displays.size();
    output.write(Integer.toString(size));
    for(button i : buttons)
    {
      output.newLine();
      output.write("b" + " " + i.pos.x + " " + i.pos.y + " " + i.dim.x + " " + i.dim.y + " " + hex(i.maincol) + " " + hex(i.seccol) + " " + i.label.replace(" ",";"));
    }
    for(slider i : sliders)
    {
      output.newLine();
      output.write("s" + " " + i.pos.x + " " + i.pos.y + " " + i.dim.x + " " + i.dim.y + " " + hex(i.col) + " " + i.label.replace(" ",";"));
    }
    for(textDisplay i : displays)
    {
      output.newLine();
      output.write("t" + " " + i.pos.x + " " + i.pos.y + " " + i.dim.x + " " + i.dim.y + " " + hex(i.col) + " " + i.label.replace(" ",";"));
    }
    output.close();
  }catch(Exception e){System.out.println("SAVE FAILED");}
}

void setup()
{
  font = createFont("C:/Users/apark5/Downloads/My STUFF (no touchy)/coding/Processing Projects/ui/data/MPLUSRounded1c-Bold.ttf",16);
  generic = new ui(pv(0,0),pv(100,100),#D13D3D,"DEFAULT",font);
  modeDisplay = new textDisplay(pv(10,10),pv(100,50),#CE8628,"SELECT",font);
  load("C:/Users/apark5/Downloads/My STUFF (no touchy)/coding/Processing Projects/ui/data/soft_body.txt","C:/Users/apark5/Downloads/My STUFF (no touchy)/coding/Processing Projects/ui/data/MPLUSRounded1c-Bold.ttf");
  size(500,500);
}

void keyPressed()
{
  in.handleKey(key);
}
void mousePressed()
{
  if(mode != 0 && !placing)
  {
    modeDisplay.visable = false;
    generic.pos.x = mouseX;
    generic.pos.y = mouseY;
    stop = false;
    placing = true;
  }
}
void mouseReleased() {
  if (mode != 0 && placing) {
    stop = true;
    in.request(() -> {
      try{
        generic.col = (int)(0xFF000000 | (0xFFFFFFFF & unhex(in.getInput())));
      }catch(Exception e)
      {
        System.out.println("ERROR: invalid color, defaulting to #D13D3D");
        generic.col = #D13D3D;
      }
      switch(mode)
      {
        case 1:
          final color[] buttonpresscol = { #D13D3D }; 
          in.request(() -> {
            try {
              String s = trim(in.getInput());
              if (s.startsWith("#")) s = s.substring(1);
              if (s.startsWith("0x") || s.startsWith("0X")) s = s.substring(2);
          
              // Parse as RGB hex, force alpha to opaque
              buttonpresscol[0] = (color)(0xFF000000 | (unhex(s) & 0x00FFFFFF));
            } catch (Exception e) {
              println("ERROR: invalid color, defaulting to #D13D3D");
            }
            in.request(() -> {
              generic.label = in.getInput();
              buttons.add(new button(generic.pos, generic.dim, generic.col, buttonpresscol[0], generic.label, font));
              mode = 0;
              placing = false;
              generic = new ui(pv(0,0),pv(100,100),#D13D3D," ",font);
              modeDisplay.visable = true;
            });
          });
          break;
        case 2:
          in.request(() -> {
            generic.label = in.getInput();
            sliders.add(new slider(generic.pos, generic.dim, generic.col, generic.label, font));
            mode = 0;
            placing = false;
            generic = new ui(pv(0,0),pv(100,100),#D13D3D," ",font);
            modeDisplay.visable = true;
          });
          break;
        case 3:
          in.request(() -> {
            generic.label = in.getInput();
            displays.add(new textDisplay(generic.pos, generic.dim, generic.col, generic.label, font));
            mode = 0;
            placing = false;
            generic = new ui(pv(0,0),pv(100,100),#D13D3D," ",font);
            modeDisplay.visable = true;
          });
          break;
      }
    });
  }
}

void draw()
{
  background(182);  
  
  updateAll();
  
  if(keyPressed)
  {    
    switch(key)
    {
      case BACKSPACE:
        mode = 0;
        break;
      case TAB:
        upload("C:/Users/apark5/Downloads/My STUFF (no touchy)/coding/Processing Projects/ui/data/soft_body.txt");
        break;
      case DELETE:
        for (button i : buttons) {
          if (mouseX < i.pos.x + i.dim.x && mouseX > i.pos.x && mouseY < i.pos.y + i.dim.y && mouseY > i.pos.y &&
              mode == 0) {
            rbuttons.add(i);
          }
        }
        for (slider i : sliders) {
          if (mouseX < i.pos.x + i.dim.x && mouseX > i.pos.x && mouseY < i.pos.y + i.dim.y && mouseY > i.pos.y && mode == 0) {
            rsliders.add(i);
          }
        }
        for (textDisplay i : displays) {
          if (mouseX < i.pos.x + i.dim.x && mouseX > i.pos.x && mouseY < i.pos.y + i.dim.y && mouseY > i.pos.y && mode == 0) {
            rdisplays.add(i);
          }
        }
      
        buttons.removeAll(rbuttons);
        sliders.removeAll(rsliders);
        displays.removeAll(rdisplays);
      
        rbuttons.clear();
        rsliders.clear();
        rdisplays.clear();
        break;
      case 'b': //for button
        mode = 1;
        break;
      case 's': //for button
        mode = 2;
        break;
      case 't': //for button
        mode = 3;
        break;
    }
  }
  switch(mode)
  {
      case 0:
        modeDisplay.update("SELECT");
        break;
      case 1:
        modeDisplay.update("BUTTON");
        break;
      case 2:
        modeDisplay.update("SLIDER");
        break;
      case 3:
        modeDisplay.update("TEXT");
        break;
  }
  modeDisplay.display();
  
  if(placing)
  {
    generic.display();  
    generic.label = in.getInput();
    if(!stop){
      generic.dim.x = abs(mouseX - generic.pos.x);
      generic.dim.y = abs(mouseY - generic.pos.y);
    }
  }
}
