import java.util.Arrays;

class Smoothers {
    float smoothValue, smoothRate, sensitivity, thresh;
    int size;
    boolean kickDraw = false;
    Smoother[] smoothers = new Smoother[1];;
    KickSmoother kick;
    
    Smoothers(int spectrumSize) {
        size = spectrumSize;
        smoothRate = 30.0;
        smoothValue = 0.0;
        sensitivity = 2;
        thresh = 0;
        initializeSmoothers();
    }
    
    private void initializeSmoothers() {
      smoothers = (Smoother[])expand(smoothers, size);
      for (int i = 0; i < spectrumSize; i++) {
        smoothers[i] = new Smoother(smoothRate);
      }
      Smoother[] bassSmoothers = Arrays.copyOfRange(smoothers, 1, 5);
      kick = new KickSmoother(smoothRate);
    }

    void update(FFT fftLog) {
      float[] values = new float[size];
      for (int i = 0; i < size; i++) {
        smoothers[i].update(fftLog.getAvg(i));
        values[i] = smoothers[i].value();
      }

      kick.update(values);
    }
    
    void setSens(float sens) {
      sensitivity = sens;
      updateValuesForSmoothers();
    }
    
    void setSmooth(float rate) {
      smoothRate = rate;
      updateValuesForSmoothers();
    }
    
    void setThresh(float newThresh) {
      thresh = newThresh;
      updateValuesForSmoothers();
    }
    
    private void updateValuesForSmoothers() {
      for (int i = 0; i < size; i++) {
        smoothers[i].setSens(sensitivity);
        smoothers[i].setThresh(thresh);
        smoothers[i].setSmooth(smoothRate);
      }
    }
    
    float get(int index) {
      return smoothers[index].normalSmoothValue();
    }

    float getWithoutSmooth(int index) {
      return smoothers[index].normalSmoothValue();
    }
    
    private int chunkSize() {
      return Math.round(size / 3);
    }
    
    float getKick() {
      return kick.get();
    }
    
    float getMid() {
      float maxVal = 0;
      for (int i = chunkSize() - 1; i < chunkSize(); i ++) {
        if (get(i) > maxVal) maxVal = get(i);
      }
      return maxVal;
    }
    
    float getHigh() {
      float maxVal = 0;
      for (int i = (chunkSize() * 2) - 1; i < chunkSize(); i ++) {
        if (get(i) > maxVal) maxVal = get(i);
      }
      return maxVal;
    }

    void toggleKick() {
      kickDraw = !kickDraw;
    }
}
