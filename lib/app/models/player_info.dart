import 'dart:convert';
import 'dart:io';
import 'package:blessing_of_olympus/app/widgets/hero_card.dart'; // Убедитесь, что HeroStatus и его сериализация/десериализация корректны

class PlayerInfo {
  int bestScore;
  int lastScore;
  int balance;
  List<String> heroNames;
  Map<String, HeroStatus> heroStatuses;
  Map<String, int> heroPrices;
  List<String> itemNames;
  Map<String, int> itemPrices;
  Map<String, int> itemCounts;
  DateTime lastDailyBonus;
  bool musicOn;
  bool soundOn;
  bool vibrationOn;

  // Путь к файлу данных игрока. Рассмотрите возможность сделать его не final,
  // если путь может меняться или передаваться извне.
  // Или передавайте путь в методы saveData/getData.
  // Для простоты оставим его как поле класса.
  String filePath = 'assets/data/player_data.json'; // Путь по умолчанию, можно изменить или сделать более гибким

  PlayerInfo({
    required this.bestScore,
    required this.lastScore,
    required this.balance,
    required this.heroNames,
    required this.heroStatuses,
    required this.heroPrices,
    required this.itemNames,
    required this.itemPrices,
    required this.itemCounts,
    required this.lastDailyBonus,
    required this.musicOn,
    required this.soundOn,
    required this.vibrationOn,
  });

  // Вспомогательный метод для получения пути к директории документов приложения.
  // Для Flutter лучше использовать path_provider, но для простоты примера
  // пока оставим так. Если это Flutter-проект, замените на path_provider.
  Future<String> _getActualFilePath() async {
    // Если это Flutter приложение, используйте path_provider:
    // final directory = await getApplicationDocumentsDirectory();
    // return '${directory.path}/$filePath';

    // Для чистого Dart или если filePath - это уже абсолютный путь:
    // Если filePath - это просто имя файла, он будет создан в текущей рабочей директории.
    // Чтобы сделать его более надежным, лучше формировать полный путь.
    // Пока что предположим, что filePath - это имя файла в текущей директории или полный путь.
    final file = File(filePath);
    if (!file.isAbsolute) {
      // Это очень упрощенный вариант для не-Flutter окружения.
      // В Flutter используйте getApplicationDocumentsDirectory() из path_provider
      // для получения безопасного места для хранения файлов.
      final currentDirPath = Directory.current.path;
      return '$currentDirPath/$filePath';
    }
    return filePath;
  }


