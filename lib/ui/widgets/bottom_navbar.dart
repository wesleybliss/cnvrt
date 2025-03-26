import 'package:cnvrt/config/application.dart';
import 'package:cnvrt/config/routing/routes.dart';
import 'package:flutter/material.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => BottomNavbarState();
}

class BottomNavbarState extends State<BottomNavbar> {
  final pageRoutes = [Routes.home, Routes.units];

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
          Application.router.navigateTo(context, pageRoutes[index]);
        });
      },
      selectedIndex: currentPageIndex,
      destinations: const [
        NavigationDestination(
          selectedIcon: Icon(Icons.attach_money),
          icon: Icon(Icons.attach_money),
          label: 'Currencies',
        ),
        NavigationDestination(icon: Badge(child: Icon(Icons.rule_rounded)), label: 'Units'),
      ],
    );
  }
}
