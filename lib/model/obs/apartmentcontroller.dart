import 'package:get/get.dart';

class ApartmentControllerObs extends GetxController{
  var apartmentName = "".obs;

  void setApartmentName(String name){
    apartmentName.value = name;
  }
}