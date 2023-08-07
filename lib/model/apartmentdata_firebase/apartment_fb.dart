
class ApartmentFB{
  int year;              // 건축년도
  double x;              // 경도
  String contract;       // 계약시점
  double rate;           // 계약시점기준금리
  String apartmentName;  // 단지명
  String rodeName;       // 도로명
  int streetAddress;  // 번지
  int deposit;           // 보증금
  String city;           // 시군구
  double y;              // 위도
  double extent;         // 임대면적
  int station;           // 정류장수
  int subway;            // 지하철역거리
  int floor;              // 층

  ApartmentFB(
    {
      required this.year,
      required this.x,
      required this.contract,
      required this.rate,
      required this.apartmentName,
      required this.rodeName,
      required this.streetAddress,
      required this.deposit,
      required this.city,
      required this.y,
      required this.extent,
      required this.station,
      required this.subway,
      required this.floor,
    }
  );

}