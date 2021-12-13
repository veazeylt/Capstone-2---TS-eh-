
import processing.video.*;
import processing.serial.*;

int NUM_OF_VALUES_FROM_ARDUINO = 2;
int sensorValues[];

String myString = null;

Serial myPort;

Movie analysis1, analysis2;


Capture cam1;
Capture cam2;

//webcam video length stuff
int LENGTH = 30;
PImage clip1[] = new PImage[LENGTH];
PImage clip2[] = new PImage[LENGTH];


//these are all my images/videos
PImage bg, ap, de1, de2, de3, de4, de5, de6, de7, de8, de9, de10, de11, de12, de13, de14;


// this is webcam recording/playing
boolean record1 = false;
boolean record2 = false;

boolean playback1 = false;
boolean playback2 = false;

//boolean result = false;
int frameRec1 = 0;
int frameRec2 = 0;

int framePlay1 = 0;
int framePlay2 = 0;
//

//random result
float result;

//fake scanning
float line1, line2, line3, line4, line5, line6, line7, line8;

//restart sketch timing
int resetTime = 0;

//on to result
boolean analysisDone = false;
int toResult = 0;

int screen = 0;

void setup() {
  fullScreen(2);
  bg = loadImage("Home.jpg");
  ap = loadImage("Approved.jpg");
  de1 = loadImage("Denied1.jpg");
  de2 = loadImage("Denied2.jpg");
  de3 = loadImage("Denied3.jpg");
  de4 = loadImage("Denied4.jpg");
  de5 = loadImage("Denied5.jpg");
  de6 = loadImage("Denied6.jpg");
  de7 = loadImage("Denied7.jpg");
  de8 = loadImage("Denied8.jpg");
  de9 = loadImage("Denied9.jpg");
  de10 = loadImage("Denied10.jpg");
  de11 = loadImage("Denied11.jpg");
  de12 = loadImage("Denied12.jpg");

  analysis1 = new Movie(this, "analysis1.m4v");
  analysis2 = new Movie(this, "analysis2.m4v");
  println(analysis1.duration());
  println(analysis2.duration());

  line1 = 864;
  line2 = 979;
  line3 = 223;
  line4 = 338;
  line5 = 864;
  line6 = 979;
  line7 = 764;
  line8 = 879;

  String[] cameras = Capture.list();

  setupSerial();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam1 = new Capture(this, 0, 0);
    //cam2 = new Capture(this, 640, 480);
  } else if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    printArray(cameras);

    // The camera can be initialized directly using an element
    // from the array returned by list():

    cam1 = new Capture(this, cameras[2]);
    cam2 = new Capture(this, cameras[1]);

    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);

    // Start capturing the images from the camera
    cam1.start();
    cam2.start();
  }
}




void draw() {
  result = random(0, 18);
  getSerialData();
  //printArray(sensorValues);
  decideScreen();    //this function decides what screen to change to, according to sensorVaqlues
  readCamera1();
  readCamera2();


  if ( screen == 0 ) {
    background(bg);
  } else if ( screen == 1 ) {
    image(analysis1, 0, 0);
  } else if ( screen == 2 ) {
    image(analysis2, 0, 0);
    finishAnalysis();
  } else if ( screen == 3 ) {
    image(ap, 0, 0);
    scanSim();
    video1();
    video2();
    resetTiming();
    reset();
  } else if ( screen == 4 ) {
    image(de1, 0, 0);
    scanSim();
    video1();
    video2();
    resetTiming();
    reset();
  } else if ( screen == 5 ) {
    image(de2, 0, 0);
    scanSim();
    video1();
    video2();
    resetTiming();
    reset();
  } else if ( screen == 6 ) {
    image(de3, 0, 0);
    scanSim();
    video1();
    video2();
    resetTiming();
    reset();
  } else if ( screen == 7 ) {
    image(de4, 0, 0);
    scanSim();
    video1();
    video2();
    resetTiming();
    reset();
  } else if ( screen == 8 ) {
    image(de5, 0, 0);
    scanSim();
    video1();
    video2();
    resetTiming();
    reset();
  } else if ( screen == 9 ) {
    image(de6, 0, 0);
    scanSim();
    video1();
    video2();
    resetTiming();
    reset();
  } else if ( screen == 10 ) {
    image(de7, 0, 0);
    scanSim();
    video1();
    video2();
    resetTiming();
    reset();
  } else if ( screen == 11 ) {
    image(de8, 0, 0);
    scanSim();
    video1();
    video2();
    resetTiming();
    reset();
  } else if ( screen == 12 ) {
    image(de9, 0, 0);
    scanSim();
    video1();
    video2();
    resetTiming();
    reset();
  } else if ( screen == 13 ) {
    image(de10, 0, 0);
    scanSim();
    video1();
    video2();
    resetTiming();
    reset();
  } else if ( screen == 14 ) {
    image(de11, 0, 0);
    scanSim();
    video1();
    video2();
    resetTiming();
    reset();
  } else if ( screen == 15 ) {
    image(de12, 0, 0);
    scanSim();
    video1();
    video2();
    resetTiming();
    reset();
  }
}


