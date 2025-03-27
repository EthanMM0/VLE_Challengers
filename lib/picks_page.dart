import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PicksPage extends StatefulWidget {
  const PicksPage({super.key});

  @override
  State<PicksPage> createState() => _PicksPageState();
}

class _PicksPageState extends State<PicksPage> {
  // Hardcoded matches (Round 1) as pairs of teams.
  final List<List<String>> matches = const [
    ["Team A", "Team F"],
    ["Team B", "Team G"],
    ["Team C", "Team H"],
    ["Team D", "Team I"],
    ["Team E", "Team J"],
  ];

  // Map: match index -> selected team (one per match).
  Map<int, String> picks = {};

  // Flag to indicate that picks have been submitted.
  bool submitted = false;

  // Maximum picks allowed (one per match, so 5 total).
  final int maxPicks = 5;

  @override
  void initState() {
    super.initState();
    _loadPicksFromDevice();
  }

  // Load saved picks from SharedPreferences, if any.
  Future<void> _loadPicksFromDevice() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedPicks = prefs.getString('picks');
    if (savedPicks != null) {
      // Convert the JSON string back to Map<int, String>
      Map<String, dynamic> decoded = json.decode(savedPicks);
      setState(() {
        picks = decoded.map((key, value) => MapEntry(int.parse(key), value.toString()));
        submitted = true;
      });
    }
  }

  // Toggle the pick for a given match.
  void _togglePick(int matchIndex, String team) {
    setState(() {
      // If this match already has a selection:
      if (picks.containsKey(matchIndex)) {
        // If tapping the same team, deselect it.
        if (picks[matchIndex] == team) {
          picks.remove(matchIndex);
        }
        // If tapping the opposing team, do nothing.
      } else {
        // If total picks are less than max allowed, record this pick.
        if (picks.length < maxPicks) {
          picks[matchIndex] = team;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Maximum of 5 picks reached")),
          );
        }
      }
    });
  }

  // Lock in the picks and save to SharedPreferences.
  Future<void> _submitPicks() async {
    setState(() {
      submitted = true;
    });
    final prefs = await SharedPreferences.getInstance();
    // Save picks as a JSON string; convert keys to string because JSON keys must be strings.
    await prefs.setString('picks', json.encode(picks.map((key, value) => MapEntry(key.toString(), value))));
  }

  // Build a row for a single match (a table row with two interactive boxes).
  TableRow _buildMatchRow(int matchIndex, List<String> match) {
    String teamA = match[0];
    String teamB = match[1];
    String? selected = picks[matchIndex];

    // Each team box is a GestureDetector wrapping a Container.
    Widget buildTeamBox(String team) {
      bool isSelected = selected == team;
      // Disable tapping on this box if the match already has a different selection.
      bool isDisabled = (selected != null && selected != team);
      return GestureDetector(
        onTap: isDisabled
            ? null
            : () {
                _togglePick(matchIndex, team);
              },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.transparent,
            border: Border.all(color: Colors.grey),
          ),
          child: Text(
            team,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      );
    }

    return TableRow(
      children: [
        buildTeamBox(teamA),
        buildTeamBox(teamB),
      ],
    );
  }

  // Build the Round 1 table with header "Round 1 Picks".
  Widget _buildMatchesTable() {
    List<TableRow> rows = [];
    // Header row
    rows.add(
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
        children: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Round 1 Picks',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Round 1 Picks',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ],
      ),
    );

    // Build a row for each match.
    for (int i = 0; i < matches.length; i++) {
      rows.add(_buildMatchRow(i, matches[i]));
    }

    return Table(
      border: TableBorder.all(color: Colors.grey),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
      },
      children: rows,
    );
  }

  // Build the "My Picks" section which displays the user's selected teams.
  Widget _buildMyPicksSection() {
    List<Widget> pickBoxes = [];
    picks.forEach((_, team) {
      pickBoxes.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(51),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            team,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      );
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "My Picks:",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...pickBoxes,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Picks Page'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
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
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Display the table with matches (Round 1 pick list)
              _buildMatchesTable(),
              const SizedBox(height: 24),
              // Submit button to lock in picks and save to device
              ElevatedButton(
                onPressed: _submitPicks,
                child: const Text("Submit Picks"),
              ),
              const SizedBox(height: 24),
              // If submitted, show the My Picks section
              if (submitted) _buildMyPicksSection(),
            ],
          ),
        ),
      ),
    );
  }
}
