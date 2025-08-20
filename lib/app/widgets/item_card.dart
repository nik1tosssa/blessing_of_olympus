import 'package:blessing_of_olympus/app/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({super.key, required this.itemName, required this.price});

  final String itemName;
  final int price;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  // final Map<String, int> _itemPrice = { // Если цена передается, это может не понадобиться
  // //   'magnet': 350,
  // //   'lightning': 350,
  // //   'shield': 350,
  // // };

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      child: Center( // Обертка Center для всей карточки, если нужно
        child: Stack(
          alignment: Alignment.center,
          // <--- Важно: выравниваем все дочерние элементы Stack по центру
          children: <Widget>[
            // 1. Подложка (фон)
            Image.asset(
              'assets/images/shop_screen/item_back.png',
              scale: 1.1, // Масштаб подложки
            ),
            // 2. Изображение предмета (itemName)
            // Убираем Padding и ConstrainedBox вокруг этого Image,
            // если они не служат специальной цели смещения.
            // Stack с alignment: Alignment.center уже должен его центрировать.
            Image.asset(
              'assets/images/shop_screen/${widget.itemName}.png',
              scale: 1.2, // Масштаб самого предмета
              // width: 80, // Опционально: можно задать явную ширину/высоту,
              // height: 80, // если нужно точное совпадение с какой-то областью подложки
            ),
            // 3. Кнопка "BUY"
            // Позиционируем кнопку относительно низа Stack или явно с помощью Positioned или Align
            Align(
              alignment: Alignment.bottomCenter,
              // Выравниваем по нижнему центру Stack
              child: Padding(
                // Отступ для кнопки от нижнего края (или от других элементов)
                // Подберите значение padding так, чтобы кнопка не перекрывала изображение и была на нужном месте
                padding: const EdgeInsets.only(top: 70.0),
                // Примерный отступ снизу
                child: CustomButton(
                  text: 'BUY',
                  onPressed: () {
                    //TODO: Реализовать покупку предмета
                    print("Attempting to buy item: ${widget
                        .itemName}, price: ${widget.price}");
                  },
                  color: ButtonColor.blue,
                  size: ButtonSize.small,
                  textSize: 15,
                  scale: 1,
                  // Масштаб кнопки
                  forSale: true,
                  price: widget.price,
                  gemScale: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:blessing_of_olympus/app/widgets/custom_button.dart';
// import 'package:flutter/material.dart';
//
// class ItemCard extends StatefulWidget {
//   const ItemCard({super.key, required this.itemName, required this.price});
//
//   final String itemName;
//   final int price;
//
//   @override
//   State<ItemCard> createState() => _ItemCardState();
// }
//
// class _ItemCardState extends State<ItemCard> {
//   // final Map<String, int> _itemPrice = {
//   // //   'magnet': 350,
//   // //   'lightning': 350,
//   // //   'shield': 350,
//   // // };
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
//           children: <Widget>[
//             Image.asset('assets/images/shop_screen/item_back.png', scale: 1.1),
//             Padding(
//               padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(maxWidth: 123, maxHeight: 123),
//                 child: Image.asset(
//                   'assets/images/shop_screen/${widget.itemName}.png',
//                   scale: 1.2,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
//               child: Align(
//                 alignment: AlignmentGeometry.bottomCenter,
//                 child: CustomButton(
//                   text: 'BUY',
//                   onPressed: () {
//                     //TODO: Реализовать покупку
//                   },
//                   color: ButtonColor.blue,
//                   size: ButtonSize.small,
//                   textSize: 15,
//                   scale: 1,
//                   forSale: true,
//                   price: widget.price,
//                   gemScale: 4,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
