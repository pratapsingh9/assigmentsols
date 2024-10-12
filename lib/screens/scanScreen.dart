import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<ScanResult> scanResults = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    if (statuses[Permission.bluetoothScan]?.isGranted == true &&
        statuses[Permission.location]?.isGranted == true) {
      startScan();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permissions denied. Please grant permissions to scan for devices.')),
      );
    }
  }

  void startScan() {
    setState(() {
      scanResults.clear();
      isScanning = true;
    });

    FlutterBluePlus.startScan(timeout: Duration(seconds: 4));

    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        scanResults = results;
      });
    });

    Timer(Duration(seconds: 4), () {
      stopScan();
    });
  }

  void stopScan() {
    FlutterBluePlus.stopScan();
    setState(() {
      isScanning = false;
    });
  }

  Widget _buildBeaconTile(ScanResult result) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.bluetooth, color: Colors.blue),
        ),
        title: Text(
          result.device.name.isNotEmpty ? result.device.name : 'Unknown Device',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text('MAC: ${result.device.id}', style: TextStyle(color: Colors.grey.shade600)),
            SizedBox(height: 4),
            Text('Signal Strength: ${result.rssi} dBm', style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Bluetooth Devices', style: TextStyle(color: Colors.black87)),
        actions: [
          IconButton(
            icon: Icon(isScanning ? Icons.stop : Icons.refresh, color: Colors.blue),
            onPressed: isScanning ? stopScan : startScan,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Icon(isScanning ? Icons.radar : Icons.bluetooth_disabled, color: Colors.blue, size: 24),
                SizedBox(width: 12),
                Text(
                  isScanning ? 'Scanning for devices...' : 'Tap refresh to scan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                ),
              ],
            ),
          ),
          Expanded(
            child: scanResults.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bluetooth_searching, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No devices found', style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: scanResults.length,
                    itemBuilder: (context, index) {
                      return _buildBeaconTile(scanResults[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}