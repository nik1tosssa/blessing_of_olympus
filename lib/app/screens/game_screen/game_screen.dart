import 'package:flutter/material.dart';
import 'dart:math'; // Для Random
import 'package:flutter/scheduler.dart'; // Для Ticker

// Импорты ваших экранов и виджетов
import 'package:blessing_of_olympus/app/screens/pause_screen/pause_screen.dart';
import 'package:blessing_of_olympus/app/widgets/pause_button.dart';

// Убедитесь, что этот путь правильный и файл FallingObject модифицирован (поля не final)
import 'package:blessing_of_olympus/app/widgets/falling_object.dart';

// НОВЫЙ ИМПОРТ для экрана Game Over
import 'package:blessing_of_olympus/app/screens/game_over_screen/game_over_screen.dart';


// PlayerCharacter виджет
class PlayerCharacter extends StatelessWidget {
  final String direction;
  final String heroName;

  const PlayerCharacter({
    super.key,
    required this.heroName,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/images/game_screen/${heroName}_${direction}.png';
    return Container(
      width: 100,
      height: 100,
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
      ),
    );
  }
}


class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with TickerProviderStateMixin {
  // --- Состояние персонажа ---
  String _selectedHero = 'zeus';
  Offset _characterPosition = Offset.zero;
  final GlobalKey _characterKey = GlobalKey();
  Size _characterSize = Size.zero;
  bool _isCharacterReady = false;
  String _characterDirection = 'left';
  Offset? _lastFingerPosition;
  static const double bottomPadding = 20.0;
  double _fixedCharacterY = 0.0;

  // --- Состояние падающих объектов и игрового цикла ---
  List<FallingObject> _fallingObjects = [];
  List<FallingObject> _inactiveObjectsPool = [];

  Ticker? _ticker;
  late AnimationController _characterAppearanceController;
  late Animation<double> _characterOpacityAnimation;
  late Animation<double> _characterScaleAnimation;
  bool _characterHasAppeared = false;

  final Random _random = Random();
  DateTime? _lastObjectSpawnTime;
  final Duration _objectSpawnInterval = const Duration(milliseconds: 700);
  Duration _previousElapsed = Duration.zero; // Для расчета deltaTime
  static const int _maxFallingObjects = 15;

  // --- ValueNotifiers ---
  final ValueNotifier<int> _scoreNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> _livesNotifier = ValueNotifier<int>(3);
  final ValueNotifier<int> _balanceNotifier = ValueNotifier<int>(0);

  // --- Конфигурация объектов ---
  final Map<FallingObjectType, String> _objectImagePaths = {
    FallingObjectType.scoreBonus: 'assets/images/game_screen/lightning.png',
    FallingObjectType.lifePenalty: 'assets/images/game_screen/stone.png',
    FallingObjectType.gem: 'assets/images/game_screen/gem.png',
  };
  final Map<FallingObjectType, Size> _objectSizes = {
    FallingObjectType.scoreBonus: const Size(45, 45),
    FallingObjectType.lifePenalty: const Size(55, 55),
    FallingObjectType.gem: const Size(40, 40),
  };
  final Map<FallingObjectType, double> _objectSpeeds = {
    FallingObjectType.scoreBonus: 230.0,
    FallingObjectType.lifePenalty: 180.0,
    FallingObjectType.gem: 250.0,
  };

  bool _assetsPrecached = false;
  bool _allAssetsLoaded = false;
  bool _poolPrepopulated = false;

