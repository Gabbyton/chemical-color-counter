
import processing.video.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

ExecutorService executorService;
List<Future<ColorCount>> list;

Movie video;

int refreshPeriod = 30;
int prevTime = 0;
int saveCount = 0;
int entryCount = 0;

int timeStart = 0;
int setCount = timeStart / 30 + 1;

float movieDuration;

boolean flag = false;

// IMPORTANT SPECIFICATIONS
int leftCornerX = 447; 
int leftCornerY = 155;
int rightCornerX = 524;
int rightCornerY = 382;

int movieWidth = 1920;
int movieHeight = 1080;

Table table;
Box dimensions;

void setup()
{
  size(960, 540);
  table = new Table(); 
  table.addColumn("timeStamp");
  table.addColumn("red");
  table.addColumn("green");
  table.addColumn("blue");
  dimensions = new Box( leftCornerX * 2 , leftCornerY * 2 , rightCornerX * 2 , rightCornerY * 2 );
  
  executorService = Executors.newFixedThreadPool(10);
  list = new ArrayList<Future<ColorCount>>();
    
  video = new Movie(this, "Med Temp Trial 3.mp4");
  video.play();
  video.jump(timeStart + 1);
}
 
void draw() {
  image(video,0,0,960,540);
  noStroke();
  fill(255);
  text("X:\t" + mouseX , 10 , 40 );
  text("Y:\t" + mouseY , 10 , 50 );
  text("Trial Name: " + video.filename,10,60);
  text("Data Set Count: " + setCount,10,70);
  noFill();
  stroke(255,0,0);
  strokeWeight(4);
  rect(leftCornerX,leftCornerY,rightCornerX-leftCornerX,rightCornerY-leftCornerY);
  if(video.available()) {
    if(!flag) {
      movieDuration = video.duration() - 0.1;
      //movieDuration = 5; // if you want to set custom end time
      flag = true;
    }
    video.volume(0);
    noStroke();
    fill(255);
    text(video.time(),10,10);
    text( "/" + video.duration(), 100 , 10);
    video.read();
    if( (int) video.time() > prevTime ) {
    video.loadPixels();
    Callable<ColorCount> callable = new FindColorThread( video.time() , video.pixels.clone() , movieWidth , dimensions );
    Future<ColorCount> color_det = executorService.submit(callable);
    list.add(color_det);
    
    prevTime = (int) video.time();
  }
  
    if( video.time() >= movieDuration ) {
      awaitTerminationAfterShutdown(executorService);
      addTableRows( movieDuration );
      System.out.println( entryCount + " data entries saved." );
      video.stop();      
    }
  }
}

void addTableRows( float duration ) {
  System.out.println("Now loading the data...");
  for(Future<ColorCount> currentColorCount : list ) {
    try {
      TableRow newRow = table.addRow();
      ColorCount result = currentColorCount.get();
      newRow.setFloat("timeStamp", result.getTimeStamp());
      newRow.setInt("red",result.getRed());
      newRow.setInt("green",result.getGreen());
      newRow.setInt("blue",result.getBlue());
      entryCount ++;
      
      if( result.getTimeStamp() >= duration - 1 || (int) result.getTimeStamp() % refreshPeriod == 0 ) {
        saveData();
      } 
    }
    catch( Exception e ) {
      e.printStackTrace();
    }
  } 
}

void saveData() {
  saveTable(table, setCount + "_" + saveCount + ".csv");
  table.clearRows();
  saveCount ++;
}

public void awaitTerminationAfterShutdown(ExecutorService threadPool) {
    threadPool.shutdown();
    try {
        if (!threadPool.awaitTermination(60, TimeUnit.SECONDS)) {
            threadPool.shutdownNow();
        }
    } catch (InterruptedException ex) {
        threadPool.shutdownNow();
        Thread.currentThread().interrupt();
    }
}
