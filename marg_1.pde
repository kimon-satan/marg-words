PFont font;
JSONArray values;
ArrayList<Phrase> phrases;
int currentPhrase;

long targetTime;

class Phrase{
  
  int x;
  int y;
  String text;
  float in;
  float sustain;
  float out;
  long startTime;
  
  Phrase()
  {
    x = 0;
    y = 0;
    in = 1.0;
    text = "";
    sustain = 5.0;
    startTime  = 0;
  }
  
  long getTargetTime()
  {
    long l = startTime;
    l += in * 1000;
    l += sustain * 1000;
    l += out * 1000;
    
    return l;
  }
  
};


void setup()
{
  
  fullScreen(); 
  textAlign(CENTER);
  
  font  = loadFont("Helvetica-Light-48.vlw");
  textSize(72);
  textFont(font);
  
  phrases = new ArrayList<Phrase>();
  
  values = loadJSONArray("test.json");

  for (int i = 0; i < values.size(); i++) 
  {
    
    JSONObject j = values.getJSONObject(i);
    Phrase p = new Phrase();
    p.x = j.getInt("x");
    p.y = j.getInt("y");
    p.in = j.getFloat("in");
    p.out = j.getFloat("out");
    p.sustain = j.getFloat("sustain");
    p.text = j.getString("text");

    phrases.add(p);

  }
  
  currentPhrase = 0;
  setPhrase(currentPhrase);

}


void setPhrase(int i)
{
  Phrase p = phrases.get(i);
  p.startTime = millis();
}


void draw()
{
  background(0);
  
  Phrase p = phrases.get(currentPhrase);
  
  float delta = (float)(millis() - p.startTime)/1000.0;
  
  float inProg = delta/p.in;
  inProg = min(1.0, inProg);
  
  float outProg = delta - (p.sustain + p.in)/p.out;
  

  
  if(outProg > 0)
  {
    fill(255,255 * (1- outProg));
  }
  else
  {
    
    fill(255,255 * inProg);
  }
  
  text(p.text, p.x, p.y);
  
  if(millis() > p.getTargetTime())
  {
    if(currentPhrase < phrases.size() -1 )
    {
      currentPhrase = currentPhrase + 1;
      setPhrase(currentPhrase);
    }
  }
  
}

void keyPressed()
{
 
   
   if(key == ' ')
   {
      currentPhrase = 0;
      setPhrase(currentPhrase);
   }
}
