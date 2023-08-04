import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
// flutter_dotenv 라이브러리의 기능
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'home_tap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');

  // 라이브러리 메모리에 appKey 등록
  // kakao JavaScript 키
  AuthRepository.initialize(appKey: dotenv.env['KAKAOKEY'] ?? '');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeTap(),
    );
  }
}
