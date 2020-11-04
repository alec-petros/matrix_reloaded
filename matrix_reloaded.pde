import toxi.color.*;
import oscP5.*;  
import netP5.*;
import ddf.minim.analysis.*;
import ddf.minim.*;
import spout.*;

OPC opc;
Spout spout;

Smoothers smoothers;

ColorGradient gradient;
GradientController grads;

Minim minim;  
AudioInput audioInput;
BeatDetect beat;
FFT fftLin;
FFT fftLog;
String windowName;

OscP5 oscP5;
float varName;
NetAddress myRemoteLocation;

float height3;
float height23;
float spectrumScale = 4;
int spectrumDivisor = 5;
int spectrumSize;

float increment = 0.03;
float zIndex = 0.0;
float alphaIndex = 0.0;

PFont font;
float maxValues[];

int chunkHeight;
int matrixHeight4;

PShape rectangle;
PShape sq;
int xDiff;

void setup()
{
  size(720, 256);
  frameRate(120);
  height3 = height/3;
  height23 = 2*height/3;
  
  //spout = new Spout(this);
  //spout.createSender("Spout Processing");

  maxValues = new float[9];
  
  oscP5 = new OscP5(this, 8000);   //listening
  myRemoteLocation = new NetAddress("127.0.0.1", 57120);  //  speak to
  
  // The method plug take 3 arguments. Wait for the <keyword>
  oscP5.plug(this, "varName", "keyword");

  // maxValues[0] = 53.05477;
  // maxValues[1] = 20.453335;
  // maxValues[2] = 15.642995;
  // maxValues[3] = 8.958029;
  // maxValues[4] = 7.492257;
  // maxValues[5] = 1.5066102;
  // maxValues[6] = 0.48962182;
  // maxValues[7] = 0.21129508;
  // maxValues[8] = 0.039143644;

  maxValues[0] = 180.5942;
  maxValues[1] = 59.74217;
  maxValues[2] = 30.849203;
  maxValues[3] = 22.770254;
  maxValues[4] = 11.008822;
  maxValues[5] = 6.8135614;
  maxValues[6] = 4.7134547;
  maxValues[7] = 1.7664095;
  maxValues[8] = 0.0000001;

  // Connect to the local instance of fcserver. You can change this line to connect to another computer's fcserver
  opc = new OPC(this, "127.0.0.1", 7890);
  // opc = new OPC(this, "127.0.0.1", 7890);
  //opc = new OPC(this, "192.168.1.7", 7890);
  
   //opc.setColorCorrection(2.5, 2, 2, 2);

  chunkHeight = height / 4;
  matrixHeight4 = chunkHeight / 4;

  // oldskool matrix
  opc.ledStrip(320, 64, width / 4, 3 * matrixHeight4, width / 130.0, 0, true);
  opc.ledStrip(256, 64, width / 4, 2 * matrixHeight4, width / 130.0, 0,  true);
  opc.ledStrip(192, 64, width / 4, 1 * matrixHeight4, width / 130.0, 0, true);
  opc.ledStrip(128, 64, 3 * (width / 4), 1 * matrixHeight4, width / 130.0, 0,  false);
  opc.ledStrip(64, 64, 3 * (width / 4), 3 * matrixHeight4, width / 130.0, 0,  false);
  opc.ledStrip(0, 64, 3 * (width / 4), 2 * matrixHeight4, width / 130.0, 0, false);

  // iron cross wings 
  opc.ledStrip(384, 64,  width / 7, (1 * matrixHeight4) + chunkHeight, 3, 0, true);
  opc.ledStrip(448, 64, 6 * (width / 7), (1 * matrixHeight4) + chunkHeight, 3, 0, false);
  
  // iron cross angled tubes
  opc.ledStrip(512, 64, 1 * width / 4, (2 * matrixHeight4) + chunkHeight, width / 230.0, 0, true);
  opc.ledStrip(640, 64, 3 * (width / 4), (2 * matrixHeight4) + chunkHeight, width / 230.0, 0, false);
  
  // iron cross center tube
  opc.ledStrip(576, 64, width / 2, (3 * matrixHeight4) + chunkHeight, 0 - (width / 160.0), 0, false);
  
  // opc.ledStrip(772, 64,1, 1.5 * (height / 4), width / 160.0, 0, true);
  // opc.ledStrip(836, 64, 1 * width / 4, 2.5 * (height / 4), width / 230.0, 0, true);
  // opc.ledStrip(900, 64, 3 * (width / 4), 2.5 * (height / 4), width / 230.0, 0, false);
  // opc.ledStrip(964, 64, width - 1, 1.5 * (height / 4), 0 - (width / 160.0), 0, false);
  
  //opc.ledStrip(772, 64, width / 4, (2 * matrixHeight4) + (chunkHeight * 2), width / 130.0, 0,  true);
  //opc.ledStrip(836, 64, width / 4, (1 * matrixHeight4) + (chunkHeight * 2), width / 130.0, 0, true);
  //opc.ledStrip(900, 64, 3 * (width / 4), (1 * matrixHeight4) + (chunkHeight * 2), width / 130.0, 0,  false);
  //opc.ledStrip(964, 64, 3 * (width / 4), (2 * matrixHeight4) + (chunkHeight * 2), width / 130.0, 0, false);
  
  
  // Make the status LED quiet
  opc.setStatusLed(false);
  opc.showLocations(true);
  
  colorMode(RGB, 255);
  
  minim = new Minim(this);
  audioInput = minim.getLineIn();
  
  // create an FFT object that has a time-domain buffer the same size as audioInput's sample buffer
  // note that this needs to be a power of two 
  // and that it means the size of the spectrum will be 1024. 
  // fftLin = new FFT( audioInput.bufferSize(), audioInput.sampleRate() );
  
  // calculate the averages by grouping frequency bands linearly. use 30 averages.
  // fftLin.linAverages( 256 );
  
  // create an FFT object for calculating logarithmically spaced averages
  fftLog = new FFT( audioInput.bufferSize(), audioInput.sampleRate() );

  // beat = new BeatDetect(audioInput.bufferSize(), audioInput.sampleRate());
  // beat.detectMode(BeatDetect.FREQ_ENERGY);
  // beat.setSensitivity(400);
  
  // calculate averages based on a miminum octave width of 22 Hz
  // split each octave into three bands
  // this should result in 30 averages
  fftLog.logAverages(22, 6);
  
  spectrumSize = fftLog.avgSize();
  
  smoothers = new Smoothers(spectrumSize);
  
  grads = new GradientController();
  grads.compose();

  windowName = FFT.BARTLETT.toString();

  xDiff = (width / 2) / spectrumSize;
  rectangle = createShape(RECT, 0, 0, xDiff, height);
  rectangle.setStrokeWeight(0);
}

