// В файле falling_object.dart (или где он у вас определен)

import 'package:flutter/material.dart'; // Если используете Offset, Size

enum FallingObjectType {
  scoreBonus,
  lifePenalty,
  gem,
}

class FallingObject {
  final String id; // ID может оставаться final
  FallingObjectType type; // НЕ final
  Offset position; // НЕ final (т.к. обновляется в update)
  Size size; // НЕ final
  double speed; // НЕ final
  String imagePath; // НЕ final

  FallingObject({
    required this.id,
    required this.type,
    required this.position,
    required this.size,
    required this.speed,
    required this.imagePath,
  });

  Rect get rect =>
      Rect.fromLTWH(position.dx, position.dy, size.width, size.height);

  void update(double dt) {
    position = Offset(position.dx, position.dy + speed * dt);
  }

  // Метод для "сброса" или переинициализации объекта из пула
  void reset({
    required FallingObjectType newType,
    required Offset newPosition,
    required Size newSize,
    required double newSpeed,
    required String newImagePath,
    // ID можно не менять, если он уникален при первом создании и используется только для ключа
  }) {
    type = newType;
    position = newPosition;
    size = newSize;
    speed = newSpeed;
    imagePath = newImagePath;
  }
}





// // lib/models/falling_object.dart (или где вам удобнее)
// import 'package:flutter/material.dart';
//
// enum FallingObjectType {
//   scoreBonus, // Положительный объект для очков
//   lifePenalty, // Отрицательный объект (отнимает жизнь)
//   gem, // Гем для баланса
//   // Можно добавить другие типы
// }
//
// class FallingObject {
//   final String id;
//   final FallingObjectType type;
//   Offset position; // Изменяемая позиция
//   final Size size;
//   final double speed;
//   final String imagePath; // Путь к изображению объекта
//
//   FallingObject({
//     required this.id,
//     required this.type,
//     required this.position,
//     required this.size,
//     required this.speed,
//     required this.imagePath,
//   });
//
//   // Метод для получения прямоугольника объекта для обнаружения столкновений
//   Rect get rect =>
//       Rect.fromLTWH(position.dx, position.dy, size.width, size.height);
//
//   // Метод для обновления позиции объекта
//   void update(double dt) {
//     // dt - delta time (время с последнего кадра)
//     position = Offset(position.dx, position.dy + speed * dt);
//   }
// }