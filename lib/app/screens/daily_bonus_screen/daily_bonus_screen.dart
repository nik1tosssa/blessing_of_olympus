import 'package:flutter/material.dart';
import 'package:blessing_of_olympus/app/screens/home_screen/home_screen.dart';
import 'package:blessing_of_olympus/app/widgets/custom_button.dart';
import 'package:blessing_of_olympus/app/widgets/chest_button.dart';



class DailyBonusScreen extends StatefulWidget {
  const DailyBonusScreen({super.key});

  @override
  State<DailyBonusScreen> createState() => _DailyBonusScreenState();
}


class ChestState {
  final int id; // Уникальный идентификатор или индекс
  VisualChestStatus visualStatus;
  LogicChestStatus logicStatus;

  ChestState({
    required this.id,
    this.visualStatus = VisualChestStatus.closed,
    this.logicStatus = LogicChestStatus.locked,
  });
}


class _DailyBonusScreenState extends State<DailyBonusScreen> {
  final double _chestsHorizontalPadding = 10;

  int _gemBalance = 0;

  late List<ChestState> _chestsStates;

  @override
  void initState() {
    super.initState();
    _initializeChests();
    _initializeBalance();
  }

  _initializeBalance() {

  }

  void _initializeChests() {
    _chestsStates = List.generate(
      9, // Общее количество сундуков
          (index) => ChestState(
        id: index,
        // Начальные статусы можно задать здесь, если они отличаются
        visualStatus: VisualChestStatus.closed,
        logicStatus: LogicChestStatus.unlocked,
      ),
    );
  }

  // Метод для обработки нажатия на сундук
  void _onChestTapped(int tappedChestId) {
    setState(() {
      for (var chestState in _chestsStates) {
        if (chestState.id == tappedChestId) {
          // Статусы для нажатого сундука
          chestState.visualStatus = VisualChestStatus.opened; // Пример
          chestState.logicStatus = LogicChestStatus.locked;  // Пример
          _gemBalance += 100; // Пример
        } else {
          // Статусы для ВСЕХ ОСТАЛЬНЫХ сундуков
          chestState.visualStatus = VisualChestStatus.closed; // Пример
          chestState.logicStatus = LogicChestStatus.locked;   // Пример
        }
      }
    });
    // Здесь можно добавить логику, например, предоставления бонуса,
    // если chestState.id == tappedChestId и он был успешно "открыт"
    print('Tapped chest ID: $tappedChestId. Bonus logic here.');
  }

  Widget _buildChestRow(int startId) {


    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: _chestsHorizontalPadding, vertical: 2),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ChestButton(
              // Передаем текущие статусы из _chestsStates
              visualStatus: _chestsStates[startId].visualStatus,
              logicStatus: _chestsStates[startId].logicStatus,
              scale: 1,
              // Передаем ID и обработчик нажатия
              onPressed: () => {if (_chestsStates[startId].logicStatus == LogicChestStatus.unlocked){_onChestTapped(startId)}},
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 1,
            child: ChestButton(
              visualStatus: _chestsStates[startId + 1].visualStatus,
              logicStatus: _chestsStates[startId + 1].logicStatus,
              scale: 1,
              onPressed: () => {if (_chestsStates[startId + 1].logicStatus == LogicChestStatus.unlocked){_onChestTapped(startId + 1)}},
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 1,
            child: ChestButton(
              visualStatus: _chestsStates[startId + 2].visualStatus,
              logicStatus: _chestsStates[startId + 2].logicStatus,
              scale: 1,
              onPressed: () => {if (_chestsStates[startId + 2].logicStatus == LogicChestStatus.unlocked){_onChestTapped(startId + 2)}},
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 160, 0, 0),
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
                                      padding: EdgeInsets.zero,
                                      child: Text(
                                        _gemBalance.toString(),
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
                      const Positioned.fill(
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
                  const SizedBox(height: 10),
                  Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/daily_bonus_screen/back_chest.png',
                        scale: 1.2,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: _chestsHorizontalPadding + 10,
                            vertical: 5),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const SizedBox(height: 13),
                            const Text(
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
                                const Text(
                                  'AFTER ',
                                  style: TextStyle(
                                    fontFamily: 'ProtestStrike',
                                    fontSize: 37,
                                    color: Colors.white,
                                  ),
                                ),
                                ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.white,
                                        Colors.deepPurple
                                      ],
                                    ).createShader(bounds);
                                  },
                                  child: const Text(
                                    '22',
                                    style: TextStyle(
                                      fontFamily: 'ProtestStrike',
                                      fontSize: 37,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const Text(
                                  ' HOURS',
                                  style: TextStyle(
                                    fontFamily: 'ProtestStrike',
                                    fontSize: 37,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            _buildChestRow(0), // Первый ряд, сундуки 0, 1, 2
                            _buildChestRow(3), // Второй ряд, сундуки 3, 4, 5
                            _buildChestRow(6), // Третий ряд, сундуки 6, 7, 8

                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 442, 0, 0),
                        child: CustomButton(
                          text: 'BACK',
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const HomeScreen(
                                  title: '',
                                ),
                              ),
                            );
                          },
                          color: ButtonColor.red,
                          size: ButtonSize.medium,
                          textSize: 25,
                          topTextPadding: 0,
                          scale: 1.3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

