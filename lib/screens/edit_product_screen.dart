import 'package:flutter/material.dart';

import '../provider/product.dart';

class EditProductsScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  // setting up the listener
  @override
  void initState() {
    _imageUrlController.addListener(_updateImageUrl);
    super.initState();
  }

  // update url whenever the focus changes
  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // Focus Node may lead to memory leaks if not disposed over time
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _saveFrom() {
    // triggers all the validators (this is done without autovalidators)
    final isValid = _form.currentState.validate();
    if (!isValid) {
      // this blank return stops the execution of the entire func
      return;
    }

    _form.currentState.save();
    print(_editedProduct.title);
    print(_editedProduct.description);
    print(_editedProduct.price);
    print(_editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            onPressed: _saveFrom,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _form, // key to access the form widget
            child: ListView(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  validator: (value) {
                    // value = what user enters in the input field
                    if (value.isEmpty) {
                      return 'Please provide a value';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: value,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                    );
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context)
                        .requestFocus(_descriptionFocusNode); //
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter price!';
                    }
                    if (double.tryParse(value) == null) {
                      return "Enter valid number!";
                    }
                    if (double.parse(value) <= 0) {
                      return 'Please enter a number greter than 0!';
                    }
                    return null; //valid
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: value,
                      description: _editedProduct.description,
                      price: double.parse(value),
                      imageUrl: _editedProduct.imageUrl,
                    );
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  // textInputAction: TextInputAction.next, //mutliline has inbuilt next line option
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please add description!";
                    }
                    if (value.length < 10) {
                      return "atleast 10 characters long!";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: value,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: value,
                    );
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter a URL')
                          : FittedBox(
                              child: Image.network(_imageUrlController.text),
                              fit: BoxFit.cover,
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
                          _saveFrom(); // trigered when TexInputAction.done is hit
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please add Image URL!";
                          }
                          if (!value.startsWith('http') &&
                              !value.startsWith('https') &&
                              !value.startsWith('www')) {
                            return 'Please enter valid URL';
                          }
                          if (!value.endsWith('.png') &&
                              !value.endsWith('.jpg') &&
                              !value.endsWith('.jpeg')) {
                            return 'Please enter valid image URL';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
