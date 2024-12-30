import 'package:flutter/material.dart';
import 'package:iyann_app/services/api_service.dart';

class UserDetailScreen extends StatefulWidget {
  final String? userId;

  UserDetailScreen({Key? key, this.userId}) : super(key: key);

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _fetchUserDetails() async {
    if (widget.userId == null) return;
    try {
      final user = await ApiService.getUserById(widget.userId!);
      _nameController.text = user['name'];
      _emailController.text = user['email'];
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      if (widget.userId == null) {
        await ApiService.createUser({
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        });
      } else {
        await ApiService.updateUser(widget.userId!, {
          'name': _nameController.text,
          'email': _emailController.text,
        });
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.userId == null ? 'Add User' : 'Edit User')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Name is required' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Email is required' : null,
              ),
              if (widget.userId == null)
                SizedBox(height: 16),
              if (widget.userId == null)
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Password is required' : null,
                ),
              SizedBox(height: 24),
              if (_isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _saveUser,
                  child: Text('Save'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}