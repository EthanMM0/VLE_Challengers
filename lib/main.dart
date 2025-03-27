import 'package:flutter/material.dart';
import 'account_page.dart';
import 'brackets_page.dart';
import 'picks_page.dart';

void main() {
  runApp(const RiotApp());
}

class RiotApp extends StatelessWidget {
  const RiotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VLE Challengers'),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 24),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 20, 203, 216),
                Color.fromARGB(255, 165, 231, 228),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: SweepGradient(
            colors: [
              Color.fromARGB(255, 46, 44, 44),
              Color.fromARGB(255, 34, 34, 34),
            ],
          ),
        ),
        child: Column(
          children: [
            // Top bar with IconButtons
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.account_circle),
                    iconSize: 30,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AccountPage()),
                      );
                    },
                    tooltip: 'Account',
                    color: Color.fromARGB(
                        255, 20, 203, 216), // matching teal color
                  ),
                  IconButton(
                    icon: const Icon(Icons.format_list_numbered),
                    iconSize: 30,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BracketsPage()),
                      );
                    },
                    tooltip: 'Brackets',
                    color: Color.fromARGB(
                        255, 20, 203, 216), // matching teal color
                  ),
                  IconButton(
                    icon: const Icon(Icons.check_circle),
                    iconSize: 30,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PicksPage()),
                      );
                    },
                    tooltip: 'Picks',
                    color: Color.fromARGB(
                        255, 20, 203, 216), // matching teal color
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Section with box and placeholder data
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'VLE Challengers Previous Winners',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text('Teams:', style: TextStyle(fontSize: 16)),
                    Text('Team: N/A', style: TextStyle(fontSize: 14)),
                    Text('Team: N/A', style: TextStyle(fontSize: 14)),
                    Text('Team: N/A', style: TextStyle(fontSize: 14)),
                    Text('Team: N/A', style: TextStyle(fontSize: 14)),
                    Text('Team: N/A', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// TODO: 

// - Create UI/UX Pages: Account, Brackets, Picks, Home. (complete)

// - Implement Riot Sign-In API integration to fetch and display Riot Username. (complete)

// - Fetch Valorant stats (rank, level, peak rank) and display in Account Page. (half complete)

// - Create Admin accounts for editing

// - Implement Brackets update functionality for admin.

// - Develop Picks logic (voting, notifications, points calculation based on ( 1, 2, 3, 5, 8, etc ).

// - Ensure responsive and user-friendly UI design.