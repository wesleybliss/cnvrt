import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cnvrt/l10n/app_localizations.dart';

class NoInternetError extends StatelessWidget {
  final VoidCallback onRetryClick;

  const NoInternetError({super.key, required this.onRetryClick});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.3,
          child: SvgPicture.asset(
            'assets/images/no-wifi-2-svgrepo-com.svg',
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.secondary, BlendMode.srcIn),
            semanticsLabel: AppLocalizations.of(context)!.noInternetMessage,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Text(
            AppLocalizations.of(context)!.noInternetMessage,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        ElevatedButton(
          onPressed: onRetryClick,
          child: Text(AppLocalizations.of(context)!.tryAgain.toUpperCase()),
        ),
      ],
    );
  }
}
