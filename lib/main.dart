import 'package:flutter/material.dart';
import 'builder_page.dart';
import 'selector_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Processor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Text Processor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TextEditingController _varStr1Controller;
  TextEditingController _templateStrController;
  TextEditingController _resultStrController;
  ScrollController _scrollController;
  TabController _tabcontroller;
  List<Widget> _tabList;

  @override
  void initState() {
    _varStr1Controller = TextEditingController();
    _templateStrController = TextEditingController();
    _resultStrController = TextEditingController();
    _scrollController = ScrollController();
    _tabcontroller = TabController(length: 2, vsync: this);
    _tabList = [
      Tab(
        icon: Icon(Icons.build),
        text: "Builder",
      ),
      Tab(
        icon: Icon(Icons.cut),
        text: "Selector",
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            tabs: _tabList,
            controller: _tabcontroller,
          ),
        ),
        body: Center(
            child: Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                thickness: 10,
                radius: Radius.circular(10.0),
                child: TabBarView(controller: _tabcontroller, children: [
                  builderPage(_varStr1Controller, _templateStrController,
                      _resultStrController),
                  selectorPage()
                ]))));
  }
}