void movieEvent(Movie m) {
  if (m == analysis1) {
    analysis1.read();
  } else if (m == analysis2) {
    analysis2.read();
  }
}

void decideScreen() { //this should have the exact content of keyPressed but with sensorValues[]

  if ((sensorValues[0] < 40) && (screen == 0)) {    // here you should add || sensorValues[]
    screen = 1;
    record1 = true;
    frameRec1 = 0;
    analysis1.play();

  }
  if ((sensorValues[1] == 0) && (screen == 1)) {
    screen = 2;
    record2 = true;
    frameRec2 = 0;
    analysis2.play();
  }


  if ((analysisDone == true) && (screen == 2))
  {
    if (result < 6) {
      screen = 3;
      playback1 = true;
      framePlay1 = 0;
      playback2 = true;
      framePlay2 = 0;
      println(result);
    } else if ((result >= 6) && (result < 7)) {
      screen = 4;
      playback1 = true;
      framePlay1 = 0;
      playback2 = true;
      framePlay2 = 0;
      println(result);
    } else if ((result >= 7) && (result < 8)) {
      screen = 5;
      playback1 = true;
      framePlay1 = 0;
      playback2 = true;
      framePlay2 = 0;
      println(result);
    } else if ((result >= 8) && (result < 9)) {
      screen = 6;
      playback1 = true;
      framePlay1 = 0;
      playback2 = true;
      framePlay2 = 0;
      println(result);
    } else if ((result >= 9) && (result < 10)) {
      screen = 7;
      playback1 = true;
      framePlay1 = 0;
      playback2 = true;
      framePlay2 = 0;
      println(result);
    } else if ((result >= 10) && (result < 11)) {
      screen = 8;
      playback1 = true;
      framePlay1 = 0;
      playback2 = true;
      framePlay2 = 0;
      println(result);
    } else if ((result >= 11) && (result < 12)) {
      screen = 9;
      playback1 = true;
      framePlay1 = 0;
      playback2 = true;
      framePlay2 = 0;
      println(result);
    } else if ((result >= 12) && (result < 13)) {
      screen = 10;
      playback1 = true;
      framePlay1 = 0;
      playback2 = true;
      framePlay2 = 0;
      println(result);
    } else if ((result >= 13) && (result < 14)) {
      screen = 11;
      playback1 = true;
      framePlay1 = 0;
      playback2 = true;
      framePlay2 = 0;
      println(result);
    } else if ((result >= 14) && (result < 15)) {
      screen = 12;
      playback1 = true;
      framePlay1 = 0;
      playback2 = true;
      framePlay2 = 0;
      println(result);
    } else if ((result >= 15) && (result < 16)) {
      screen = 13;
      playback1 = true;
      framePlay1 = 0;
      playback2 = true;
      framePlay2 = 0;
      println(result);
    } else if ((result >= 16) && (result < 17)) {
      screen = 14;
      playback1 = true;
      framePlay1 = 0;
      playback2 = true;
      framePlay2 = 0;
      println(result);
    } else if ((result >= 17) && (result <= 18)) {
      screen = 15;
      playback1 = true;
      framePlay1 = 0;
      playback2 = true;
      framePlay2 = 0;
      println(result);
    }
  }
}


void setupSerial() {
  //printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[ 16 ], 9600);
  myPort.clear();
  myString = myPort.readStringUntil( 10 );
  myString = null;

  sensorValues = new int[NUM_OF_VALUES_FROM_ARDUINO];
}

void getSerialData() {
  while (myPort.available() > 0) {
    myString = myPort.readStringUntil( 10 );
    if (myString != null) {
      String[] serialInArray = split(trim(myString), ",");
      if (serialInArray.length == NUM_OF_VALUES_FROM_ARDUINO) {
        for (int i=0; i<serialInArray.length; i++) {
          sensorValues[i] = int(serialInArray[i]);
        }
      }
    }
  }
}

