import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper{
  static const  _databasename = "dbms.db";
  static const _dataversion = 1;
  static const table = "Login";
  static const columnUsername = 'username';
  static const columnPassword = 'password';
  static const columnRole = 'role';
  static const columnProductName = 'product_name';
  static const columnProductPrice= 'price';
  static const columnStatus = 'status';
  static const columnProductId = 'product_id';
  static const columnLocation1 = 'location1';
  static const columnLocation2 = 'location2';
  static const columnLocation3 = 'location3';

  static Database? _database;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();



  Future<Database?> get database async{
    if(_database != null) {
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async{
  Directory documentdirectory = await getApplicationDocumentsDirectory();
  String path =join(documentdirectory.path,_databasename);
  return await openDatabase(path,version:_dataversion,onCreate: _onCreate);
  }


  Future _onCreate(Database db,int version) async{
     await db.execute(
       '''
       CREATE TABLE $table (
        $columnUsername VARCHAR(20) PRIMARY KEY,
        $columnPassword VARCHAR(20) NOT NULL,
        $columnRole VARCHAR(20) NOT NULL
       );
       '''
     );
     await db.execute(
         '''
       CREATE TABLE User_Detail(
         username VARCHAR(20),
         phone_number VARCHAR(20),
         email VARCHAR(20),
         FOREIGN KEY (username) REFERENCES Login(username)
       );
       '''
     );
     await db.execute(
         '''
       CREATE TABLE Product(
         product_id INT PRIMARY KEY,
         product_name VARCHAR(20),
         price VARCHAR(20),
         username VARCHAR(20),
         status VARCHAR(20),
         FOREIGN KEY (username) REFERENCES Login(username)
      );
       '''
     );
     await db.execute(
         '''
       INSERT INTO Product Values(1,'sample','100','user','manufactured');
       '''
     );
     await db.execute(
         '''
       CREATE TABLE Location(
          product_id INT PRIMARY KEY,
          location1 VARCHAR(20),
          location2 VARCHAR(20),
          location3 VARCHAR(20),
          FOREIGN KEY (product_id) REFERENCES Product(product_id) 
        );
       '''
     );
     await db.execute(
         '''
         CREATE Table App_Review(
         username VARCHAR(20) PRIMARY KEY,
         rating INT,
         description VARCHAR(20),
         role VARCHAR(20)
        );
       '''
     );


  }


  // insert into tables

  // Insert into Login
  Future<int> insertLogin(Map<String,dynamic> row )  async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  //Insert into User_Detail
  Future<int> insertUserDetail(Map<String,dynamic> row )  async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  // Insert into Product
  Future<int> insertProduct(Map<String,dynamic> row )  async {
    Database? db = await instance.database;
    return await db!.insert('Product', row);
  }

  //Insert into Location
  Future<int> insertLocation(Map<String,dynamic> row )  async {
    Database? db = await instance.database;
    return await db!.insert('Location', row);
  }

  //Insert into App_Review
  Future<int> insertAppReview(Map<String,dynamic> row )  async {
    Database? db = await instance.database;
    return await db!.insert('App_Review', row);
  }


  //query all
  Future<List<Map<String,dynamic>>> queryAll() async{
    Database? db = await instance.database;
    return await db!.query(table);
  }
  Future<List<Map<String,dynamic>>> queryAllProduct() async{
    Database? db = await instance.database;
    return await db!.query('Product');
  }

  Future<List<Map<String,dynamic>>> redirect(String username) async{
    Database? db = await instance.database;
    var res = await db!.rawQuery(
        '''
          SELECT * FROM $table 
          WHERE $columnUsername = ?; 
        ''',[username]);
     return res;
  }

  Future<List<Map<String,dynamic>>> getProductCount() async{
    Database? db = await instance.database;
    var res = await db!.rawQuery(
        '''
          SELECT COUNT(*) FROM Product; 
        ''',);
    return res;
  }
  Future<List<Map<String,dynamic>>> getProducts() async{
    Database? db = await instance.database;
    var res = await db!.rawQuery(
      '''
          SELECT * FROM Product; 
        ''',);
    return res;
  }

  void insertLocation2(int pid,String loc2) async{

    Database? db = await instance.database;
     await db!.rawUpdate(''' 
         UPDATE Location
         SET location2 = ?
         WHERE product_id = ?
    ''',[loc2,pid]);

     await db.rawUpdate(''' 
      UPDATE Product
      SET status = 'Shipped';
     ''');
  }

  Future<List<Map<String,dynamic>>> getLocations() async{
    Database? db = await instance.database;
    var res = await db!.rawQuery(
        '''
          SELECT * from Location ;
        ''');
    return res;
  }

  Future<List<Map<String,dynamic>>> getProductInfo(int proID) async{
    Database? db = await instance.database;
    var res = await db!.rawQuery(
        '''
          SELECT * from Product 
          WHERE product_id = ?;
        ''',[proID]);
    return res;
  }

}

 class User{
  late String username;
  late String password;
  late String role;
  // Constructor
  User(this.username,this.password,this.role);


  factory User.fromJson(Map<String, dynamic> Json){
  return User(
    Json['username'] as String,
    Json['password'] as String,
    Json['role'] as String
   );
  }

  }

  // from JSON

