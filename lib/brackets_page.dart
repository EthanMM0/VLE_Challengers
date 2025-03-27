import 'package:flutter/material.dart';

class BracketsPage extends StatelessWidget {
  const BracketsPage({super.key});

  // Define your team lists for the table.
  final List<String> leftTeams = const [
    "Team A",
    "Team B",
    "Team C",
    "Team D",
    "Team E"
  ];
  final List<String> rightTeams = const [
    "Team F",
    "Team G",
    "Team H",
    "Team I",
    "Team J"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brackets Page'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Color.fromARGB(255, 20, 203, 216),
                Color.fromARGB(255, 165, 231, 228),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
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
            children: [
              // ---------------- Teams List Table ----------------
              Table(
                border: TableBorder.all(color: Colors.grey),
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                },
                children: [
                  // Header Row with gradient background and "Teams List" header in both columns.
                  TableRow(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: const [
                          Color.fromARGB(255, 20, 203, 216),
                          Color.fromARGB(255, 165, 231, 228),
                        ],
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Teams List',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Teams List',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  // Build rows for each team.
                  for (int i = 0; i < leftTeams.length; i++)
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            leftTeams[i],
                            textAlign: TextAlign.center,
                            style:
                                const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            rightTeams[i],
                            textAlign: TextAlign.center,
                            style:
                                const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 32),

              // ---------------- Bracket Rounds ----------------
              // Round 1
              _buildRoundHeader("Round 1"),
              _buildMatchBox("Team A", "Team F"),
              const SizedBox(height: 12),
              _buildMatchBox("Team B", "Team G"),
              const SizedBox(height: 12),
              _buildMatchBox("Team C", "Team H"),
              const SizedBox(height: 32),

              // Round 2
              _buildRoundHeader("Round 2"),
              _buildMatchBox("Team A", "Team G"),
              const SizedBox(height: 12),
              _buildMatchBox("Team C", "Team I"),
              const SizedBox(height: 32),

              // Round 3
              _buildRoundHeader("Round 3"),
              _buildMatchBox("Team E", "Team I"),
              const SizedBox(height: 32),

              // Round 4 (Finals)
              _buildRoundHeader("Round 4 (Finals)"),
              _buildMatchBox("Team E", "Team G"),
              const SizedBox(height: 32),

              // Winners Section
              const Text(
                "Winners:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "1st: Team E\n2nd: Team G\n3rd: Team A",
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// A reusable header for each round.
  Widget _buildRoundHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  /// A reusable widget that displays a single match in a box.
  Widget _buildMatchBox(String teamA, String teamB) {
    return Center(
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(51), // ~20% opacity
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              teamA,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 16.0),
            const Text(
              "vs",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 16.0),
            Text(
              teamB,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
