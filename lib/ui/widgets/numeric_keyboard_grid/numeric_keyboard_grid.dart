import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cnvrt/domain/di/providers/state/currencies_provider.dart';
import 'package:cnvrt/domain/di/providers/state/currency_input_mode_provider.dart';
import 'package:cnvrt/domain/di/providers/state/currency_values_provider.dart';
import 'package:cnvrt/ui/widgets/numeric_keyboard_grid/numeric_keyboard_grid_button.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:cnvrt/utils/utils.dart';

class NumericKeyboardGrid extends ConsumerStatefulWidget {
  const NumericKeyboardGrid({super.key});

  @override
  ConsumerState<NumericKeyboardGrid> createState() => _NumericKeyboardGridState();
}

class _NumericKeyboardGridState extends ConsumerState<NumericKeyboardGrid> {
  final log = Logger('NumericKeyboardGrid');
  
  @override
  Widget build(BuildContext context) {
    int buttonLabelIndex = 1;
    final focusedCurrencyInputSymbol = ref.watch(focusedCurrencyInputSymbolProvider);
    
    // Get the bottom padding to account for safe area
    final bottomPadding = MediaQuery
        .of(context)
        .padding
        .bottom;
    
    int nextButtonIndex() {
      if (buttonLabelIndex == 10) buttonLabelIndex = 0;
      return buttonLabelIndex++;
    }

    void updateInput(String value) {
      if (focusedCurrencyInputSymbol == null) return;
      ref.read(currencyValuesProvider.notifier).setValue(focusedCurrencyInputSymbol, value);
    }
    
    void setInputMode(CurrencyInputModes mode) {
      ref.read(currencyInputModeProvider.notifier).setMode(mode);
    }
    
    void onBackspaceLongPressed() {
      if (focusedCurrencyInputSymbol == null) return;
      ref.read(currencyValuesProvider.notifier).setValue(focusedCurrencyInputSymbol, '');
    }
    
    Widget numericButtonFor(String label, VoidCallback onPressed, [VoidCallback? onLongPress]) => NumericKeyboardGridButton(
      label: label,
      onPressed: onPressed,
      onLongPress: onLongPress,
    );

    final indexToButtonMap = {
      3: numericButtonFor('+', () => setInputMode(CurrencyInputModes.addition)),
      7: numericButtonFor('-', () => setInputMode(CurrencyInputModes.subtraction)),
      11: numericButtonFor('*', () => setInputMode(CurrencyInputModes.multiplication)),
      12: numericButtonFor(',', () => setInputMode(CurrencyInputModes.decimal)),
      14: numericButtonFor('/', () => setInputMode(CurrencyInputModes.normal)),
      15: numericButtonFor('/', () => setInputMode(CurrencyInputModes.division), onBackspaceLongPressed),
    };
    
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 16,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // 4 columns
              crossAxisSpacing: 8.0, // Spacing between columns
              mainAxisSpacing: 8.0, // Spacing between rows
              childAspectRatio: 2.0, // Width is 2x the height
            ),
            itemBuilder: (context, index) {
              
              if (indexToButtonMap.containsKey(index)) {
                return indexToButtonMap[index]!;
              } else {
                final buttonIndex = nextButtonIndex();
                return NumericKeyboardGridButton(
                  label: '$buttonIndex',
                  onPressed: () {
                    updateInput(buttonIndex.toString());
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
