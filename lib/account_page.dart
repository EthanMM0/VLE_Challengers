import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'val_link.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String username = '';
  String valorantUsername = '';
  String valorantTag = '';
  String valorantRank = '';

  @override
  void initState() {
    super.initState();
    _loadUserSession();
  }

  // Load the user session from SharedPreferences
  Future<void> _loadUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    String storedUsername = prefs.getString('username') ?? '';

    if (!mounted) return;
    if (storedUsername.isEmpty) {
      // Not signed in, redirect to login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      return;
    }

    setState(() {
      username = storedUsername;
      valorantUsername = prefs.getString('valorantUsername') ?? '';
      valorantTag = prefs.getString('valorantTag') ?? '';
      valorantRank = prefs.getString('valorantRank') ?? '';
    });
  }

  // Function to log out the user by clearing the SharedPreferences data
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored data

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  // Function to unlink the Valorant account
  Future<void> _unlinkValorantAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('valorantUsername');
    await prefs.remove('valorantTag');
    await prefs.remove('valorantRank');

    // After unlinking, reload the user session
    _loadUserSession();
  }

  @override
  Widget build(BuildContext context) {
    // If username is still empty, show a loading indicator (or a blank screen)
    if (username.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Page'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 20, 203, 216), // Color 1
                Color.fromARGB(255, 165, 231, 228), // Color 2
              ],
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: SweepGradient(
            center: Alignment.center,
            startAngle: 0.0,
            endAngle: 3.14,
            colors: [
              Color.fromARGB(255, 46, 44, 44),
              Color.fromARGB(255, 34, 34, 34),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Account Details:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              // Username Display
              Text(
                'Username: $username',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              // Valorant account info display based on linked status
              if (valorantUsername.isNotEmpty && valorantTag.isNotEmpty) ...[
                Text(
                  'Valorant IGN: $valorantUsername',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Tagline: $valorantTag',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Rank: $valorantRank',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
              ] else ...[
                Text(
                  'Valorant IGN: Not Linked',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Tagline: Not Linked',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Rank: Unranked',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              // Additional account details can go here...
            ],
          ),
        ),
      ),
      // Buttons at the bottom right of the screen in a Row
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (valorantUsername.isNotEmpty && valorantTag.isNotEmpty) ...[
              ElevatedButton(
                onPressed: _unlinkValorantAccount,
                child: const Text('Unlink Account'),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ValLinkPage()),
                  );

                  if (result == true) {
                    // Refresh data when returning from ValLinkPage
                    _loadUserSession();
                  }
                },
                child: const Text('Link Valorant Account'),
              ),
            ],
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _logout,
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
