import 'package:cnvrt/utils/logger.dart';
import 'package:cnvrt/utils/pair.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List<String> items = ['foo', 'bar', 'biz'];

List<Pair<String, Color>> buildColorsList(context) => [
  Pair("secondary", Theme.of(context).colorScheme.secondary),
  Pair("primary", Theme.of(context).colorScheme.primary),
  Pair("onPrimary", Theme.of(context).colorScheme.onPrimary),
  Pair("onSecondary", Theme.of(context).colorScheme.onSecondary),
  Pair("error", Theme.of(context).colorScheme.error),
  Pair("onError", Theme.of(context).colorScheme.onError),
  Pair("surface", Theme.of(context).colorScheme.surface),
  Pair("onSurface", Theme.of(context).colorScheme.onSurface),

  Pair("primaryContainer", Theme.of(context).colorScheme.primaryContainer),
  Pair("onPrimaryContainer", Theme.of(context).colorScheme.onPrimaryContainer),
  Pair("primaryFixed", Theme.of(context).colorScheme.primaryFixed),
  Pair("primaryFixedDim", Theme.of(context).colorScheme.primaryFixedDim),
  Pair("onPrimaryFixed", Theme.of(context).colorScheme.onPrimaryFixed),
  Pair("onPrimaryFixedVariant", Theme.of(context).colorScheme.onPrimaryFixedVariant),
  Pair("secondaryContainer", Theme.of(context).colorScheme.secondaryContainer),
  Pair("onSecondaryContainer", Theme.of(context).colorScheme.onSecondaryContainer),
  Pair("secondaryFixed", Theme.of(context).colorScheme.secondaryFixed),
  Pair("secondaryFixedDim", Theme.of(context).colorScheme.secondaryFixedDim),
  Pair("onSecondaryFixed", Theme.of(context).colorScheme.onSecondaryFixed),
  Pair("onSecondaryFixedVariant", Theme.of(context).colorScheme.onSecondaryFixedVariant),
  Pair("tertiary", Theme.of(context).colorScheme.tertiary),
  Pair("onTertiary", Theme.of(context).colorScheme.onTertiary),
  Pair("tertiaryContainer", Theme.of(context).colorScheme.tertiaryContainer),
  Pair("onTertiaryContainer", Theme.of(context).colorScheme.onTertiaryContainer),
  Pair("tertiaryFixed", Theme.of(context).colorScheme.tertiaryFixed),
  Pair("tertiaryFixedDim", Theme.of(context).colorScheme.tertiaryFixedDim),
  Pair("onTertiaryFixed", Theme.of(context).colorScheme.onTertiaryFixed),
  Pair("onTertiaryFixedVariant", Theme.of(context).colorScheme.onTertiaryFixedVariant),
  Pair("errorContainer", Theme.of(context).colorScheme.errorContainer),
  Pair("onErrorContainer", Theme.of(context).colorScheme.onErrorContainer),
  Pair("surfaceVariant", Theme.of(context).colorScheme.surfaceContainerHighest),
  Pair("surfaceDim", Theme.of(context).colorScheme.surfaceDim),
  Pair("surfaceBright", Theme.of(context).colorScheme.surfaceBright),
  Pair("surfaceContainerLowest", Theme.of(context).colorScheme.surfaceContainerLowest),
  Pair("surfaceContainerLow", Theme.of(context).colorScheme.surfaceContainerLow),
  Pair("surfaceContainer", Theme.of(context).colorScheme.surfaceContainer),
  Pair("surfaceContainerHigh", Theme.of(context).colorScheme.surfaceContainerHigh),
  Pair("surfaceContainerHighest", Theme.of(context).colorScheme.surfaceContainerHighest),
  Pair("onSurfaceVariant", Theme.of(context).colorScheme.onSurfaceVariant),
  Pair("outline", Theme.of(context).colorScheme.outline),
  Pair("outlineVariant", Theme.of(context).colorScheme.outlineVariant),
  Pair("shadow", Theme.of(context).colorScheme.shadow),
  Pair("scrim", Theme.of(context).colorScheme.scrim),
  Pair("inverseSurface", Theme.of(context).colorScheme.inverseSurface),
  Pair("onInverseSurface", Theme.of(context).colorScheme.onInverseSurface),
  Pair("inversePrimary", Theme.of(context).colorScheme.inversePrimary),
  Pair("surfaceTint", Theme.of(context).colorScheme.surfaceTint),
  Pair("background", Theme.of(context).colorScheme.surface),
  Pair("onBackground", Theme.of(context).colorScheme.onSurface),
];

Widget buildCard(Pair<String, Color> item) => Card(
  margin: EdgeInsets.zero,
  color: item.second,
  child: SizedBox(
    width: double.infinity,
    height: 50,
    child: Center(child: Text(item.first, style: TextStyle(color: Colors.grey))),
  ),
);

class DebugThemeScreen extends ConsumerStatefulWidget {
  const DebugThemeScreen({super.key});

  @override
  ConsumerState<DebugThemeScreen> createState() => _DebugThemeScreenState();
}

class _DebugThemeScreenState extends ConsumerState<DebugThemeScreen> {
  final log = Logger('DebugThemeScreen');

  @override
  Widget build(BuildContext context) {
    final colorsList = buildColorsList(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: colorsList.length,
        itemBuilder: (context, index) => buildCard(colorsList[index]),
      ),
    );
  }
}
