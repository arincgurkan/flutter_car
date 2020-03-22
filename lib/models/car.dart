import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Car with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  String imgUrl;
  bool isFavorite;
  int kilometer;

  Car({
    @required this.title,
    @required this.id,
    this.description,
    @required this.price,
    @required this.imgUrl,
    this.isFavorite = false,
    this.kilometer,
  });

  // If something wents wrong, this will keep old status
  void _setOldStatus(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    final oldValue = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://flutter-car.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setOldStatus(oldValue);
      }
    } catch (error) {
      _setOldStatus(oldValue);
      // Display the error pop up
    }
    notifyListeners();
  }
}
