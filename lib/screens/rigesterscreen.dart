
import 'package:flutter/material.dart';
import '../Request_Models/localstoragehelper.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegistrationScreen> {

  // Controllers (optional but good practice)
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void _submitRegistration() async {
    //  Dummy API response (abhi backend nahi hai)
    await LocalStorage.setString("status", "PENDING");
    await LocalStorage.setString(
      "message",
      "You are registered. Please wait for admin approval",
    );

    //  User ko HomeScreen par wapas bhejo
    Navigator.pop(context);

    //  Small success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Registration successful. Waiting for approval."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration Form')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [

            // Name
            const Text('Name'),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Mobile
            const Text('Mobile No'),
            const SizedBox(height: 8),
            TextField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Email
            const Text('Email'),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            // SIGN UP BUTTON
            ElevatedButton(
              onPressed: _submitRegistration,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('SignUp'),
            ),
          ],
        ),
      ),
    );
  }
}