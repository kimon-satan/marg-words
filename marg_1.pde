import processing.video.*;

Capture cam;

PFont font;
JSONArray wordsValues;
JSONObject cameraValues;

float camMul_w;

ArrayList<Phrase> phrases;
int currentPhrase;

boolean isSquare;
int squareSize;



void setup()
{
  
  fullScreen(); 
  textAlign(CENTER);
  
  font  = loadFont("Helvetica-Light-48.vlw");
  textSize(72);
  textFont(font);
  
  phrases = new ArrayList<Phrase>();
  
  wordsValues = loadJSONArray("test.json");

  for (int i = 0; i < wordsValues.size(); i++) 
  {
    
    JSONObject j = wordsValues.getJSONObject(i);
    Phrase p = new Phrase();
    p.x = j.getInt("x");
    p.y = j.getInt("y");
    p.in = j.getFloat("in");
    p.out = j.getFloat("out");
    p.sustain = j.getFloat("sustain");
    p.text = j.getString("text");

    phrases.add(p);

  }
  
  cameraValues = loadJSONObject("cameraConfig.json");
  
  currentPhrase = 0;
  setPhrase(currentPhrase);
  
  setupCameras();
  
  isSquare = false;

}

void setupCameras()
{
  
 String[] cameras = Capture.list();

  if (cameras == null) 
  {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 640, 480);
  } 
  if (cameras.length == 0) 
  {
    println("There are no cameras available for capture.");
    exit();
  } 
  else 
  {
    
    
    //println("Available cameras:");
    printArray(cameras);

    // The camera can be initialized directly using an element
    // from the array returned by list():
    String s = cameraValues.getString("camera_name");
    int w = cameraValues.getInt("width");
    int h = cameraValues.getInt("height");
    
    squareSize = cameraValues.getInt("square_size");
  
    //cam = new Capture(this, cameras[18]);
    cam = new Capture(this, w,h,s,30);
    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);
   
    camMul_w = (float)width/cam.width;
    
    // Start capturing the images from the camera
    cam.start();
  } 
}


void setPhrase(int i)
{
  Phrase p = phrases.get(i);
  p.startTime = millis();
}


void drawPhrase(Phrase p)
{
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
}


void draw()
{
  background(0);
  
  Phrase p = phrases.get(currentPhrase);
  
  if (cam.available() == true) 
  {
    cam.read();
  }
  
  fill(255);
  
  int w = (int)(640 * camMul_w);
  int h = (int)(480 * camMul_w);
  
  image(cam, 0, 0, width, h);
  
  
  if(isSquare)
  {
    push();
    rectMode(CENTER);
    noStroke();
    fill(255);
    rect(width/2,height/2,squareSize,squareSize);
    pop();
  }
  else
  {
    
    drawPhrase(p);
    
    if(millis() > p.getTargetTime())
    {
      if(currentPhrase < phrases.size() -1 )
      {
        currentPhrase = currentPhrase + 1;
        setPhrase(currentPhrase);
      }
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
   
   if(key == 's'){
      isSquare = !isSquare; 
   }
   
}
