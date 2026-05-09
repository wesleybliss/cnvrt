import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cnvrt/l10n/app_localizations.dart';

const defaultDuration = Duration(seconds: 3);

extension ContextExtensions on BuildContext {
  /// Quick and easy SnackBar shortcut
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(String text, {
    Color? backgroundColor,
    double? elevation,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? width,
    ShapeBorder? shape,
    HitTestBehavior? hitTestBehavior,
    SnackBarBehavior? behavior,
    SnackBarAction? action,
    double? actionOverflowThreshold,
    bool? showCloseIcon,
    Color? closeIconColor,
    Duration duration = defaultDuration,
    bool persist = false,
    Animation<double>? animation,
    VoidCallback? onVisible,
    DismissDirection? dismissDirection,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
      ),
    );
  }
  
  void copyToClipboard(String text, {bool showSnackBar = false}) {
    Clipboard.setData(ClipboardData(text: text));

    if (showSnackBar) {
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(this)!.copiedToClipboard)),
      );
    }
  }
}
