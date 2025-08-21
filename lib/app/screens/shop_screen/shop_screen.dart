import 'package:flutter/material.dart';

// Предполагаемые импорты
import 'package:blessing_of_olympus/app/screens/home_screen/home_screen.dart';
import 'package:blessing_of_olympus/app/widgets/hero_card.dart'; // Обязательно!
import 'package:blessing_of_olympus/app/widgets/item_card.dart';

// Убедитесь, что HeroStatus в hero_card.dart содержит только selected, unselected, forSale
// enum HeroStatus {
//   selected,
//   unselected, // Означает: куплен, но не выбран
//   forSale,    // Означает: не куплен
// }

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late List<Map<String, dynamic>> heroesData;
  late int playerBalance;
  late Map<String, int> heroPrices;
  late Map<String, int> itemPrice;

  @override
  void initState() {
    super.initState();
    playerBalance = 6200; // TODO: Замените на актуальный баланс

    // Цены героев
    //todo: Замените на актуальные цены из файла
    heroPrices = {
      'zeus': 0, // Зевс "куплен" по умолчанию (цена 0)
      'athena': 500,
      'poseidon': 1000,
      'hades': 5000,
    };

    //todo: Замените на актуальные цены из файла
    itemPrice = {
      'magnet': 350,
      'lightning': 350,
      'shield': 350,
    };

    heroesData = [
      {
        'name': 'zeus',
        // Зевс куплен и выбран по умолчанию
        'status': HeroStatus.selected,
        'price': heroPrices['zeus']!,
      },
      {
        'name': 'athena',
        // Афина не куплена по умолчанию
        'status': HeroStatus.forSale,
        'price': heroPrices['athena']!,
      },
      {
        'name': 'poseidon',
        'status': HeroStatus.forSale,
        'price': heroPrices['poseidon']!,
      },
      {
        'name': 'hades',
        'status': HeroStatus.forSale,
        'price': heroPrices['hades']!,
      },
    ];

    // Начальная коррекция статусов: если цена 0, герой считается "купленным" (unselected),
    // если он не выбран по умолчанию.
    bool isAnySelected = heroesData.any(
      (hero) => hero['status'] == HeroStatus.selected,
    );
    for (var hero in heroesData) {
      if (hero['price'] == 0 && hero['status'] != HeroStatus.selected) {
        hero['status'] = HeroStatus
            .unselected; // Бесплатный становится "купленным, но не выбранным"
      }
    }
  }

  void _handleHeroSelection(String heroNameToSelect) {
    final heroToSelectData = heroesData.firstWhere(
      (hero) => hero['name'] == heroNameToSelect,
    );

    // Можно выбирать только тех, кто НЕ forSale (т.е. selected или unselected)
    if (heroToSelectData['status'] == HeroStatus.forSale) {
      print(
        "Cannot select hero $heroNameToSelect because they are for sale (not purchased).",
      );
      return;
    }

    // Если герой уже выбран, ничего не делаем
    if (heroToSelectData['status'] == HeroStatus.selected) {
      print("Hero $heroNameToSelect is already selected.");
      return;
    }

    setState(() {
      // Сначала всем героям, которые были 'selected', ставим 'unselected' (куплен, но не выбран)
      for (var heroData in heroesData) {
        if (heroData['status'] == HeroStatus.selected) {
          heroData['status'] = HeroStatus.unselected;
        }
      }
      // Затем герою, которого выбрали (он должен быть unselected), ставим 'selected'
      heroToSelectData['status'] = HeroStatus.selected;
      print(
        "Selected hero: $heroNameToSelect. Updated heroesData: $heroesData",
      );
    });
  }

  void _handleHeroPurchase(String heroNameToPurchase) {
    final heroToPurchaseData = heroesData.firstWhere(
      (hero) => hero['name'] == heroNameToPurchase,
    );
    final int price = heroToPurchaseData['price'];

    if (playerBalance >= price) {
      setState(() {
        playerBalance -= price;
        // После покупки герой становится 'unselected' (куплен, но не выбран)
        heroToPurchaseData['status'] = HeroStatus.unselected;
      });
    }
  }

  HeroStatus _getHeroStatus(String heroName) {
    try {
      return heroesData.firstWhere(
        (hero) => hero['name'] == heroName,
      )['status'];
    } catch (e) {
      return HeroStatus.forSale; // По умолчанию, если что-то пошло не так
    }
  }

  int _getHeroPrice(String heroName) {
    try {
      return heroesData.firstWhere((hero) => hero['name'] == heroName)['price'];
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ... (остальная часть декораций фона и градиента остается прежней) ...
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  // Секция с балансом и заголовком
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
                                Text(
                                  '$playerBalance',
                                  // Отображаем актуальный баланс
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
                  // Секция с карточками героев и кнопкой назад
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/shop_screen/shop_back.png',
                      scale: 1.2,
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(35, 20, 35, 0),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 300),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: HeroCard(
                                        heroName: 'zeus',
                                        status: _getHeroStatus('zeus'),
                                        price: _getHeroPrice('zeus'),
                                        onSelected: () =>
                                            _handleHeroSelection('zeus'),
                                        onPurchaseAttempt: () =>
                                            _handleHeroPurchase('zeus'),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: HeroCard(
                                        heroName: 'athena',
                                        status: _getHeroStatus('athena'),
                                        price: _getHeroPrice('athena'),
                                        onSelected: () =>
                                            _handleHeroSelection('athena'),
                                        onPurchaseAttempt: () =>
                                            _handleHeroPurchase('athena'),
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
                                        status: _getHeroStatus('poseidon'),
                                        price: _getHeroPrice('poseidon'),
                                        onSelected: () =>
                                            _handleHeroSelection('poseidon'),
                                        onPurchaseAttempt: () =>
                                            _handleHeroPurchase('poseidon'),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: HeroCard(
                                        heroName: 'hades',
                                        status: _getHeroStatus('hades'),
                                        price: _getHeroPrice('hades'),
                                        onSelected: () =>
                                            _handleHeroSelection('hades'),
                                        onPurchaseAttempt: () =>
                                            _handleHeroPurchase('hades'),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  // Ваши ItemCard остаются без изменений
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: ItemCard(
                                        itemName: 'magnet',
                                        price: itemPrice['magnet'] ?? 0,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: ItemCard(
                                        itemName: 'lightning',
                                        price: itemPrice['lightning'] ?? 0,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: ItemCard(
                                        itemName: 'shield',
                                        price: itemPrice['shield'] ?? 0,
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
                    Padding(
                      // Кнопка "Назад"
                      padding: EdgeInsets.fromLTRB(0, 420, 0, 0),
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
