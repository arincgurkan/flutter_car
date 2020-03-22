import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import './car.dart';

class Cars with ChangeNotifier {
  List<Car> _cars = [
    // Car(
    //   title: 'Ford Focus',
    //   id: '1',
    //   price: 170000,
    //   transmission: 'automatic',
    //   kilometer: 1000,
    //   description: 'Some texts',
    //   imgUrl:
    //       'https://i2.milimaj.com/i/milliyet/75/0x410/5cc0365dec10bb27142f0d8e.jpg',
    // ),
    // Car(
    //   title: 'BMW 2',
    //   id: '2',
    //   price: 169000,
    //   transmission: 'automatic',
    //   kilometer: 1000,
    //   description: 'Some texts',
    //   imgUrl:
    //       'https://iasbh.tmgrup.com.tr/e848eb/0/0/0/0/0/0?u=https://isbh.tmgrup.com.tr/sb/album/2019/10/16/1571207005802.jpg&mw=633',
    // ),
    // Car(
    //   title: 'Ford Focus',
    //   id: '3',
    //   price: 169000,
    //   transmission: 'automatic',
    //   kilometer: 1000,
    //   description: 'Some texts',
    //   imgUrl:
    //       'https://i2.milimaj.com/i/milliyet/75/0x410/5cc0365dec10bb27142f0d8e.jpg',
    // ),
    // Car(
    //   title: 'Ford Focus',
    //   id: '4',
    //   price: 169000,
    //   transmission: 'automatic',
    //   kilometer: 1000,
    //   description: 'Some texts',
    //   imgUrl:
    //       'https://i2.milimaj.com/i/milliyet/75/0x410/5cc0365dec10bb27142f0d8e.jpg',
    // ),
  ];

  final String authToken;
  final String userId;

  Cars(
    this.authToken,
    this._cars,
    this.userId,
  );

  List<Car> get cars {
    return [..._cars];
  }

  Car findByID(String id) {
    return _cars.firstWhere((car) => car.id == id);
  }

  List<Car> get favoriteItems {
    return _cars.where((carItem) => carItem.isFavorite).toList();
  }

  Future<void> deleteCars(String id) async {
    final url =
        'https://flutter-car.firebaseio.com/cars/$id.json?auth=$authToken';
    final existingCarIndex = _cars.indexWhere((car) => car.id == id);
    var existingCar = _cars[existingCarIndex];
    _cars.removeAt(existingCarIndex);
    notifyListeners();
    final response = await http.delete(url);
    // If something wents wrong, this keeps removed car
    if (response.statusCode >= 400) {
      _cars.insert(existingCarIndex, existingCar);
      notifyListeners();
      // Error mesasjı pop upla
    }
    existingCar = null;
  }

  Future<void> updateCars(String id, Car newCar) async {
    final carIndex = _cars.indexWhere((car) => car.id == id);
    if (carIndex >= 0) {
      final url =
          'https://flutter-car.firebaseio.com/cars/$id.json?auth=$authToken';
      await http.patch(
        url,
        body: json.encode({
          'title': newCar.title,
          'description': newCar.description,
          'price': newCar.price,
          'imgUrl': newCar.imgUrl,
          'kilometer': newCar.kilometer,
        }),
      );
      // _cars[carIndex].title = newCar.title;
      // _cars[carIndex].description = newCar.description;
      // _cars[carIndex].price = newCar.price;
      // _cars[carIndex].imgUrl = newCar.imgUrl;

      _cars[carIndex] = newCar;
      notifyListeners();
    }
  }

  Future<void> addCar(Car car) async {
    final url = 'https://flutter-car.firebaseio.com/cars.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': car.title,
          'description': car.description,
          'imgUrl': car.imgUrl,
          'price': car.price,
          'kilometer': car.kilometer,
          'creatorId': userId,
        }),
      );
      final newCar = Car(
        title: car.title,
        description: car.description,
        price: car.price,
        imgUrl: car.imgUrl,
        kilometer: car.kilometer,
        id: json.decode(response.body)['name'],
      );
      _cars.add(newCar);
      print('Add does work');
      notifyListeners();
    } catch (error) {
      print('Add doenst work');
      throw error;
    }
    // final newCar = Car(
    //     title: car.title,
    //     price: car.price,
    //     imgUrl: car.imgUrl,
    //     description: car.description);
    // _cars.add(newCar);
    // notifyListeners();
  }

  Future<void> getCarsFromDatabase([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://flutter-car.firebaseio.com/cars.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedDate = json.decode(response.body) as Map<String, dynamic>;
      if (extractedDate == null) {
        return;
      }
      url =
          'https://flutter-car.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Car> loadedCars = [];
      extractedDate.forEach((carId, carData) {
        loadedCars.add(Car(
          id: carId,
          title: carData['title'],
          description: carData['description'],
          price: carData['price'],
          imgUrl: carData['imgUrl'],
          kilometer: carData['kilometer'],
          isFavorite:
              favoriteData == null ? false : favoriteData[carId] ?? false,
        ));
      });
      print('Get does work');
      _cars = loadedCars;
      notifyListeners();
    } catch (error) {
      print('Get doenst work');
      throw (error);
    }
  }
}
