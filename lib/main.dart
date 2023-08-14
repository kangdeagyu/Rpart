import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fluttermainproject/firebase_options.dart';
import 'package:fluttermainproject/viewmodel/prediction_provider.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
// flutter_dotenv 라이브러리의 기능
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'home_tap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');
  // 라이브러리 메모리에 appKey 등록
  // kakao JavaScript 키
  AuthRepository.initialize(appKey: dotenv.env['KAKAOKEY'] ?? '');
  // kakao login 키
  KakaoSdk.init(nativeAppKey: '30511460539a0b5b8ba3095c9afa7f76'); // 이 줄을 runApp 위에 추가한다.


  // firebase 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Prediction(),
      child: GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: AnimatedSplashScreen(
          splash: Image.asset("images/loding.gif"), 
          nextScreen: const HomeTap(),
          
        ),
        getPages: [
          GetPage(name: '/next', page: () => HomeTap()),
        ],
      ),
    );
  }
}
