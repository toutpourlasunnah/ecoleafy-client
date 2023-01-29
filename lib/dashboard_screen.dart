import 'package:front_end/dashboard_tab.dart';
import 'package:side_navigation/side_navigation.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
//import 'package:side_navigation_bar/side_navigation_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;
  List<Widget> views = const [
    Center(
      child: DashboardTab(),
    ),
    Center(
      child: Text('Room'),
    ),
    Center(
      child: Text('Account'),
    ),
    Center(
      child: Text('Settings'),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ecoleafy'),
        backgroundColor: Colors.blue,
      ),
      body: Row(
        children: [
          /// Pretty similar to the BottomNavigationBar!
          SideNavigationBar(
            selectedIndex: selectedIndex,
            items: const [
              SideNavigationBarItem(
                icon: Icons.dashboard,
                label: 'Dashboard',
              ),
              SideNavigationBarItem(
                icon: Icons.room,
                label: 'Room',
              ),
              SideNavigationBarItem(
                icon: Icons.account_tree,
                label: 'Account',
              ),
              SideNavigationBarItem(
                icon: Icons.settings,
                label: 'Settings',
              ),
            ],
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            theme: SideNavigationBarTheme(
              backgroundColor: Colors.blue,
              togglerTheme: SideNavigationBarTogglerTheme.standard(),
              itemTheme: SideNavigationBarItemTheme.standard(),
              dividerTheme: SideNavigationBarDividerTheme.standard(),
            ),
          ),

          /// Make it take the rest of the available width
          Expanded(
            child: views.elementAt(selectedIndex),
          )
        ],
      ),
    );
  }
}
