import 'package:flutter/material.dart';
import 'package:blessing_of_olympus/app/screens/home_screen/home_screen.dart';
import 'package:blessing_of_olympus/app/widgets/custom_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _vibrationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/settings_screen/background.png'),
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
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/settings_screen/back_settings.png',
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(45, 0, 45, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _buildSettingsRow(
                              iconPath:
                                  'assets/images/settings_screen/sound_logo.png',
                              text: ' SOUND',
                              value: _soundEnabled,
                              onChanged: (bool value) {
                                setState(() {
                                  _soundEnabled = value;
                                });
                              },
                            ),
                            _buildSettingsRow(
                              iconPath:
                                  'assets/images/settings_screen/music_logo.png',
                              text: ' MUSIC',
                              value: _musicEnabled,
                              onChanged: (bool value) {
                                setState(() {
                                  _musicEnabled = value;
                                });
                              },
                            ),
                            _buildSettingsRow(
                              iconPath:
                                  'assets/images/settings_screen/vibration_logo.png',
                              text: ' VIBRATION',
                              value: _vibrationEnabled,
                              onChanged: (bool value) {
                                setState(() {
                                  _vibrationEnabled = value;
                                });
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                print('Privacy Tapped');
                              },
                              child: ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.white,
                                      Colors.purpleAccent[100]!,
                                    ],
                                  ).createShader(bounds);
                                },
                                child: const Text(
                                  'PRIVACY',
                                  style: TextStyle(
                                    fontFamily: 'ProtestStrike',
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                    decorationThickness: 1.5,
                                    fontSize: 21,
                                    color: Colors.white,
                                  ),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 360),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/settings_screen/back_title.png'),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text(
                        'SETTINGS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontFamily: 'ProtestStrike',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 300),
                child: CustomButton(
                  text: 'BACK',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(title: ''),
                      ),
                    );
                  },
                  color: ButtonColor.red,
                  size: ButtonSize.medium,
                  textSize: 27,
                  scale: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsRow({
    required String iconPath,
    required String text,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(iconPath, width: 24, height: 24),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontFamily: 'ProtestStrike',
            ),
          ),
          const Spacer(),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: Colors.purpleAccent[100]!,
            inactiveThumbColor: Colors.white70,
            inactiveTrackColor: Colors.grey.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
