public class RainbowduinoCubeDevice extends RainbowduinoDevice {


  RainbowduinoCubeDevice(PApplet app) {
    this(app, null, 0);
  }

  RainbowduinoCubeDevice(PApplet app, String port_name) {
    this(app, port_name, 0);
  }

  RainbowduinoCubeDevice(PApplet app, int baud_rate) {
    this(app, null, baud_rate);
  }

  RainbowduinoCubeDevice(PApplet app, String port_name, int baud_rate) {
    super( app, port_name, baud_rate);
  }

  int[] mapping_xy2ab = new int[] {35,36,3,4,34,37,2,5,33,38,1,6,32,39,0,7};
  int[] mapping_ab2xy = new int[] {14,10,6,2,3,7,11,15};

  private int[] x2xy(int x) {
    return new int[]{ x % 8, x / 8};
  }
  
  private int[] xy2ab(int x, int y) {
    int k = 8 * (y / 2) + mapping_xy2ab[x + 8 * (y % 2)];
    return x2xy(k);
  }

  private int[] ab2xy(int a, int b) {
    int k = mapping_ab2xy[a];
    if( b >= 4) k -= 2;
    k += (b % 4) * 16;
    return x2xy(k);
  }
}


