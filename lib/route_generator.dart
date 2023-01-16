import 'package:flutter/material.dart';
import 'src/pages/map.dart';

import 'src/models/route_argument.dart';
import 'src/pages/chat.dart';
import 'src/pages/details.dart';
import 'src/pages/forget_password.dart';
import 'src/pages/help.dart';
import 'src/pages/languages.dart';
import 'src/pages/login.dart';
import 'src/pages/notifications.dart';
import 'src/pages/order.dart';
import 'src/pages/order_edit.dart';
import 'src/pages/pages.dart';
import 'src/pages/settings.dart';
import 'src/pages/signup.dart';
import 'src/pages/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/Splash':
        return MaterialPageRoute(builder: (_) => SplashScreen(), settings: settings);
      case '/SignUp':
        return MaterialPageRoute(builder: (_) => SignUpWidget(), settings: settings);
      case '/MobileVerification':
        return MaterialPageRoute(builder: (_) => SignUpWidget(), settings: settings);
      case '/MobileVerification2':
        return MaterialPageRoute(builder: (_) => SignUpWidget(), settings: settings);
      case '/Login':
        return MaterialPageRoute(builder: (_) => LoginWidget(), settings: settings);
      case '/ForgetPassword':
        return MaterialPageRoute(builder: (_) => ForgetPasswordWidget(), settings: settings);
      case '/Pages':
        return MaterialPageRoute(builder: (_) => PagesTestWidget(currentTab: args), settings: settings);
      case '/Chat':
        return MaterialPageRoute(builder: (_) => ChatWidget(routeArgument: args as RouteArgument), settings: settings);
      case '/Map':
        return MaterialPageRoute(builder: (_) => MapWidget(restaurant: args ), settings: settings);
      case '/Details':
        return MaterialPageRoute(builder: (_) => DetailsWidget(routeArgument: args), settings: settings);
      case '/OrderDetails':
        return MaterialPageRoute(builder: (_) => OrderWidget(routeArgument: args as RouteArgument), settings: settings);
      case '/OrderEdit':
        return MaterialPageRoute(builder: (_) => OrderEditWidget(routeArgument: args as RouteArgument), settings: settings);
      case '/Notifications':
        return MaterialPageRoute(builder: (_) => NotificationsWidget(), settings: settings);
      case '/Languages':
        return MaterialPageRoute(builder: (_) => LanguagesWidget(), settings: settings);
      case '/Help':
        return MaterialPageRoute(builder: (_) => HelpWidget(), settings: settings);
      case '/Settings':
        return MaterialPageRoute(builder: (_) => SettingsWidget(), settings: settings);
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(builder: (_) => PagesTestWidget(currentTab: 2), settings: settings);
    }
  }
}
