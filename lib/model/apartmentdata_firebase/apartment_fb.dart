
class ApartmentFB{
  int id;
  int year;              // 건축년도
  String x;              // 경도
  String contract;       // 계약시점
  double rate;           // 계약시점기준금리
  String apartmentName;  // 단지명
  String rodeName;       // 도로명
  String streetAddress;  // 번지
  int deposit;           // 보증금
  String subway;            // 역거리
  String subwayName;     // 역이름
  String y;              // 위도
  double extent;         // 임대면적
  String station;           // 정류장이름
  int stationCount;    //주변정류장개수
  int floor;              // 층
  String line;          // 호선

  ApartmentFB(
    {
      required this.id,
      required this.year,
      required this.x,
      required this.contract,
      required this.rate,
      required this.apartmentName,
      required this.rodeName,
      required this.streetAddress,
      required this.deposit,
      required this.line,
      required this.subwayName,
      required this.stationCount,
      required this.y,
      required this.extent,
      required this.station,
      required this.subway,
      required this.floor,
    }
  );

}