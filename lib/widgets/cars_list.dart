import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/car_item.dart';
import '../models/cars.dart';

class CarList extends StatelessWidget {
  bool _showFavoritesOnly;

  CarList(this._showFavoritesOnly);

  @override
  Widget build(BuildContext context) {
    final carData = Provider.of<Cars>(context);
    final cars = _showFavoritesOnly ? carData.favoriteItems : carData.cars;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        itemCount: cars.length,
        itemBuilder: (_, index) => ChangeNotifierProvider.value(
          value: cars[index],
          child: CarItem(),
        ),
      ),
    );
  }
}
