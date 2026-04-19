import 'package:extendable_dropdown/extendable_dropdown.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Extendable Dropdown',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal,
        ),
        useMaterial3: true,
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Colors.teal,
          contentTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      home: const HomePage(),
    );
  }
}

/// A simple data model for demonstration.
class Location {
  final String name;
  final String country;

  const Location(this.name, this.country);

  @override
  String toString() => '$name, $country';
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showList = false;

  final List<Location> locations = const [
    Location('Colombo', 'Sri Lanka'),
    Location('Kandy', 'Sri Lanka'),
    Location('Galle', 'Sri Lanka'),
    Location('London', 'UK'),
    Location('Tokyo', 'Japan'),
    Location('Paris', 'France'),
  ];

  List<Location> _selectedLocations = [];

  void _handleLocationsChanged(List<Location> selected) {
    setState(() {
      _selectedLocations = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 246, 247),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Extendable Dropdown',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                      child: Text(
                        'Select Destinations',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    ExtendableDropdown<Location>(
                      list: locations,
                      onSendListChanged: _handleLocationsChanged,
                      labelBuilder: (location) => location.name,
                      selectedIcon: Icons.check_circle,
                      selectedIconColor: theme.primaryColor,
                      nonSelectedIcon: Icons.circle_outlined,
                      nonSelectedIconColor: Colors.grey,
                      listIcon: Icons.location_on,
                      listIconColor: theme.primaryColor,
                      dropdownBorderRadius: 12.0,
                      // Custom Add Button
                      addButton: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: theme.primaryColor),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_location_alt,
                                color: theme.primaryColor),
                            const SizedBox(width: 8),
                            Text(
                              'Add Destination',
                              style: TextStyle(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      // Custom Message Display
                      onMessage: (context, message) {
                        debugPrint('Custom Message: $message');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Alert: $message'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_selectedLocations.isNotEmpty) ...[
              const Text(
                'Your Selections:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _selectedLocations
                    .map((loc) => Chip(
                          label: Text(loc.name),
                          backgroundColor: theme.primaryColor.withOpacity(0.1),
                          side: BorderSide.none,
                          avatar: const Icon(Icons.location_on, size: 16),
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    final names = _selectedLocations.map((e) => e.name).join(', ');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Selected: ${names.isEmpty ? 'None' : names}')),
                    );
                  },
                  child: const Text(
                    'Confirm Selection',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
