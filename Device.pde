public interface Device {

  void write_frame(Frame frame);  
  void speed_up();
  void speed_down();     
  
  boolean enabled();
    
}

