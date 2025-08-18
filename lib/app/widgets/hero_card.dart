import 'package:flutter/material.dart';

enum HeroStatus { selected, unselected, forSale }

class HeroCard extends StatefulWidget {
  const HeroCard({super.key, required this.heroName, required this.status});

  final String heroName;
  final HeroStatus status;

  @override
  State<HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<HeroCard> {
  final TextStyle _inscriptionStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontFamily: 'ProtestStrike',
  );

  final TextStyle _priceStyle = TextStyle(
    color: Colors.white,
    fontSize: 15,
    fontFamily: 'ProtestStrike',
  );

  final Map<String, int> _heroPrice = {
    'zeus': 100,
    'athena': 500,
    'poseidon': 1000,
    'hades': 5000,
  };

  String _getStatus() {
    if (widget.status == HeroStatus.selected) {
      return 'SELECTED';
    } else if (widget.status == HeroStatus.forSale) {
      return 'BUY ';
    } else if (widget.status == HeroStatus.unselected) {
      return 'SELECT';
    } else {
      return '';
    }
  }

  Widget _button() {
    if (widget.status == HeroStatus.selected) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
        child: Text(_getStatus(), style: _inscriptionStyle),
      );
    } else if(widget.status == HeroStatus.forSale){
      return Padding(
        padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: Image.asset('assets/images/shop_screen/button.png'),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(_getStatus(), style: _inscriptionStyle),
                      Text(
                        _heroPrice[widget.heroName].toString(),
                        style: _priceStyle,
                      ),
                    ],
                  ),

                  Image.asset(
                    'assets/images/shop_screen/gem_icon.png',
                    scale: 2.5,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else{
      return Padding(
        padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: Image.asset('assets/images/shop_screen/button.png'),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(_getStatus(), style: _inscriptionStyle),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Image.asset(
                'assets/images/shop_screen/' + widget.heroName + '.png',
                scale: 1.1,
              ),
              _button(),
            ],
          ),
        ),
      );

  }
}
