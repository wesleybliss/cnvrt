import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension ContextExtensions on BuildContext {
  
  void copyToClipboard(String text, {bool showSnackBar = false}) {
    
    Clipboard.setData(ClipboardData(text: text));
    
    if (showSnackBar) {
      ScaffoldMessenger.of(this).showSnackBar(
        const SnackBar(content: Text('Copied to clipboard')),
      );
    }
    
  }
  
}
