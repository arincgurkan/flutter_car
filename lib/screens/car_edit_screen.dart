import 'package:car_app/models/car.dart';
import 'package:car_app/models/cars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarEditScreen extends StatefulWidget {
  static const routeName = '/car-edit-screen';
  @override
  _CarEditScreenState createState() => _CarEditScreenState();
}

class _CarEditScreenState extends State<CarEditScreen> {
  final _priceFocusNode = FocusNode();
  final _kilometerFocusNode = FocusNode();
  final _descriptonNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedCar = Car(
    id: null,
    title: '',
    price: 0,
    imgUrl: '',
    description: '',
    kilometer: 0,
  );

  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
    'kilometer': '',
  };

  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedCar =
            Provider.of<Cars>(context, listen: false).findByID(productId);
        _initValues = {
          'title': _editedCar.title,
          'description': _editedCar.description,
          'price': _editedCar.price.toString(),
          'kilometer': _editedCar.kilometer.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedCar.imgUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _kilometerFocusNode.dispose();
    _descriptonNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() async {
    final valid = _form.currentState.validate();
    if (!valid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedCar.id != null) {
      await Provider.of<Cars>(context, listen: false)
          .updateCars(_editedCar.id, _editedCar);

      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Cars>(context, listen: false).addCar(_editedCar);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ),
        );
      }
      Navigator.of(context).pop();
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedCar = Car(
                          title: value,
                          price: _editedCar.price,
                          description: _editedCar.description,
                          imgUrl: _editedCar.imgUrl,
                          id: _editedCar.id,
                          kilometer: _editedCar.kilometer,
                          isFavorite: _editedCar.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptonNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero';
                        }
                        if (double.parse(value) >= 1000000) {
                          return 'No value, that is greater than 1.000.000\$ accepted.';
                        }
                      },
                      onSaved: (value) {
                        _editedCar = Car(
                          title: _editedCar.title,
                          price: double.parse(value),
                          description: _editedCar.description,
                          imgUrl: _editedCar.imgUrl,
                          id: _editedCar.id,
                          kilometer: _editedCar.kilometer,
                          isFavorite: _editedCar.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['kilometer'],
                      decoration: InputDecoration(labelText: 'Kilometer'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _kilometerFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptonNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero';
                        }
                      },
                      onSaved: (value) {
                        _editedCar = Car(
                          title: _editedCar.title,
                          price: _editedCar.price,
                          description: _editedCar.description,
                          imgUrl: _editedCar.imgUrl,
                          id: _editedCar.id,
                          kilometer: int.parse(value),
                          isFavorite: _editedCar.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptonNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a decription.';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 character long';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedCar = Car(
                          title: _editedCar.title,
                          price: _editedCar.price,
                          description: value,
                          imgUrl: _editedCar.imgUrl,
                          id: _editedCar.id,
                          kilometer: _editedCar.kilometer,
                          isFavorite: _editedCar.isFavorite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(_imageUrlController.text,
                                      fit: BoxFit.cover),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an image';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL.';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid URL.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedCar = Car(
                                title: _editedCar.title,
                                price: _editedCar.price,
                                description: _editedCar.description,
                                imgUrl: value,
                                id: _editedCar.id,
                                kilometer: _editedCar.kilometer,
                                isFavorite: _editedCar.isFavorite,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
