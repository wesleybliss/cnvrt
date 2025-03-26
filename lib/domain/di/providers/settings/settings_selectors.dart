import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final themeProvider = Provider<AsyncValue<String>>((ref) {
  final settings = ref.watch(settingsNotifierProvider);
  return settings.whenData((value) => value.theme);
});
