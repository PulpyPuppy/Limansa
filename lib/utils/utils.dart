import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl(String urlStr) async {
  final Uri url = Uri.parse(urlStr);
  
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Couldn\'t open url');
  }
}

