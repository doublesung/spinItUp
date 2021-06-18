class Barrier {
    PImage img;
    float w = 285, h = 36;
    float x, y;
    float lastY = 340;
    float speed;
    float timer;
    int scoreValue = 1;
    boolean isAlive;
    boolean move;
    boolean left;
    
    Barrier(float x, float y, boolean left) {
        this.x = x;
        this.y = y;
        this.left = left;
        move = false;
        timer = 0;
        speed = 0.5;
        isAlive = true;
        img = barrierImg;
    }

    void display() {
        if(left){
            image(img, x, y, w, h);
            noStroke();
            ellipse(x + w, y, 10, 10);
            ellipse(x + w, y + h, 10, 10);
        }else {
            pushMatrix();
            translate(x, y);
            scale(-1, 1);
            image(img, -285, 0, 285, h);
            noStroke();
            ellipse(0, 0, 10, 10);
            ellipse(0, h, 10, 10);
            popMatrix();
        }
    }

    void update() {
        if(move) {
            timer += 1;
            if(left) {
                x += speed;
            }else {
                x -= speed;
            }
            if(timer == 100) {
                speed *= -1;
                timer = 0;
            }
        }
    }

    void overtaken(){
        if(aircraft.y < y && isAlive) {
            isAlive = false;
            addScore(scoreValue);
            if(fire.x == -1000 && !onfire.isAlive) {
                if(random(15) < 1) {
                    fire.x = random(0, width - 50);
                    fire.y = -fire.size * 2;
                    fire.isAlive = true;
                }
            }
        }
    }
}
