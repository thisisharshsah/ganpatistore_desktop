import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:ganpatistore_desktop/Models/product_model.dart';
import 'package:ganpatistore_desktop/Models/user_model.dart';
import 'package:ganpatistore_desktop/Screens/user_details_screen.dart';
import 'package:nepali_utils/nepali_utils.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key, required this.user});
  final UserModel user;

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final CollectionReference _productCollection =
      Firestore.instance.collection('products');

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productCodeController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productBaseController = TextEditingController();

  var _product = ProductModel();

  void _addProductFirebase() async {
    NepaliDateTime dateTimeNow = NepaliDateTime.now();
    var nepaliDateNow = NepaliDateFormat.yMMMMd().format(dateTimeNow);
    if (_formKey.currentState!.validate()) {
      _product = ProductModel(
        buyerId: widget.user.docId,
        buyerName: widget.user.name,
        productName: _productNameController.text,
        productPrice: _productPriceController.text,
        productCode: _productCodeController.text,
        productBase: _productBaseController.text,
        createdAt: nepaliDateNow,
        updatedAt: nepaliDateNow,
      );
      try {
        var docref = await _productCollection.add(_product.toJson());
        _product.productId = docref.id;
        await _productCollection.document(docref.id).set(_product.toJson());

        showToast(
          'Product added successfully',
          context: context,
          backgroundColor: Colors.green,
          animation: StyledToastAnimation.slideFromBottom,
          reverseAnimation: StyledToastAnimation.slideToBottom,
          position: StyledToastPosition.bottom,
          animDuration: const Duration(seconds: 1),
          duration: const Duration(seconds: 4),
          curve: Curves.elasticOut,
          reverseCurve: Curves.fastOutSlowIn,
        );

        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailsScreen(
              user: widget.user,
            ),
          ),
        );
      } catch (e) {
        showToast(
          'Something went wrong',
          context: context,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          animation: StyledToastAnimation.slideFromBottom,
          reverseAnimation: StyledToastAnimation.slideToBottom,
          position: StyledToastPosition.bottom,
          animDuration: const Duration(seconds: 1),
          curve: Curves.elasticOut,
          reverseCurve: Curves.fastOutSlowIn,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return UserDetailsScreen(
                        user: widget.user,
                      );
                    },
                  ),
                );
              },
            ),
            title: const Text('Add Product'),
            centerTitle: true,
          ),
          body: Container(
            margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
            width: width,
            height: height,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _productNameController,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Product Name',
                      hintText: 'Enter Product Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter product name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _productNameController.text = value!;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _productPriceController,
                    decoration: InputDecoration(
                      labelText: 'Product Price',
                      hintText: 'Enter Product Price',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter product price';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _productPriceController.text = value!;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _productCodeController,
                    decoration: InputDecoration(
                      labelText: 'Product Code',
                      hintText: 'Enter Product Code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter product code';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _productCodeController.text = value!;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _productBaseController,
                    decoration: InputDecoration(
                      labelText: 'Product Base',
                      hintText: 'Enter Product Base',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _productBaseController.text = value!;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green,
                        child: MaterialButton(
                          padding: const EdgeInsets.all(20),
                          minWidth: width,
                          onPressed: () async {
                            _addProductFirebase();
                          },
                          child: const Text('Add Product',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                              softWrap: false,
                              overflow: TextOverflow.fade),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red,
                        child: MaterialButton(
                          padding: const EdgeInsets.all(20),
                          minWidth: width,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Are you sure?'),
                                  content: const Text(
                                      'This action cannot be undone.'),
                                  actions: <Widget>[
                                    Material(
                                      child: MaterialButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Yes',
                                            style: TextStyle(
                                              color: Colors.blue,
                                            )),
                                      ),
                                    ),
                                    Material(
                                      child: MaterialButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel',
                                            style: TextStyle(
                                              color: Colors.blue,
                                            )),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text('Cancel',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                              softWrap: false,
                              overflow: TextOverflow.fade),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
