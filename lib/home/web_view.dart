import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:connectivity/connectivity.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:santri_app/pages/page_archive.dart';
import 'package:santri_app/pages/page_article.dart';
import 'package:santri_app/pages/page_contact.dart';
import 'package:santri_app/pages/page_home.dart';
import 'package:santri_app/pages/page_search.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Santri View',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Santri View'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Stream<ConnectivityResult> connectivitySub;
  static final homeKey = GlobalKey<PageHomeState>();
  final PageArchive _archive = PageArchive();
  final PageArticle _article = PageArticle();
  final PageContact _contact = PageContact();
  final PageHome _home = PageHome(
    key: homeKey,
  );
  final PageSearch _search = PageSearch();

  Widget _showPage = PageHome();

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return _contact;
        break;
      case 1:
        return _article;
        break;
      case 2:
        return _home;
        break;
      case 3:
        return _search;
        break;
      case 4:
        return _archive;
        break;
      default:
        return Container(
          child: Center(
            child: Text("Tidak ada halaman"),
          ),
        );
    }
  }

  @override
  void initState() {
    connectivitySub = Connectivity().onConnectivityChanged;
    connectivitySub.listen((result) {
      if (result == ConnectivityResult.none) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Tidak ada koneksi internet'),
              content: Text(
                  'Mohon untuk nyalakan data internet. Pergi ke pengaturan->lainnya->jaringan seluler->aktifkan data'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              actions: <Widget>[
                FlatButton(
                  child: Text('Oke'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
      }
    });
    super.initState();
  }

  Widget saback() {
    return Container(
      child: FloatingActionButton(
        onPressed: () async {
          if (_showPage == _home) {
            (await homeKey.currentState.controller.future).canGoBack();
          }
        },
        child: Icon(Icons.add_circle),
      ),
    );
  }

  Widget saforward() {
    return Container(
      child: FloatingActionButton(
        onPressed: null,
        tooltip: 'maju',
        child: Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_showPage == _home) {
      (await homeKey.currentState.controller.future).canGoBack();
    }
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          items: <Widget>[
            Icon(
              Icons.account_circle,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.add_circle,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.home,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.search,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.archive,
              size: 30,
              color: Colors.white,
            ),
          ],
          color: Color.fromARGB(255, 173, 62, 195),
          backgroundColor: Colors.white,
          buttonBackgroundColor: Color.fromARGB(225, 106, 30, 133),
          index: 2,
          height: 50.0,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (int tappedIndex) {
            setState(() {
              _showPage = _pageChooser(tappedIndex);
            });
          },
        ),
        body: SafeArea(
          child: StreamBuilder<ConnectivityResult>(
            stream: connectivitySub,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.active) {
                return SizedBox();
              }
              if (snapshot.data == ConnectivityResult.none) {
                return SizedBox();
              }
              return _showPage;
            },
          ),
        ),
        floatingActionButton: AnimatedFloatingActionButton(
          fabButtons: <Widget>[saback(), saforward()],
          colorStartAnimation: Colors.blue[800],
          colorEndAnimation: Colors.purple[900],
          animatedIconData: AnimatedIcons.view_list,
        ),
      ),
    );
  }
}
