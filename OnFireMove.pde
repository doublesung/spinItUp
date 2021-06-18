class OnFireMove {
    float x, y;
    float size;
    float circles;
    boolean go;
    
    OnFireMove(float x, float y) {
        this.x = x;
        this.y = y;
        size = 0;
        circles = 0;
    }
    
    void display(float x, float y) {
        pushStyle();
        noStroke();
        fill(220, 135, 68, 130);
        ellipse(x, y, size, size);
        for(int i = 0; i < circles; i++){
            fill(220, 135, 68, 30 - i * 1.5);
            ellipse(x, 40 + y + i * 5, 50 - i * 2, 50 - i * 2);
        }
        popStyle();
    }
    
    void update() {
        if(onfire.alpha[0] <= 100){
            go = true;
            if(size <= 200) {
                size += 10;
            }
        }
        
        if(go && !(onfire.targetScore + 8 <= score)) {
            if(circles <= 20)circles += 0.5;
        }else{
           if(circles > 0) circles -= 1;
        }
        if(!go && (onfire.targetScore + 10 <= score)) {
            if(size > 0) size -= 10;
        }
    }
}
