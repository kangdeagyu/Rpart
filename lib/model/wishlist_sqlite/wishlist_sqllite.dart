class WishlistSql{
  int? seq;
  String aptname;

  WishlistSql(
    {
      this.seq,
      required this.aptname
    }
  );

  WishlistSql.fromMap(Map<String, dynamic> res)
    : seq = res['seq'],
      aptname = res['aptname'];

    Map<String, Object?> toMap(){
    return {
      'seq': seq,
      'aptname':aptname,
    };
  }

}