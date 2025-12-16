import 'package:flutter/material.dart';
import 'package:talkbuddyai/screens/loginToChat/loginToChatWithList.dart';
import 'package:talkbuddyai/shared/image_widget.dart';
import '../user/user_page.dart';

class BottomBar extends StatefulWidget {
  final int selectedIndex;
  final String username;
  final String authToken;

  const BottomBar({
    Key? key,
    required this.selectedIndex,
    required this.username,
    required this.authToken,
  }) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  static List<Widget> getWidgetOptions(String username, String authToken) {
    return [
      LoginToChatWithList(
        username: username,
        authToken: authToken,
      ),
      UserInfoPage(
        username: username,
        authToken: authToken,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions =
        getWidgetOptions(widget.username, widget.authToken);

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? ImageWidget(
                    "lib/assets/images/guncelicon.png",   Colors.amber)
                : ImageWidget(
                    "lib/assets/images/guncelicon.png", Colors.black54),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? ImageWidget("lib/assets/images/profile.png",
                    Colors.amber)
                : ImageWidget(
                    "lib/assets/images/profile.png", Colors.black54),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.black54,
        onTap: _onItemTapped,
      ),
    );
  }
}
