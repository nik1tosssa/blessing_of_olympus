import 'package:flutter/material.dart';
import 'package:blessing_of_olympus/app/screens/shop_screen/shop_screen.dart';
import 'package:blessing_of_olympus/app/screens/daily_bonus_screen/daily_bonus_screen.dart';
import 'package:blessing_of_olympus/app/screens/settings_screen.dart';

import 'package:blessing_of_olympus/app/widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Оставляем эти отступы для общего выравнивания контента на экране
  final double _screenWidthPadding = 35;
  // final double _topMainPadding = 0; // Не используется явно ниже, можно убрать если не нужно
  // final double _bottomMainPadding = 0; // Не используется явно ниже, можно убрать если не нужно

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
        ),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/main_screen/home_background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
            child: Center(
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0), // Отступы для молнии
                        child: Image.asset(
                          'assets/images/main_screen/lightning.png',
                          scale: 1.3,
                        ),
                      ),

                      // Отступ для всей группы кнопок от молнии и "Best Score"
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: _screenWidthPadding, vertical: 20), // Добавим немного вертикального отступа
                        child: Column(
                          children: <Widget>[
                            // Кнопка PLAY GAME - будет использовать _screenWidthPadding
                            CustomButton(
                              onPressed: () {},
                              text: 'PLAY GAME',
                              color: ButtonColor.blue,
                              size: ButtonSize.large, // Предполагается, что CustomButton правильно обрабатывает Size
                              textSize: 37,
                              scale: 1,
                            ),

                            // Добавим небольшой отступ между кнопкой PLAY GAME и остальными
                            const SizedBox(height: 0), // Можете настроить высоту

                            // Внутренний Padding и Column для остальных кнопок, чтобы они были уже
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30), // Дополнительный отступ для кнопок ниже
                              child: Column(
                                children: <Widget>[
                                  CustomButton(
                                    onPressed: () {Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const ShopScreen()),
                                    );},
                                    text: 'SHOP',
                                    color: ButtonColor.red,
                                    size: ButtonSize.medium,
                                    textSize: 25,
                                    scale: 1,
                                  ),
                                  const SizedBox(height: 0), // Отступ между кнопками
                                  CustomButton(
                                    onPressed: () {Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const DailyBonusScreen(gemBalance: 0,)),
                                    );},
                                    text: 'DAILY BONUS',
                                    color: ButtonColor.red,
                                    size: ButtonSize.medium,
                                    textSize: 25,
                                    scale: 1,
                                  ),
                                  const SizedBox(height: 0), // Отступ между кнопками
                                  CustomButton(
                                    onPressed: () {Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => const SettingsScreen()),
                                    );},
                                    text: 'SETTINGS',
                                    color: ButtonColor.red,
                                    size: ButtonSize.medium,
                                    textSize: 25,
                                    scale: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 30), // Увеличим верхний отступ
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'BEST SCORE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'ProtestStrike',
                            ),
                          ),
                          const Text(
                            '1234567890',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontFamily: 'ProtestStrike',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
