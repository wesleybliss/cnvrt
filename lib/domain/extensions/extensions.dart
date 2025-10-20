import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cnvrt/l10n/app_localizations.dart';

extension ContextExtensions on BuildContext {
  
  void copyToClipboard(String text, {bool showSnackBar = false}) {
    
    Clipboard.setData(ClipboardData(text: text));
    
    if (showSnackBar) {
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(this)!.copiedToClipboard)),
      );
    }
    
  }
  
}
