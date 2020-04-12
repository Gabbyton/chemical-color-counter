public class Box {
  private int leftCornerX , leftCornerY;
  private int rightCornerX , rightCornerY;
  
  public Box( int _leftCornerX , int _leftCornerY , int _rightCornerX , int _rightCornerY ) {
    this.leftCornerX = _leftCornerX;
    this.leftCornerY = _leftCornerY;
    this.rightCornerX = _rightCornerX;
    this.rightCornerY = _rightCornerY;
  }
  
  public int getStartX() {
    return leftCornerX;
  }
  
  public int getStartY() {
    return leftCornerY;
  }
  
  public int getRectHeight() {
    return (rightCornerY - leftCornerY);
  }
  
  public int getRectWidth() {
    return (rightCornerX - leftCornerX);
  }
  
  public int getEndX() {
    return rightCornerX;
  }
  
  public int getEndY() {
    return rightCornerY;
  }
}
