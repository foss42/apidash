import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class OAuthHeaderConfigWidget extends StatefulWidget {
  final Map<String, String>? initialHeaders;
  final Function(Map<String, String>) onHeadersUpdated;

  const OAuthHeaderConfigWidget({
    Key? key,
    this.initialHeaders,
    required this.onHeadersUpdated,
  }) : super(key: key);

  @override
  State<OAuthHeaderConfigWidget> createState() => _OAuthHeaderConfigWidgetState();
}

class _OAuthHeaderConfigWidgetState extends State<OAuthHeaderConfigWidget> {
  final _clientIdController = TextEditingController();
  final _clientSecretController = TextEditingController();
  final _authUrlController = TextEditingController();
  final _tokenUrlController = TextEditingController();
  final _scopeController = TextEditingController();
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    print('[OAuth] Initializing OAuthHeaderConfigWidget');
    if (widget.initialHeaders != null &&
        widget.initialHeaders!.containsKey('Authorization')) {
      _accessToken = widget.initialHeaders!['Authorization'];
      print('[OAuth] Loaded initial access token: $_accessToken');
    }
  }

  Future<void> _handleOAuthFlow() async {
    try {
      print('\n[OAuth] Starting OAuth flow...');
      
      // Basic validation
      print('[OAuth] Validating input fields...');
      print('[OAuth] Client ID: ${_clientIdController.text.isNotEmpty ? 'Present' : 'Missing'}');
      print('[OAuth] Client Secret: ${_clientSecretController.text.isNotEmpty ? 'Present' : 'Missing'}');
      print('[OAuth] Auth URL: ${_authUrlController.text}');
      print('[OAuth] Token URL: ${_tokenUrlController.text}');
      print('[OAuth] Scope: ${_scopeController.text}');

      if (_clientIdController.text.isEmpty ||
          _clientSecretController.text.isEmpty ||
          _authUrlController.text.isEmpty ||
          _tokenUrlController.text.isEmpty) {
        print('[OAuth] Validation failed: Missing required fields');
        throw Exception('Please fill in all required fields');
      }

      // Step 1: Launch authorization URL
      print('\n[OAuth] Step 1: Building authorization URL');
      final authUrl = Uri.parse(_authUrlController.text).replace(queryParameters: {
        'client_id': _clientIdController.text,
        'response_type': 'code',
        'scope': _scopeController.text,
        'redirect_uri': 'http://localhost:8080/callback',
      });
      
      print('[OAuth] Authorization URL: $authUrl');

      print('[OAuth] Launching authorization URL in browser...');
      if (!await launchUrl(authUrl, mode: LaunchMode.externalApplication)) {
        print('[OAuth] Failed to launch URL: $authUrl');
        throw Exception('Could not launch authorization URL');
      }
      print('[OAuth] Successfully launched auth URL');

      // Step 2: Get authorization code from user
      print('\n[OAuth] Step 2: Waiting for authorization code input...');
      final codeController = TextEditingController();
      final code = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Enter Authorization Code'),
          content: TextField(
            controller: codeController,
            decoration: const InputDecoration(
              hintText: 'Paste the authorization code here',
            ),
            autofocus: true,
            onSubmitted: (value) {
              print('[OAuth] Code submitted via keyboard: ${value.length} characters');
              Navigator.of(context).pop(value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                print('[OAuth] Authorization cancelled by user');
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                print('[OAuth] Code submitted via button: ${codeController.text.length} characters');
                Navigator.of(context).pop(codeController.text);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      );

      if (code == null || code.isEmpty) {
        print('[OAuth] No authorization code provided');
        throw Exception('Authorization code is required');
      }
      print('[OAuth] Received authorization code: ${code.length} characters');

      // Step 3: Exchange code for token
      print('\n[OAuth] Step 3: Exchanging code for token...');
      print('[OAuth] Token endpoint URL: ${_tokenUrlController.text}');
      
      final tokenRequestBody = {
        'grant_type': 'authorization_code',
        'client_id': _clientIdController.text,
        'client_secret': _clientSecretController.text,
        'code': code,
        'redirect_uri': 'http://localhost:8080/callback',
      };
      print('[OAuth] Token request body: $tokenRequestBody');

      print('[OAuth] Sending token request...');
      final tokenResponse = await http.post(
        Uri.parse(_tokenUrlController.text),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: tokenRequestBody,
      );

      print('[OAuth] Token response status code: ${tokenResponse.statusCode}');
      print('[OAuth] Token response headers: ${tokenResponse.headers}');
      print('[OAuth] Token response body: ${tokenResponse.body}');

      if (tokenResponse.statusCode != 200) {
        print('[OAuth] Token request failed');
        throw Exception('Failed to get access token: ${tokenResponse.body}');
      }

      print('[OAuth] Parsing token response...');
      final tokenData = json.decode(tokenResponse.body);
      print('[OAuth] Decoded token data: $tokenData');
      
      final accessToken = tokenData['access_token'];
      if (accessToken == null) {
        print('[OAuth] No access_token found in response data');
        throw Exception('No access token in response');
      }
      print('[OAuth] Successfully extracted access token');

      setState(() {
        _accessToken = 'Bearer $accessToken';
        print('[OAuth] Updated access token state: $_accessToken');
      });

      // Update headers
      widget.onHeadersUpdated({
        'Authorization': 'Bearer $accessToken',
      });
      print('[OAuth] Updated headers with new access token');
      print('[OAuth] OAuth flow completed successfully\n');

    } catch (e, stackTrace) {
      print('\n[OAuth] Error occurred during OAuth flow:');
      print('[OAuth] Error message: $e');
      print('[OAuth] Stack trace:\n$stackTrace');
      
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('OAuth Error'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Error: $e'),
                const SizedBox(height: 8),
                const Text('Stack Trace:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(stackTrace.toString(), style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('[OAuth] Building OAuth configuration widget');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _clientIdController,
          decoration: const InputDecoration(
            labelText: 'Client ID',
            hintText: 'Enter your OAuth client ID',
          ),
        ),
        TextField(
          controller: _clientSecretController,
          decoration: const InputDecoration(
            labelText: 'Client Secret',
            hintText: 'Enter your OAuth client secret',
          ),
          obscureText: true,
        ),
        TextField(
          controller: _authUrlController,
          decoration: const InputDecoration(
            labelText: 'Authorization URL',
            hintText: 'Enter the OAuth authorization URL',
          ),
        ),
        TextField(
          controller: _tokenUrlController,
          decoration: const InputDecoration(
            labelText: 'Token URL',
            hintText: 'Enter the OAuth token URL',
          ),
        ),
        TextField(
          controller: _scopeController,
          decoration: const InputDecoration(
            labelText: 'Scope (Optional)',
            hintText: 'Enter space-separated OAuth scopes',
          ),
        ),
        const SizedBox(height: 16),
        if (_accessToken != null) ...[
          Text('Current Access Token: $_accessToken'),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _handleOAuthFlow,
            icon: const Icon(Icons.refresh),
            label: const Text('Get New Token'),
          ),
        ] else
          ElevatedButton(
            onPressed: _handleOAuthFlow,
            child: const Text('Authenticate with OAuth'),
          ),
      ],
    );
  }

  @override
  void dispose() {
    print('[OAuth] Disposing OAuth configuration widget');
    _clientIdController.dispose();
    _clientSecretController.dispose();
    _authUrlController.dispose();
    _tokenUrlController.dispose();
    _scopeController.dispose();
    super.dispose();
  }
}