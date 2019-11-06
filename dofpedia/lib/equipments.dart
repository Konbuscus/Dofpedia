import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Equipments extends StatefulWidget {
 @override
 _EquipmentsState createState() => new _EquipmentsState();
}

class _EquipmentsState extends State<Equipments> {

  @override
  void initState() {
    super.initState();

  }
  //TODO : faire la classe items pour chopper tout ce qui est stats
  List<String> itemName = new  List<String>();
  //C'est ici qu'on va pourrir l'API


  @override
  Widget build(BuildContext context) {

    return new FutureBuilder(
      future: getItems(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Center(child:new CupertinoActivityIndicator());
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return buildListItemView(context, snapshot);
        }
      },
    );
  }

  Widget buildListItemView(BuildContext context, AsyncSnapshot snapshot){
      List<String> itemsList = new List<String>();
      itemsList.add("Dark vlad");
      itemsList.add("Dofus vulbus");
      itemsList.add("PlaceHolde3");
    return new ListView.builder(
      
      itemCount: itemsList.length,
      itemBuilder: (BuildContext context, int index) {
        var currentItem = itemsList.elementAt(index);
        return new Column(
          
          children: <Widget>[
            new ListTile(
                title: new Text(currentItem),
                onTap: () {}
                 ),
          ],
        );
      },
    );
  }
  }

 

Future<String> getItems() async{
  final response = await http.get("https://fr.dofus.dofapi.fr/equipments");
  var body  = response.body;
  return body;
}