  // --- Новый метод для получения данных из JSON-файла в текущий экземпляр ---
  Future<void> getData() async {
    try {
      final actualPath = await _getActualFilePath();
      final file = File(actualPath);

      if (await file.exists()) {
        final contents = await file.readAsString();
        if (contents.isNotEmpty) {
          final Map<String, dynamic> jsonMap = jsonDecode(contents) as Map<
              String,
              dynamic>;

          // Обновляем поля текущего экземпляра
          bestScore = jsonMap['bestScore'] as int? ?? bestScore;
          lastScore = jsonMap['lastScore'] as int? ?? lastScore;
          balance = jsonMap['balance'] as int? ?? balance;
          heroNames =
          List<String>.from(jsonMap['heroNames'] as List? ?? heroNames);

          // ВАЖНО: Обработка HeroStatus требует специального внимания
          // Если HeroStatus - это enum, вам нужно преобразовать строки из JSON в значения enum
          if (jsonMap['heroStatuses'] != null) {
            heroStatuses =
                (jsonMap['heroStatuses'] as Map<String, dynamic>).map(
                        (key, value) {
                      // Замените это на вашу реальную логику преобразования строки в HeroStatus
                      // Например, если HeroStatus - это enum: HeroStatus.values.byName(value as String)
                      // Или если у вас есть вспомогательный метод: HeroStatusHelper.fromString(value as String)
                      // Для примера, если HeroStatus - это просто строка:
                      if (value is String) { // Добавим проверку типа для безопасности
                        // Предположим, HeroStatus - это enum и у вас есть метод fromString
                        // или вы используете values.firstWhere / byName (для Dart 2.15+)
                        // Эта часть очень зависит от того, как определен HeroStatus
                        // и как вы его сериализуете/десериализуете.
                        // ПРИМЕР: если HeroStatus - это enum HeroStatus { selected, unselected, forSale }
                        // и в JSON хранятся строки "selected", "unselected", "forSale"
                        try {
                          // Для Dart 2.15+
                          // return MapEntry(key, HeroStatus.values.byName(value));
                          // Для более старых версий Dart или более сложной логики:
                          switch (value.toLowerCase()) {
                            case 'selected':
                              return MapEntry(key, HeroStatus.selected);
                            case 'unselected':
                              return MapEntry(key, HeroStatus.unselected);
                            case 'forsale':
                              return MapEntry(key, HeroStatus.forSale);
                            default:
                              print(
                                  "Неизвестный статус героя: $value для ключа $key. Используется unselected.");
                              return MapEntry(key, HeroStatus
                                  .unselected); // Значение по умолчанию
                          }
                        } catch (e) {
                          print(
                              "Ошибка преобразования HeroStatus для '$value': $e. Используется unselected.");
                          return MapEntry(key, HeroStatus
                              .unselected); // Значение по умолчанию при ошибке
                        }
                      } else {
                        // Если значение не строка, это неожиданно. Возвращаем значение по умолчанию.
                        print("Неожиданный тип для HeroStatus: ${value
                            .runtimeType} для ключа $key. Используется unselected.");
                        return MapEntry(key, HeroStatus.unselected);
                      }
                    }
                );
          }


          heroPrices =
          Map<String, int>.from(jsonMap['heroPrices'] as Map? ?? heroPrices);
          itemNames =
          List<String>.from(jsonMap['itemNames'] as List? ?? itemNames);
          itemPrices =
          Map<String, int>.from(jsonMap['itemPrices'] as Map? ?? itemPrices);
          itemCounts =
          Map<String, int>.from(jsonMap['itemCounts'] as Map? ?? itemCounts);
          lastDailyBonus = DateTime.parse(
              jsonMap['lastDailyBonus'] as String? ??
                  lastDailyBonus.toIso8601String());
          musicOn = jsonMap['musicOn'] as bool? ?? musicOn;
          soundOn = jsonMap['soundOn'] as bool? ?? soundOn;
          vibrationOn = jsonMap['vibrationOn'] as bool? ?? vibrationOn;

          print(
              "Данные успешно загружены в экземпляр PlayerInfo из $actualPath");
        } else {
          print("Файл $actualPath пуст. Данные не загружены.");
        }
      } else {
        print(
            "Файл $actualPath не найден. Данные не загружены. Используются текущие/умолчательные значения экземпляра.");
        // Здесь можно решить, нужно ли создавать файл с данными по умолчанию, если он не найден.
      }
    } catch (e) {
      print("Ошибка при чтении и применении данных из файла $filePath: $e");
      // Решите, нужно ли перебрасывать исключение или обрабатывать его здесь.
    }
  }

  // --- Новый метод для записи текущего состояния экземпляра в JSON-файл ---
  Future<void> saveData() async {
    try {
      final actualPath = await _getActualFilePath();
      final file = File(actualPath);

      // Преобразуем текущий экземпляр в Map
      final Map<String,
          dynamic> jsonMap = toJson(); // Используем существующий toJson()

      // Преобразуем Map в JSON-строку
      final String jsonString = jsonEncode(jsonMap);

      // Записываем строку в файл
      await file.writeAsString(jsonString);
      print("Данные успешно сохранены в файл: $actualPath");
    } catch (e) {
      print("Ошибка при записи данных в файл $filePath: $e");
      // Решите, нужно ли перебрасывать исключение или обрабатывать его здесь.
    }
  }


