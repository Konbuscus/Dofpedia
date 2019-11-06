import 'package:dofpedia/database.dart';
import 'package:dofpedia/equipments.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash/animated_splash.dart';

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
  //On référence la bdd ici
  final dbHelper = DataBaseHelper.instance;
  int tabIndex = 1;
  List<String> charactersNames = List<String>();
  int _page = 0;
  PageController _c;
  @override
  void initState() {
    super.initState();
    populateCharacters();
   
  }

  @override
  Widget build(BuildContext context) {
    //Pas besoin de future builder ici, on va écrire un fichier json au lancement de l'appli
    //Si le fichier existe déjà on va seulement le charger

    return Scaffold(
        appBar: AppBar(
          title: Text('Dofpedia'),
          backgroundColor: Colors.lightGreen
        ),
        body: new Container(
            child: new Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: new IconButton(
                icon: Icon(CupertinoIcons.add, color: Colors.blue),
                onPressed: () {
                  displayAndInput(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: buildCharactersListView(context),
            ),
            
          ],
        )
        ),
        bottomNavigationBar: new BottomNavigationBar(
        currentIndex: tabIndex,
        onTap: (int index) { setState((){ 
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
      itemCount: charactersNames.length,
      itemBuilder: (context, index) {
        return ListTile(
          trailing: new Icon(Icons.favorite),
          title: Text(charactersNames[index]),
          onTap: () {},
          onLongPress: () {
            return showCupertinoDialog(
                context: context,
                builder: (context) {
//Pop up suppression
                  return CupertinoAlertDialog(
                    title: new Text(
                        "Suppression du personnage " + charactersNames[index]),
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
                          removeCharactersFromDb(index);
                          //setstate remove name
                          setState(() {
                            charactersNames.removeAt(index);
                          });
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text("Non"),
                        onPressed: () {
                          //Fermeture modale
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
          },
        );
      },
    );
  }

  displayAndInput(BuildContext context) async {
    TextEditingController tec = TextEditingController();
    return showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: new Text("Nom du personnage"),
            content: new CupertinoTextField(
              controller: tec,
              decoration: BoxDecoration(),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("Sauvegarder"),
                onPressed: () {
                  //Sauvegarde dans la base de données
                  insertName(tec.value.text);
                  Navigator.of(context).pop();
                  setState(() {
                    charactersNames.add(tec.value.text);
                  });
                },
              ),
              CupertinoDialogAction(
                child: Text("Annuler"),
                onPressed: () {
                  //Fermeture de la popup
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void populateCharacters() {
    DataBaseHelper.instance.queryAllRows().then((data) => {
          setState(() => {
                for (int i = 0; i < data.length; i++)
                  {charactersNames.add(data[i]["nom"])}
              })
        });
  }

  void insertName(nameValue) async {
    Map<String, dynamic> row = {
      DataBaseHelper.columnName: nameValue,
      DataBaseHelper.columnItemsEquipped: ""
    };
    final id = await dbHelper.insert(row);
  }

  //TODO: Faire une classe personage et on pourra le delete par son id :)
  void removeCharactersFromDb(int id) async {
    var test = await dbHelper.delete(id);
  }
}
