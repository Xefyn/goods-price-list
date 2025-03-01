import 'dart:async';
import 'package:flutter/material.dart';
import 'package:goods_list_item/Model/goods.dart';
import 'package:goods_list_item/Screen/goodsDetail.dart';
import 'package:goods_list_item/Util/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class GoodsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GoodsListState();
  }
}

class GoodsListState extends State<GoodsList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Goods> goodsList;
  int count = 0;

  Icon customIcon = Icon(Icons.search);
  Widget customTitle = Text("Barang");
  FocusNode focusSearchbar = FocusNode();

  bool isShowDeleted = false;

  @override
  Widget build(BuildContext context) {
    if (goodsList == null) {
      goodsList = List<Goods>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: customTitle,
        backgroundColor: Colors.blue.shade800,
        actions: <Widget>[
          IconButton(
            icon: customIcon, 
            onPressed: (){
              setState((){
                if(this.customIcon.icon == Icons.search){
                  this.customIcon = Icon(Icons.cancel);
                  this.customTitle = TextField(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0
                    ),
                    focusNode: focusSearchbar,
                    onSubmitted: (query){
                      updateListViewWithQuery(query);
                    },
                  );
                  focusSearchbar.requestFocus();
                }else{
                  this.customIcon = Icon(Icons.search);
                  this.customTitle = Text("Barang");
                  updateListView();
                }
              });
            }
          ),
          IconButton(
            icon: Icon(Icons.delete), 
            onPressed: (){
              isShowDeleted = !isShowDeleted;
              isShowDeleted? updateListViewWithDeleted() : updateListView();
            }
          ),
        ],
      ),
      body: getGoodsListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Goods('', '', '', '' ,'-', 0), 'Add Barang');
        },
        tooltip: 'Add Barang',
        backgroundColor: Colors.blue.shade800,
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getGoodsListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(getFirstLetter(this.goodsList[position].name),
              style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(this.goodsList[position].name,
            style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Merk: '+this.goodsList[position].brand
            +'\nHarga: '+this.goodsList[position].price.toString()
            +'\nStore: '+this.goodsList[position].store
            +'\nNote: '+this.goodsList[position].note),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: isShowDeleted ? Icon(Icons.delete_forever,color: Colors.black,) : Icon(Icons.delete,color: Colors.red,),
                  onTap: () {
                    confirmAlertDialog(position);
                  },
                ),
              ],
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(this.goodsList[position], 'Edit Barang');
            },
          ),
        );
      },
    );
  }

  getFirstLetter(String title) {
    return title.substring(0, 2);
  }

 
  void _delete(BuildContext context, Goods goods) async {
    int result = await databaseHelper.deleteGoods(goods.id);
    if (result != 0) {
      _showSnackBar(context, 'Barang berhasil di delete');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Goods goods, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return GoodsDetail(goods, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Goods>> goodsListFuture = databaseHelper.getGoodsList();
      goodsListFuture.then((goodsList) {
        setState(() {
          this.goodsList = goodsList;
          this.count = goodsList.length;
        });
      });
    });
  }

  void updateListViewWithQuery(String query) {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Goods>> goodsListFuture = databaseHelper.getGoodsListWithQuery(query);
      goodsListFuture.then((goodsList) {
        setState(() {
          this.goodsList = goodsList;
          this.count = goodsList.length;
        });
      });
    });
  }

  void updateListViewWithDeleted() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Goods>> goodsListFuture = databaseHelper.getGoodsListWithDeleted();
      goodsListFuture.then((goodsList) {
        setState(() {
          this.goodsList = goodsList;
          this.count = goodsList.length;
          debugPrint(goodsList.length.toString());
        });
      });
    });
  }

  void confirmAlertDialog(int position){
    AlertDialog dialog =  AlertDialog(
      content: Text('Are you sure you want to delete this?'),
      actions: <Widget>[
        FlatButton(
          child: Text('Yes'),
          onPressed: () {
            _delete(context, goodsList[position]);
            updateListView();
            Navigator.of(context).pop(false);
          },
        ),
        FlatButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
    showDialog(
				context: context,
				builder: (_) => dialog
		);
  }
}