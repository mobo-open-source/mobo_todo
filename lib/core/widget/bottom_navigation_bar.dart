import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_todo/features/dashboard%20screen/provider/dash_board_provider.dart';
import 'package:mobo_todo/features/activity%20screen/screens/activity_screen.dart';
import 'package:mobo_todo/features/task%20screen/screens/all_task_screen.dart';
import 'package:mobo_todo/features/dashboard%20screen/screens/dashboard_screen.dart';
import 'package:mobo_todo/core/utils/color_constants.dart';
import 'package:provider/provider.dart';

class BottomNavig extends StatelessWidget {
  BottomNavig({super.key});
  List<Widget> screens = <Widget>[
    DashboardScreen(),
    TaskScreen(),
    ActivityScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Consumer<DashBoardProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: screens[provider.selectedScreen],
          bottomNavigationBar: SnakeNavigationBar.color(
            backgroundColor: isDarkTheme
                ? ColorConstants.grey900
                : ColorConstants.mainWhite,
            unselectedItemColor: isDarkTheme
                ? ColorConstants.mainGrey
                : Colors.black,
            selectedItemColor: isDarkTheme
                ? ColorConstants.mainWhite
                : ColorConstants.primaryRed,
            snakeViewColor: ColorConstants.primaryRed,
            showSelectedLabels: true,
            currentIndex: provider.selectedScreen,
            showUnselectedLabels: true,
            onTap: (value) => provider.screens(value),
            snakeShape: SnakeShape.indicator,
            height: 75,

            unselectedLabelStyle: GoogleFonts.montserrat(),
            items: [
              BottomNavigationBarItem(
                icon: HugeIcon(icon: HugeIcons.strokeRoundedDashboardSquare02),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: HugeIcon(icon: HugeIcons.strokeRoundedTask01),
                label: 'All Task',
              ),
              BottomNavigationBarItem(
                icon: HugeIcon(icon: HugeIcons.strokeRoundedActivity01),
                label: 'Activity',
              ),
            ],
          ),
        );
      },
    );
  }
}
