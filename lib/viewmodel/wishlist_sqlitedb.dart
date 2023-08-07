import 'package:fluttermainproject/model/wishlist_sqlite/wishlist_sqllite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class WishlistDatabaseHandler {
  Future<Database> initiallizeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'userwishlist.db'), // path로 경로를 찾아서 들어가서 불러온다.
      onCreate: (db, version) async {
        // 데이터베이스가 없으면 실행
        await db.execute(
            'create table wishlist(seq integer primary key autoincrement, aptname text)');
      },
      version: 1,
    );
  }

  // 타입 정의는 Future로 끝나 제너릭에서 생성자로 만든 Students를 넣어줌
  Future<List<WishlistSql>> queryWishList() async {
    final Database db = await initiallizeDB();
    final List<Map<String, Object?>> queryResults =
        await db.rawQuery('select * from wishlist');
    return queryResults.map((e) => WishlistSql.fromMap(e)).toList();
  }

  Future<List<WishlistSql>> queryWishListstar(String aptData) async {
    final Database db = await initiallizeDB();
    final List<Map<String, Object?>> queryResults =
        await db.rawQuery('select * from wishlist where aptname = ?', [aptData]);
    return queryResults.map((e) => WishlistSql.fromMap(e)).toList();
  }

  Future<int> insertWishList(String aptData) async {
    int result = 0;
    final Database db = await initiallizeDB();
    var dbcontent = await db.rawQuery(
        'select * from wishlist where aptname = ?', [aptData]);
    if(dbcontent.isEmpty){
      result = await db
          .rawInsert('insert into wishlist(aptname) values (?)', [aptData]);    
    }

    return result;
  }

  // 삭제
  Future<void> deleteWishList(String aptData) async {
    final Database db = await initiallizeDB();
    await db.rawDelete('delete from wishlist where aptname = ?', [aptData]);
  }


}