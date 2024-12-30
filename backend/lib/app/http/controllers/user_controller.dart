import 'package:vania/vania.dart';
import 'package:backend/app/models/user.dart';

class UserController extends Controller {
  // Get all users
  Future<Response> index() async {
    final users = await User().query().get();
    for (var user in users) {
      user.remove('password'); // Menghapus password dari response
    }
    return Response.json(users);
  }

  // Get a single user by ID
  Future<Response> show(int id) async {
    final user = await User().query().find(id);
    if (user == null) {
      return Response.json({"message": "User tidak ditemukan"}, 404);
    }
    user.remove('password'); // Menghapus password dari response
    return Response.json(user);
  }

  // Create a new user
  Future<Response> store(Request request) async {
    request.validate({
      'name': 'required',
      'email': 'required|email',
      'password': 'required|min_length:6|confirmed',
    }, {
      'name.required': 'Nama tidak boleh kosong',
      'email.required': 'Email tidak boleh kosong',
      'email.email': 'Email tidak valid',
      'password.required': 'Password tidak boleh kosong',
      'password.min_length': 'Password harus terdiri dari minimal 6 karakter',
      'password.confirmed': 'Konfirmasi password tidak sesuai',
    });

    final name = request.input('name');
    final email = request.input('email');
    var password = request.input('password').toString();

    var existingUser = await User().query().where('email', '=', email).first();
    if (existingUser != null) {
      return Response.json({"message": "User dengan email ini sudah ada"}, 409);
    }

    password = Hash().make(password);
    final userId = await User().query().insert({
      "name": name,
      "email": email,
      "password": password,
      "created_at": DateTime.now().toIso8601String(),
    });

    return Response.json({"message": "User berhasil ditambahkan", "id": userId}, 201);
  }

  // Update an existing user
  Future<Response> update(Request request, int id) async {
    request.validate({
      'name': 'required',
      'email': 'required|email',
    }, {
      'name.required': 'Nama tidak boleh kosong',
      'email.required': 'Email tidak boleh kosong',
      'email.email': 'Email tidak valid',
    });

    final name = request.input('name');
    final email = request.input('email');

    var user = await User().query().find(id);
    if (user == null) {
      return Response.json({"message": "User tidak ditemukan"}, 404);
    }

    await User().query().where('id', '=', id).update({
      "name": name,
      "email": email,
      "updated_at": DateTime.now().toIso8601String(),
    });

    return Response.json({"message": "User berhasil diperbarui"});
  }

  // Delete a user
  Future<Response> destroy(int id) async {
    var user = await User().query().find(id);
    if (user == null) {
      return Response.json({"message": "User tidak ditemukan"}, 404);
    }

    await User().query().where('id', '=', id).delete();
    return Response.json({"message": "User berhasil dihapus"});
  }
}

final UserController userController = UserController();
