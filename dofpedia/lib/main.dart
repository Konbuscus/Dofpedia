import 'package:dofpedia/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';


void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
  
    return new SplashScreen(
        seconds: 5,
        navigateAfterSeconds: new AfterSplash(),
        title: new Text(
          'Bienvenue sur DofPedia',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        image: new Image.asset("assets/images/dofpedia.png"),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: () => print("Data loaded"),
        loaderColor: Colors.deepPurpleAccent);
  }
}

class AfterSplash extends StatelessWidget {

   //On référence la bdd ici
   final dbHelper = DataBaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    //Pas besoin de future builder ici, on va écrire un fichier json au lancement de l'appli
    //Si le fichier existe déjà on va seulement le charger

          return FutureBuilder(
      future: DataBaseHelper.instance.queryAllRows(),
      builder: (BuildContext context, snapshot) {
        
          return Scaffold(
            appBar: AppBar(
              title: Text('Vos personnages'),
              backgroundColor: Colors.orange,
            ),
            body: new Container(
              child:new Stack(
                  children: <Widget>[
                    Align(
              alignment: Alignment.topCenter,
              child: new IconButton(
                icon: Icon(Icons.add, color: Colors.green),
                onPressed: () {
                  displayAndInput(context);
                },

              ),
              
            ),  
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: buildCharactersListView(context, snapshot),
            )
                  ],
              )
            )
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
                 
                },
              ),
              CupertinoDialogAction(
                child: Text("Annuler"),
                onPressed: () {
                  //Fermeture de la popup
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
  void insertName(nameValue) async{
  Map<String, dynamic> row = {
    DataBaseHelper.columnName : nameValue,
    DataBaseHelper.columnItemsEquipped : ""
  };
  final id = await dbHelper.insert(row);
}
}



Widget buildCharactersListView(BuildContext context, AsyncSnapshot snapshot) {

  return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          return ListTile(
            trailing: new Icon(Icons.favorite),
            title: Text(snapshot.data[index]["nom"]),
            onTap: (){

            },
          );
        },
      );
}
