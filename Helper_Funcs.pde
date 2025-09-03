PVector convert (PVector cord)
{
  PVector g = new PVector(cord.x, cord.y);
  g.y *= -1;
  
  //x dimension of scene
  g.x += (500 / 2);
  
  //y dimension of scene
  g.y += (500 / 2);
  
  return g;
}
PVector pv (float a, float b)
{
  PVector out = new PVector (a,b,0);
  return out;
}
float calcDis (PVector a, PVector b)
{
  float x = a.x - b.x;
  float y = a.y - b.y;
  return sqrt(x*x+y*y);
}
void cir (PVector pos, float radius)
{
  ellipse(convert(pos).x,convert(pos).y,radius,radius);
}


class Stringin {
  String currentInput = "";
  boolean inputActive = false;
  Runnable onInputComplete;

  // Start recording user input
  void request(Runnable callback) {
    currentInput = "";
    inputActive = true;
    onInputComplete = callback;
  }

  // Handle key events (must be called from global keyPressed())
  void handleKey(char key) {
    if (!inputActive) return;

    if (key == BACKSPACE) {
      if (currentInput.length() > 0) {
        currentInput = currentInput.substring(0, currentInput.length() - 1);
      }
    } else if (key == ENTER || key == RETURN) {
      inputActive = false;
      if (onInputComplete != null) {
        onInputComplete.run();
      }
    } else if (key == DELETE){
      currentInput = "";
    } else if (key != CODED) {
      // Accepts all printable characters (including special chars like !@#$%^&* etc.)
      currentInput += key;
    }
  }

  boolean isActive() {
    return inputActive;
  }

  String getInput() {
    return currentInput;
  }
}
