import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DecryptionPage extends StatefulWidget {
  @override
  _DecryptionPageState createState() => _DecryptionPageState();
}

class _DecryptionPageState extends State<DecryptionPage> {
  bool _useKey = false;
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _ciphertextController = TextEditingController();
  String _decryptedMessage = '';
  bool _isLoading = false;

  Future<void> _decryptMessage() async {
    if (_ciphertextController.text.isEmpty) {
      setState(() {
        _decryptedMessage = 'Please enter a ciphertext.';
      });
      return;
    }
    if (_useKey && _keyController.text.isEmpty) {
      setState(() {
        _decryptedMessage = 'Please enter a key or toggle off "Use Key".';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _decryptedMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse('https://encrash.onrender.com/decrypt'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'ciphertext': _ciphertextController.text,
          'key': _useKey ? _keyController.text : null,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _decryptedMessage =
              data['plaintext']?.toString() ?? 'No decrypted message received';
        });
      } else {
        setState(() {
          _decryptedMessage = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _decryptedMessage = 'Error: $e';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _keyController.dispose();
    _ciphertextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Decryption',
              style: TextStyle(fontFamily: 'Courier', fontSize: 30)),
          backgroundColor: Colors.black45),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Toggle thingy
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Use Key',
                        style: TextStyle(
                            fontFamily: 'Courier',
                            color: Colors.greenAccent,
                            fontSize: 30)),
                    Switch(
                      value: _useKey,
                      activeColor: Colors.greenAccent,
                      onChanged: (value) {
                        setState(() {
                          _useKey = value;
                          if (!value) {
                            _keyController.clear();
                          }
                        });
                      },
                    ),
                  ],
                ),
                if (_useKey)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextField(
                      controller: _keyController,
                      style: const TextStyle(
                          color: Colors.greenAccent, fontFamily: 'Courier'),
                      decoration: const InputDecoration(
                        labelText: 'Enter Key',
                        labelStyle:
                            TextStyle(fontFamily: 'Courier', fontSize: 30),
                        prefixIcon:
                            Icon(Icons.vpn_key, color: Colors.greenAccent),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextField(
                    controller: _ciphertextController,
                    style: const TextStyle(
                        color: Colors.greenAccent, fontFamily: 'Courier'),
                    decoration: const InputDecoration(
                        labelText: 'Enter Ciphertext',
                        labelStyle:
                            TextStyle(fontFamily: 'Courier', fontSize: 30)),
                  ),
                ),
                ElevatedButton.icon(
                  icon:
                      const Icon(Icons.lock_open_rounded, color: Colors.black),
                  label: const Text('Decrypt',
                      style: TextStyle(fontFamily: 'Courier', fontSize: 30)),
                  onPressed: _isLoading ? null : _decryptMessage,
                ),
                const SizedBox(height: 20),
                if (_decryptedMessage.isNotEmpty)
                  const Text(
                    'Decrypted Message:',
                    style: TextStyle(fontSize: 30),
                  ),
                Container(
                  margin: const EdgeInsets.only(top: 12.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.greenAccent),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _decryptedMessage,
                          style: const TextStyle(
                            fontFamily: 'Courier',
                            color: Colors.greenAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


//$_decryptedMessage',
                    //style: const TextStyle(
                    //    fontFamily: 'Courier',
                    //    color: Colors.greenAccent,
                    //    fontWeight: FontWeight.bold,
                     //   fontSize: 20),