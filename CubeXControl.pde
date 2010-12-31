import javax.media.opengl.*;
import processing.opengl.*;
import javax.swing.JFrame;
import picking.*;

import damkjer.ocd.*;

public class PFrame extends JFrame {
    CubeApplet s;

    public PFrame() {
        setBounds(100,100,640, 640);
        s = new CubeApplet();
        add(s);
        s.init();
        show();
    }
}

public class CubeApplet extends PApplet {
    Picker picker;
    Camera camera1;

    public boolean setupOk = false;

    int a = 30;  //cube side length
    int q = a / 3; //distance between two LEDs
    float a2 = a / 2.0;

    float rotX;
    float min_rotX = 2 * a;
    float max_rotX = 5 * a;

    float rotY;

    float distance;
    float min_distance = 2 * a;
    float max_distance = 4 * a;

   public void setup() {
       //noLoop();
       size(640, 640, P3D);

        picker = new Picker(this);
        distance = 3 * a;

        addMouseWheelListener(new java.awt.event.MouseWheelListener() {
          public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) {
             mouseWheel(evt.getWheelRotation());
          }
        });
        setupOk = true;

        camera1 = new Camera( this, (float)(a/2.0), (float)(a/2.0), a * 2.0, // eyeX, eyeY, eyeZ
        (float)(a/2.0), (float)(a/2.0), (float)(a/2.0)); // centerX, centerY, centerZ
    }

    public void draw() {
      if(!setupOk) return;

      background(120);
      lights();
      //smooth();

      //camera1.feed();

      camera( a2,  a2, distance, // eyeX, eyeY, eyeZ
              a2,  a2,  a2,
             0.0, 1.0, 0.0); // centerX, centerY, centerZ


      translate( a2, 0, a2);
      rotateY(rotY);
      translate( -a2, 0, -a2);

      translate( 0, a2, a2);
      rotateX(-rotX);
      rotateX(PI/2);
      translate( 0, -a2, -a2);
      
      // Basement
      pushMatrix();
      translate( a2, a2,  float(a) / -6.0);
      fill(#666666);
      noStroke();
      box (a* 1.5, a * 1.5, 1.0);
      popMatrix();

      // Line Grid
      pushMatrix();
      stroke(100,100,100);
      for (int dim = 0; dim < 3; dim++) {
        for(int i = 0; i < 4; i++ ) {
          for(int j = 0; j < 4; j++ ) {
            line((i*q), (j*q), 0, (i*q), (j*q), a);
          }
        }
        rotateX(PI/2);
        rotateY(PI/2);
      }
      popMatrix();

      stroke(140,140,140);
      //noStroke();
      int scale = 10;
      Frame f = matrix.current_frame();
      for(int y = 0; y < f.rows; y++) {
        for(int x = 0; x < f.cols; x++) {
          picker.start(y * f.cols + x);

          fill(f.get_pixel(x,y).get_color());
          pushMatrix();

          int x1 = 2 + x / 4 - 2 * (int) (Math.floor(y / 4));
          int y1 = (int) (Math.ceil(Math.abs(x - 3.5)) - 1);
          int z1 = y % 4;

          translate(x1*scale, y1*scale, z1*scale);
          box(4);
          //sphere(2);
          popMatrix();
        }
      }
      picker.stop();
    }

    void drawDebug(PGraphics g) {
      g.noFill();
      /*--- 0 == white ---*/
      g.stroke(255,255,255);
      g.box(4);

      /*--- x == red ---*/
      g.translate(a,0,0);
      g.stroke(255,0,0);
      g.box(7);
      g.translate(-a,0,0);

      /*--- y == green ---*/
      g.translate(0,a,0);
      g.stroke(0,255,0);
      g.box(7);
      g.translate(0,-a,0);

      /*--- z == blue ---*/
      g.translate(0,0,a);
      g.stroke(0,0,255);
      g.box(7);
      g.translate(0,0,-a);
    }

    void mouseDragged() {
      rotY += radians(mouseX - pmouseX);
      rotX += radians(mouseY - pmouseY);
      camera1.tumble( -1.0 * radians(mouseX - pmouseX), -1.0 * radians(mouseY - pmouseY));
    }

    void mouseClicked() {
      int id = picker.get(mouseX, mouseY);
      if (id > -1) {
        matrix.clickRowCol(id % 8, id / 8, false);
        mark_for_update();
      }
    }

    void mouseWheel(int delta) {
      camera1.zoom(delta*0.03);
      distance += delta * 0.5;
      if (distance > max_distance) {
        distance = max_distance;
      } else if ( distance < min_distance) {
         distance = min_distance;
      }
    }

    void keyPressed() {
      main.keyCode = keyCode;
      main.keyPressed();
    }

    void keyReleased() {
      main.keyCode = keyCode;
      main.keyReleased();
    }

}
