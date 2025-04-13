import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EncryptionPage extends StatefulWidget {
  @override
  _EncryptionPageState createState() => _EncryptionPageState();
}

class _EncryptionPageState extends State<EncryptionPage> {
  bool _useKey = false;
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _encryptedMessage = '';
  bool _isLoading = false;

  Future<void> _encryptMessage() async {
    if (_messageController.text.isEmpty) {
      setState(() {
        _encryptedMessage = 'please write your message';
      });
      return;
    }
    if (_useKey && _keyController.text.isEmpty) {
      setState(() {
        _encryptedMessage = 'Please enter a key or toggle off "Use Key".';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _encryptedMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse('https://encrash.onrender.com/encrypt'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'plaintext': _messageController.text,
          'key': _useKey ? _keyController.text : null,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _encryptedMessage =
              data['ciphertext']?.toString() ?? 'No encrypted message received';
        });
      } else {
        setState(() {
          _encryptedMessage = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _encryptedMessage = 'Error: $e';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Copied to clipboard!",
          style: TextStyle(fontFamily: 'Courier'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _keyController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encryption',
            style: TextStyle(fontFamily: 'Courier', fontSize: 30)),
        backgroundColor: Colors.black45,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                // Toggle key part.
                Center(
                  child: Row(
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
                    controller: _messageController,
                    style: const TextStyle(
                        color: Colors.greenAccent, fontFamily: 'Courier'),
                    decoration: const InputDecoration(
                        labelText: 'Enter Message',
                        labelStyle:
                            TextStyle(fontFamily: 'Courier', fontSize: 30)),
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.lock,
                    color: Colors.black,
                  ),
                  label: const Text('Encrypt',
                      style: TextStyle(fontFamily: 'Courier', fontSize: 30)),
                  onPressed: _isLoading ? null : _encryptMessage,
                ),
                const SizedBox(height: 20),
                if (_encryptedMessage.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Encrypted Message:',
                        style: TextStyle(
                            fontFamily: 'Courier',
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
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
                                _encryptedMessage,
                                style: const TextStyle(
                                  fontFamily: 'Courier',
                                  color: Colors.greenAccent,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy,
                                  color: Colors.greenAccent),
                              onPressed: () =>
                                  _copyToClipboard(_encryptedMessage),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
