import 'dart:async';
import 'package:flutter/material.dart';
import 'package:goods_list_item/Model/goods.dart';
import 'package:goods_list_item/Util/database_helper.dart';
import 'package:intl/intl.dart';

class GoodsDetail extends StatefulWidget {

	final String appBarTitle;
	final Goods goods;

	GoodsDetail(this.goods, this.appBarTitle);

	@override
  State<StatefulWidget> createState() {

    return GoodsDetailState(this.goods, this.appBarTitle);
  }
}

class GoodsDetailState extends State<GoodsDetail> {

	//static var _priorities = ['High', 'Low'];

	DatabaseHelper helper = DatabaseHelper();

	String appBarTitle;
	Goods goods;

	TextEditingController nameController = TextEditingController();
	TextEditingController brandController = TextEditingController();
	TextEditingController priceController = TextEditingController();
	TextEditingController storeController = TextEditingController();
	TextEditingController noteController = TextEditingController();

	GoodsDetailState(this.goods, this.appBarTitle);

	@override
  Widget build(BuildContext context) {

		TextStyle textStyle = Theme.of(context).textTheme.subtitle2;

		nameController.text = goods.name;
		brandController.text = goods.brand;
		priceController.text = goods.price;
		storeController.text = goods.store;
		noteController.text = goods.note;

    return WillPopScope(

	    onWillPop: () {
	    	// Write some code to control things, when user press Back navigation button in device navigationBar
		    moveToLastScreen();
	    },

	    child: Scaffold(
	    appBar: AppBar(
		    title: Text(appBarTitle),
		    leading: IconButton(icon: Icon(
				    Icons.arrow_back),
				    onPressed: () {
		    	    // Write some code to control things, when user press back button in AppBar
		    	    moveToLastScreen();
				    }
		    ),
	    ),

	    body: Padding(
		    padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
		    child: ListView(
			    children: <Widget>[

			    	// First element
				    // ListTile(
					  //   title: DropdownButton(
						// 	    items: _priorities.map((String dropDownStringItem) {
						// 	    	return DropdownMenuItem<String> (
						// 			    value: dropDownStringItem,
						// 			    child: Text(dropDownStringItem),
						// 		    );
						// 	    }).toList(),

						// 	    style: textStyle,

						// 	    value: getPriorityAsString(todo.priority),

						// 	    onChanged: (valueSelectedByUser) {
						// 	    	setState(() {
						// 	    	  debugPrint('User selected $valueSelectedByUser');
						// 	    	  updatePriorityAsInt(valueSelectedByUser);
						// 	    	});
						// 	    }
					  //   ),
				    // ),

				    // Second Element
				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: TextField(
						    controller: nameController,
						    style: textStyle,
						    onChanged: (value) {
						    	debugPrint('Something changed in Name Text Field');
						    	updateTitle();
						    },
						    decoration: InputDecoration(
							    labelText: 'Nama Barang',
							    labelStyle: textStyle,
							    border: OutlineInputBorder(
								    borderRadius: BorderRadius.circular(10.0)
							    )
						    ),
					    ),
				    ),

				    // Third Element
				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: TextField(
						    controller: brandController,
						    style: textStyle,
						    onChanged: (value) {
							    debugPrint('Something changed in Brand Text Field');
							    updateDescription();
						    },
						    decoration: InputDecoration(
								    labelText: 'Merk Barang',
								    labelStyle: textStyle,
								    border: OutlineInputBorder(
										    borderRadius: BorderRadius.circular(10.0)
								    )
						    ),
					    ),
				    ),

            // price
            Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: TextField(
						    controller: priceController,
						    style: textStyle,
                keyboardType: TextInputType.number,
						    onChanged: (value) {
							    debugPrint('Something changed in Price Text Field');
							    updatePrice();
						    },
						    decoration: InputDecoration(
								    labelText: 'Harga Barang',
								    labelStyle: textStyle,
								    border: OutlineInputBorder(
										    borderRadius: BorderRadius.circular(10.0)
								    )
						    ),
					    ),
				    ),

            // store
            Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: TextField(
						    controller: storeController,
						    style: textStyle,
						    onChanged: (value) {
							    debugPrint('Something changed in Store Text Field');
							    updateStore();
						    },
						    decoration: InputDecoration(
								    labelText: 'Nama Toko',
								    labelStyle: textStyle,
								    border: OutlineInputBorder(
										    borderRadius: BorderRadius.circular(10.0)
								    )
						    ),
					    ),
				    ),

            // note
            Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: TextField(
						    controller: noteController,
						    style: textStyle,
						    onChanged: (value) {
							    debugPrint('Something changed in Note Text Field');
							    updateNote();
						    },
						    decoration: InputDecoration(
								    labelText: 'Note',
								    labelStyle: textStyle,
								    border: OutlineInputBorder(
										    borderRadius: BorderRadius.circular(10.0)
								    )
						    ),
					    ),
				    ),

				    // Fourth Element
				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: Row(
						    children: <Widget>[
						    	Expanded(
								    child: RaisedButton(
									    color: Theme.of(context).primaryColorDark,
									    textColor: Theme.of(context).primaryColorLight,
									    child: Text(
										    'Save',
										    textScaleFactor: 1.5,
									    ),
									    onPressed: () {
									    	setState(() {
									    	  debugPrint("Save button clicked");
									    	  _save();
									    	});
									    },
								    ),
							    ),

							    Container(width: 5.0,),

							    Expanded(
								    child: RaisedButton(
									    color: Theme.of(context).primaryColorDark,
									    textColor: Theme.of(context).primaryColorLight,
									    child: Text(
										    'Delete',
										    textScaleFactor: 1.5,
									    ),
									    onPressed: () {
										    setState(() {
											    debugPrint("Delete button clicked");
											    _delete();
										    });
									    },
								    ),
							    ),

						    ],
					    ),
				    ),


			    ],
		    ),
	    ),

    ));
  }

  void moveToLastScreen() {
		Navigator.pop(context, true);
  }

	// Convert the String priority in the form of integer before saving it to Database
	// void updatePriorityAsInt(String value) {
	// 	switch (value) {
	// 		case 'High':
	// 			todo.priority = 1;
	// 			break;
	// 		case 'Low':
	// 			todo.priority = 2;
	// 			break;
	// 	}
	// }

	// Convert int priority to String priority and display it to user in DropDown
	// String getPriorityAsString(int value) {
	// 	String priority;
	// 	switch (value) {
	// 		case 1:
	// 			priority = _priorities[0];  // 'High'
	// 			break;
	// 		case 2:
	// 			priority = _priorities[1];  // 'Low'
	// 			break;
	// 	}
	// 	return priority;
	// }

	// Update the title of todo object
  void updateTitle(){
    goods.name = nameController.text;
  }

	// Update the description of todo object
	void updateDescription() {
		goods.brand = brandController.text;
	}

  void updatePrice() {
    debugPrint(priceController.text.toString());
		goods.price = priceController.text.toString();
	}

  void updateStore() {
    goods.store = storeController.text;
	}

  void updateNote() {
    goods.note = noteController.text;
	}

	// Save data to database
	void _save() async {

		moveToLastScreen();
		int result;
		if (goods.id != null) {  // Case 1: Update operation
			result = await helper.updateGoods(goods);
		} else { // Case 2: Insert Operation
			result = await helper.insertGoods(goods);
		}

		if (result != 0) {  // Success
			_showAlertDialog('Status', 'Goods Saved Successfully');
		} else {  // Failure
			_showAlertDialog('Status', 'Problem Saving Todo');
		}

	}


	void _delete() async {

		moveToLastScreen();

		// Case 1: If user is trying to delete the NEW todo i.e. he has come to
		// the detail page by pressing the FAB of todoList page.
		if (goods.id == null) {
			_showAlertDialog('Status', 'No Todo was deleted');
			return;
		}

		// Case 2: User is trying to delete the old todo that already has a valid ID.
		int result = await helper.deleteGoods(goods.id);
		if (result != 0) {
			_showAlertDialog('Status', 'Todo Deleted Successfully');
		} else {
			_showAlertDialog('Status', 'Error Occured while Deleting Todo');
		}
	}

	void _showAlertDialog(String title, String message) {

		AlertDialog alertDialog = AlertDialog(
			title: Text(title),
			content: Text(message),
		);
		showDialog(
				context: context,
				builder: (_) => alertDialog
		);
	}

}

