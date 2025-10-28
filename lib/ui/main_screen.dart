import 'package:cnvrt/config/application.dart';
import 'package:cnvrt/config/routing/routes.dart';
import 'package:cnvrt/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late final PageController _pageController;
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [GlobalKey<NavigatorState>(), GlobalKey<NavigatorState>()];

  List<String> get _tabRoutes => [Routes.home, Routes.units];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    // If we're switching to a different tab, reset the previous tab's Navigator stack
    if (_selectedIndex != index) {
      final previousNavigator = _navigatorKeys[_selectedIndex].currentState;
      if (previousNavigator != null) {
        // Pop all routes until we're back to the root of the previous tab
        previousNavigator.popUntil((route) => route.isFirst);
      }
    }
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    // If we're switching to a different tab, reset the previous tab's Navigator stack
    if (_selectedIndex != index) {
      final previousNavigator = _navigatorKeys[_selectedIndex].currentState;
      if (previousNavigator != null) {
        // Pop all routes until we're back to the root of the previous tab
        previousNavigator.popUntil((route) => route.isFirst);
      }
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildNavigator(int index) {
    return _KeepAlivePage(
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: Application.router.generator,
        initialRoute: _tabRoutes[index],
      ),
    );
  }

  Future<bool> _handlePop() async {
    final currentNavigator = _navigatorKeys[_selectedIndex].currentState;
    if (currentNavigator != null && currentNavigator.canPop()) {
      currentNavigator.pop();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _handlePop();
        if (shouldPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: [
            _buildNavigator(0),
            _buildNavigator(1),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.attach_money),
              selectedIcon: Icon(Icons.attach_money, color: Theme.of(context).colorScheme.inversePrimary),
              label: AppLocalizations.of(context)!.currency,
            ),
            NavigationDestination(
              icon: Icon(Icons.straighten),
              selectedIcon: Icon(Icons.straighten, color: Theme.of(context).colorScheme.inversePrimary),
              label: AppLocalizations.of(context)!.units,
            ),
          ],
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          indicatorColor: Colors.transparent,
          height: 70,
        ),
      ),
    );
  }
}

// Helper widget to keep pages alive in PageView
class _KeepAlivePage extends StatefulWidget {
  const _KeepAlivePage({required this.child});

  final Widget child;

  @override
  State<_KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<_KeepAlivePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
