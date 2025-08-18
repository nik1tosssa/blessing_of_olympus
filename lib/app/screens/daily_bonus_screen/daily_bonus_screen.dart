// Импорт необходимых пакетов Flutter.
import 'package:flutter/material.dart';
// Импорт другого экрана из вашего приложения (HomeScreen).
import 'package:blessing_of_olympus/app/screens/home_screen/home_screen.dart';

// Определение класса DailyBonusScreen, который является StatefulWidget.
// StatefulWidget - это виджет, состояние которого может изменяться во время выполнения.
class DailyBonusScreen extends StatefulWidget {
  // Конструктор класса DailyBonusScreen.
  // {super.key} передает необязательный параметр key родительскому классу StatefulWidget.
  const DailyBonusScreen({super.key});

  // Переопределение метода createState для создания и возврата экземпляра _DailyBonusScreenState.
  // Этот метод вызывается фреймворком для создания изменяемого состояния этого виджета.
  @override
  State<DailyBonusScreen> createState() => _DailyBonusScreenState();
}

// Определение класса _DailyBonusScreenState, который управляет состоянием DailyBonusScreen.
class _DailyBonusScreenState extends State<DailyBonusScreen> {
  // Переопределение метода build, который описывает часть пользовательского интерфейса, представленную этим виджетом.
  // Этот метод вызывается каждый раз, когда виджету нужно перерисоваться.
  @override
  Widget build(BuildContext context) {
    // Возвращает виджет Scaffold, который реализует базовую структуру визуального макета Material Design.
    return Scaffold(
      // Тело Scaffold, которое будет содержать основной контент экрана.
      body: Container(
        // Оформление контейнера с фоновым изображением.
        decoration: BoxDecoration(
          image: DecorationImage(
            // Указание пути к изображению в папке assets.
            image: AssetImage(
              'assets/images/daily_bonus_screen/background.png',
            ),
            // Масштабирование изображения для покрытия всего контейнера.
            fit: BoxFit.cover,
          ),
        ),
        // Вложенный контейнер для применения градиента поверх фонового изображения.
        child: Container(
          // Оформление вложенного контейнера с градиентом.
          decoration: BoxDecoration(
            // Линейный градиент.
            gradient: LinearGradient(
              // Начало градиента сверху по центру.
              begin: Alignment.topCenter,
              // Конец градиента снизу по центру.
              end: Alignment.bottomCenter,
              // Цвета градиента: от прозрачного к черному с прозрачностью 0.7.
              colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),

          // Центрирование дочернего виджета (Column) внутри контейнера.
          child: Center(
            // Виджет Column для расположения дочерних элементов вертикально.
            child: Column(
              // Выравнивание дочерних элементов по началу главной оси (сверху).
              mainAxisAlignment: MainAxisAlignment.start,
              // Список дочерних виджетов Column.
              children: <Widget>[
                // Виджет Stack для наложения виджетов друг на друга.
                Stack(
                  // Выравнивание дочерних элементов Stack сверху по центру.
                  alignment: Alignment.topCenter,
                  // Список дочерних виджетов Stack.
                  children: <Widget>[
                    // Виджет Padding для добавления отступов.
                    Padding(
                      // Отступ сверху на 160 пикселей.
                      padding: EdgeInsets.fromLTRB(0, 160, 0, 0),
                      // Вложенный Stack для отображения информации о драгоценных камнях.
                      child: Stack(
                        // Выравнивание дочерних элементов внутреннего Stack сверху по центру.
                        alignment: Alignment.topCenter,
                        // Список дочерних виджетов внутреннего Stack.
                        children: <Widget>[
                          // Изображение фона для драгоценных камней.
                          Image.asset(
                            'assets/images/daily_bonus_screen/back_gems.png',
                          ),
                          // Виджет Positioned.fill для растягивания дочернего виджета на все доступное пространство родительского Stack.
                          Positioned.fill(
                            // Центрирование дочернего виджета (Row).
                            child: Center(
                              // Виджет Row для расположения элементов горизонтально.
                              child: Row(
                                // Выравнивание дочерних элементов Row по центру главной оси (горизонтально).
                                mainAxisAlignment: MainAxisAlignment.center,
                                // Список дочерних виджетов Row.
                                children: <Widget>[
                                  // Виджет Padding для добавления отступов к тексту.
                                  Padding(
                                    // Нулевые отступы.
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    // Текстовый виджет для отображения количества драгоценных камней.
                                    child: Text(
                                      '123456789', // Пример количества камней
                                      // Выравнивание текста по центру.
                                      textAlign: TextAlign.center,
                                      // Стиль текста.
                                      style: TextStyle(
                                        // Используемый шрифт.
                                        fontFamily: 'ProtestStrike',
                                        // Размер шрифта.
                                        fontSize: 26,
                                        // Цвет текста.
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  // Изображение драгоценных камней.
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

                    // Изображение фона для заголовка.
                    Image.asset(
                      'assets/images/daily_bonus_screen/back_title.png',
                    ),
                    // Виджет Positioned.fill для растягивания дочернего виджета на все доступное пространство родительского Stack.
                    Positioned.fill(
                      // Центрирование дочернего виджета (Padding).
                      child: Center(
                        // Виджет Padding для добавления отступов к тексту заголовка.
                        child: Padding(
                          // Отступ снизу на 50 пикселей.
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
                          // Текстовый виджет для отображения заголовка "DAILY BONUS".
                          child: Text(
                            'DAILY BONUS',
                            // Выравнивание текста по центру.
                            textAlign: TextAlign.center,
                            // Стиль текста.
                            style: TextStyle(
                              // Используемый шрифт.
                              fontFamily: 'ProtestStrike',
                              // Размер шрифта.
                              fontSize: 34,
                              // Цвет текста.
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Виджет SizedBox для создания пустого пространства (отступа) по вертикали.
                SizedBox(height: 10),

                // Еще один виджет Stack для наложения элементов, связанных с сундуками.
                Stack(
                  // Выравнивание дочерних элементов Stack сверху по центру.
                  alignment: Alignment.topCenter,
                  // Список дочерних виджетов Stack.
                  children: <Widget>[
                    // Изображение фона для секции с сундуками.
                    Image.asset(
                      'assets/images/daily_bonus_screen/back_chest.png',
                      // Масштабирование изображения.
                      scale: 1.2,
                    ),
                    // Виджет Positioned.fill для растягивания дочернего виджета на все доступное пространство родительского Stack.
                    Positioned.fill(
                      // Центрирование дочернего виджета (Column).
                      child: Center(
                        // Виджет Column для вертикального расположения элементов внутри секции с сундуками.
                        child: Column(
                          // Список дочерних виджетов Column.
                          children: <Widget>[
                            // Отступ сверху.
                            SizedBox(height: 13),
                            // Текстовый виджет "NEXT BONUS".
                            Text(
                              'NEXT BONUS',
                              // Стиль текста.
                              style: TextStyle(
                                fontFamily: 'ProtestStrike',
                                fontSize: 27,
                                color: Colors.white,
                              ),
                            ),
                            // Виджет Row для горизонтального расположения текста о времени до следующего бонуса.
                            Row(
                              // Выравнивание дочерних элементов Row по центру.
                              mainAxisAlignment: MainAxisAlignment.center,
                              // Список дочерних виджетов Row.
                              children: <Widget>[
                                // Текстовый виджет "AFTER ".
                                Text(
                                  'AFTER ',
                                  // Стиль текста.
                                  style: TextStyle(
                                    fontFamily: 'ProtestStrike',
                                    fontSize: 37,
                                    color: Colors.white,
                                  ),
                                ),

                                // Виджет ShaderMask для применения градиента к тексту.
                                ShaderMask(
                                  // Функция, которая создает шейдер (градиент).
                                  shaderCallback: (Rect bounds) {
                                    // Возвращает линейный градиент.
                                    return LinearGradient(
                                      // Начало градиента сверху по центру.
                                      begin: Alignment.topCenter,
                                      // Конец градиента снизу по центру.
                                      end: Alignment.bottomCenter,
                                      // Цвета градиента: от белого к темно-фиолетовому.
                                      colors: [Colors.white, Colors.deepPurple],
                                    ).createShader(bounds);
                                  },
                                  // Текстовый виджет, к которому применяется градиент (отображает количество часов).
                                  child: Text(
                                    '22', // Пример количества часов
                                    // Стиль текста.
                                    style: TextStyle(
                                      fontFamily: 'ProtestStrike',
                                      fontSize: 37,
                                      // Важно: цвет здесь должен быть белым, так как градиент будет наложен на него.
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                // Текстовый виджет " HOURS".
                                Text(
                                  ' HOURS',
                                  // Стиль текста.
                                  style: TextStyle(
                                    fontFamily: 'ProtestStrike',
                                    fontSize: 37,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),

                            // Отступ по вертикали.
                            SizedBox(height: 20),

                            // Контейнер для сетки сундуков.
                            Container(
                              // Виджет Column для расположения рядов сундуков вертикально.
                              child: Column(
                                // Список дочерних виджетов Column (ряды сундуков).
                                children: <Widget>[
                                  // Первый ряд сундуков.
                                  Padding(
                                    // Горизонтальные отступы для ряда.
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    // Центрирование Row внутри Padding.
                                    child: Center(
                                      // Виджет Row для горизонтального расположения сундуков.
                                      child: Row(
                                        // Список дочерних виджетов Row (сундуки).
                                        children: <Widget>[
                                          // Виджет Expanded для того, чтобы каждый IconButton занимал равную часть доступной ширины.
                                          Expanded(
                                            // Коэффициент растяжения (по умолчанию 1).
                                            flex: 1,
                                            // Кнопка с иконкой закрытого сундука.
                                            child: IconButton(
                                              // Функция, вызываемая при нажатии на кнопку (в данном случае пустая).
                                              onPressed: () {},
                                              // Иконка кнопки (изображение закрытого сундука).
                                              icon: Image.asset(
                                                'assets/images/daily_bonus_screen/closed_chest.png',
                                              ),
                                            ),
                                          ),
                                          // Кнопка с иконкой открытого сундука.
                                          Expanded(
                                            flex: 1, // Занимает 1 часть из 3 (если всего 3 элемента)
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: Image.asset(
                                                'assets/images/daily_bonus_screen/opened_chest.png',
                                              ),
                                            ),
                                          ),
                                          // Кнопка с иконкой закрытого сундука.
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

                                  // Второй ряд сундуков (аналогичен первому).
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

                                  // Третий ряд сундуков (аналогичен первым двум).
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
                                            // Здесь был пропущен виджет IconButton и его содержимое в предоставленном коде.
                                            // Предполагаю, что здесь также должна быть кнопка с иконкой сундука.
                                            // Для полноты примера, добавлю его:
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: Image.asset(
                                                'assets/images/daily_bonus_screen/closed_chest.png', // или opened_chest.png, в зависимости от логики
                                              ),
                                            ),
                                          ),
                                          // Следующий IconButton также был не полностью завершен в исходном коде
                                          // Дополняю для примера
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

                    // Кнопка "назад" для возврата на предыдущий экран.
                    Padding(
                      // Отступ сверху для позиционирования кнопки.
                      padding: EdgeInsets.fromLTRB(0, 425, 0, 0),
                      // Кнопка с иконкой.
                      child: IconButton(
                        // Функция, вызываемая при нажатии на кнопку.
                        onPressed: () {
                          // Навигация на HomeScreen.
                          Navigator.push(
                            context,
                            // Создание нового маршрута (экрана).
                            MaterialPageRoute(
                              // Функция, которая строит виджет для нового экрана.
                              builder: (context) => HomeScreen(title: ''), // Передача пустого заголовка в HomeScreen
                            ),
                          );
                        },
                        // Иконка кнопки (изображение стрелки "назад").
                        icon: Image.asset(
                          'assets/images/daily_bonus_screen/back.png',
                          // Масштабирование иконки.
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
