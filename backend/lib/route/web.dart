import 'package:vania/vania.dart';
import 'package:intl/intl.dart';

class WebRoute implements Route {
  @override
  void register() {
    Router.get("/", () {
      return Response.html(Intl.message(
        'Welcome, {name}',
        args: ['Vania'],
        name: 'welcomeMessage',
        examples: const {'name': 'Vania'}
      ).replaceAll('{name}', 'Vania'));
    });
  }
}
