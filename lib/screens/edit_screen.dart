import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProducts extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProducts> {
  final TextEditingController _imageUrlCont = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _newProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'iamgeUrl': ''
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void dispose() {
    _imageUrlCont.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imageUrlCont.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null) {
        _newProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _newProduct.title,
          'description': _newProduct.description,
          'price': _newProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlCont.text = _newProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    if (_newProduct.id != '') {
      print('hello');
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_newProduct.id, _newProduct);

      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_newProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured!'),
            content: Text('Something went Wrong'),
            actions: [
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
        // } finally {
        //   print('object');
        //   setState(() {
        //     _isLoading = false;
        //   });
        // Navigator.of(context).pop();
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          FlatButton(
            onPressed: _saveForm,
            child: Text(
              'Submit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
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
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        style: BorderStyle.solid,
                        color: Colors.grey,
                        width: 1.5,
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextFormField(
                          initialValue: _initValues['title'],
                          decoration: InputDecoration(labelText: 'Title'),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter a Title.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _newProduct = Product(
                              id: _newProduct.id,
                              isFav: _newProduct.isFav,
                              title: value!,
                              description: _newProduct.description,
                              price: _newProduct.price,
                              imageUrl: _newProduct.imageUrl,
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: _initValues['price'],
                          decoration: InputDecoration(labelText: 'Price'),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter a Price.';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please Enter a Valid Number';
                            }
                            if (double.parse(value) <= 0) {
                              return 'Please Enter a Number greater than 0';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _newProduct = Product(
                              id: _newProduct.id,
                              isFav: _newProduct.isFav,
                              title: _newProduct.title,
                              description: _newProduct.description,
                              price: double.parse(value!),
                              imageUrl: _newProduct.imageUrl,
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: _initValues['description'],
                          decoration: InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter a Description.';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _newProduct = Product(
                              id: _newProduct.id,
                              isFav: _newProduct.isFav,
                              title: _newProduct.title,
                              description: value!,
                              price: _newProduct.price,
                              imageUrl: _newProduct.imageUrl,
                            );
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(top: 8, right: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              child: _imageUrlCont.text.isEmpty
                                  ? Center(child: Text('Enter a URL'))
                                  : FittedBox(
                                      child: Image.network(_imageUrlCont.text),
                                      fit: BoxFit.contain,
                                    ),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Image url'),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlCont,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter an image URL.';
                                  }
                                  if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return 'Please enter a valid URL.';
                                  }
                                  if (!value.endsWith('.png') &&
                                      !value.endsWith('.jpg') &&
                                      !value.endsWith('.jpeg')) {
                                    return 'Please enter a valid image URL.';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                onSaved: (value) {
                                  _newProduct = Product(
                                    id: _newProduct.id,
                                    isFav: _newProduct.isFav,
                                    title: _newProduct.title,
                                    description: _newProduct.description,
                                    price: _newProduct.price,
                                    imageUrl: value!,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: _saveForm,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
