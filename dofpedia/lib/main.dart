import 'package:dofpedia/database.dart';
import 'package:dofpedia/equipments.dart';
import 'package:dofpedia/models/characters.dart';
import 'package:dofpedia/models/classes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash/animated_splash.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  Function duringSplash = () {
    print("lodaded");
    return 1;
  };

  runApp(new MaterialApp(
      home: AnimatedSplash(
    imagePath: "assets/images/dofpedia.png",
    home: MyApp(),
    type: AnimatedSplashType.StaticDuration,
    duration: 2000,

    //customFunction: duringSplash,
  )));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final double _kPickerItemHeight = 32.0;
  final dbHelper = DataBaseHelper.instance;
  int tabIndex = 1;
  List<Characters> characters = List<Characters>();
  List<Classes> dofusClass = List<Classes>();

  @override
  void initState() {
    super.initState();
    populateCharacters();
    getClasses();
  }

  @override
  Widget build(BuildContext context) {
    //Pas besoin de future builder ici, on va écrire un fichier json au lancement de l'appli
    //Si le fichier existe déjà on va seulement le charger

    return Scaffold(
      appBar:
          AppBar(title: Text('Dofpedia'), backgroundColor: Colors.lightGreen),
      body: new Container(
          child: new Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: new IconButton(
              icon: Icon(CupertinoIcons.add, color: Colors.blue),
              onPressed: () {
                setState(() {
                  displayAndInput(context);
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: buildCharactersListView(context),
          ),
        ],
      )),
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: tabIndex,
        onTap: (int index) {
          setState(() {
            this.tabIndex = index;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Equipments()),
          );
        },
        fixedColor: Colors.lightGreen,
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
            icon: new Icon(CupertinoIcons.settings),
            title: new Text("Equipements"),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(CupertinoIcons.profile_circled),
            title: new Text("Personnages"),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(CupertinoIcons.book),
            title: new Text("Encyclopédie"),
          )
        ],
      ),
    );
  }

  Widget buildCharactersListView(BuildContext context) {
    return ListView.builder(
      itemCount: characters.length,
      itemBuilder: (context, index) {
        return ListTile(
          trailing: Image.network(characters[index].url),
          title: Text(characters[index].name),
          onTap: () {},
          onLongPress: () {
            return showCupertinoModalPopup(
                context: context,
                builder: (context) {
                  //Pop up suppression
                  return CupertinoAlertDialog(
                    title: new Text(
                        "Suppression du personnage " + characters[index].name),
                    content: new Text(
                        "Voulez-vous vraiment supprimer ce personnage ?"),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        child: Text("Oui"),
                        onPressed: () {
                          //Fermeture modale
                          Navigator.of(context).pop();
                          //Suppression en base
                          removeCharactersFromDb(characters[index].id);
                          //setstate remove name
                          setState(() {
                            characters.removeAt(index);
                          });
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text("Non"),
                        onPressed: () {
                          //Fermeture modale
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
          },
        );
      },
    );
  }

   displayAndInput(BuildContext context){
    TextEditingController tec = TextEditingController();
    String defaultValueSelect = dofusClass.elementAt(0).name;
    List<String> namesValues = dofusClass.map((f) => f.name).toList();
    Characters c = new Characters();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: new Text("Nom du personnage"),
            content: new TextField(
              controller: tec,
            ),
            actions: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    DropdownButton<String>(
                      value: defaultValueSelect,
                      style: TextStyle(color: Colors.lightGreen),
                      underline: Container(
                        height: 1,
                        color: Colors.lightGreen,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          defaultValueSelect = newValue;
                          c.type = newValue;
                          c.url = dofusClass.firstWhere((d)=> d.name == newValue).maleImg;
                        });
                      },
                      items: namesValues
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value)
                        );
                      }).toList(),
                    ),
                    FloatingActionButton.extended(
                      shape: new RoundedRectangleBorder(),
                      backgroundColor: Colors.lightGreen,
                      icon: Icon(Icons.save),
                      label: Text("Sauvegarde"),
                      onPressed: () {
                        //Sauvegarde dans la base de données
                        c.name = tec.value.text;
                        insertName(c);
                        Navigator.of(context).pop();
                        setState(() {
                          characters.add(c);
                          //charactersNames.add(tec.value.text);
                        });
                      },
                    ),
                  ],
                ),
              )
              // FloatingActionButton.extended(
              //   icon: Icon(Icons.close),
              //   label: Text("c"),
              //   onPressed: () {
              //     //Fermeture de la popup
              //     Navigator.of(context).pop();
              //   },
              // ),
            ],
          );
        });
  }

  void populateCharacters() {
    DataBaseHelper.instance.queryAllRows().then((data) => {
          setState(() => {
                for (int i = 0; i < data.length; i++)
                  {
                    characters.add(new Characters(
                        id: data[i]["_id"],
                        name: data[i]["nom"],
                        type: data[i]["type"],
                        url: data[i]["url"]))
                  }
              })
        });
  }

  void insertName(Characters character) async {
    Map<String, dynamic> row = {
      DataBaseHelper.columnName: character.name,
      DataBaseHelper.columnClass: character.type,
      DataBaseHelper.columnUrlImg: character.url.toString(),
      DataBaseHelper.columnItemsEquipped: ""
    };
    final id = await dbHelper.insert(row);
  }

  //TODO: Faire une classe personage et on pourra le delete par son id :)
  void removeCharactersFromDb(int id) async {
    var test = await dbHelper.delete(id);
  }

  Future<void> getClasses() async {
    var url = "https://fr.dofus.dofapi.fr/classes";
    var response = await http.get(url);
    var array = convert.jsonDecode(response.body);

    for (var elem in array) {
      dofusClass.add(Classes.fromJson(elem));
    }
    //await new Future.delayed(Duration(milliseconds:500));
  }

}