void draw() {
  background(0);
  
  // perform a forward FFT on the samples in audioInput's mix buffer
  // note that if audioInput were a MONO file, this would be the same as using audioInput.left or audioInput.right
  // fftLin.forward( audioInput.mix );
  fftLog.forward( audioInput.mix );
  // beat.detect( audioInput.mix );

  smoothers.update(fftLog);

  for (int i = 0; i < spectrumSize; i++) {
    int xLeft = xDiff * i;
    int xRight = xDiff * (i + 1);

     noStroke();
     pushMatrix();
     translate(xLeft, 0);
     rectangle.setFill(grads.getColor(xLeft, parseInt(map(smoothers.get(i), 0, 1, 0, 255))));
     shape(rectangle);
     popMatrix();
     pushMatrix();
     translate(width - xRight, 0);
     rectangle.setFill(grads.getColor(width - xLeft - 1, parseInt(map(smoothers.get(i), 0, 1, 0, 255))));
     shape(rectangle);
     popMatrix();
  }

  if (smoothers.kickDraw) {
    float kick = smoothers.getKick();
    fill(color(0, 0, 0));
    rect (0, 1.1 * matrixHeight4, width, 1.6 * matrixHeight4);
    fill(grads.getColor(0, parseInt(map(kick, 0, 1, 0, 255))));
    rect (0, 1.1 * matrixHeight4, width, 1.6 * matrixHeight4);
  }
  
  // println(fftSmoothers[0].maxVal(), fftSmoothers[1].maxVal(), fftSmoothers[2].maxVal(), fftSmoothers[3].maxVal(), fftSmoothers[4].maxVal(), fftSmoothers[5].maxVal(), fftSmoothers[6].maxVal(), fftSmoothers[7].maxVal());
  
  //spout.sendTexture();
}

int parsePush(OscMessage message) {
  String partial = message.addrPattern().replace("/1/push", "");
  return parseInt(partial);
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.get(0).floatValue());
  
  if (theOscMessage.addrPattern().contains("/1/push")) {
    int index = parsePush(theOscMessage);
    if (index < 9) {
      grads.setA(index - 1);
    } else {
      grads.setB(index - 9);
    }
  }
  
  if (theOscMessage.checkAddrPattern("/1/fader1")) {
    grads.setCross(theOscMessage.get(0).floatValue());
  }
  
  if (theOscMessage.checkAddrPattern("/1/fader2")) {
    grads.setSens(theOscMessage.get(0).floatValue());
    smoothers.setSens(theOscMessage.get(0).floatValue() * 3);
  }
  
  if (theOscMessage.checkAddrPattern("/1/fader3")) {
    smoothers.setSmooth(theOscMessage.get(0).floatValue() * 2);
  }
    
  if (theOscMessage.checkAddrPattern("/2/multixy1/1")) {
    smoothers.setThresh(theOscMessage.get(0).floatValue());
    grads.setCross(theOscMessage.get(1).floatValue());
  }
  
  if (theOscMessage.checkAddrPattern("/2/multixy1/2")) {
    smoothers.setSens(theOscMessage.get(0).floatValue() * 2);
    smoothers.setSmooth(theOscMessage.get(1).floatValue() * 30);
  }

  if (theOscMessage.checkAddrPattern("/1/toggle1")) {
    smoothers.toggleKick();
  }
}