  @override
  void initState() {
    super.initState();
    print("DEBUG: initState CALLED");

    _characterAppearanceController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _characterOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _characterAppearanceController, curve: Curves.easeIn),
    );
    _characterScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
          parent: _characterAppearanceController, curve: Curves.elasticOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print(
        "DEBUG: didChangeDependencies CALLED. _assetsPrecached: $_assetsPrecached");
    if (!_assetsPrecached) {
      _assetsPrecached = true;
      _initializeAssetsAndGame();
    }
  }

  Future<void> _initializeAssetsAndGame() async {
    print("DEBUG: _initializeAssetsAndGame STARTED");
    await _precacheGameImages();
    print(
        "DEBUG: _precacheGameImages FINISHED. _allAssetsLoaded: $_allAssetsLoaded");

    if (mounted && _allAssetsLoaded) {
      _prepopulateObjectsPool();
      print(
          "DEBUG: Object pool prepopulation finished. Pool size: ${_inactiveObjectsPool
              .length}");
      _poolPrepopulated = true;
      if (mounted) {
        setState(() {});
      }
    } else if (mounted && !_allAssetsLoaded) {
      print("DEBUG: Not all assets loaded successfully.");
      if (mounted) {
        setState(() {});
      }
    }
    print("DEBUG: _initializeAssetsAndGame FINISHED");
  }

  Future<void> _precacheGameImages() async {
    print("DEBUG: _precacheGameImages STARTED");
    final Set<String> pathsToPrecache = {};
    pathsToPrecache.addAll(_objectImagePaths.values);
    pathsToPrecache.add('assets/images/game_screen/${_selectedHero}_left.png');
    pathsToPrecache.add('assets/images/game_screen/${_selectedHero}_right.png');
    pathsToPrecache.add('assets/images/game_screen/back_balance.png');
    pathsToPrecache.add('assets/images/game_screen/gem_icon.png');
    int successfullyLoadedCount = 0;
    try {
      for (String path in pathsToPrecache) {
        if (mounted) {
          await precacheImage(AssetImage(path), context);
          successfullyLoadedCount++;
        } else {
          _allAssetsLoaded = false;
          return;
        }
      }
      _allAssetsLoaded = (successfullyLoadedCount == pathsToPrecache.length);
      print(_allAssetsLoaded
          ? "DEBUG: All images successfully precached."
          : "DEBUG: Failed to precache some images.");
    } catch (e) {
      print('DEBUG: Error during image precaching: $e');
      _allAssetsLoaded = false;
    }
    print(
        "DEBUG: _precacheGameImages FINISHED. _allAssetsLoaded: $_allAssetsLoaded");
  }

  void _prepopulateObjectsPool() {
    print("DEBUG: _prepopulateObjectsPool STARTED");
    if (!_allAssetsLoaded) return;
    _inactiveObjectsPool.clear();
    const int objectsPerType = 33;
    FallingObjectType.values.forEach((type) {
      for (int i = 0; i < objectsPerType; i++) {
        _inactiveObjectsPool.add(FallingObject(
          id: 'pooled_${type.name}_$i',
          type: type,
          position: const Offset(-10000, -10000),
          size: _objectSizes[type]!,
          speed: _objectSpeeds[type]!,
          imagePath: _objectImagePaths[type]!,
        ));
      }
    });
    print("DEBUG: Pool prepopulated. Total: ${_inactiveObjectsPool.length}");
  }

  @override
  void dispose() {
    print("DEBUG: dispose CALLED");
    _ticker?.dispose();
    _characterAppearanceController.dispose();
    _scoreNotifier.dispose();
    _livesNotifier.dispose();
    _balanceNotifier.dispose();
    super.dispose();
  }

  void _determineCharacterSizeAndFixedY() {
    print(
        "DEBUG: _determineCharacterSizeAndFixedY. ReadyFlags: $_allAssetsLoaded, $_poolPrepopulated");
    if (!mounted || !_allAssetsLoaded || !_poolPrepopulated) return;

    final RenderBox? characterRenderBox = _characterKey.currentContext
        ?.findRenderObject() as RenderBox?;
    print("DEBUG: _characterKey.currentContext: ${_characterKey
        .currentContext}, RenderBox: $characterRenderBox");

    if (characterRenderBox != null && characterRenderBox.hasSize) {
      final characterSizeValue = characterRenderBox.size;
      final screenSize = MediaQuery
          .of(context)
          .size;
      if (characterSizeValue.width > 0 && characterSizeValue.height > 0) {
        _fixedCharacterY =
            screenSize.height - characterSizeValue.height - bottomPadding;
        _fixedCharacterY = _fixedCharacterY.clamp(
            0.0, screenSize.height - characterSizeValue.height);

        if (!_isCharacterReady || _characterSize != characterSizeValue) {
          bool wasNotReady = !_isCharacterReady;
          setState(() {
            _characterSize = characterSizeValue;
            _characterPosition = Offset(
                (screenSize.width - _characterSize.width) / 2,
                _fixedCharacterY);
            _isCharacterReady = true;
            print(
                "DEBUG: _isCharacterReady SET TRUE. Pos: $_characterPosition");
          });
          if (wasNotReady && !_characterHasAppeared) {
            _characterAppearanceController.forward();
            _characterHasAppeared = true;
          }
        }
        if ((_ticker == null || !_ticker!.isActive) &&
            _livesNotifier.value > 0) {
          _startGameLoop();
        }
      } else {
        _retryDetermineCharacterSizeAndFixedY();
      }
    } else {
      _retryDetermineCharacterSizeAndFixedY();
    }
  }

  void _retryDetermineCharacterSizeAndFixedY() {
    print("DEBUG: _retryDetermineCharacterSizeAndFixedY CALLED");
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && !_isCharacterReady && _allAssetsLoaded &&
          _poolPrepopulated) {
        _determineCharacterSizeAndFixedY();
      }
    });
  }

  void _startGameLoop() {
    print(
        "DEBUG: _startGameLoop CALLED. Ready: $_isCharacterReady, Assets: $_allAssetsLoaded, Pool: $_poolPrepopulated");
    if (!_isCharacterReady || !_allAssetsLoaded || !_poolPrepopulated) return;
    if (_ticker?.isActive ?? false) return;

    // _previousElapsed устанавливается в Duration.zero перед первым запуском тикера
    // или при полном рестарте игры (_resetGame).
    // При возобновлении после паузы, он уже содержит последнее значение.
    _ticker = createTicker((
        elapsed) { // elapsed - общее время с момента создания тикера (или сброса)
      if (!mounted || _livesNotifier.value <= 0) {
        _ticker?.stop();
        return;
      }

      final Duration currentFrameDuration = elapsed - _previousElapsed;
      _previousElapsed = elapsed; // Обновляем для следующего тика

      double deltaTime = currentFrameDuration.inMilliseconds / 1000.0;

      if (deltaTime > 0.1) deltaTime = 0.1;
      if (deltaTime < 0) deltaTime = 0; // На всякий случай
      // Если это первый кадр после старта/возобновления и currentFrameDuration была 0, даем минимальный шаг
      if (deltaTime == 0 && elapsed.inMilliseconds > 0 &&
          (_ticker?.isActive ?? false)) {
        deltaTime = 1.0 / 60.0; // Предполагаем 60 FPS
      }


      _trySpawnObject();
      List<FallingObject> objectsToDeactivate = [];
      bool objectsMoved = false;

      for (var obj in _fallingObjects) {
        Offset oldPosition = obj.position;
        obj.update(deltaTime);
        if ((obj.position.dy - oldPosition.dy).abs() > 0.001)
          objectsMoved = true;
        if (obj.position.dy > MediaQuery
            .of(context)
            .size
            .height) objectsToDeactivate.add(obj);
      }

      bool poolChanged = false;
      if (_isCharacterReady && _characterSize != Size.zero) {
        Rect characterRect = Rect.fromLTWH(
            _characterPosition.dx, _characterPosition.dy, _characterSize.width,
            _characterSize.height);
        for (var obj in List<FallingObject>.from(_fallingObjects)) {
          if (!objectsToDeactivate.contains(obj) &&
              characterRect.overlaps(obj.rect)) {
            _handleCollision(obj);
            objectsToDeactivate.add(obj);
          }
        }
      }

      if (objectsToDeactivate.isNotEmpty) {
        for (var objToDeactivate in objectsToDeactivate) {
          _fallingObjects.remove(objToDeactivate);
          _inactiveObjectsPool.add(objToDeactivate);
        }
        poolChanged = true;
      }

      if (_livesNotifier.value <= 0) _gameOver();

      if (mounted &&
          (_fallingObjects.isNotEmpty || poolChanged || objectsMoved)) {
        setState(() {});
      }
    });
    _previousElapsed =
        Duration.zero; // <--- Сброс перед самым первым стартом/рестартом тикера
    _ticker?.start();
    _lastObjectSpawnTime = DateTime.now();
    print("DEBUG: Ticker started.");
  }

  void _trySpawnObject() {
    if (_fallingObjects.length >= _maxFallingObjects) return;
    if (_lastObjectSpawnTime == null ||
        DateTime.now().difference(_lastObjectSpawnTime!) >
            _objectSpawnInterval) {
      _spawnOrReuseObject();
      _lastObjectSpawnTime = DateTime.now();
    }
  }

  void _spawnOrReuseObject() {
    if (!mounted || MediaQuery
        .of(context)
        .size
        .width <= 0 || !_allAssetsLoaded || !_poolPrepopulated ||
        _fallingObjects.length >= _maxFallingObjects) return;
    final targetType = FallingObjectType.values[_random.nextInt(
        FallingObjectType.values.length)];
    int reusableIdx = _inactiveObjectsPool.indexWhere((obj) =>
    obj.type == targetType);
    FallingObject objectToActivate;

    if (reusableIdx != -1) {
      objectToActivate = _inactiveObjectsPool.removeAt(reusableIdx);
      objectToActivate.reset(
        newType: targetType,
        newPosition: Offset(_random.nextDouble() * (MediaQuery
            .of(context)
            .size
            .width - _objectSizes[targetType]!.width),
            -_objectSizes[targetType]!.height),
        newSize: _objectSizes[targetType]!,
        newSpeed: _objectSpeeds[targetType]!,
        newImagePath: _objectImagePaths[targetType]!,
      );
    } else {
      final size = _objectSizes[targetType]!;
      objectToActivate = FallingObject(
        id: 'created_${targetType.name}_${DateTime
            .now()
            .millisecondsSinceEpoch}',
        type: targetType,
        position: Offset(_random.nextDouble() * (MediaQuery
            .of(context)
            .size
            .width - size.width), -size.height),
        size: size,
        speed: _objectSpeeds[targetType]!,
        imagePath: _objectImagePaths[targetType]!,
      );
    }
    if (mounted) setState(() => _fallingObjects.add(objectToActivate));
  }

  void _handleCollision(FallingObject object) {
    switch (object.type) {
      case FallingObjectType.scoreBonus:
        _scoreNotifier.value += 10;
        break;
      case FallingObjectType.lifePenalty:
        _livesNotifier.value -= 1;
        break;
      case FallingObjectType.gem:
        _balanceNotifier.value += 1;
        break;
    }
  }

  void _gameOver() {
    if (mounted && (_ticker?.isActive ?? true)) _ticker?.stop();
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => GameOverScreen(score: _scoreNotifier.value)));
    }
  }

  void _resetGame() {
    print("DEBUG: _resetGame CALLED");
    _scoreNotifier.value = 0;
    _livesNotifier.value = 3;
    _balanceNotifier.value = 0;
    _characterHasAppeared = false;
    _characterAppearanceController.reset();

    if (mounted) {
      _ticker?.stop();
      _fallingObjects.clear();
      _inactiveObjectsPool.clear();
      _prepopulateObjectsPool();
      _isCharacterReady = false;
      _characterPosition = Offset.zero;
      _lastObjectSpawnTime = null;
      _previousElapsed =
          Duration.zero; // Важно для корректного deltaTime при рестарте
      setState(() {});
      // Определение размеров персонажа будет вызвано из build
    }
  }

  void _updateCharacterPosition(Offset currentFingerPosition) {
    if (!_isCharacterReady || _characterSize == Size.zero) {
      if (mounted && !_isCharacterReady && _allAssetsLoaded &&
          _poolPrepopulated) _determineCharacterSizeAndFixedY();
      return;
    }
    bool directionChanged = false;
    if (_lastFingerPosition != null) {
      double dx = currentFingerPosition.dx - _lastFingerPosition!.dx;
      if (dx > 2.0) {
        if (_characterDirection != 'right') {
          _characterDirection = 'right';
          directionChanged = true;
        }
      }
      else if (dx < -2.0) {
        if (_characterDirection != 'left') {
          _characterDirection = 'left';
          directionChanged = true;
        }
      }
    }
    _lastFingerPosition = currentFingerPosition;
    final screenSize = MediaQuery
        .of(context)
        .size;
    double newX = currentFingerPosition.dx - (_characterSize.width / 2);
    newX = newX.clamp(0.0, screenSize.width - _characterSize.width);
    final newPosition = Offset(newX, _fixedCharacterY);
    if ((_characterPosition != newPosition || directionChanged) && mounted) {
      setState(() {
        if (_characterPosition != newPosition) _characterPosition = newPosition;
      });
    }
  }

  void _onInteractionEnd() {
    _lastFingerPosition = null;
  }

  @override
  Widget build(BuildContext context) {
    print(
        "DEBUG: build CALLED. Assets: $_allAssetsLoaded, Pool: $_poolPrepopulated, CharReady: $_isCharacterReady, Appeared: $_characterHasAppeared");
    List<Widget> gameLayerWidgets = [];

    if (_allAssetsLoaded && _poolPrepopulated) {
      gameLayerWidgets.add(
          Positioned(
            left: _isCharacterReady ? _characterPosition.dx : -10000.0,
            top: _isCharacterReady ? _characterPosition.dy : -10000.0,
            child: ScaleTransition(scale: _characterScaleAnimation,
              child: FadeTransition(opacity: _characterOpacityAnimation,
                child: Container(key: _characterKey,
                  child: PlayerCharacter(
                      heroName: _selectedHero, direction: _characterDirection),
                ),
              ),
            ),
          )
      );
      if (!_isCharacterReady && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _allAssetsLoaded && _poolPrepopulated &&
              !_isCharacterReady) {
            _determineCharacterSizeAndFixedY();
          }
        });
      }
    }

    if (_allAssetsLoaded && _poolPrepopulated && _isCharacterReady) {
      gameLayerWidgets.addAll(_fallingObjects.map((obj) =>
          Positioned(
            key: ValueKey(obj.id), left: obj.position.dx, top: obj.position.dy,
            child: Container(width: obj.size.width,
                height: obj.size.height,
                child: Image.asset(obj.imagePath, fit: BoxFit.contain)),
          )).toList());
    } else if (!(_allAssetsLoaded && _poolPrepopulated && _isCharacterReady)) {
      List<Widget> loadingWidgets = [];
      if (_allAssetsLoaded && _poolPrepopulated &&
          !gameLayerWidgets.any((w) => w.key == _characterKey)) {
        loadingWidgets.add(
            Opacity(opacity: 0.0, child: IgnorePointer(ignoring: true,
                child: Container(key: _characterKey,
                    child: PlayerCharacter(heroName: _selectedHero,
                        direction: _characterDirection)))));
      }
      loadingWidgets.add(Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 10),
            Text(!_allAssetsLoaded ? "Loading assets..." : !_poolPrepopulated
                ? "Preparing objects..."
                : "Initializing character...",
                style: const TextStyle(color: Colors.white, fontSize: 16)),
          ])));
      if (loadingWidgets.isNotEmpty) gameLayerWidgets.addAll(loadingWidgets);
    }

    Widget mainGameLayer = Stack(children: gameLayerWidgets);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage(
            'assets/images/game_screen/${_selectedHero}_background.png'),
            fit: BoxFit.cover)),
        child: Stack(children: [
          GestureDetector(
            onPanStart: (details) {
              if (!_isCharacterReady && mounted && _allAssetsLoaded &&
                  _poolPrepopulated) _determineCharacterSizeAndFixedY();
              _lastFingerPosition = details.localPosition;
              if (_isCharacterReady) _updateCharacterPosition(
                  details.localPosition);
            },
            onPanUpdate: (details) {
              if (_isCharacterReady) _updateCharacterPosition(
                  details.localPosition);
            },
            onPanEnd: (details) => _onInteractionEnd(),
            onTapDown: (details) {
              if (!_isCharacterReady && mounted && _allAssetsLoaded &&
                  _poolPrepopulated) _determineCharacterSizeAndFixedY();
              _lastFingerPosition = details.localPosition;
              if (_isCharacterReady) {
                final screenSize = MediaQuery
                    .of(context)
                    .size;
                double newX = details.localPosition.dx -
                    (_characterSize.width / 2);
                newX = newX.clamp(0.0, screenSize.width - _characterSize.width);
                if (_characterPosition.dx != newX && mounted) setState(() =>
                _characterPosition = Offset(newX, _fixedCharacterY));
              }
            },
            onTapUp: (details) => _onInteractionEnd(),
            child: Container(width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
                child: mainGameLayer),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 40, 25, 0),
            child: Center(child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: <Widget>[
                      PauseButton(onPressed: () {
                        if (_ticker?.isActive ?? false) {
                          _ticker?.stop();
                          print("DEBUG: Game paused.");
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const PauseScreen())).then((
                              _) {
                            print("DEBUG: Returned from PauseScreen.");
                            if (mounted && !(_ticker?.isActive ?? true) &&
                                _livesNotifier.value > 0) {
                              // _previousElapsed уже содержит значение на момент остановки.
                              // Ticker.start() продолжит с него.
                              _ticker?.start();
                              print("DEBUG: Game resumed.");
                            }
                          });
                        }
                      }),
                      const Spacer(),
                      ConstrainedBox(constraints: const BoxConstraints(
                          maxWidth: 260), child: Stack(
                          alignment: Alignment.center, children: <Widget>[
                        Image.asset(
                            'assets/images/game_screen/back_balance.png',
                            scale: 1.2),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ValueListenableBuilder<int>(
                                  valueListenable: _balanceNotifier,
                                  builder: (c, bal, w) =>
                                      Text('$bal',
                                      style: const TextStyle(
                                          fontFamily: 'ProtestStrike',
                                          fontSize: 24,
                                          color: Colors.white))),
                              const SizedBox(width: 5),
                              Image.asset(
                                  'assets/images/game_screen/gem_icon.png',
                                  scale: 1.8),
                            ]),
                      ])),
                    ]),
                    const SizedBox(height: 20),
                    const Text('SCORE', style: TextStyle(
                        fontFamily: 'ProtestStrike',
                        fontSize: 25,
                        color: Colors.white)),
                    ValueListenableBuilder<int>(valueListenable: _scoreNotifier,
                        builder: (c, score, w) =>
                            Text('$score', style: const TextStyle(
                                fontFamily: 'ProtestStrike',
                                fontSize: 25,
                                color: Colors.white))),
                  ]),
            )),
          ),
        ]),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'dart:math'; // Для Random
