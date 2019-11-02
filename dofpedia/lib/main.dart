import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
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
    //On vérifie si le fichier characters.json est dans le dossier
    //Si il existe on ne fait rien ici :)
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
  final LocalStorage storage = new LocalStorage('characters');

  @override
  Widget build(BuildContext context) {
    //Pas besoin de future builder ici, on va écrire un fichier json au lancement de l'appli
    //Si le fichier existe déjà on va seulement le charger

    return FutureBuilder(
      future: storage.ready,
      builder: (BuildContext context, snapshot) {
        if (1==0) {
          Map<String, String> data = storage.getItem('characterName');
          print(data);
        //Liste des noms de personnages
          
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Vos personnages'),
              backgroundColor: Colors.orange,
            ),
            body: Align(
              alignment: Alignment.topRight,
              child: new IconButton(
                icon: Icon(Icons.add, color: Colors.green),
                onPressed: () {
                  displayAndInput(context);
                },
              ),
            ),
          );
        }
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
                  //Ecriture dans le fichier json
                  storage.setItem("characterName", tec.value.text);
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
}

Widget buildCharactersListView(BuildContext context, AsyncSnapshot snapshot) {}
