import 'package:car_app/models/car.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cars_detail_screen.dart';
import '../providers/auth.dart';

class CarItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final double price;
  // final String imageUrl;
  // bool isFavorite;

  // CarItem(
  //   this.id,
  //   this.title,
  //   this.imageUrl,
  //   this.price,
  //   this.isFavorite,
  // );

  @override
  Widget build(BuildContext context) {
    final car = Provider.of<Car>(context);
    final authData = Provider.of<Auth>(context, listen: false);
    return Column(
      children: <Widget>[
        GestureDetector(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(car.imgUrl),
              radius: 35.0,
            ),
            title: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      car.title,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(8),
                        decoration: myBoxDecoration(),
                        child: Text('\$${car.price}'),
                      ),
                      Icon(Icons.arrow_right),
                      IconButton(
                        icon: car.isFavorite
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_border),
                        onPressed: () {
                          car.toggleFavoriteStatus(
                              authData.token, authData.userId);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          onTap: () => Navigator.of(context)
              .pushNamed(CarDetailScreen.routeName, arguments: car.id),
        ),
        Divider(),
      ],
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
    );
  }
}
