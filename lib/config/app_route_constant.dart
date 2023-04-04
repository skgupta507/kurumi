class AppRouteConstant {
  static Route HomeScreen = Route('home', '/home');
  static Route SplashScreen = Route('splash', '/splash');
  static Route LoginScreen = Route('login', '/login');
  static Route ErrorScreen = Route('error', '/error');
  static Route SearchScreen = Route('search', '/search');
  static Route SettingScreen = Route('settings', '/settings');
  static Route MediaScreen = Route('media', '/media');
  static Route Character = Route('character', '/character');
  static Route Review = Route('review', '/review');
}

class Route {
  final String name;
  final String path;
  Route(this.name, this.path);
}
