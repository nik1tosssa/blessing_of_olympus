import 'package:flutter/material.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({super.key, required this.itemName});

  final String itemName;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  final Map<String, int> _itemPrice = {
    'magnet': 350,
    'lightning': 350,
    'shield': 350,
  };

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      child: Center(
        child: Stack(
          children: <Widget>[
            Image.asset('assets/images/shop_screen/item_back.png', scale: 1.1),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Image.asset(
                'assets/images/shop_screen/' + widget.itemName + '.png',
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/images/shop_screen/button_mini.png',
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'BUY',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'ProtestStrike',
                        ),
                      ),
                      Text(
                        _itemPrice[widget.itemName].toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontFamily: 'ProtestStrike',
                        ),
                      ),
                      Image.asset(
                        'assets/images/shop_screen/gem_icon.png',
                        scale: 4.5,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
