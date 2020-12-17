import 'package:communio/controller/redux/actions.dart';
import 'package:communio/model/app_state.dart';
import 'package:communio/view/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:toast/toast.dart';

class NavigationDrawer extends StatefulWidget {
  final BuildContext parentContext;

  NavigationDrawer({@required this.parentContext}) {}

  @override
  State<StatefulWidget> createState() {
    return new NavigationDrawerState(parentContext: parentContext);
  }
}

class NavigationDrawerState extends State<NavigationDrawer> {
  final BuildContext parentContext;

  NavigationDrawerState({@required this.parentContext}) {}

  static final drawerItems = [
    "Homepage",
    "PeopleSearch",
    "ListConnected",
    "Settings", 
    "QRCode",
    "Profile",
    "CreateProfile",
    "LogIn",
    "Friend-Requests"
  ];

  getCurrentRoute() => ModalRoute.of(parentContext).settings.name == null
      ? null
      : ModalRoute.of(parentContext).settings.name.substring(1);

  _onSelectItem(int index) {
    final prev = getCurrentRoute();

    Navigator.of(context).pop();

    if (prev != drawerItems[index]) {
      Navigator.pushNamed(context, '/' + drawerItems[index]);
    }
  }

  _buildBorder(name) {
    return (name == getCurrentRoute())
        ? (const BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 5.0,
                    color: cyanColor))))
        : null;
  }

  Widget createLogOutOption() {
    return new ListTile(
      title: new Row(
        children: <Widget>[
          new Container(
            decoration: _buildBorder("Terminar sessão"),
            child: new Text("Terminar sessão",
              style: Theme.of(context).textTheme.body1))  ,

        ],
      ),
      onTap: () => {StoreProvider.of<AppState>(context)
          .dispatch(UpdateUser(null)),
        Toast.show('Login Out...', context, duration: 5),
    Navigator.of(context).pushNamed('/Homepage')},
    );
  }

  Widget createDrawerNavigationOption(String d, int i) {
    return new ListTile(
      key: new Key(d),
      title: new Row(
        children: <Widget>[
          new Container(
            decoration: _buildBorder(d),
            child: new Text(d,
                style: Theme.of(context).textTheme.body1),
          ),
        ],
      ),
      selected: d == getCurrentRoute(),
      onTap: () => _onSelectItem(i),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> drawerOptions = [];

    for (var i = 0; i < drawerItems.length; i++) {
      drawerOptions.add(createDrawerNavigationOption(drawerItems[i], i));
    }

    return new Drawer(
      key: Key('drawer'),
      child: new Padding(
        padding: EdgeInsets.all(20.0),
        child: new Column(
          children: <Widget>[
            Flexible(
              child: new ListView(
                children: drawerOptions,
              ),
            ),
            Container(
              child: createLogOutOption(),
            ),
          ],
        ),
      )
    );
  }
}
