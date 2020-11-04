class Smoother {
    float rawValue = 0, smoothValue, smoothRate, maxVal, smoothMaxVal, sensitivity, thresh;

    Smoother(float rate) {
        smoothValue = 0.0;
        smoothRate = rate;
        maxVal = 0;
        sensitivity = 1;
        thresh = 0.0;
        smoothMaxVal = 0.5;
    }

    void update(float newValue) {
        float normalVal = normalizeValue(newValue, smoothMaxVal);
        rawValue = newValue;

        if (newValue > maxVal) {
            maxVal = newValue;
            smoothMaxVal = newValue;
        } else {
            smoothMaxVal = maxVal * 0.999;
        }
        if ((newValue > smoothValue) && (normalVal > thresh)) {
            smoothValue = newValue;
        } else {
            smoothValue = (smoothValue * smoothRate) / (smoothRate + 1);
        }
    }

    float value() {
        return rawValue;
    }

    float normalSmoothValue() {
        return normalizeValue(smoothValue, smoothMaxVal / sensitivity);
    }

    float normalizeValue(float newValue, float maxNormal) {
        float freshVal = map(newValue, 0, maxNormal, 0, 1);
        return (float)Math.pow(freshVal, 2);
    }

    float maxVal() {
        return maxVal;
    }
    
    void setSens(float sens) {
      sensitivity = sens;
    }
    
    void setSmooth(float rate) {
      smoothRate = rate;
    }
    
    void setThresh(float newThresh) {
      thresh = newThresh;
    }
}
