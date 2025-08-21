import 'package:flutter/material.dart';

import 'package:blessing_of_olympus/app/screens/home_screen/home_screen.dart';
import 'package:blessing_of_olympus/app/screens/game_screen/game_screen.dart';

import 'package:blessing_of_olympus/app/widgets/custom_button.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key, required this.score});

  final int score;

  @override
  State<GameOverScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<GameOverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/settings_screen/background.png'),
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
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 600),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/game_screen/back_balance.png',
                              scale: 1.2,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  '123', //todo: replace with actual balance
                                  style: TextStyle(
                                    fontFamily: 'ProtestStrike',
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Image.asset(
                                  'assets/images/game_screen/gem_icon.png',
                                  scale: 1.8,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Image.asset(
                        'assets/images/settings_screen/back_settings.png',
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(45, 0, 45, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'GAME SCORE',
                              style: TextStyle(
                                fontFamily: 'ProtestStrike',
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              widget.score.toString(),
                              style: TextStyle(
                                fontFamily: 'ProtestStrike',
                                fontSize: 40,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 20,),
                            Text(
                              'BEST SCORE',
                              style: TextStyle(
                                fontFamily: 'ProtestStrike',
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '123456', //todo: заменить на актуальные очки
                              style: TextStyle(
                                fontFamily: 'ProtestStrike',
                                fontSize: 23,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 360),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/settings_screen/back_title.png'),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text(
                        'GAME OVER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontFamily: 'ProtestStrike',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 300),
                child: CustomButton(
                  text: 'RESTART',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameScreen(),
                      ),
                    );
                  },
                  color: ButtonColor.red,
                  size: ButtonSize.medium,
                  textSize: 27,
                  scale: 1.2,
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(top: 470),
                child: CustomButton(
                  text: 'HOME',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(title: ''),
                      ),
                    );
                  },
                  color: ButtonColor.red,
                  size: ButtonSize.medium,
                  textSize: 27,
                  scale: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
