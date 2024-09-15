import 'package:extendable_dropdown/extendable_dropdown.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Extendable Dropdown',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showList = false;
  List<String> stringList = [
    'Colombo',
    'Kandy',
    'Galle',
    'Jaffna',
    'Matara',
    'Trincomalee',
  ];

  List<dynamic> _selectedItems = [];

  void _handleSendListChanged(List<dynamic> sendList) {
    setState(() {
      _selectedItems = sendList;
    });
    // print('Selected items: $_selectedItems');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 246, 247),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 246, 247),
        centerTitle: true,
        title: const Text(
          'Extendable Dropdown',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 30),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            ExtendableDropdown(
              dropdownBorderRadius: 10.0,
              snackBarMargin: 10.0,
              snakBarBorderRadius: 5.0,
              paddingLeft: 16.0,
              paddingBottom: 16.0,
              paddingRight: 16.0,
              paddingTop: 16.0,
              dismissibleBackgroundColor: Colors.red,
              snackBarcolor: Colors.blue[500],
              nonSelectedIcon: Icons.radio_button_checked_rounded,
              selectedIcon: Icons.location_on_outlined,
              selectedIconColor: Colors.green,
              nonSelectedIconColor: Colors.red,
              listIcon: Icons.location_on_outlined,
              listIconColor: Colors.black87,
              list: stringList,
              dismissibleIcon: const Icon(
                Icons.delete,
                color: Colors.black45,
              ),
              onSendListChanged: _handleSendListChanged,
            ),
            const SizedBox(height: 5),
            if (_selectedItems.isNotEmpty && showList == true)
              ListView.builder(
                shrinkWrap:
                    true, // Ensure the ListView takes up only necessary space
                physics:
                    const NeverScrollableScrollPhysics(), // Prevent ListView from scrolling inside SingleChildScrollView
                itemCount: _selectedItems.length,
                itemBuilder: (context, index) {
                  return Text(
                    _selectedItems[index].toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black45, fontSize: 25),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      overlayColor: Colors.transparent,
                      shape: const RoundedRectangleBorder(),
                      splashFactory: NoSplash.splashFactory,
                      backgroundColor: Colors.transparent,
                      elevation: 0),
                  onPressed: () {
                    setState(() {
                      showList = !showList;
                    });
                  },
                  child: Text(
                    'Show List',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: MediaQuery.of(context).size.width * 0.035),
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
