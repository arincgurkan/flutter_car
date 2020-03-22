import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/cars_list.dart';
import '../models/cars.dart';
import '../widgets/app_drawer.dart';

class CarOverviewScreen extends StatefulWidget {
  @override
  _CarOverviewScreenState createState() => _CarOverviewScreenState();
}

class _CarOverviewScreenState extends State<CarOverviewScreen> {
  bool _showFavoritesOnly = false;

  Future<void> _refreshCars(BuildContext context) async {
    await Provider.of<Cars>(context, listen: false).getCarsFromDatabase(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cars'),
        actions: <Widget>[
          IconButton(
            icon: Icon(_showFavoritesOnly
                ? Icons.all_inclusive
                : Icons.favorite_border),
            onPressed: () {
              setState(() {
                _showFavoritesOnly = !_showFavoritesOnly;
              });
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshCars(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshCars(context),
                    child: CarList(_showFavoritesOnly),
                  ),
      ),
    );
  }
}
