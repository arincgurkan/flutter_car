import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/car.dart';
import '../models/cars.dart';

class CarDetailScreen extends StatelessWidget {
  static const routeName = '/car-detail-screen';

  var _carDetail = Car(
    id: '',
    title: '',
    price: null,
    imgUrl: '',
    isFavorite: false,
  );

  @override
  Widget build(BuildContext context) {
    final carId = ModalRoute.of(context).settings.arguments as String;
    _carDetail = Provider.of<Cars>(context).findByID(carId);
    return Scaffold(
      appBar: AppBar(
        title: Text(_carDetail.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Image.network(
                _carDetail.imgUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.format_list_numbered),
                      title: Text('Features'),
                    ),
                    Divider(),
                    ListTile(
                      title: Text('1- Description: ${_carDetail.description}'),
                    ),
                    Divider(),
                    ListTile(
                      title: Text('2- Price: ${_carDetail.price}\$'),
                    ),
                    Divider(),
                    ListTile(
                      title: Text('3- Kilometer: ${_carDetail.kilometer}km'),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
