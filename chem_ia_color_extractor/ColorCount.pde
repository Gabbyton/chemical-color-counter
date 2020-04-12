public class ColorCount {
  int red;
  int green;
  int blue;
  
  float timeStamp;
  
  public ColorCount( int _red, int _green , int _blue , float _timeStamp ) {
    this.red = _red;
    this.green = _green;
    this.blue = _blue;
    this.timeStamp = _timeStamp;
  }
  
  public int getRed() {
    return red;
  }
  
  public int getGreen() {
    return green;
  }
  
  public int getBlue() {
    return blue;
  }
  
  public float getTimeStamp() {
    return timeStamp;
  }
  
  public void setRed( int newRed ) {
    this.red = newRed;
  }
  
  public void setBlue( int newBlue ) {
    this.blue = newBlue;
  }
  
  public void setGreen( int newGreen ) {
    this.green = newGreen;
  }
  
  public void setTimeStamp( float _timeStamp ) {
    this.timeStamp = _timeStamp;
  }
}
