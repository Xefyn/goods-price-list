import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:goods_list_item/Model/goods.dart';

class DatabaseHelper {

	static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
	static Database _database;                // Singleton Database

	String goodsTable = 'goods_table';
	String colId = 'id';
	String colName = 'name';
	String colBrand = 'brand';
  String colPrice = 'price';
	String colStore = 'store';
	String colNote = 'note';

	DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

	factory DatabaseHelper() {

		if (_databaseHelper == null) {
			_databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
		}
		return _databaseHelper;
	}

	Future<Database> get database async {

		if (_database == null) {
			_database = await initializeDatabase();
		}
		return _database;
	}

	Future<Database> initializeDatabase() async {
		// Get the directory path for both Android and iOS to store database.
		Directory directory = await getApplicationDocumentsDirectory();
		String path = directory.path + 'goods.db';

		// Open/create the database at a given path
		var goodsdatabase = await openDatabase(path, version: 1, onCreate: _createDb);
		return goodsdatabase;
	}

	void _createDb(Database db, int newVersion) async {

		await db.execute('CREATE TABLE $goodsTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colBrand TEXT, $colPrice TEXT, $colStore TEXT, $colNote TEXT)');
	}

	// Fetch Operation: Get all todo objects from database
	Future<List<Map<String, dynamic>>> getGoodsMapList() async {
		Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $todoTable order by $colTitle ASC');
		var result = await db.query(goodsTable, orderBy: '$colName ASC');
		return result;
	}

	// Insert Operation: Insert a todo object to database
	Future<int> insertGoods(Goods goods) async {
		Database db = await this.database;
		var result = await db.insert(goodsTable, goods.toMap());
		return result;
	}

	// Update Operation: Update a todo object and save it to database
	Future<int> updateGoods(Goods goods) async {
		var db = await this.database;
		var result = await db.update(goodsTable, goods.toMap(), where: '$colId = ?', whereArgs: [goods.id]);
		return result;
	}

  	Future<int> updateGoodsCompleted(Goods goods) async {
		var db = await this.database;
		var result = await db.update(goodsTable, goods.toMap(), where: '$colId = ?', whereArgs: [goods.id]);
		return result;
	}

	// Delete Operation: Delete a todo object from database
	Future<int> deleteGoods(int id) async {
		var db = await this.database;
		int result = await db.rawDelete('DELETE FROM $goodsTable WHERE $colId = $id');
		return result;
	}

	// Get number of todo objects in database
	Future<int> getCount() async {
		Database db = await this.database;
		List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $goodsTable');
		int result = Sqflite.firstIntValue(x);
		return result;
	}

	// Get the 'Map List' [ List<Map> ] and convert it to 'todo List' [ List<Todo> ]
	Future<List<Goods>> getGoodsList() async {

		var goodsMapList = await getGoodsMapList(); // Get 'Map List' from database
		int count = goodsMapList.length;         // Count the number of map entries in db table

		List<Goods> goodsList = List<Goods>();
		// For loop to create a 'todo List' from a 'Map List'
		for (int i = 0; i < count; i++) {
			goodsList.add(Goods.fromMapObject(goodsMapList[i]));
		}

		return goodsList;
	}

  Future<List<Goods>> getGoodsListWithQuery(String query) async {
    Database db = await this.database;

		var result = await db.query(
      goodsTable, 
      where: 'lower($colName) like ? or lower($colBrand) like ? or lower($colPrice) like ? or lower($colStore) like ? or lower($colNote) like ?',
      whereArgs: ['%$query%','%$query%','%$query%','%$query%','%$query%'],
      orderBy: '$colName ASC');
    
		int count = result.length;         // Count the number of map entries in db table

		List<Goods> goodsList = List<Goods>();
		// For loop to create a 'todo List' from a 'Map List'
		for (int i = 0; i < count; i++) {
			goodsList.add(Goods.fromMapObject(result[i]));
		}

		return goodsList;
	}

}
