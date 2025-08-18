import 'package:flutter/material.dart';
import 'package:blessing_of_olympus/app/screens/shop_screen/shop_screen.dart';
import 'package:blessing_of_olympus/app/screens/daily_bonus_screen/daily_bonus_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _leftMainPadding = 35;
  double _topMainPadding = 0;
  double _rightMainPadding = 35;
  double _bottomMainPadding = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: null,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Image.asset(
                        'assets/images/main_screen/lightning.png',
                        scale: 1.3,
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      _leftMainPadding,
                      _topMainPadding,
                      _rightMainPadding,
                      _bottomMainPadding,
                    ),
                    child: Column(
                      children: <Widget>[
                        IconButton(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          onPressed: () {},
                          icon: Image.asset('assets/images/main_screen/play_game.png'),
                        ),

                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 3, 30, 10),
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ShopScreen()));},
                                icon: Image.asset('assets/images/main_screen/shop.png'),
                              ),
                              IconButton(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => DailyBonusScreen()));},
                                icon: Image.asset(
                                  'assets/images/main_screen/daily_bonus.png',
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                onPressed: () {},
                                icon: Image.asset('assets/images/main_screen/settings.png'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'BEST SCORE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontFamily: 'ProtestStrike',
                          ),
                        ),
                        Text(
                          '1234567890',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 47,
                            fontFamily: 'ProtestStrike',
                          ),
                        ),
                      ],
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
