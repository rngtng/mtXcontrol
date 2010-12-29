import javax.media.opengl.*;
import processing.opengl.*;
import javax.swing.JFrame;
import picking.*;

public class PFrame extends JFrame {
    CubeApplet s;

    public PFrame() {
        setBounds(100,100,640, 640);
        s = new CubeApplet();
        add(s);
        s.init();
        show();
    }

    public void draw() {
  //    if( isShowing() ) s.redraw();
    }
}

public class CubeApplet extends PApplet {
    Picker picker;

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
        distance = max_distance;

        addMouseWheelListener(new java.awt.event.MouseWheelListener() {
          public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) {
             mouseWheel(evt.getWheelRotation());
          }
        });
        setupOk = true;
    }

    public void draw() {
      if(!setupOk) return;

      background(120);
      lights();
      smooth();

      camera( a2,  a2, distance, // eyeX, eyeY, eyeZ
              a2,  a2,  a2,
             0.0, 1.0, 0.0); // centerX, centerY, centerZ

      translate( a2, 0, a2);
      rotateY(rotY);
      translate( -a2, 0, -a2);

      translate( 0, a2, a2);
      rotateX(-rotX);
      translate( 0, -a2, -a2);

      // Basement
      pushMatrix();
      translate( a2, a2,  float(a) / -6.0);
      fill(#666666);
      noStroke();
      box (a* 1.5, a * 1.5, 1.0);
      popMatrix();

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

      noStroke();
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
          popMatrix();
        }
      }
      picker.stop();

      noFill();
      /*--- 0 == white ---*/
      stroke(255,255,255);
      box(4);


      /*--- x == red ---*/
      translate(a,0,0);
      stroke(255,0,0);
      box(7);
      translate(-a,0,0);

      /*--- y == green ---*/
      translate(0,a,0);
      stroke(0,255,0);
      box(7);
      translate(0,-a,0);

      /*--- z == blue ---*/
      translate(0,0,a);
      stroke(0,0,255);
      box(7);
      translate(0,0,-a);
    }

    void mouseDragged() {
      rotY += radians(mouseX - pmouseX);
      rotX += radians(mouseY - pmouseY);
    }

    void mouseClicked() {
      int id = picker.get(mouseX, mouseY);
      if (id > -1) {
        println(id + " " + (id % 8) + " " + (id / 8) );
        matrix.clickRowCol(id % 8, id / 8, false);
        mark_for_update();
        //spheres[id].changeColor();
      }
    }

    void mouseWheel(int delta) {
      distance += delta * 0.5;
      if (distance > max_distance) {
        distance = max_distance;
      } else if ( distance < min_distance) {
         distance = min_distance;
      }
    }
}
