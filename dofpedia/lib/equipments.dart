

import 'package:dofpedia/models/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Equipments extends StatefulWidget {
  @override
  _EquipmentsState createState() => new _EquipmentsState();
}

class _EquipmentsState extends State<Equipments> {
  @override
  void initState() {
    super.initState();
    //Getting items
  }

  List<Item> itemsList = new List<Item>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new FutureBuilder(
      future: getItems(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Center(child: new CupertinoActivityIndicator());
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return buildListItemView(context, snapshot);
        }
      },
    ));
  }

  Widget buildListItemView(BuildContext context, AsyncSnapshot snapshot) {
    
    var array = convert.jsonDecode(snapshot.data);
    for(var elem in array){
      itemsList.add(Item.fromJson(elem));
    }
    itemsList.sort((a,b) => 
       b.level.compareTo(a.level)
    );

    return new ListView.builder(
      itemCount: itemsList.length,
      itemBuilder: (BuildContext context, int index) {
        var currentItem = itemsList.elementAt(index);
        return new Column(
          children: <Widget>[
            Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                  decoration:
                      BoxDecoration(color: Colors.lightGreen),
                  child:  makeListTile(currentItem)),
            )
          ],
        );
      },
    );
  }
  Future<String> getItems() async {
  final response = await http.get("https://fr.dofus.dofapi.fr/equipments");
  var body = response.body;
  return body;
  
}
}

Widget makeListTile(Item item){

  return ListTile(
    onTap: (){
      //Dialog avec des stats ?

    },
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: new BoxDecoration(
          border: new Border(
              right: new BorderSide(width: 1.0, color: Colors.white24))),
      child: Image.network(item.imgUrl),
    ),
    title: Text(
      item.name,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
    subtitle: Row(
      children: <Widget>[
        Text("Niveau ", style: TextStyle(color: Colors.white)),
        //Icon(Icons.label_important, color: Colors.yellowAccent),
        Text(item.level.toString(), style: TextStyle(color: Colors.white))

      ],
    ),
    trailing:
        Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0)
        );
        

} 

