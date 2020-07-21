class Goods {

	int _id;
	String _name;
	String _brand;
	int _price;
	String _store;
	String _note;

	Goods(this._name, this._brand, this._price, this._store, this._note);

	Goods.withId(this._id, this._name, this._brand, this._price, this._store, this._note);

	int get id => _id;

	String get name => _name;

	String get brand => _brand;

	int get price => _price;

	String get store => _store;

	String get note => _note;

	set name(String newName) {
		if (newName.length <= 255) {
			this._name = newName;
		}
	}

  set price(int newPrice) {
		this._price = newPrice;
	}
  
  set brand(String newBrand) {
		this._brand = newBrand;
	}

	set store(String newStore) {
		if (newStore.length <= 255) {
			this._store = newStore;
		}
	}

  set note(String newNote) {
		this._note = newNote;
	}
	

	// Convert a Note object into a Map object
	Map<String, dynamic> toMap() {

		var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = _id;
		}
		map['name'] = _name;
		map['brand'] = _brand;
		map['price'] = _price;
		map['store'] = _store;
		map['note'] = _note;

		return map;
	}

	// Extract a Note object from a Map object
	Goods.fromMapObject(Map<String, dynamic> map) {
		this._id = map['id'];
		this._name = map['name'];
		this._brand = map['brand'];
		this._price = map['price'];
		this._store = map['store'];
		this._note = map['note'];
	}
}
