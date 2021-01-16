import 'package:bdebtrader/models/dailyprice.dart';
import 'package:bdebtrader/utils/presentation.dart';
import 'package:bdebtrader/views/metadata_card.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:bdebtrader/services/alphavantage.dart';
import 'package:bdebtrader/models/metadata.dart';
import 'package:bdebtrader/views/overview_view.dart';
import 'package:bdebtrader/models/searchresult.dart';
import 'package:bdebtrader/views/stockview.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart' as path;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await path.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(MetaDataObjectAdapter());
  Hive.registerAdapter(DailyPriceAdapter());
  await Hive.openBox('bdebtrader');
  await DotEnv().load('assets/.env');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        initialRoute: '/',
        title: 'Welcome to Flutter',
        home: FutureBuilder(
          future: Hive.openBox('bdebtrader'),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return Home();
              }
            } else {
              return Scaffold();
            }
          },
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  //List<MetaDataObject> liste;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BdebTrader'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: SymbolSearch());
              }),
        ],
      ),
      body: _buildListView(),
    );
  }
}

class SymbolSearch extends SearchDelegate<SearchResult> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
        future: AlphaVantage.executeSearch(query),
        builder: (context, AsyncSnapshot<List<SearchResult>> snapshot) {
          if (snapshot.hasData) {
            List<SearchResult> results = snapshot.data;
            return ListView(
              children: results
                  .map((SearchResult result) => Card(
                        child: ListTile(
                          trailing:
                              Presentation.showCurrencySymbol(result.currency),
                          leading: Text(result.region),
                          title: Text(result.symbol),
                          subtitle: Text(result.name),
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LineChartView(
                                          symbol: result.symbol,
                                          name: result.name,
                                        )))
                          },
                        ),
                      ))
                  .toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Type some text to search symbol or company name',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

Widget _buildListView() {
  final metas = Hive.box('bdebtrader');
  return ValueListenableBuilder(
    builder: (context, value, child) {
      if (metas.isNotEmpty) {
        return ListView.separated(
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemCount: metas.length,
          itemBuilder: (context, index) {
            final meta = metas.getAt(index) as MetaDataObject;
            return MetaCard(meta: meta, index: index);
          },
        );
      } else {
        return Center(
          child: Text(
            'Your watchlist is empty',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        );
      }
    },
    valueListenable: metas.listenable(),
  );
}
