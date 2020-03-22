import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './car_edit_screen.dart';
import '../models/cars.dart';
import '../widgets/app_drawer.dart';

class UserCarScreen extends StatelessWidget {
  static const routeName = '/user-car-screen';

  Future<void> _refreshCars(BuildContext context) async {
    await Provider.of<Cars>(context, listen: false).getCarsFromDatabase(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cars'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(CarEditScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshCars(context),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshCars(context),
                child: Consumer<Cars>(
                  builder: (ctx, carData, _) => Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ListView.builder(
                      itemCount: carData.cars.length,
                      itemBuilder: (_, index) => ChangeNotifierProvider.value(
                        value: carData.cars[index],
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(carData.cars[index].imgUrl),
                            radius: 35.0,
                          ),
                          title: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                  carData.cars[index].title,
                                  overflow: TextOverflow.ellipsis,
                                )),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.all(8),
                                      padding: EdgeInsets.all(8),
                                      decoration: myBoxDecoration(),
                                      child: Text(
                                          '\$${carData.cars[index].price}'),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        carData
                                            .deleteCars(carData.cars[index].id);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            CarEditScreen.routeName,
                                            arguments: carData.cars[index].id);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
    );
  }
}
