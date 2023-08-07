import 'package:get/get.dart';

class WishListControllerObs extends GetxController{
  var apartmentStar = "false".obs;

  void setApartmentStar(String star){
    apartmentStar.value = star;
    update();
  }
}