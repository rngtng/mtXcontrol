public class RainbowduinoCubeDevice extends RainbowduinoDevice {


  RainbowduinoCubeDevice(PApplet app) {
    super(app);
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


