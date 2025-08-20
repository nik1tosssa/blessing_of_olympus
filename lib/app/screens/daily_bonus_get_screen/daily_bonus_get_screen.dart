import 'package:flutter/material.dart';

import 'package:blessing_of_olympus/app/screens/daily_bonus_screen/daily_bonus_screen.dart';

import 'package:blessing_of_olympus/app/widgets/custom_button.dart';

class DailyBonusGetScreen extends StatefulWidget {
  const DailyBonusGetScreen({super.key, required this.coinsGet});

  final int coinsGet;

  @override
  State<DailyBonusGetScreen> createState() => _DailyBonusGetScreenState();
}

class _DailyBonusGetScreenState extends State<DailyBonusGetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/daily_bonus_get_screen/background.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/daily_bonus_get_screen/back_title.png',
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '+${widget.coinsGet.toString()}',
                          style: TextStyle(
                            fontFamily: 'ProtestStrike',
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                        Image.asset(
                          'assets/images/daily_bonus_get_screen/gem_icon.png',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/daily_bonus_get_screen/opend_chest.png',
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'GET',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DailyBonusScreen(gemBalance: widget.coinsGet,),
                    ),
                  );
                },
                color: ButtonColor.red,
                size: ButtonSize.medium,
                textSize: 24,
                topTextPadding: 0,
                scale: 1.2,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
