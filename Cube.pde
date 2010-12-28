import javax.media.opengl.*;
import com.sun.opengl.util.FPSAnimator;

import processing.opengl.*;
import picking.*;

public class PFrame extends java.awt.Frame {
    CubeApplet s;


    public PFrame() {
      GLCanvas canvas = new GLCanvas();
       canvas.addGLEventListener(new GLRenderer());
       add(canvas);
       setSize(300, 300);
       setLocation(0,0);
       //setUndecorated(true);
       show();
       FPSAnimator animator = new FPSAnimator(canvas, 60);
       animator.start();
    }

    public void draw() {
     // if( isShowing() && s.setupOk ) s.redraw();
    }
}


class GLRenderer implements GLEventListener {
 GL gl;

 public void init(GLAutoDrawable drawable) {
   this.gl = drawable.getGL();
   gl.glClearColor(0, 0, 0, 0);
 }

 public void display(GLAutoDrawable drawable) {
   gl.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT );
   gl.glColor3f(1, 1, 1); 
   gl.glRectf(-0.8, 0.8, frameCount%100/100f -0.8, 0.7);
 }
 
 public void reshape(GLAutoDrawable drawable, int x, int y, int width, int height) {
 }

 public void displayChanged(GLAutoDrawable drawable, boolean modeChanged, boolean deviceChanged) {
 }
}

public class CubeApplet extends PApplet {
    Picker picker;
    Sphere[] spheres;

    boolean setupDone = false;
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

    void mouseDragged() {
      rotY += radians(mouseX - pmouseX);
      rotX += radians(mouseY - pmouseY);
    }


   public void setup() {
       println("Hi " + setupDone);
        if( setupDone ) return;
        setupDone = true;
        noLoop();

        size(640, 360, OPENGL);

        // picker = new Picker(this);
        // 
        // addMouseWheelListener(new java.awt.event.MouseWheelListener() {
        //   public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) {
        //      mouseWheel(evt.getWheelRotation());
        //   }
        // });

        // int id = 0;
        // spheres = new Sphere[64];
        // for(int x = 0; x < 4; x++) {
        //   for(int y = 0; y < 4; y++) {
        //     for(int z = 0; z < 4; z++) {
        //       spheres[id++] = new Sphere(x, y, z, q);
        //     }
        //   }
        // }

        setupOk = true;
        println("SetupOk");
    }

    public void draw() {
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
      box (a* 1.5, a * 1.5, 1.5);
      popMatrix();
    }

    void mouseWheel(int delta) {
      distance -= delta * 0.5;
      if (distance > max_distance) {
        distance = max_distance;
      } else if ( distance < min_distance) {
         distance = min_distance;
      }
    }
}

class Sphere {

  int x, y, z, scale;
  color c;
  byte r, g, b;

  Sphere(int x, int y, int z, int scale) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.scale = scale;
    this.r = 0;
    this.g = 0;
    this.b = 0;
    this.c = color(this.r * 255, this.g * 255, this.b * 255);
  }

  void changeColor() {
    if(this.b == 1) {
      this.g = invert(this.g);
      if(this.g == 1) this.r = invert(this.r);
    }
    this.b = invert(this.b);
    c = color(this.r * 255, this.g * 255, this.b * 255);
  }

  byte invert(byte v) {
    return (byte) (1 - v);
  }

  void display() {
    fill(c);
    pushMatrix();
    translate(x*scale, y*scale, z*scale);
    box(2);
    popMatrix();
  }
}
