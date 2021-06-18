class JetPoint {
    PImage img;
    final float AIRCRAFT_INIT_X = width / 2;
    final float AIRCRAFT_INIT_Y = height / 4 * 3;
    float x, y;
    float w = 10, h = 9;
    float sx, sy;
    boolean turnLeft = true;
    boolean turnRight = false;
    
    JetPoint(float x, float y) {
        this.x = x;
        this.y = y;
        img = jetpointImg;
    }

    void display() {
        
        if(turnLeft) angle -= 0.025;
        if(turnRight) angle += 0.025;
        
        if(angle <= -3.1415927) {
            turnLeft = false;
            turnRight = true;
        }
        if(angle >= 0) {
            turnLeft = true;
            turnRight = false;
        }
        
        sx = x + cos(radians(0) + angle) * AIRCRAFT_SIZE / 2;
        sy = y + sin(radians(0) + angle) * AIRCRAFT_SIZE / 2;
       
        image(img, sx - w / 2, sy - h / 2);
    }

    void update(float x, float y){
        this.x = x;
        this.y = y;
    }
}
