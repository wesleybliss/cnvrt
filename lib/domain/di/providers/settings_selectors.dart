import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cnvrt/domain/di/providers/settings_provider.dart';

final themeProvider = Provider<AsyncValue<String>>((ref) {
  final settings = ref.watch(settingsNotifierProvider);
  return settings.whenData((value) => value.theme);
});