// import 'package:flutter/scheduler.dart'; // Для Ticker
//
// // Импорты ваших экранов и виджетов
// import 'package:blessing_of_olympus/app/screens/pause_screen/pause_screen.dart';
// import 'package:blessing_of_olympus/app/widgets/pause_button.dart';
//
// // Убедитесь, что этот путь правильный и файл FallingObject модифицирован (поля не final)
// import 'package:blessing_of_olympus/app/widgets/falling_object.dart';
//
// // НОВЫЙ ИМПОРТ для экрана Game Over
// import 'package:blessing_of_olympus/app/screens/game_over_screen/game_over_screen.dart';
//
//
// // PlayerCharacter виджет
// class PlayerCharacter extends StatelessWidget {
//   final String direction;
//   final String heroName;
//
//   const PlayerCharacter({
//     super.key,
//     required this.heroName,
//     required this.direction,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     String imagePath = 'assets/images/game_screen/${heroName}_${direction}.png';
//     return Container(
//       width: 100, // Фактическая ширина спрайта персонажа
//       height: 100, // Фактическая высота спрайта персонажа
//       child: Image.asset(
//         imagePath,
//         fit: BoxFit.contain,
//       ),
//     );
//   }
// }
//
//
// class GameScreen extends StatefulWidget {
//   const GameScreen({super.key});
//
//   @override
//   State<GameScreen> createState() => _GameScreenState();
// }
//
// class _GameScreenState extends State<GameScreen>
//     with TickerProviderStateMixin {
//   // ИЗМЕНЕНИЕ: TickerProviderStateMixin
//   // --- Состояние персонажа ---
//   String _selectedHero = 'hades'; //todo: replace with actual selected hero name
//   Offset _characterPosition = Offset.zero;
//   final GlobalKey _characterKey = GlobalKey();
//   Size _characterSize = Size.zero;
//   bool _isCharacterReady = false;
//   String _characterDirection = 'left';
//   Offset? _lastFingerPosition;
//   static const double bottomPadding = 20.0;
//   double _fixedCharacterY = 0.0;
//
//   // --- Состояние падающих объектов и игрового цикла ---
//   List<FallingObject> _fallingObjects = [];
//   List<FallingObject> _inactiveObjectsPool = [];
//
//   Ticker? _ticker; // Для игрового цикла
//   // --- НОВЫЕ ПОЛЯ ДЛЯ АНИМАЦИИ ПЕРСОНАЖА ---
//   late AnimationController _characterAppearanceController;
//   late Animation<double> _characterOpacityAnimation;
//   late Animation<double> _characterScaleAnimation;
//   bool _characterHasAppeared = false;
//
//   final Random _random = Random();
//   DateTime? _lastObjectSpawnTime;
//   final Duration _objectSpawnInterval = const Duration(milliseconds: 700);
//   Duration _previousElapsed = Duration.zero;
//   static const int _maxFallingObjects = 15;
//
//   // --- ValueNotifiers ---
//   final ValueNotifier<int> _scoreNotifier = ValueNotifier<int>(0);
//   final ValueNotifier<int> _livesNotifier = ValueNotifier<int>(3);
//   final ValueNotifier<int> _balanceNotifier = ValueNotifier<int>(0);
//
//   // --- Конфигурация объектов ---
//   final Map<FallingObjectType, String> _objectImagePaths = {
//     FallingObjectType.scoreBonus: 'assets/images/game_screen/lightning.png',
//     FallingObjectType.lifePenalty: 'assets/images/game_screen/stone.png',
//     FallingObjectType.gem: 'assets/images/game_screen/gem.png',
//   };
//   final Map<FallingObjectType, Size> _objectSizes = {
//     FallingObjectType.scoreBonus: const Size(45, 45),
//     FallingObjectType.lifePenalty: const Size(55, 55),
//     FallingObjectType.gem: const Size(40, 40),
//   };
//   final Map<FallingObjectType, double> _objectSpeeds = {
//     FallingObjectType.scoreBonus: 230.0,
//     FallingObjectType.lifePenalty: 180.0,
//     FallingObjectType.gem: 250.0,
//   };
//
//   bool _assetsPrecached = false;
//   bool _allAssetsLoaded = false;
//   bool _poolPrepopulated = false;
//
//   @override
//   void initState() {
//     super.initState();
//     print("DEBUG: initState CALLED");
//
//     _characterAppearanceController = AnimationController(
//       duration: const Duration(milliseconds: 700),
//       // Длительность анимации появления
//       vsync: this, // TickerProviderStateMixin
//     );
//
//     _characterOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _characterAppearanceController,
//         curve: Curves.easeIn,
//       ),
//     );
//
//     _characterScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _characterAppearanceController,
//         curve: Curves.elasticOut, // Эффект "пружинки"
//       ),
//     );
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     print(
//         "DEBUG: didChangeDependencies CALLED. _assetsPrecached: $_assetsPrecached");
//     if (!_assetsPrecached) {
//       _assetsPrecached = true;
//       _initializeAssetsAndGame();
//     }
//   }
//
//   Future<void> _initializeAssetsAndGame() async {
//     print("DEBUG: _initializeAssetsAndGame STARTED");
//     await _precacheGameImages();
//     print(
//         "DEBUG: _precacheGameImages FINISHED. _allAssetsLoaded: $_allAssetsLoaded");
//
//     if (mounted && _allAssetsLoaded) {
//       _prepopulateObjectsPool();
//       print(
//           "DEBUG: Object pool prepopulation finished. Pool size: ${_inactiveObjectsPool
//               .length}");
//       _poolPrepopulated = true;
//
//       if (mounted) {
//         setState(() {}); // Чтобы build() перерисовался с обновленными флагами
//       }
//     } else if (mounted && !_allAssetsLoaded) {
//       print(
//           "DEBUG: Not all assets loaded successfully, game initialization might be incomplete.");
//       if (mounted) {
//         setState(() {});
//       }
//     }
//     print("DEBUG: _initializeAssetsAndGame FINISHED");
//   }
//
//   Future<void> _precacheGameImages() async {
//     print("DEBUG: _precacheGameImages STARTED");
//     final Set<String> pathsToPrecache = {};
//     pathsToPrecache.addAll(_objectImagePaths.values);
//     pathsToPrecache.add('assets/images/game_screen/${_selectedHero}_left.png');
//     pathsToPrecache.add('assets/images/game_screen/${_selectedHero}_right.png');
//     pathsToPrecache.add('assets/images/game_screen/back_balance.png');
//     pathsToPrecache.add('assets/images/game_screen/gem_icon.png');
//
//     int successfullyLoadedCount = 0;
//     try {
//       for (String path in pathsToPrecache) {
//         if (mounted) {
//           await precacheImage(AssetImage(path), context);
//           print('DEBUG: Successfully precached: $path');
//           successfullyLoadedCount++;
//         } else {
//           print('DEBUG: Attempted to precache on unmounted widget: $path');
//           _allAssetsLoaded = false;
//           return;
//         }
//       }
//       _allAssetsLoaded = (successfullyLoadedCount == pathsToPrecache.length);
//       if (_allAssetsLoaded)
//         print("DEBUG: All images successfully precached.");
//       else
//         print(
//             "DEBUG: Failed to precache all images. Loaded $successfullyLoadedCount of ${pathsToPrecache
//                 .length}");
//     } catch (e, stackTrace) {
//       print('DEBUG: Error during image precaching: $e');
//       print(stackTrace);
//       _allAssetsLoaded = false;
//     }
//     print(
//         "DEBUG: _precacheGameImages FINISHED. _allAssetsLoaded: $_allAssetsLoaded");
//   }
//
//   void _prepopulateObjectsPool() {
//     print("DEBUG: _prepopulateObjectsPool STARTED");
//     if (!_allAssetsLoaded) {
//       print("DEBUG: Cannot prepopulate pool, assets not loaded.");
//       return;
//     }
//     _inactiveObjectsPool.clear();
//     const int objectsPerType = 33;
//     FallingObjectType.values.forEach((type) {
//       for (int i = 0; i < objectsPerType; i++) {
//         final newObj = FallingObject(
//           id: 'pooled_${type.name}_$i',
//           type: type,
//           position: const Offset(-10000, -10000),
//           // Далеко за экраном
//           size: _objectSizes[type]!,
//           speed: _objectSpeeds[type]!,
//           imagePath: _objectImagePaths[type]!,
//         );
//         _inactiveObjectsPool.add(newObj);
//       }
//     });
//     print(
//         "DEBUG: Pool prepopulated. Total pooled objects: ${_inactiveObjectsPool
//             .length}");
//   }
//
//   @override
//   void dispose() {
//     print("DEBUG: dispose CALLED");
//     _ticker?.dispose();
//     _characterAppearanceController
//         .dispose(); // НЕ ЗАБУДЬТЕ УДАЛИТЬ КОНТРОЛЛЕР АНИМАЦИИ
//     _scoreNotifier.dispose();
//     _livesNotifier.dispose();
//     _balanceNotifier.dispose();
//     super.dispose();
//   }
//
//   void _determineCharacterSizeAndFixedY() {
//     print(
//         "DEBUG: _determineCharacterSizeAndFixedY CALLED. Mounted: $mounted, AllAssetsLoaded: $_allAssetsLoaded, PoolPrepopulated: $_poolPrepopulated");
//     if (!mounted || !_allAssetsLoaded || !_poolPrepopulated) {
//       print(
//           "DEBUG: _determineCharacterSizeAndFixedY - Not proceeding (unmounted, assets not loaded, or pool not ready).");
//       return;
//     }
//
//     final RenderBox? characterRenderBox = _characterKey.currentContext
//         ?.findRenderObject() as RenderBox?;
//     print("DEBUG: _characterKey.currentContext is: ${_characterKey
//         .currentContext}");
//     print("DEBUG: characterRenderBox is: $characterRenderBox");
//
//     if (characterRenderBox != null && characterRenderBox.hasSize) {
//       final characterSizeValue = characterRenderBox.size;
//       print("DEBUG: characterRenderBox HAS SIZE: $characterSizeValue");
//       final screenSize = MediaQuery
//           .of(context)
//           .size;
//       if (characterSizeValue.width > 0 && characterSizeValue.height > 0) {
//         _fixedCharacterY =
//             screenSize.height - characterSizeValue.height - bottomPadding;
//         _fixedCharacterY = _fixedCharacterY.clamp(
//             0.0, screenSize.height - characterSizeValue.height);
//
//         if (!_isCharacterReady || _characterSize != characterSizeValue ||
//             _characterPosition != Offset(
//                 (screenSize.width - characterSizeValue.width) / 2,
//                 _fixedCharacterY)) {
//           bool wasNotReady = !_isCharacterReady;
//           setState(() {
//             _characterSize = characterSizeValue;
//             _characterPosition = Offset(
//                 (screenSize.width - _characterSize.width) / 2,
//                 _fixedCharacterY);
//             _isCharacterReady = true;
//             print(
//                 "DEBUG: _isCharacterReady SET TO TRUE. Position: $_characterPosition");
//           });
//
//           if (wasNotReady && !_characterHasAppeared) {
//             _characterAppearanceController.forward();
//             _characterHasAppeared = true;
//           }
//         }
//
//         if ((_ticker == null || !_ticker!.isActive) &&
//             _livesNotifier.value > 0) {
//           print("DEBUG: Condition to start game loop MET");
//           _startGameLoop();
//         }
//       } else {
//         print("DEBUG: characterRenderBox size is ZERO or negative. Retrying.");
//         _retryDetermineCharacterSizeAndFixedY();
//       }
//     } else {
//       print("DEBUG: characterRenderBox is NULL or has NO SIZE. Retrying.");
//       _retryDetermineCharacterSizeAndFixedY();
//     }
//   }
//
//   void _retryDetermineCharacterSizeAndFixedY() {
//     print("DEBUG: _retryDetermineCharacterSizeAndFixedY CALLED");
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (mounted && !_isCharacterReady && _allAssetsLoaded &&
//           _poolPrepopulated) {
//         print("DEBUG: Retrying _determineCharacterSizeAndFixedY from retry...");
//         _determineCharacterSizeAndFixedY();
//       }
//     });
//   }
//
//   void _startGameLoop() {
//     print("DEBUG: _startGameLoop CALLED");
//     if (!_isCharacterReady || !_allAssetsLoaded || !_poolPrepopulated) {
//       print(
//           "DEBUG: _startGameLoop - Cannot start, game not fully initialized.");
//       return;
//     }
//     if (_ticker?.isActive ?? false) {
//       print("DEBUG: _startGameLoop - Ticker already active, returning.");
//       return;
//     }
//     _previousElapsed = Duration.zero;
//     _ticker = createTicker((elapsed) {
//       if (!mounted || _livesNotifier.value <= 0) {
//         _ticker?.stop();
//         print("DEBUG: Ticker stopped (unmounted or no lives).");
//         return;
//       }
//
//       final Duration elapsedInFrame = elapsed - _previousElapsed;
//       _previousElapsed = elapsed;
//       double deltaTime = elapsedInFrame.inMilliseconds / 1000.0;
//       if (deltaTime <= 0 && elapsed.inMilliseconds > 0) deltaTime = 1 / 60.0;
//       if (deltaTime > 0.1) deltaTime = 0.1;
//
//       _trySpawnObject();
//
//       List<FallingObject> objectsToDeactivate = [];
//       bool objectsMoved = false;
//
//       for (var obj in _fallingObjects) {
//         Offset oldPosition = obj.position;
//         obj.update(deltaTime);
//         if ((obj.position.dy - oldPosition.dy).abs() > 0.001) {
//           objectsMoved = true;
//         }
//         if (obj.position.dy > MediaQuery
//             .of(context)
//             .size
//             .height) {
//           objectsToDeactivate.add(obj);
//         }
//       }
//
//       bool poolChanged = false;
//       if (_isCharacterReady && _characterSize != Size.zero) {
//         Rect characterRect = Rect.fromLTWH(
//             _characterPosition.dx, _characterPosition.dy,
//             _characterSize.width, _characterSize.height);
//         for (var obj in List<FallingObject>.from(_fallingObjects)) {
//           if (!objectsToDeactivate.contains(obj) &&
//               characterRect.overlaps(obj.rect)) {
//             _handleCollision(obj);
//             objectsToDeactivate.add(obj);
//           }
//         }
//       }
//
//       if (objectsToDeactivate.isNotEmpty) {
//         for (var objToDeactivate in objectsToDeactivate) {
//           _fallingObjects.remove(objToDeactivate);
//           _inactiveObjectsPool.add(objToDeactivate);
//         }
//         poolChanged = true;
//       }
//
//       if (_livesNotifier.value <= 0) {
//         _gameOver();
//       }
//
//       if (mounted &&
//           (_fallingObjects.isNotEmpty || poolChanged || objectsMoved)) {
//         setState(() {});
//       }
//     });
//     _ticker?.start();
//     _lastObjectSpawnTime = DateTime.now();
//     print("DEBUG: Ticker started.");
//   }
//
//   void _trySpawnObject() {
//     if (_fallingObjects.length >= _maxFallingObjects) {
//       return;
//     }
//     if (_lastObjectSpawnTime == null ||
//         DateTime.now().difference(_lastObjectSpawnTime!) >
//             _objectSpawnInterval) {
//       _spawnOrReuseObject();
//       _lastObjectSpawnTime = DateTime.now();
//     }
//   }
//
//   void _spawnOrReuseObject() {
//     if (!mounted || MediaQuery
//         .of(context)
//         .size
//         .width <= 0 || !_allAssetsLoaded || !_poolPrepopulated ||
//         _fallingObjects.length >= _maxFallingObjects) {
//       return;
//     }
//
//     final availableObjectTypes = FallingObjectType.values;
//     final targetType = availableObjectTypes[_random.nextInt(
//         availableObjectTypes.length)];
//     FallingObject objectToActivate;
//     int reusableObjectIndex = _inactiveObjectsPool.indexWhere((obj) =>
//     obj.type == targetType);
//
//     if (reusableObjectIndex != -1) {
//       objectToActivate = _inactiveObjectsPool.removeAt(reusableObjectIndex);
//       objectToActivate.reset(
//         newType: targetType,
//         newPosition: Offset(
//             _random.nextDouble() * (MediaQuery
//                 .of(context)
//                 .size
//                 .width - _objectSizes[targetType]!.width),
//             -_objectSizes[targetType]!.height),
//         newSize: _objectSizes[targetType]!,
//         newSpeed: _objectSpeeds[targetType]!,
//         newImagePath: _objectImagePaths[targetType]!,
//       );
//     } else {
//       final size = _objectSizes[targetType]!;
//       objectToActivate = FallingObject(
//         id: 'created_new_${targetType.name}_${DateTime
//             .now()
//             .millisecondsSinceEpoch}',
//         type: targetType,
//         position: Offset(
//             _random.nextDouble() * (MediaQuery
//                 .of(context)
//                 .size
//                 .width - size.width),
//             -size.height),
//         size: size,
//         speed: _objectSpeeds[targetType]!,
//         imagePath: _objectImagePaths[targetType]!,
//       );
//     }
//
//     if (mounted) {
//       setState(() {
//         _fallingObjects.add(objectToActivate);
//       });
//     }
//   }
//
//   void _handleCollision(FallingObject object) {
//     switch (object.type) {
//       case FallingObjectType.scoreBonus:
//         _scoreNotifier.value += 10;
//         break;
//       case FallingObjectType.lifePenalty:
//         _livesNotifier.value -= 1;
//         break;
//       case FallingObjectType.gem:
//         _balanceNotifier.value += 1;
//         break;
//     }
//   }
//
//   void _gameOver() {
//     if (mounted && (_ticker?.isActive ?? true)) {
//       _ticker?.stop();
//       print("DEBUG: Ticker stopped in _gameOver.");
//     }
//
//     if (mounted) {
//       print("DEBUG: Navigating to GameOverScreen with score: ${_scoreNotifier
//           .value}");
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => GameOverScreen(score: _scoreNotifier.value),
//         ),
//       );
//     } else {
//       print(
//           "DEBUG: _gameOver called, but widget is not mounted. Cannot navigate.");
//     }
//   }
//
//   void _resetGame() {
//     print("DEBUG: _resetGame CALLED");
//     _scoreNotifier.value = 0;
//     _livesNotifier.value = 3;
//     _balanceNotifier.value = 0;
//
//     _characterHasAppeared = false;
//     _characterAppearanceController.reset();
//
//     if (mounted) {
//       _fallingObjects.clear();
//       _inactiveObjectsPool.clear();
//       _prepopulateObjectsPool();
//
//       _isCharacterReady = false;
//       _characterPosition = Offset.zero;
//       _lastObjectSpawnTime = null;
//       setState(() {});
//     }
//   }
//
//   void _updateCharacterPosition(Offset currentFingerPosition) {
//     if (!_isCharacterReady || _characterSize == Size.zero) {
//       if (mounted && !_isCharacterReady && _allAssetsLoaded &&
//           _poolPrepopulated) {
//         _determineCharacterSizeAndFixedY();
//       }
//       return;
//     }
//     bool directionChanged = false;
//     if (_lastFingerPosition != null) {
//       double dx = currentFingerPosition.dx - _lastFingerPosition!.dx;
//       if (dx > 2.0) {
//         if (_characterDirection != 'right') {
//           _characterDirection = 'right';
//           directionChanged = true;
//         }
//       }
//       else if (dx < -2.0) {
//         if (_characterDirection != 'left') {
//           _characterDirection = 'left';
//           directionChanged = true;
//         }
//       }
//     }
//     _lastFingerPosition = currentFingerPosition;
//     final screenSize = MediaQuery
//         .of(context)
//         .size;
//     double newX = currentFingerPosition.dx - (_characterSize.width / 2);
//     newX = newX.clamp(0.0, screenSize.width - _characterSize.width);
//     final newPosition = Offset(newX, _fixedCharacterY);
//     bool positionChanged = _characterPosition != newPosition;
//     if ((positionChanged || directionChanged) && mounted) {
//       setState(() {
//         if (positionChanged) _characterPosition = newPosition;
//       });
//     }
//   }
//
//   void _onInteractionEnd() {
//     _lastFingerPosition = null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print(
//         "DEBUG: build CALLED. AssetsPrecached: $_assetsPrecached, AllAssetsLoaded: $_allAssetsLoaded, PoolPrepopulated: $_poolPrepopulated, CharacterReady: $_isCharacterReady, HasAppeared: $_characterHasAppeared");
//
//     List<Widget> gameLayerWidgets = [];
//
//     if (_allAssetsLoaded && _poolPrepopulated) {
//       gameLayerWidgets.add(
//           Positioned(
//             left: _isCharacterReady ? _characterPosition.dx : -10000.0,
//             top: _isCharacterReady ? _characterPosition.dy : -10000.0,
//             child: ScaleTransition(
//               scale: _characterScaleAnimation,
//               child: FadeTransition(
//                 opacity: _characterOpacityAnimation,
//                 child: Container(
//                   key: _characterKey,
//                   child: PlayerCharacter(
//                     heroName: _selectedHero,
//                     direction: _characterDirection,
//                   ),
//                 ),
//               ),
//             ),
//           )
//       );
//
//       if (!_isCharacterReady && mounted) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           print(
//               "DEBUG: build -> addPostFrameCallback: Trying to determine character size.");
//           if (mounted && _allAssetsLoaded && _poolPrepopulated &&
//               !_isCharacterReady) {
//             _determineCharacterSizeAndFixedY();
//           }
//         });
//       }
//     }
//
//     if (_allAssetsLoaded && _poolPrepopulated && _isCharacterReady) {
//       gameLayerWidgets.addAll(_fallingObjects.map((obj) {
//         return Positioned(
//           key: ValueKey(obj.id),
//           left: obj.position.dx,
//           top: obj.position.dy,
//           child: Container(
//             width: obj.size.width,
//             height: obj.size.height,
//             child: Image.asset(obj.imagePath, fit: BoxFit.contain),
//           ),
//         );
//       }).toList());
//     } else if (!(_allAssetsLoaded && _poolPrepopulated && _isCharacterReady)) {
//       List<Widget> loadingWidgets = [];
//       if (_allAssetsLoaded && _poolPrepopulated &&
//           !gameLayerWidgets.any((w) => w.key == _characterKey)) {
//         loadingWidgets.add(
//             Opacity(
//               opacity: 0.0, // Should be initially invisible if not yet animated
//               child: IgnorePointer(
//                 ignoring: true, // Should not interact if not yet ready/animated
//                 child: Container(
//                   key: _characterKey,
//                   child: PlayerCharacter(
//                     heroName: _selectedHero,
//                     direction: _characterDirection,
//                   ),
//                 ),
//               ),
//             )
//         );
//       }
//       loadingWidgets.add(
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const CircularProgressIndicator(color: Colors.white),
//                 const SizedBox(height: 10),
//                 Text(
//                   !_allAssetsLoaded ? "Loading assets..."
//                       : !_poolPrepopulated ? "Preparing objects..."
//                       : "Initializing character...",
//                   style: const TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ],
//             ),
//           )
//       );
//       // Ensure that loadingWidgets are added to the main list if they contain something
//       if (loadingWidgets.isNotEmpty) {
//         gameLayerWidgets.addAll(loadingWidgets);
//       }
//     }
//
//     Widget mainGameLayer = Stack(children: gameLayerWidgets);
//
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(
//                 'assets/images/game_screen/${_selectedHero}_background.png'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Stack(
//           children: [
//             GestureDetector(
//               onPanStart: (details) {
//                 if (!_isCharacterReady && mounted && _allAssetsLoaded &&
//                     _poolPrepopulated) _determineCharacterSizeAndFixedY();
//                 _lastFingerPosition = details.localPosition;
//                 if (_isCharacterReady) _updateCharacterPosition(
//                     details.localPosition);
//               },
//               onPanUpdate: (details) {
//                 if (_isCharacterReady) _updateCharacterPosition(
//                     details.localPosition);
//               },
//               onPanEnd: (details) => _onInteractionEnd(),
//               onTapDown: (details) {
//                 if (!_isCharacterReady && mounted && _allAssetsLoaded &&
//                     _poolPrepopulated) _determineCharacterSizeAndFixedY();
//                 _lastFingerPosition = details.localPosition;
//                 if (_isCharacterReady) {
//                   final screenSize = MediaQuery
//                       .of(context)
//                       .size;
//                   double newX = details.localPosition.dx -
//                       (_characterSize.width / 2);
//                   newX =
//                       newX.clamp(0.0, screenSize.width - _characterSize.width);
//                   if (_characterPosition.dx != newX && mounted) {
//                     setState(() =>
//                     _characterPosition = Offset(newX, _fixedCharacterY));
//                   }
//                 }
//               },
//               onTapUp: (details) => _onInteractionEnd(),
//               child: Container(
//                 width: double.infinity,
//                 height: double.infinity,
//                 color: Colors.transparent,
//                 child: mainGameLayer,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(25, 40, 25, 0),
//               child: Center(
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(maxWidth: 400),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Row(
//                         children: <Widget>[
//                           PauseButton(
//                               onPressed: () {
//                                 _ticker?.stop();
//                                 Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(builder: (
//                                       context) => const PauseScreen()),
//                                 ).then((_) {
//                                   if (mounted && _ticker != null &&
//                                       !_ticker!.isActive &&
//                                       _livesNotifier.value > 0) {
//                                     _previousElapsed = Duration.zero;
//                                     _ticker!.start();
//                                   }
//                                 });
//                               }
//                           ),
//                           const Spacer(),
//                           ConstrainedBox(
//                             constraints: const BoxConstraints(maxWidth: 260),
//                             child: Stack(
//                               alignment: Alignment.center,
//                               children: <Widget>[
//                                 Image.asset(
//                                     'assets/images/game_screen/back_balance.png',
//                                     scale: 1.2),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: <Widget>[
//                                     ValueListenableBuilder<int>(
//                                       valueListenable: _balanceNotifier,
//                                       builder: (context, balance, child) {
//                                         return Text('$balance',
//                                             style: const TextStyle(
//                                                 fontFamily: 'ProtestStrike',
//                                                 fontSize: 24,
//                                                 color: Colors.white));
//                                       },
//                                     ),
//                                     const SizedBox(width: 5),
//                                     Image.asset(
//                                         'assets/images/game_screen/gem_icon.png',
//                                         scale: 1.8),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       const Text('SCORE', style: TextStyle(
//                           fontFamily: 'ProtestStrike',
//                           fontSize: 25,
//                           color: Colors.white)),
//                       ValueListenableBuilder<int>(
//                         valueListenable: _scoreNotifier,
//                         builder: (context, score, child) {
//                           return Text('$score', style: const TextStyle(
//                               fontFamily: 'ProtestStrike',
//                               fontSize: 25,
//                               color: Colors.white));
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
