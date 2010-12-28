public interface Device {

  void setColorScheme();
  boolean draw_as_circle();

  boolean enabled();
  void write_frame(Frame frame);
}

public interface StandaloneDevice {

  public Matrix read_matrix();
  public void write_matrix(Matrix matrix);
  public void toggle();

  public void init(Rainbowduino _rainbowduino);

  void speedUp();
  void speedDown();

  void brightnessUp();
  void brightnessDown();
}
