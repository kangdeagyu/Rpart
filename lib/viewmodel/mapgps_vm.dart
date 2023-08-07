import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class MapGPS extends GetxController{
  // 사용자 위치를 비동기적으로 얻어오는 함수
  Future<Position?> getCurrentLocation() async {
    try {
      // 위치 권한을 확인하고, 권한이 있는 경우 사용자의 현재 위치를 얻어옴
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }
      // 사용자의 현재 위치를 얻어와서 반환
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      update();
      return position;
    } catch (e) {
      return null;
    }
  }
}