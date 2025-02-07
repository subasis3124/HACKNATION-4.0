import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vehicle Health Monitor',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.grey[900],
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    HomeContent(),
    RepairCenters(),
    BestServiceCenters(),
    SparePartShops(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showCheckupPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Last Vehicle Check-up Status'),
          content: Text('The last check-up was performed 2 weeks ago. Vehicle is in good condition.'),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Health Monitor'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Repair Centers'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Best Service'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Spare Parts'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCheckupPopup(context),
        tooltip: 'Check-up Status',
        child: Icon(Icons.info),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _status = "Checking...";
  double _value = 60.0;
  String _title = "Speed";
  Color _meterColor = Colors.blue;

  double speed = 60.0;
  double rpm = 3000.0;
  double heatLevel = 90.0;

  @override
  void initState() {
    super.initState();
    _updateStatus();
  }

  void _updateStatus() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _status = "Vehicle is in good condition!";
      });
    });
  }

  void _changeMeter(String metric) {
    setState(() {
      if (metric == 'Speed') {
        _value = speed;
        _title = "Speed";
        _meterColor = Colors.blue;
      } else if (metric == 'RPM') {
        _value = rpm;
        _title = "RPM";
        _meterColor = Colors.green;
      } else if (metric == 'Heat') {
        _value = heatLevel;
        _title = "Heat Level";
        _meterColor = Colors.red;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    _status,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  SemiCircleGauge(
                    value: _value,
                    minValue: 0,
                    maxValue: _title == "Speed" ? 200 : (_title == "RPM" ? 6000 : 120),
                    size: 250,
                    title: _title,
                    meterColor: _meterColor,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _changeMeter('Speed'),
                        child: Text('Speed'),
                      ),
                      ElevatedButton(
                        onPressed: () => _changeMeter('RPM'),
                        child: Text('RPM'),
                      ),
                      ElevatedButton(
                        onPressed: () => _changeMeter('Heat'),
                        child: Text('Heat'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SemiCircleGauge extends StatelessWidget {
  final double value;
  final double minValue;
  final double maxValue;
  final double size;
  final String title;
  final Color meterColor;

  SemiCircleGauge({
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.size,
    required this.title,
    required this.meterColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 10),
        CustomPaint(
          size: Size(size, size / 2),
          painter: SemiCirclePainter(
            value: value,
            minValue: minValue,
            maxValue: maxValue,
            meterColor: meterColor,
          ),
        ),
      ],
    );
  }
}

class SemiCirclePainter extends CustomPainter {
  final double value;
  final double minValue;
  final double maxValue;
  final Color meterColor;

  SemiCirclePainter({
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.meterColor,
  });

