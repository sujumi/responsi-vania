import 'package:backend/app/http/controllers/auth_controller.dart';
import 'package:backend/app/http/controllers/user_controller.dart';
import 'package:backend/app/http/middleware/authenticate.dart';
import 'package:vania/vania.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix
    Router.basePrefix('api');

    Router.group(() {
      Router.post('register', authController.register);
      Router.post('login', authController.login);
    }, prefix: 'auth');

    Router.group(() {
      // Get all users
      Router.get('/', userController.index);

      // Get a single user by ID
      Router.get('/{id}', userController.show);

      // Create a new user
      Router.post('/', userController.store);

      // Update an existing user by ID
      Router.put('/{id}', userController.update);

      // Delete a user by ID
      Router.delete('/{id}', userController.destroy);
    }, prefix: 'user', middleware: [AuthenticateMiddleware()]);
  }
}