  // Фабричный конструктор для создания экземпляра из Map (обычно после jsonDecode)
  // Этот конструктор создает НОВЫЙ экземпляр.
  factory PlayerInfo.fromJson(Map<String, dynamic> json) {
    // ВАЖНО: Убедитесь, что логика для heroStatuses здесь также корректна
    Map<String, HeroStatus> statuses = {};
    if (json['heroStatuses'] != null) {
      statuses = (json['heroStatuses'] as Map<String, dynamic>).map(
              (key, value) {
            // Та же логика преобразования, что и в getData()
            // ПРИМЕР:
            try {
              // return MapEntry(key, HeroStatus.values.byName(value as String));
              switch ((value as String).toLowerCase()) {
                case 'selected':
                  return MapEntry(key, HeroStatus.selected);
                case 'unselected':
                  return MapEntry(key, HeroStatus.unselected);
                case 'forsale':
                  return MapEntry(key, HeroStatus.forSale);
                default:
                  return MapEntry(key, HeroStatus.unselected);
              }
            } catch (e) {
              return MapEntry(key, HeroStatus.unselected);
            }
          }
      );
    }

    return PlayerInfo(
      bestScore: json['bestScore'] as int,
      lastScore: json['lastScore'] as int,
      balance: json['balance'] as int,
      heroNames: List<String>.from(json['heroNames'] as List),
      heroStatuses: statuses,
      heroPrices: Map<String, int>.from(json['heroPrices'] as Map),
      itemNames: List<String>.from(json['itemNames'] as List),
      itemPrices: Map<String, int>.from(json['itemPrices'] as Map),
      itemCounts: Map<String, int>.from(json['itemCounts'] as Map),
      lastDailyBonus: DateTime.parse(json['lastDailyBonus'] as String),
      musicOn: json['musicOn'] as bool? ?? true,
      // Значение по умолчанию, если отсутствует
      soundOn: json['soundOn'] as bool? ?? true,
      // Значение по умолчанию
      vibrationOn: json['vibrationOn'] as bool? ??
          true, // Значение по умолчанию
    );
  }

  // Метод для преобразования экземпляра в Map (для последующего jsonEncode)
  Map<String, dynamic> toJson() {
    return {
      'bestScore': bestScore,
      'lastScore': lastScore,
      'balance': balance,
      'heroNames': heroNames,
      // ВАЖНО: Убедитесь, что HeroStatus правильно сериализуется в строку
      'heroStatuses': heroStatuses.map((key, value) {
        // Замените это на вашу реальную логику преобразования HeroStatus в строку
        // Например, если HeroStatus - это enum: MapEntry(key, value.name)
        // Для примера:
        return MapEntry(key, value
            .toString()
            .split('.')
            .last); // "HeroStatus.selected" -> "selected"
      }),
      'heroPrices': heroPrices,
      'itemNames': itemNames,
      'itemPrices': itemPrices,
      'itemCounts': itemCounts,
      'lastDailyBonus': lastDailyBonus.toIso8601String(),
      'musicOn': musicOn,
      'soundOn': soundOn,
      'vibrationOn': vibrationOn,
    };
  }

  // Вспомогательный метод для прямого преобразования в JSON-строку
  String toJsonString() => jsonEncode(toJson());

