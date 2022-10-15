import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:ganpatistore_desktop/Models/product_model.dart';
import 'package:ganpatistore_desktop/Models/user_model.dart';
import 'package:ganpatistore_desktop/Screens/add_product_screen.dart';
import 'package:ganpatistore_desktop/Screens/home_screen.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key, required this.user});
  final UserModel user;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CollectionReference productCollection =
      Firestore.instance.collection('products');
  CollectionReference userCollection = Firestore.instance.collection('users');

  Future<List<Document>> getProducts() async {
    var products = await productCollection
        .where('buyerId', isEqualTo: widget.user.docId)
        .get();
    return products;
  }

  late Future productsLoaded;
  final List _allProducts = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    productsLoaded = getAllProductData();
  }

  getAllProductData() async {
    var data = await getProducts();
    setState(
      () {
        _allProducts.addAll(data);
        _allProducts.sort(
          (a, b) => b['updatedAt'].compareTo(a['updatedAt']),
        );
      },
    );
  }

  Future deleteAllProducts() async {
    var products = await productCollection
        .where('buyerId', isEqualTo: widget.user.docId)
        .get();

    if (products.isNotEmpty) {
      for (var product in products) {
        await productCollection.document(product.id).delete();
      }
    }
  }

  updateBuyerName() async {
    await productCollection
        .where('buyerId', isEqualTo: widget.user.docId)
        .get()
        .then((value) {
      for (var product in value) {
        productCollection.document(product.id).update({
          'buyerName': widget.user.name,
        });
      }
    });
  }

  productCard() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 500,
      child: FutureBuilder(
        future: productsLoaded,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: _allProducts.length,
              itemBuilder: (context, index) {
                var productFromList = _allProducts[index];
                return Card(
                  elevation: 8,
                  margin: const EdgeInsets.all(10.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${productFromList['productName']}'
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Code: ${productFromList['productCode']}\nBase: ${productFromList['productBase']}\nPrice: Rs ${productFromList['productPrice']}|-',
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(212, 7, 31, 120),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                        size: 30.0,
                                      ),
                                      onPressed: () {
                                        _editProductDialog(productFromList);
                                      },
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 30.0,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Delete Product'),
                                            content: const Text(
                                                'Are you sure you want to delete this product?'),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                child: const Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              ElevatedButton(
                                                child: const Text(
                                                    'Delete Product'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  productCollection
                                                      .document(productFromList[
                                                          'productId'])
                                                      .delete();
                                                  setState(() {
                                                    _allProducts.remove(
                                                        productFromList);
                                                  });
                                                  showToast(
                                                    'Product Deleted Successfully',
                                                    context: context,
                                                    animation:
                                                        StyledToastAnimation
                                                            .scale,
                                                    reverseAnimation:
                                                        StyledToastAnimation
                                                            .fade,
                                                    position:
                                                        StyledToastPosition
                                                            .bottom,
                                                    animDuration:
                                                        const Duration(
                                                            seconds: 1),
                                                    duration: const Duration(
                                                        seconds: 4),
                                                    curve: Curves.elasticOut,
                                                    reverseCurve:
                                                        Curves.fastOutSlowIn,
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30.0),
                                Text(
                                  '${productFromList['updatedAt']}',
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _editInsideFirebase(user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit'),
          content: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  controller: TextEditingController(
                    text: user.name,
                  ),
                  onChanged: (value) {
                    user.name = value;
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  controller: TextEditingController(
                    text: user.phoneNumber,
                  ),
                  onChanged: (value) {
                    user.phoneNumber = value;
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Address',
                  ),
                  controller: TextEditingController(
                    text: user.address,
                  ),
                  onChanged: (value) {
                    user.address = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            Material(
              child: MaterialButton(
                color: Colors.blue,
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Material(
              child: MaterialButton(
                color: Colors.blue,
                child: const Text(
                  'Edit',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  userCollection
                      .document(user.docId)
                      .update(user.toJson())
                      .then((value) {
                    updateBuyerName();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailsScreen(
                          user: user,
                        ),
                      ),
                    );
                    showToast(
                      'User Details Updated Successfully',
                      context: context,
                      backgroundColor: Colors.green,
                      animation: StyledToastAnimation.scale,
                      reverseAnimation: StyledToastAnimation.fade,
                      position: StyledToastPosition.bottom,
                      animDuration: const Duration(seconds: 1),
                      duration: const Duration(seconds: 4),
                      curve: Curves.elasticOut,
                      reverseCurve: Curves.fastOutSlowIn,
                    );
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteFromFirebase(user) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: [
            Material(
              child: MaterialButton(
                color: Colors.blue,
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Material(
              child: MaterialButton(
                color: Colors.blue,
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  userCollection.document(user.docId).delete().then((value) {
                    deleteAllProducts();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                    showToast(
                      'User Deleted Successfully',
                      context: context,
                      backgroundColor: Colors.red,
                      animation: StyledToastAnimation.scale,
                      reverseAnimation: StyledToastAnimation.fade,
                      position: StyledToastPosition.bottom,
                      animDuration: const Duration(seconds: 1),
                      duration: const Duration(seconds: 4),
                      curve: Curves.elasticOut,
                      reverseCurve: Curves.fastOutSlowIn,
                    );
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _editProductDialog(productFromList) async {
    final TextEditingController nameController =
        TextEditingController(text: productFromList['productName']);
    final TextEditingController priceController =
        TextEditingController(text: productFromList['productPrice']);
    final TextEditingController codeController =
        TextEditingController(text: productFromList['productCode']);
    final TextEditingController baseController =
        TextEditingController(text: productFromList['productBase']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit'),
          content: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                    ),
                    controller: nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter product name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      nameController.text = value!;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Product Price',
                    ),
                    controller: priceController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter product price';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      priceController.text = value!;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Product Code',
                    ),
                    controller: codeController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter product code';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      codeController.text = value!;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Product Base',
                    ),
                    controller: baseController,
                    onSaved: (value) {
                      baseController.text = value!;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Material(
              child: MaterialButton(
                color: Colors.blue,
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Material(
              child: MaterialButton(
                color: Colors.blue,
                child: const Text(
                  'Edit',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final product = ProductModel(
                      productName: nameController.text,
                      productPrice: priceController.text,
                      productCode: codeController.text,
                      productBase: baseController.text,
                      productId: productFromList['productId'],
                      buyerId: productFromList['buyerId'],
                      buyerName: productFromList['buyerName'],
                      createdAt: productFromList['createdAt'],
                      updatedAt: productFromList['updatedAt'],
                    );
                    try {
                      productCollection
                          .document(productFromList['productId'])
                          .update(product.toJson())
                          .then(
                        (value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserDetailsScreen(user: widget.user),
                            ),
                          );
                        },
                      );

                      showToast(
                        'Product edited successfully',
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
                    } catch (e) {
                      showToast(
                        'Error editing product',
                        context: context,
                        backgroundColor: Colors.red,
                        animation: StyledToastAnimation.slideFromBottom,
                        reverseAnimation: StyledToastAnimation.slideToBottom,
                        position: StyledToastPosition.bottom,
                        animDuration: const Duration(seconds: 1),
                        duration: const Duration(seconds: 4),
                        curve: Curves.elasticOut,
                        reverseCurve: Curves.fastOutSlowIn,
                      );
                    }
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('${'${widget.user.name}'.toUpperCase()} Details'),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.my_library_add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProductScreen(
                        user: widget.user,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState!.openEndDrawer();
                },
              ),
            ],
          ),
          endDrawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${widget.user.name}'.toUpperCase()),
                      const SizedBox(height: 20),
                      Text('${widget.user.phoneNumber}'),
                      const SizedBox(height: 20),
                      Text('${widget.user.address}'),
                    ],
                  ),
                ),
                ListTile(
                  title: const Text('Edit'),
                  onTap: () {
                    _editInsideFirebase(widget.user);
                  },
                ),
                ListTile(
                  title: const Text('Delete'),
                  onTap: () {
                    _deleteFromFirebase(widget.user);
                  },
                ),
              ],
            ),
          ),
          body: Container(
            margin: const EdgeInsets.all(10),
            width: width,
            height: height,
            child: productCard(),
          ),
        );
      },
    );
  }
}
