import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utilities/validators.dart';
import '../../bloc/auth/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isSignup = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSignup ? 'Create Account' : 'Welcome Back'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AuthAuthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Welcome, ${state.userName}!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App Logo/Title
                Container(
                  margin: EdgeInsets.only(bottom: 32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.restaurant,
                        size: 80,
                        color: Colors.red,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Demato',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        _isSignup ? 'Create your account' : 'Sign in to continue',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // Name Field (Signup only)
                if (_isSignup) ...[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: Validators.validateName,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 16),
                ],

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: Validators.validateEmail,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 16),

                // Phone Field (Signup only)
                if (_isSignup) ...[
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: Validators.validatePhone,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 16),
                ],

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: Validators.validatePassword,
                  textInputAction: _isSignup ? TextInputAction.next : TextInputAction.done,
                  onFieldSubmitted: _isSignup ? null : (value) => _handleSubmit(),
                ),
                SizedBox(height: 16),

                // Confirm Password Field (Signup only)
                if (_isSignup) ...[
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) => Validators.validateConfirmPassword(
                      _passwordController.text,
                      value,
                    ),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) => _handleSubmit(),
                  ),
                  SizedBox(height: 24),
                ],

                SizedBox(height: _isSignup ? 8 : 24),

                // Submit Button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is AuthLoading ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state is AuthLoading
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(_isSignup ? 'Creating Account...' : 'Signing In...'),
                        ],
                      )
                          : Text(
                        _isSignup ? 'Create Account' : 'Sign In',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),

                SizedBox(height: 16),

                // Switch between Login/Signup
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isSignup = !_isSignup;
                    });
                    _clearForm();
                  },
                  child: Text.rich(
                    TextSpan(
                      text: _isSignup
                          ? 'Already have an account? '
                          : 'Don\'t have an account? ',
                      style: TextStyle(color: Colors.grey[600]),
                      children: [
                        TextSpan(
                          text: _isSignup ? 'Sign In' : 'Sign Up',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_isSignup) {
        context.read<AuthBloc>().add(
          SignupRequested(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            phone: _phoneController.text.trim(),
          ),
        );
      } else {
        context.read<AuthBloc>().add(
          LoginRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
      }
    }
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _phoneController.clear();
    _confirmPasswordController.clear();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
