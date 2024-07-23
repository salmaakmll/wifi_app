import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WiFi Info App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WiFiInfoPage(),
    );
  }
}

class WiFiInfoPage extends StatefulWidget {
  const WiFiInfoPage({super.key});

  @override
  _WiFiInfoPageState createState() => _WiFiInfoPageState();
}

class _WiFiInfoPageState extends State<WiFiInfoPage> {
  String? _publicIP;
  String? _wifiSSID;
  String? _wifiBSSID;
  String? _wifiIP;
  String? _wifiSignalStrength;

  @override
  void initState() {
    super.initState();
    _getPublicIP();
  }

  Future<void> _getPublicIP() async {
    final url = Uri.parse('https://api.ipify.org?format=json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _publicIP = data['ip'];
      });
    } else {
      setState(() {
        _publicIP = 'Failed to get public IP';
      });
    }
  }

  void _showWiFiInfo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('WiFi Info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Public IP: $_publicIP'),
              const SizedBox(height: 10),
              Text('WiFi SSID: $_wifiSSID'),
              Text('WiFi BSSID: $_wifiBSSID'),
              Text('WiFi IP: $_wifiIP'),
              Text('WiFi Signal Strength: $_wifiSignalStrength'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
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
        title: const Text('WiFi Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Public IP: $_publicIP'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showWiFiInfo,
              child: const Text('Get Wi-Fi Info'),
            ),
          ],
        ),
      ),
    );
  }
}