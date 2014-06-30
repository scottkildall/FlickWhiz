/**
 *  TransmissionMaker
 *
 *  by Scott Kildall
 *
 *  From a folder of images, this will generate sequenced JPEG files for output 
 *
 *  May 20 2014
 */

import java.util.Date;

// CHANGE THIS TO LIMIT YOUR NUMBER OF FRAMES
int maxNumFiles = 18000;    // 10 minutes

Boolean bProcessFiles = false;
String status = "Ready";  // Either "Ready" or "Done"

//-- these will be in the data directory, i.e. data/input
String inputDir = "input/";
String outputDir = "output/";
String processedDir = "processed/";
String errorDir = "error/";
String dts = "";

// Files
int numInputFiles = 0;
String [] inputFiles;
String inputFile = "";
int processFileIndex = 0;
int numProcessedFiles = 0;
int numErrorFiles = 0;
String frameString = "";  // for numbered sequencing, this will be: "00001", "00002", etc. 

//-- UI
PFont font;
int vLine = 20;
int hMargin = 20;
int maxDisplayFiles = 30;
PImage currentImage;

//-- image dimensions
int maxWidth = 640;
int maxHeight = 480;


public void setup() {
  size(1280, 720);
  
  font = createFont("Arial",16,true); // Arial, 16 point, anti-aliasing on
  imageMode(CENTER);
  
  loadInputFiles();
}

public void draw() {
  background(0);
  
  if( status == "Ready") {
    if( bProcessFiles == true ) {
        processNextFile();
        if( currentImage != null) {
          image(currentImage, width/2, height/2);
          saveFrame(dataPath(outputDir + dts + "vidout_" + frameString + ".jpg") );
        }  
    }
    
     drawReadyStatus();
    
  }
  else if( status == "Done" )
    drawDoneStatus();
}

//-- depends on status
void keyPressed() {
  if( key == ' ' ) {
    if( status == "Ready" && bProcessFiles == false ) {
      beginProcessFiles();
    }
    else if( status == "Done" ) {
      status = "Ready";
      loadInputFiles(); 
    }
  }
  else if( key == 'l' || key == 'L' ) { 
    if( status == "Ready" )
      loadInputFiles();
  }
}

void beginProcessFiles() {
   makeDTSDirectories();
   bProcessFiles = true;
   size(1280,720);
   
   numProcessedFiles = 0;
}

//-- makes dts (datetimestamp), plus director
void makeDTSDirectories() {
    Date d = new Date();
    long ms = d.getTime()/1000;
    dts = String.valueOf(ms) + "/";
    
    // Make output files directory
    File f = new File(dataPath(outputDir + dts));
    f.mkdirs();
    
    // Make processed files directory
    f = new File(dataPath(processedDir + dts));
    f.mkdirs();
    
    // Make error files directory
    f = new File(dataPath(errorDir + dts));
    f.mkdirs();
}

void drawReadyStatus() {
    int v = vLine *2;
    
    fill(255,0,0);
    textFont(font);
    textSize(16);
    textAlign(CENTER);
    text("Ready", width/2, v );
    v += vLine;
    
    if( bProcessFiles ) {
        v = drawFileCounts(v);
        
       
        fill(255);
         text( inputFile, width/2, v );
    }
    else {
      textAlign(LEFT);
      textSize(12);
      fill(255); 
      text( "Num files = " + numInputFiles, hMargin, v );
      v += vLine;
      
      fill(0,255,0);  
      int max = (numInputFiles < maxDisplayFiles) ? numInputFiles : maxDisplayFiles; 
      for( int i = 0; i < max; i++ ) {
        text( inputFiles[i], hMargin, v );
        v += vLine;
      }
      
      textAlign(CENTER);
      textSize(16);
      fill(255); 
      
      if( bProcessFiles == false )
        text("Press <SPACE> to process input files", width/2, height - 80 );
      
      text("Press 'l' to reload file list", width/2, height - 60 );
    }  
}

void drawDoneStatus() {
   int v = vLine *2;
    fill(255,0,0);
    textFont(font);
    textSize(16);
    textAlign(CENTER);
    
    text("Done", width/2, v );
    v+=vLine;
    
    drawFileCounts(v);
    
    text("Press <SPACE> to reload file list", width/2, height - 60 );
}

int drawFileCounts(int v) {
    fill(255); 
    text("Num processed files = " + numProcessedFiles , width/2, v );
    v += vLine;
    text("Num error files = " + numErrorFiles , width/2, v );
    v += vLine;
    return v;
}

PImage resizeImage(PImage img) {
  if( img.width > maxWidth || img.height > maxHeight ) {
      float wFactor = (float)img.width/(float)maxWidth;
      float hFactor = (float)img.height/(float)maxHeight;
      
      if( wFactor > hFactor )
         img.resize(maxWidth, 0);
      else
        img.resize(0, maxHeight);
  }
  
  //println( "resize, w = " + img.width + " h = " + img.height );
    
  return img; 
}
//-- loadInputFiles(): will count all files in the input directory
void loadInputFiles() {
  processFileIndex = 0;
  
  // we'll have a look in the data folder
  java.io.File folder = new java.io.File(dataPath(inputDir));
  
  // list the files in the data folder, passing the filter as parameter
  inputFiles = folder.list();
  numInputFiles = inputFiles.length;
  
  // For debugging: comment this out to see list of all files
  // display the filenames
 // for (int i = 0; i < inputFiles.length; i++) {
  //  println(inputFiles[i]);
  //}
  
  numProcessedFiles = 0; 
  numErrorFiles = 0;
  currentImage = null;
}

//-- Each draw loop, load a new file into Image and process it by resizing, etc.
void processNextFile() {
  //-- if this is an invalid file, it may or may not throw an exception 
  try {
      String filename = dataPath(inputDir + inputFiles[processFileIndex]);
      //println("Loading: " + filename);
      currentImage = loadImage(filename);
  } catch ( Exception e ) {
   // if exception is thrown, set to null
   println("Exception");
   currentImage = null;
  }
  
  if(currentImage == null ) {
    moveFile(dataPath(inputDir+inputFiles[processFileIndex]),dataPath(errorDir + dts +inputFiles[processFileIndex]));
    numErrorFiles++;
  }
  else {
    currentImage = resizeImage(currentImage);
    
    inputFile = inputFiles[processFileIndex];
    moveFile(dataPath(inputDir+inputFiles[processFileIndex]),dataPath(processedDir + dts + inputFiles[processFileIndex]));
    numProcessedFiles++;
    frameString = String.format("%05d", numProcessedFiles);
  }
   processFileIndex++;
  
  if( processFileIndex == numInputFiles || processFileIndex == maxNumFiles ) {
    size( 1280, 720 );
    bProcessFiles = false;
    currentImage = null;
    status = "Done";
  }
    
  //  processFileIndex++;
  //currentImage = null;
}

Boolean moveFile( String srcPath, String destPath ) {
   //println("SRC=" +srcPath);
   //println("DST=" +destPath); 
    File srcFile;
    File destFile;
       
      try{      
         // create new File objects
         srcFile = new File(srcPath);
         destFile = new File(destPath);
         
         // rename file
         return srcFile.renameTo(destFile);
         
      }catch(Exception e){
         e.printStackTrace();
         return false;
   }
}

