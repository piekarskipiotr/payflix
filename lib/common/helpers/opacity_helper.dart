class OpacityHelper {
  static double calculateHeaderOpacity(double height, double a, double b) {
    if (height < a || height > b) {
      return 1.0;
    } else if (height < a + 1 || height > b - 1) {
      return 0.8;
    } else if (height < a + 2 || height > b - 2) {
      return 0.6;
    } else if (height < a + 3 || height > b - 3) {
      return 0.4;
    } else {
      return 0.0;
    }
  }
}
