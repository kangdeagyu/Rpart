class SearchSql{
  int? seq;
  String content;

  SearchSql(
    {
      this.seq,
      required this.content
    }
  );

  SearchSql.fromMap(Map<String, dynamic> res)
    : seq = res['seq'],
      content = res['content'];

    Map<String, Object?> toMap(){
    return {
      'seq': seq,
      'content':content,
    };
  }
}