void finishAnalysis() {
  if (toResult < 410) {
    toResult ++;
  }
  if (toResult == 410) {
    analysisDone = true;
    //toResult = 0;
  }
    println(toResult);

}

  void resetTiming() {
    if (screen >= 3) {
      resetTime += 1;
    }
    println(resetTime);
  }

  void reset() {
    if (resetTime == 120) {
      resetTime = 0;
      screen = 0;
      record1 = false;
      record2 = false;
      playback1 = false;
      playback2 = false;
      frameRec1 = 0;
      frameRec2 = 0;
      framePlay1 = 0;
      framePlay2 = 0;
      analysis1.stop();
      analysis2.stop();
      toResult = 0;
      analysisDone = false;
    }
  }



  void scanSim() {
    fill(0);
    noStroke();
    rect(108, 749, 346, 346);
    fill(0);
    noStroke();
    rect(649, 749, 346, 346);
    stroke(#FFFF00);
    line(108, line1, 454, line1);
    line1 = line1 - 5;
    if (line1 < 749) {
      line1 = 1095;
    }
    line(108, line2, 454, line2);
    line2 = line2 + 5;
    if (line2 > 1095) {
      line2 = 749;
    }
    line(line3, 749, line3, 1095);
    line3 = line3 - 5;
    if (line3 < 108) {
      line3 = 454;
    }
    line(line4, 749, line4, 1095);
    line4 = line4 + 5;
    if (line4 > 454) {
      line4 = 108;
    }
    line(649, line5, 995, line5);
    line5 = line5 - 5;
    if (line5 < 749) {
      line5 = 1095;
    }
    line(649, line6, 995, line6);
    line6 = line6 + 5;
    if (line6 > 1095) {
      line6 = 749;
    }
    line(line7, 749, line7, 1095);
    line7 = line7 - 5;
    if (line7 < 649) {
      line7 = 995;
    }
    line(line8, 749, line8, 1095);
    line8 = line8 + 5;
    if (line8 > 995) {
      line8 = 649;
    }
  }

  void video1() {
    if (playback1) {
      tint(255, 126);
      clip1[0].filter(GRAY);
      clip1[1].filter(GRAY);
      clip1[2].filter(GRAY);
      clip1[3].filter(GRAY);
      clip1[4].filter(GRAY);
      clip1[5].filter(GRAY);
      clip1[6].filter(GRAY);
      clip1[7].filter(GRAY);
      clip1[8].filter(GRAY);
      clip1[9].filter(GRAY);
      clip1[10].filter(GRAY);
      clip1[11].filter(GRAY);
      clip1[12].filter(GRAY);
      clip1[13].filter(GRAY);
      clip1[14].filter(GRAY);
      clip1[15].filter(GRAY);
      clip1[16].filter(GRAY);
      clip1[17].filter(GRAY);
      clip1[18].filter(GRAY);
      clip1[19].filter(GRAY);
      clip1[20].filter(GRAY);
      clip1[21].filter(GRAY);
      clip1[22].filter(GRAY);
      clip1[23].filter(GRAY);
      clip1[24].filter(GRAY);
      clip1[25].filter(GRAY);
      clip1[26].filter(GRAY);
      clip1[27].filter(GRAY);
      clip1[28].filter(GRAY);
      clip1[29].filter(GRAY);
      image(clip1[framePlay1], 649, 749, 346, 346);
      if (framePlay1++ >= LENGTH-1) framePlay1 = 0;

    }
  }


  void video2() {
    if (playback2) {
      tint(255, 126);
      clip2[0].filter(GRAY);
      clip2[1].filter(GRAY);
      clip2[2].filter(GRAY);
      clip2[3].filter(GRAY);
      clip2[4].filter(GRAY);
      clip2[5].filter(GRAY);
      clip2[6].filter(GRAY);
      clip2[7].filter(GRAY);
      clip2[8].filter(GRAY);
      clip2[9].filter(GRAY);
      clip2[10].filter(GRAY);
      clip2[11].filter(GRAY);
      clip2[12].filter(GRAY);
      clip2[13].filter(GRAY);
      clip2[14].filter(GRAY);
      clip2[15].filter(GRAY);
      clip2[16].filter(GRAY);
      clip2[17].filter(GRAY);
      clip2[18].filter(GRAY);
      clip2[19].filter(GRAY);
      clip2[20].filter(GRAY);
      clip2[21].filter(GRAY);
      clip2[22].filter(GRAY);
      clip2[23].filter(GRAY);
      clip2[24].filter(GRAY);
      clip2[25].filter(GRAY);
      clip2[26].filter(GRAY);
      clip2[27].filter(GRAY);
      clip2[28].filter(GRAY);
      clip2[29].filter(GRAY);
      image(clip2[framePlay2], 108, 749, 346, 346);
      if (framePlay2++ >= LENGTH-1) framePlay2 = 0;
    }
  }


  void readCamera1() {
    if (cam1.available() == true) {
      if (record1 && (millis()%100<20)) {
        if ( frameRec1 < LENGTH ) {
          cam1.read();
          cam1.loadPixels();
          clip1[frameRec1] = cam1.copy();
          frameRec1 ++;
          print(".");
        } else {
          record1 = false;
          frameRec1 = 0;
          println("recorded");
        }
      }
    }
  }


  void readCamera2() {
    if (cam2.available() == true) {
      if (record2 && (millis()%100<20)) {
        if ( frameRec2 < LENGTH ) {
          cam2.read();
          cam2.loadPixels();
          clip2[frameRec2] = cam2.copy();
          frameRec2 ++;
          print(".");
        } else {
          record2 = false;
          frameRec2 = 0;
          println("recorded");
        }
      }
    }
  }
  
  
//All code is original or based on tutorials from processing.org or from NYU Shanghai's IMA Website Tutorials
//I am the sole owner of this content and any usage of my content must be credited properly.
