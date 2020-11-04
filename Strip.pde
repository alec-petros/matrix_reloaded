class Strip {
    int firstPixel;
    int stripLength;
    float noiseTrigger;
    float noiseSpeed;

    Strip(int start, int fullStripLength, float speed, FFT fftLin) {
        firstPixel = start;
        stripLength = fullStripLength;
        noiseSpeed = speed;
        noiseTrigger = random(0, 1000);
    }

    void draw(float normalAmp) {
      
        noiseTrigger += noiseSpeed + map(normalAmp, 0, 1, 0, 0.1); 

        float z = noiseTrigger;

        float xoff = 0;
        //for (int x = 0; x < stripLength; x++) {
        //    float yoff = 0;
            
        //    float noiseOne = noise(xoff, yoff, z);
        //    float noiseTwo = noise(xoff, yoff, z + 10000);

        //    color c = color(
        //        map(noiseOne, 0, 1, 80, 300),
        //        map(noiseTwo, 0, 1, 0, 255),
        //        map(normalAmp, 0, 1, 0, 360)
        //    );
            
        //    opc.setPixel(firstPixel + x, c);
                
        //    xoff += 0.01;
        //}
        
        this.trigRand(normalAmp);
        
        for (int x = 0; x < stripLength; x++) {
          color currentColor = opc.getPixel(x + firstPixel);
          color newColor = lerpColor(color(0, 0, 0, 0), currentColor, 0.9);
          
          //opc.setPixel(x + firstPixel, newColor);
        }
    }
    
    void trigRand(float normalMid) {
      int flashPixel = int(random(0, stripLength));
      if (normalMid > 0.26) {
        //opc.setPixel(firstPixel + flashPixel, color(0, 255, 255));
      }
    }
    
    void flashAll() {
      for (int x = 0; x < stripLength; x++) {
          //opc.setPixel(x + firstPixel, color(255, 0, 255));
        }
    }
}
