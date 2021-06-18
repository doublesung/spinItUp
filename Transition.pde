class Transition {
    float w, h;
    float x, y;
    float alpha;
    boolean isAlive;
    boolean state2;
    boolean over;
    Transition() {
        x = width / 2;
        y = height / 2;
        w = 380;
        h = 680;
        alpha = 0;
        isAlive = false;
        state2 = false;
        over = false;
    }
    
    void display() {
        pushStyle();
        rectMode(CENTER);
        noStroke();
        fill(0, alpha);
        rect(x, y, w, h);
        popStyle();
    }
    
    void update() {
        if(isAlive) {
            if(!state2) {
                alpha += 5 ;
                if(alpha == 255) {
                    state2 = true;
                    over = true;
                }
            }else {
                if(alpha > 0) alpha -= 5; 
                if(alpha == 0) {
                    state2 = false;
                    isAlive = false;
                    //over = false;
                }
            }
        }
    }
}
