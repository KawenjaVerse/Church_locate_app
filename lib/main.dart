import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    List<Favor> mockPendingFavors = [];
    List<Favor> mockCompletedFavors = [];
    List<Favor> mockRefusedFavors = [];
    List<Favor> mockDoingFavors = [];

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: FavorsPage(
        pendingAnswerFavors: mockPendingFavors,
        completedFavors: mockCompletedFavors,
        refusedFavors: mockRefusedFavors,
        acceptedFavors: mockDoingFavors,
      ),
    );
  }
}

class FavorsPage extends StatelessWidget {
  // using mock values from mock_favors dart file for now
  final List<Favor> pendingAnswerFavors;
  final List<Favor> acceptedFavors;
  final List<Favor> completedFavors;
  final List<Favor> refusedFavors;
  const FavorsPage({
    super.key,
    //required Key key,
    required this.pendingAnswerFavors,
    required this.acceptedFavors,
    required this.completedFavors,
    required this.refusedFavors,
    //required this.completedFavors,
  });
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Your favors"),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              _buildCategoryTab("Requests"),
              _buildCategoryTab("Doing"),
              _buildCategoryTab("Completed"),
              _buildCategoryTab("Refused"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _favorsList("Pending Requests", pendingAnswerFavors),
            _favorsList("Doing", acceptedFavors),
            _favorsList("Completed", completedFavors),
            _favorsList("Refused", refusedFavors),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Ask a favor',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String title) {
    return Tab(
      child: Text(title),
    );
  }

  Widget _favorsList(String title, List<Favor> favors) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(title),
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: favors.length,
            itemBuilder: (BuildContext context, int index) {
              final favor = favors[index];
              return Card(
                key: ValueKey(favor.uuid),
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 25.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      _itemHeader(favor),
                      Text(favor.description),
                      _itemFooter(favor)
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

Row _itemHeader(Favor favor) {
  return Row(
    children: <Widget>[
      CircleAvatar(
        backgroundImage: NetworkImage(
          favor.friend.photoURL,
        ),
      ),
      Expanded(
          child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("${favor.friend.name} asked you to...")))
    ],
  );
}

Widget _itemFooter(Favor favor) {
  if (favor.isCompleted) {
    //  DateFormat();
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      alignment: Alignment.centerRight,
      child: const Chip(
        label: Text("Completed at:{format.format(favor.completed)}"),
      ),
    );
  }
  if (favor.isRequested) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        ElevatedButton(
          child: const Text("Refuse"),
          onPressed: () {},
        ),
        ElevatedButton(
          child: const Text("Do"),
          onPressed: () {},
        )
      ],
    );
  }
  if (favor.isDoing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        ElevatedButton(
          child: const Text("give up"),
          onPressed: () {},
        ),
        ElevatedButton(
          child: const Text("complete"),
          onPressed: () {},
        )
      ],
    );
  }
  return Container();
}

class Favor {
  bool get isRequested => true;

  bool get isDoing => true;

  bool get isCompleted => true;

  get friend => null;

  get description => null;

  get uuid => null;
}
