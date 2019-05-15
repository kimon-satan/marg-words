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
  
  long getDecayTime()
  {
    long l = startTime;
    l += in * 1000;
    l += sustain * 1000;
    
    return l;
  }
  
};
