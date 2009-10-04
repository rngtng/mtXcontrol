/* Button Class Taken from Processiong.org Tutorials:
 -> http://processing.org/learning/topics/buttons.html

 And modified for lock parameter, added renamed rect to square button and added real rectbutton
  code cleanup
 */

class Button extends GuiElement
{
  public color highlightcolor;
  boolean over = false;
  //  boolean pressed = false;
  boolean locked = false;

  Button(int ix, int iy,  color icolor, color ihighlight) {
    super(ix, iy, icolor);
    this.highlightcolor = ihighlight;
  }

  public boolean pressed() {
    if(!this.over) return false;
    boolean old_locked = this.locked;
    this.locked = !this.locked;
    return this.locked != old_locked;
  }

  public boolean key_pressed(int key_code, boolean mac, boolean crtl, boolean alt) {
    return false;
  }

  public boolean over() {
    return false;
  }

  /* ************************************************************************** */
  protected color current_color() {
    return this.over ? highlightcolor : basecolor;
  }

  protected boolean overRect(int x, int y, int width, int height) {
    return (mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height);
  }

  protected boolean overCircle(int x, int y, int diameter) {
    float disX = x - mouseX;
    float disY = y - mouseY;
    return (sqrt(sq(disX) + sq(disY)) < diameter/2 );
  }
}

class CircleButton extends Button {
  int size;

  CircleButton(int ix, int iy, int isize, color icolor, color ihighlight) {
    super( ix, iy, icolor, ihighlight);
    this.size = isize;
  }

  public boolean over() {
    boolean old_over = this.over;
    this.over = overCircle(x, y, size);
    return this.over != old_over;
  }

  public void display(boolean hide)  {
    super.display(hide);
    if(this.hide) return;
    ellipse(x, y, size, size);
  }
}

class RectButton extends Button {
  int width, height;

  RectButton(int ix, int iy, int iwidth, int iheight, color icolor) {
    this( ix, iy, iwidth, iheight, icolor, icolor);
  }

  RectButton(int ix, int iy, int iwidth, int iheight, color icolor, color ihighlight) {
    super( ix, iy, icolor, ihighlight);
    this.width = iwidth;
    this.height = iheight;
  }

  public boolean over() {
    boolean old_over =  this.over;
    this.over = overRect(x, y, width, height);
    return this.over != old_over;
  }

  public void display(boolean hide) {
    super.display(hide);
    if(this.hide) return;
    rect(x, y, width, height);
  }
}

class SquareButton extends RectButton {

  SquareButton(int ix, int iy, int isize, color icolor, color ihighlight)  {
    super(ix, iy, isize, isize, icolor, ihighlight);
  }
}

class TextButton extends RectButton {
  String button_text;

  TextButton(String itext, int ix, int iy, int iwidth, int iheight, color icolor, color ihighlight) {
    super(ix, iy, iwidth, iheight, icolor, ihighlight);
    this.button_text = itext;
  }

  public void display(boolean hide) {
    super.display(hide);
    if(this.hide) return;
    textFont(fontA, 15);
    fill(255);
    text(this.current_text(), x + (this.width - textWidth(this.button_text)) / 2, y + 17);
  }

  protected String current_text() {
    return this.button_text;
  }
}

class ActionButton extends TextButton {

  String shortcut;

  ActionButton(String itext, String ishortcut, int ix, int iy) {
    this(itext, ishortcut, ix, iy, 134, 25, #444444, #999999);
  }

  ActionButton(String itext, String ishortcut, int ix, int iy,  int iwidth, int iheight) {
    this(itext, ishortcut, ix, iy, iwidth, iheight, #444444, #999999);
  }

  ActionButton(String itext, String ishortcut, int ix, int iy, int iwidth, int iheight, color icolor, color ihighlight) {
    super(itext, ix, iy, iwidth, iheight, icolor, ihighlight);
    this.shortcut = ishortcut;
  }

  public boolean pressed() {
    if(!this.over) return false;
    this.locked = !this.locked;
    return perform_action();
  }

  public boolean key_pressed(int key_code, boolean mac, boolean crtl, boolean alt) {
    String code = "";
    if(mac)  code = "m+" + code;
    if(crtl) code = "c+" + code;
    if(alt) code = "a+" + code;
    if(!this.shortcut.equals(code+char(key_code)) && !this.shortcut.equals(code+key_code)) return false;
    //println(code+char(key_code) + " " + code+key_code + " -> " + this.shortcut);
    this.locked = !this.locked;
    return perform_action();
  }

  protected boolean perform_action() {
    if(this.button_text == "^") matrix.current_frame().shift_up();
    if(this.button_text == "v") matrix.current_frame().shift_down();
    if(this.button_text == "<") matrix.current_frame().shift_left();
    if(this.button_text == ">") matrix.current_frame().shift_right();
    if(this.button_text == "Load from File") matrix = matrix.load_from_file();
    if(this.button_text == "Save to File") matrix.save_to_file();    
    if(this.button_text == "Save to Arduino") arduino.write_matrix(matrix);
    if(this.button_text == "Load from Arduino") matrix = arduino.read_matrix();    
    if(this.button_text == "Add")  matrix.add_frame();
    if(this.button_text == "Delete") matrix.delete_frame();
    if(this.button_text == "Copy")   matrix.copy_frame();
    if(this.button_text == "Paste")  matrix.paste_frame();
    if(this.button_text == "Fill")   matrix.current_frame().fill(matrix.current_color);
    if(this.button_text == "Clear")  matrix.current_frame().clear();

    return true;
  }
}

class ActionToggleButton extends ActionButton {
  String button_text2;

  ActionToggleButton(String itext, String itext2, String ishortcut, int ix, int iy)  {
    this(itext, itext2, ishortcut, ix, iy, 134, 25, #444444, #999999);
  }

  ActionToggleButton(String itext, String itext2, String ishortcut, int ix, int iy, int iwidth, int iheight, color icolor, color ihighlight)  {
    super(itext, ishortcut, ix, iy, iwidth, iheight, icolor, ihighlight);
    this.button_text2 = itext2;
  }

  protected String current_text() {
    return this.locked ?  this.button_text2 : this.button_text;
  }

  protected boolean perform_action() {
     if(this.shortcut == "10") toggle_mode(); // ENTER
     if(this.shortcut == "a+10") arduino.toggle(matrix.current_frame()); // ENTER
     return true;
  }
}

class ColorButton extends RectButton {

  ColorButton(int ix, int iy) {
    this(ix, iy, 134, 25);
  }

  ColorButton(int ix, int iy, int iwidth, int iheight) {
    super(ix, iy, iwidth, iheight, matrix.current_color.get_color(), matrix.current_color.get_color());
  }

  protected color current_color() {
    return matrix.current_color.get_color();
  }

  public boolean pressed() {
    if(!this.over) return false;
    matrix.current_color.invert();
    return true;
  }
}

class MiniColorButton extends RectButton {

  MiniColorButton(int ix, int iy, int iwidth, int iheight, color icolor) {
    super(ix, iy, iwidth, iheight, icolor, icolor);
  }

  public boolean pressed() {
    if(!this.over) return false;
    matrix.current_color.set_color(this.current_color());
    return true;
  }
}
