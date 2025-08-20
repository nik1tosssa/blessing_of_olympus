// lib/app/widgets/hero_card.dart

import 'package:flutter/material.dart';
import 'package:blessing_of_olympus/app/widgets/custom_button.dart'; // Убедитесь, что ButtonColor и ButtonSize здесь или импортированы

// Убедитесь, что этот enum используется согласованно
enum HeroStatus {
  selected, // Куплен и выбран
  unselected, // Куплен, но не выбран
  forSale, // Не куплен
}

// Предполагается, что ButtonColor и ButtonSize определены (например, в custom_button.dart)
// enum ButtonColor { blue }
// enum ButtonSize { medium }

class HeroCard extends StatefulWidget {
  const HeroCard({
    Key? key,
    required this.heroName,
    required this.status,
    required this.price,
    this.onSelected,
    this.onPurchaseAttempt,
  }) : super(key: key);

  final String heroName;
  final HeroStatus status;
  final int price;
  final VoidCallback? onSelected;
  final VoidCallback? onPurchaseAttempt;

  @override
  State<HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<HeroCard> {
  final TextStyle _inscriptionStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontFamily: 'ProtestStrike',
  );

  Widget _button() {
    if (widget.status == HeroStatus.selected) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
        child: Text('SELECTED', style: _inscriptionStyle),
      );
    } else if (widget.status == HeroStatus.forSale) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
        child: Center(
          child: CustomButton(
            text: 'BUY',
            onPressed: () {
              widget.onPurchaseAttempt?.call();
            },
            color: ButtonColor.blue,
            // Пример
            size: ButtonSize.medium,
            // Пример
            textSize: 18,
            scale: 1,
            forSale: true,
            // Важно для отображения цены в CustomButton
            price: widget.price,
            gemScale: 2.6,
          ),
        ),
      );
    } else if (widget.status == HeroStatus
        .unselected) { // Теперь unselected означает "куплен, но не выбран"
      return Padding(
        padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
        child: Center(
          child: CustomButton(
            text: 'SELECT',
            onPressed: () {
              widget.onSelected?.call();
            },
            color: ButtonColor.blue,
            size: ButtonSize.medium,
            textSize: 22,
            scale: 1,
            forSale: false, // Не для продажи, цена не нужна
          ),
        ),
      );
    } else {
      // На случай непредвиденного статуса (не должно происходить)
      return SizedBox.shrink();
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
              'assets/images/shop_screen/${widget.heroName}.png',
              scale: 1.1,
            ),
            _button(),
          ],
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
//
// import 'package:blessing_of_olympus/app/widgets/custom_button.dart';
//
// enum HeroStatus { selected, unselected, forSale }
//
// class HeroCard extends StatefulWidget {
//   HeroCard({
//     super.key,
//     required this.heroName,
//     required this.status,
//     this.onSelected,
//     this.onPurchaseAttempt,
//   });
//
//   final String heroName;
//   HeroStatus status;
//   final VoidCallback? onSelected;
//   final VoidCallback? onPurchaseAttempt;
//
//   @override
//   State<HeroCard> createState() => _HeroCardState();
// }
//
// class _HeroCardState extends State<HeroCard> {
//   final TextStyle _inscriptionStyle = TextStyle(
//     color: Colors.white,
//     fontSize: 18,
//     fontFamily: 'ProtestStrike',
//   );
//
//   final TextStyle _priceStyle = TextStyle(
//     color: Colors.white,
//     fontSize: 15,
//     fontFamily: 'ProtestStrike',
//   );
//
//   final Map<String, int> _heroPrice = {
//     'zeus': 100,
//     'athena': 500,
//     'poseidon': 1000,
//     'hades': 5000,
//   };
//
//   // String _getStatus() {
//   //   if (widget.status == HeroStatus.selected) {
//   //     return 'SELECTED';
//   //   } else if (widget.status == HeroStatus.forSale) {
//   //     return 'BUY ';
//   //   } else if (widget.status == HeroStatus.unselected) {
//   //     return 'SELECT';
//   //   } else {
//   //     return '';
//   //   }
//   // }
//   //
//   // void _buyHero() {}
//   //
//   // void _selectHero() {
//   //   widget.onSelected?.call();
//   // }
//
//   Widget _button() {
//     if (widget.status == HeroStatus.selected) {
//       return Padding(
//         padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
//         child: Text('SELECTED', style: _inscriptionStyle),
//       );
//     } else if (widget.status == HeroStatus.forSale) {
//       return Padding(
//         padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
//         child: Center(
//           child: CustomButton(
//             text: 'BUY',
//             onPressed: () {
//               // TODO: Реализовать логику покупки
//               // _buyHero();
//               print("Attempting to buy ${widget.heroName}");
//             },
//             color: ButtonColor.blue,
//             size: ButtonSize.medium,
//             textSize: 18,
//             scale: 1,
//             forSale: true,
//             price: _heroPrice[widget.heroName] ?? 0,
//             //if (_heroPrice[widget.heroName] == null) {0},
//             gemScale: 2.6,
//           ),
//         ),
//       );
//     } else {
//       return Padding(
//         padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
//         child: Center(
//           child: CustomButton(
//             text: 'SELECT',
//             onPressed: () {
//               // Напрямую вызываем callback, переданный от родителя
//               widget.onSelected?.call();
//             },
//             color: ButtonColor.blue,
//             size: ButtonSize.medium,
//             textSize: 22,
//             scale: 1,
//             forSale: false,
//           ),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: Theme.of(context).copyWith(
//         splashFactory: NoSplash.splashFactory,
//         highlightColor: Colors.transparent,
//       ),
//       child: Center(
//         child: Stack(
//           alignment: Alignment.topCenter,
//           children: <Widget>[
//             Image.asset(
//               'assets/images/shop_screen/${widget.heroName}.png',
//               scale: 1.1,
//             ),
//             _button(),
//           ],
//         ),
//       ),
//     );
//   }
// }
