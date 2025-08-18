import 'package:blessing_of_olympus/app/widgets/hero_card.dart';
import 'package:blessing_of_olympus/app/widgets/item_card.dart';
import 'package:blessing_of_olympus/app/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/shop_screen/background.png'),
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
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 182, 0, 0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/shop_screen/back_balance.png',
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Text(
                                  '1234567890',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontFamily: 'ProtestStrike',
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/shop_screen/gem_icon.png',
                                  scale: 2.5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset('assets/images/shop_screen/back_title.png'),

                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: const Text(
                        'SHOP SKINS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 33,
                          fontFamily: 'ProtestStrike',
                        ),
                      ),
                    ),
                  ],
                ),

                Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/shop_screen/shop_back.png',
                      scale: 1.2,
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(35, 20, 35, 0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: HeroCard(
                                          heroName: 'zeus',
                                          status: HeroStatus.selected,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: HeroCard(
                                          heroName: 'athena',
                                          status: HeroStatus.unselected,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: HeroCard(
                                          heroName: 'poseidon',
                                          status: HeroStatus.forSale,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: HeroCard(
                                          heroName: 'hades',
                                          status: HeroStatus.forSale,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: ItemCard(itemName: 'magnet'),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: ItemCard(itemName: 'lightning'),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: ItemCard(itemName: 'shield'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 440, 0, 0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(title: ''),
                            ),
                          );
                        },
                        icon: Image.asset(
                          'assets/images/shop_screen/back_button.png',
                          scale: 1.2,
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
