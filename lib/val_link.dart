// val_link.dart

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'account_page.dart'; // Ensure AccountPage is imported

class ValLinkPage extends StatefulWidget {
  const ValLinkPage({super.key});

  @override
  State<ValLinkPage> createState() => _ValLinkPageState();
}

class _ValLinkPageState extends State<ValLinkPage> {
  final TextEditingController _valorantUsernameController =
      TextEditingController();
  final TextEditingController _valorantTagController = TextEditingController();
  bool isLoading = false;

  final Logger logger = Logger();

  Future<void> _linkValorantAccount() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? '';

    logger.d("Valorant Username: ${_valorantUsernameController.text}");
    logger.d("Tagline: ${_valorantTagController.text}");

    if (_valorantUsernameController.text.isEmpty ||
        _valorantTagController.text.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter both Valorant Username and Tagline')),
      );
      setState(() => isLoading = false);
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
          'http://10.0.2.2:5000/link-valorant?username=$username&valorantUsername=${Uri.encodeComponent(_valorantUsernameController.text)}&tagline=${Uri.encodeComponent(_valorantTagController.text)}',
        ),
      );

      if (!mounted) return;

      logger.d("Response Status: ${response.statusCode}");
      logger.d("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'valorantUsername', data['valorantUsername'] ?? '');
        await prefs.setString('valorantTag', data['valorantTag'] ?? '');
        await prefs.setString('valorantRank', data['valorantRank'] ?? '');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AccountPage()),
        );
      } else {
        final errorData = json.decode(response.body);
        if (errorData['error'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Failed to link Valorant account: ${errorData['error']}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to link Valorant account')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        logger.e("Error linking Valorant account: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('An error occurred while linking your account')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Link Valorant Account')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _valorantUsernameController,
                    decoration:
                        const InputDecoration(labelText: 'Valorant Username'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _valorantTagController,
                    decoration: const InputDecoration(labelText: 'Tagline'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (mounted) {
                        _linkValorantAccount();
                      }
                    },
                    child: const Text('Link Account'),
                  ),
                ],
              ),
            ),
    );
  }
}
