import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:simple_parking_app/main.dart';
import 'package:simple_parking_app/view/auth/login_page.dart';
import 'package:simple_parking_app/view/auth/signup_page.dart';
import 'package:simple_parking_app/view/exit/exit_page.dart';
import 'package:simple_parking_app/view/parking/parking_page.dart';
import 'package:simple_parking_app/view/splash_screen.dart';
import 'package:simple_parking_app/view/top_up/top_up_page.dart';
import 'package:simple_parking_app/view/vehicle/add_vehicle_page.dart';

List<GetPage> get getRoutePages => _routePages;

List<GetPage> _routePages = [
    GetPage(name: SplashScreen.TAG, page: () => SplashScreen()),
    GetPage(name: LoginPage.TAG, page: () => LoginPage()),
    GetPage(name: SignupPage.TAG, page: () => SignupPage()),
    GetPage(name: '${NavBar.TAG}/:userID', page: () => NavBar()),
    GetPage(name: '${TopUpPage.TAG}/:userID', page: () => TopUpPage()),
    GetPage(name: '${AddVehiclePage.TAG}/:userID', page: () => AddVehiclePage()),
    GetPage(name: '${ParkingPage.TAG}/:userID', page: () => ParkingPage()),
    GetPage(name: '${ExitPage.TAG}/:userID', page: () => ExitPage()),
];
