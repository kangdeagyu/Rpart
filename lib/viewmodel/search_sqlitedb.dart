import 'package:fluttermainproject/model/search/search_sqlite.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler extends GetxController {
  Future<Database> initiallizeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'searchlist.db'), // path로 경로를 찾아서 들어가서 불러온다.
      onCreate: (db, version) async {
        // 데이터베이스가 없으면 실행
        await db.execute(
            'create table search(seq integer primary key autoincrement, content text)');
      },
      version: 1,
    );
  }

  // 타입 정의는 Future로 끝나 제너릭에서 생성자로 만든 Students를 넣어줌
  Future<List<SearchSql>> querySearch() async {
    final Database db = await initiallizeDB();
    final List<Map<String, Object?>> queryResults =
        await db.rawQuery('select * from search');
    update();
    return queryResults.map((e) => SearchSql.fromMap(e)).toList();
  }

  Future<int> insertSearch(String searchData) async {
    int result = 0;
    final Database db = await initiallizeDB();
    var dbcontent = await db.rawQuery(
        'select * from search where content = ?', [searchData]);
    if(dbcontent.isEmpty){
      result = await db
          .rawInsert('insert into search(content) values (?)', [searchData]);    
    }
    update();
    return result;
  }

  // 삭제
  Future<void> deleteSearch(int seq) async {
    final Database db = await initiallizeDB();
    await db.rawDelete('delete from search where seq = ?', [seq]);
  }
}
