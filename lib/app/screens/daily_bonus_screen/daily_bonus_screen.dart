import 'package:flutter/material.dart';

class DailyBonusScreen extends StatefulWidget {
  const DailyBonusScreen({super.key});

  @override
  State<DailyBonusScreen> createState() => _DailyBonusScreenState();
}

class _DailyBonusScreenState extends State<DailyBonusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/daily_bonus_screen/background.png',
            ),
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 160, 0, 0),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/daily_bonus_screen/back_gems.png',
                          ),
                          Positioned.fill(
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Text(
                                      '123456789',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'ProtestStrike',
                                        fontSize: 26,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/images/daily_bonus_screen/gems.png',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Image.asset(
                      'assets/images/daily_bonus_screen/back_title.png',
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
                          child: Text(
                            'DAILY BONUS',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'ProtestStrike',
                              fontSize: 34,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/daily_bonus_screen/back_chest.png',
                      scale: 1.2,
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 13),
                            Text(
                              'NEXT BONUS',
                              style: TextStyle(
                                fontFamily: 'ProtestStrike',
                                fontSize: 27,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'AFTER ',
                                  style: TextStyle(
                                    fontFamily: 'ProtestStrike',
                                    fontSize: 37,
                                    color: Colors.white,
                                  ),
                                ),

                                ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.white, Colors.deepPurple],
                                    ).createShader(bounds);
                                  },
                                  child: Text(
                                    '22',
                                    style: TextStyle(
                                      fontFamily: 'ProtestStrike',
                                      fontSize: 37,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                Text(
                                  ' HOURS',
                                  style: TextStyle(
                                    fontFamily: 'ProtestStrike',
                                    fontSize: 37,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20),

                            Container(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Center(
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: Image.asset(
                                                'assets/images/daily_bonus_screen/closed_chest.png',
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1, // Занимает 1 часть из 3
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: Image.asset(
                                                'assets/images/daily_bonus_screen/opened_chest.png',
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1, // Занимает 1 часть из 3
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: Image.asset(
                                                'assets/images/daily_bonus_screen/closed_chest.png',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Center(
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: Image.asset(
                                                'assets/images/daily_bonus_screen/closed_chest.png',
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1, // Занимает 1 часть из 3
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: Image.asset(
                                                'assets/images/daily_bonus_screen/closed_chest.png',
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1, // Занимает 1 часть из 3
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: Image.asset(
                                                'assets/images/daily_bonus_screen/closed_chest.png',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Center(
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: Image.asset(
                                                'assets/images/daily_bonus_screen/closed_chest.png',
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1, // Занимает 1 часть из 3
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: Image.asset(
                                                'assets/images/daily_bonus_screen/closed_chest.png',
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1, // Занимает 1 часть из 3
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: Image.asset(
                                                'assets/images/daily_bonus_screen/closed_chest.png',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                      padding: EdgeInsets.fromLTRB(0, 425, 0, 0),
                      child: IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/images/daily_bonus_screen/back.png',
                          scale: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
