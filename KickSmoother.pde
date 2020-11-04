class KickSmoother {
    float maxVal = 0, maxThresh = 0, value = 0, rate = 15.0, kickPowerThresh = 100.00, currentSum = 0, kickPowerMax = 180.00;
    int bassLow = 8, bassHigh = 12, lastUpdated = 0, cooldown = 16;

    KickSmoother(float smoothRate) {
        rate = smoothRate;
    }

    void update(float[] values) {
        float newSum = 0;
        float topVal = 0;
        for (int i = bassLow; i < bassHigh; i++) {
            float smootherValue = values[i];
            if (smootherValue > topVal) topVal = smootherValue;
            newSum += smootherValue;
        }

        if (topVal > maxVal) maxVal = topVal;

        if (topVal >= maxThresh && lastUpdated > cooldown) {
            println("fired: ", topVal, maxThresh);
            value = 1;
            lastUpdated = 0;
            maxThresh = min(maxVal, kickPowerMax);
        } else {
            float threshCap = min(maxThresh * 0.992, kickPowerMax);
            maxThresh = max(threshCap, kickPowerThresh);
            value = (value * rate) / (rate + 1);
        }

        if (lastUpdated > 60 && maxVal > kickPowerThresh) {
            maxVal = maxVal * 0.9995;
        }
        
        currentSum = newSum;
        lastUpdated += 1;
    }

    // void update(float[] values) {
    //     float topVal = 0;
    //     for (int i = bassLow; i < bassHigh; i++) {
    //         float smootherValue = values[i];
    //         if (smootherValue > topVal) topVal = smootherValue;
    //     }

    //     if (topVal > maxVal) {
    //         maxVal = topVal;
    //     }

    //     if (topVal >= (maxVal * 0.6) && lastUpdated > cooldown) {
    //         value = 1;
    //         lastUpdated = 0;
    //     } else {
    //         value = (value * rate) / (rate + 1);
    //     }

    //     if (lastUpdated > 60 && maxVal > kickPowerThresh) {
    //         maxVal = maxVal * 0.98;
    //     }
        
    //     lastUpdated += 1;
    // }

    float get() {
        return value;
    }

    void setBassRange(int low, int high) {
        bassLow = low;
        bassHigh = high;
    }
}