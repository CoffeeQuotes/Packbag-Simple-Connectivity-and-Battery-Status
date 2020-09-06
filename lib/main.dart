import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:battery/battery.dart';

final Color richBlackFograColor = Color(0xff031927);
final Color internantionalOrangeEngineeringColor = Color(0xffBA1200);
final Color lightCornFlowerBlueColor = Color(0xff9DD1F1);
final Color blueNCSColor = Color(0xff508AA8);
final Color blueBeauColor = Color(0xffC8E0F4);

void main() {
  runApp(MaterialApp(
    title: 'Battery And Connectivity Status',
    theme: ThemeData(
      primaryColor: richBlackFograColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: HomePage(
      title: "Dashboard",
    ),
  ));
}

class HomePage extends StatefulWidget {
  HomePage({this.title});

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //
  String _connectionStatus = 'Unknown';
  IconData _connectionIcon;
  String _batteryStatus = 'Unknown';
  IconData _batteryIcon;
  Color _connectionColor = Colors.deepOrange;
  Color _batteryColor = Colors.deepOrange;

  // Streams
  StreamSubscription<ConnectivityResult> _connSub;
  StreamSubscription<BatteryState> _battSub;

  @override
  void initState() {
    super.initState();

    _connSub = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult res) async {
      setState(() {
        switch (res) {
          case ConnectivityResult.mobile:
            _connectionStatus = 'Mobile Data';
            _connectionIcon = Icons.sim_card;
            _connectionColor = Colors.red;
            break;

          case ConnectivityResult.wifi:
            _connectionStatus = 'Wi-Fi';
            _connectionIcon = Icons.wifi;
            _connectionColor = Colors.blue;
            break;

          case ConnectivityResult.none:
            _connectionStatus = 'No Connection';
            _connectionIcon = Icons.not_interested;
            _connectionColor = Colors.black;
            break;
        }
      });
    });

    _battSub = Battery().onBatteryStateChanged.listen((BatteryState res) async {
      setState(() {
        switch (res) {
          case BatteryState.charging:
            _batteryStatus = 'Charging';
            _batteryIcon = Icons.battery_charging_full;
            _batteryColor = Colors.blueAccent;
            break;
          case BatteryState.full:
            _batteryStatus = 'Full';
            _batteryIcon = Icons.battery_full;
            _batteryColor = Colors.green;
            break;
          case BatteryState.discharging:
            _batteryStatus = 'In Use';
            _batteryIcon = Icons.battery_alert;
            _batteryColor = Colors.redAccent;
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _connSub.cancel();
    _battSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: internantionalOrangeEngineeringColor,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Icon(
                _connectionIcon,
                color: _connectionColor,
                size: 50.0,
              ),
              Text(
                "Connection:\n$_connectionStatus",
                style: TextStyle(
                  color: _connectionColor,
                  fontSize: 40.0,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                _batteryIcon,
                color: _batteryColor,
                size: 50.0,
              ),
              Text(
                "Battery:\n$_batteryStatus",
                style: TextStyle(
                  color: _batteryColor,
                  fontSize: 40.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
