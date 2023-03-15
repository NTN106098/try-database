import 'dart:developer';

import 'package:connect_mongodb/dbHelper/constants.dart';
import 'package:connect_mongodb/models/mongoDb_model.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  // static connect() async {
  //   var db= await Db.create(MONGO_URL);
  //   await db.open();
  //   inspect(db);
  //   var status = db.serverStatus();
  //   print(status);
  //   var  collection = db.collection(COLLECTION_NAME);
  //   await collection.insertMany([
  //     {
  //       "username": "nghia-1",
  //       "name":"Nghia Nguyen",
  //       "email":"nghianguyen.js1060@gmail.com"
  //     },
  //     {
  //       "username": "nghia-2",
  //       "name":"Nghia Nguyen",
  //       "email":"nghianguyen.js1060@gmail.com"
  //     },
  //     {
  //       "username": "nghia-3",
  //       "name":"Nghia Nguyen",
  //       "email":"nghianguyen.js1060@gmail.com"
  //     }
  //   ]);
  //   print(await collection.find().toList());
  //
  //   // await collection.update(where.eq('username', 'nghia'), modify.set('name', 'nghia-0'));
  //   // await collection.update(selector, document)
  // }

  static var db, userCollection;
  static connect() async {
    db = await Db.create(MONGO_URL);
    await db.open();
    // inspect(db);
    // var status = db.serverStatus();
    // print(status);
    inspect(db);

    userCollection = db.collection(COLLECTION_NAME);
    // print(await userCollection.find().toList());
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final arrData = await userCollection.find().toList();
    return arrData;
  }

  static Future<void> update(MongoDbModel data) async {
    var result = await userCollection.findOne({"_id": data.id});
    result['firstname'] = data.firstname;
    result['lastname'] = data.lastname;
    result['address'] = data.address;
    var response = await userCollection.save(result);
    insert(response);
  }

  static Future<String> insert(MongoDbModel data) async {
    try {
      var result = await userCollection.insertOne(data.toJson());
      if (result.isSuccess) {
        return "Data Inserted";
      } else {
        return "Something Wrong while inserting data.";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
