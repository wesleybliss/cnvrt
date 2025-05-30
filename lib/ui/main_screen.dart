import 'package:cnvrt/config/application.dart';
import 'package:cnvrt/config/routing/routes.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [GlobalKey<NavigatorState>(), GlobalKey<NavigatorState>()];
  DateTime? _lastBackPressTime;

  List<String> get _tabRoutes => [Routes.home, Routes.units];

  void _onItemTapped(int index) {
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

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _selectedIndex != index,
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

    final now = DateTime.now();
    if (_lastBackPressTime == null || now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Press back again to exit')));
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
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: Stack(children: [_buildOffstageNavigator(0), _buildOffstageNavigator(1)]),
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.attach_money),
              selectedIcon: Icon(Icons.attach_money, color: Theme.of(context).colorScheme.inversePrimary),
              label: 'Currency',
            ),
            NavigationDestination(
              icon: Icon(Icons.straighten),
              selectedIcon: Icon(Icons.straighten, color: Theme.of(context).colorScheme.inversePrimary),
              label: 'Units',
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
