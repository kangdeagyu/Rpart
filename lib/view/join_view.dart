import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  State<JoinPage> createState() => JoinPageState();
}

class JoinPageState extends State<JoinPage> {
  late TextEditingController useridController; // 아이디
  late TextEditingController passwordController; // 비밀번호
  late TextEditingController addressController; //주소
  late TextEditingController phoneController; //핸드폰번호

  @override
  void initState() {
    super.initState();
    useridController = TextEditingController();
    passwordController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: useridController,
                decoration: const InputDecoration(
                  labelText: '아이디을 입력해주세요',
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: '비밀번호를 입력해주세요',
                ),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: '주소를 입력해주세요'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: '전화번호를 입력해주세요',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      //텍스트 필드 미입력시 팝업
                      onPressed: () {
                        if (useridController.text.trim().isEmpty) {
                          Get.snackbar(
                            '알림',
                            '아이디를 입력해주세요.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else if (passwordController.text.trim().isEmpty) {
                          Get.snackbar(
                            '알림',
                            '패스워드를 입력해주세요.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else if (addressController.text.trim().isEmpty) {
                          Get.snackbar(
                            '알림',
                            '주소를 입력해주세요.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else if (phoneController.text.trim().isEmpty) {
                          Get.snackbar(
                            '알림',
                            '전화번호를 입력해주세요.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else {
                          // 이전 화면으로 돌아가기
                          insertAction();
                          Get.back();
                        }
                      },
                      child: const Text('회원가입'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child:const Text('취소하기')),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              
                
            ],
          ),
        ),
      ),
    );
  }
  insertAction() async {
    var url = Uri.parse(
        'http://localhost:8080/Flutter/login_insert_flutter.jsp?userid=${useridController.text}&password=${passwordController.text}&address=${addressController.text}&phone=${phoneController.text}');
    await http.get(url);
    _showDialog();
  }
  
  _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('입력'),
          content: Text('${useridController.text}회원님의 입력이 완료 되었습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}