  // Вспомогательный фабричный конструктор для создания из JSON-строки
  // Этот конструктор создает НОВЫЙ экземпляр.
  factory PlayerInfo.fromJsonString(String jsonString) {
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString) as Map<
        String,
        dynamic>;
    return PlayerInfo.fromJson(jsonMap);
  }

}
// import 'dart:convert';
// import 'dart:io';
// import 'package:blessing_of_olympus/app/widgets/hero_card.dart';
//
// class PlayerInfo {
//   int bestScore;
//   int lastScore;
//   int balance;
//   List<String> heroNames;
//   Map<String, HeroStatus> heroStatuses; // e.g., {"zeus": "selected"}
//   Map<String, int> heroPrices; // e.g., {"zeus": 0}
//   List<String> itemNames;
// //   Map<String, int> itemPrices; // e.g., {"magnet": 350}
// //   Map<String, int> itemCounts; // e.g., {"magnet": 0}
// //   DateTime lastDailyBonus;
// //   bool musicOn;
// //   bool soundOn;
// //   bool vibrationOn;
// //
// //   PlayerInfo({
// //     required this.bestScore,
// //     required this.lastScore,
// //     required this.balance,
// //     required this.heroNames,
// //     required this.heroStatuses,
// //     required this.heroPrices,
// //     required this.itemNames,
// //     required this.itemPrices,
// //     required this.itemCounts,
// //     required this.lastDailyBonus,
// //     required this.musicOn,
// //     required this.soundOn,
// //     required this.vibrationOn,
// //   });
// //
// //   String filePath = 'assets/data/player_data.json';
// //
// //   Future<String> readJsonStringFromFile() async {
// //     try {
// //       final file = File(filePath);
// //       if (await file.exists()) {
// //         final contents = await file.readAsString();
// //         return contents;
// //       } else {
// //
// //         throw FileSystemException("Файл не найден", filePath);
// //       }
// //     } catch (e) {
// //       print("Ошибка при чтении файла $filePath: $e");
// //       rethrow;
// //     }
// //   }
// //
// //   Future<void> writeJsonStringToFile(String jsonString) async {
// //     try {
// //       await File(filePath).writeAsString(jsonString);
// //     } catch (e) {
// //       rethrow;
// //     }
// //   }
// //
// //   // Фабричный конструктор для создания экземпляра из Map (обычно после jsonDecode)
// //   factory PlayerInfo.fromJson(Map<String, dynamic> json) {
// //     return PlayerInfo(
// //       bestScore: json['bestScore'] as int,
// //       lastScore: json['lastScore'] as int,
// //       balance: json['balance'] as int,
// //       heroNames: List<String>.from(json['heroNames'] as List),
// //       heroStatuses: Map<String, HeroStatus>.from(json['heroStatuses'] as Map),
// //       heroPrices: Map<String, int>.from(json['heroPrices'] as Map),
// //       itemNames: List<String>.from(json['itemNames'] as List),
// //       itemPrices: Map<String, int>.from(json['itemPrices'] as Map),
// //       itemCounts: Map<String, int>.from(json['itemCounts'] as Map),
// //       lastDailyBonus: DateTime.parse(json['lastDailyBonus'] as String),
// //       musicOn: json['musicOn'] as bool,
// //       soundOn: json['soundOn'] as bool,
// //       vibrationOn: json['vibrationOn'] as bool,
// //
// //     );
// //   }
// //
// //   // Метод для преобразования экземпляра в Map
// //   Map<String, dynamic> toJson() {
// //     return {
// //       'bestScore': bestScore,
// //       'lastScore': lastScore,
// //       'balance': balance,
// //       'heroNames': heroNames,
// //       'heroStatuses': heroStatuses,
// //       'heroPrices': heroPrices,
// //       'itemNames': itemNames,
// //       'itemPrices': itemPrices,
// //       'itemCounts': itemCounts,
// //       'lastDailyBonus': lastDailyBonus.toIso8601String(),
// //       // Стандартный формат для дат
// //     };
// //   }
// //
// //   // Вспомогательный метод для прямого преобразования в JSON-строку
// //   String toJsonString() => jsonEncode(toJson());
// //
// //   // Вспомогательный фабричный конструктор для создания из JSON-строки
// //   factory PlayerInfo.fromJsonString(String jsonString) {
// //     final Map<String, dynamic> jsonMap =
// //         jsonDecode(jsonString) as Map<String, dynamic>;
// //     return PlayerInfo.fromJson(jsonMap);
// //   }
// // }
