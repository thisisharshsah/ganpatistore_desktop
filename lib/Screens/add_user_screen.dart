import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:ganpatistore_desktop/Models/user_model.dart';
import 'package:ganpatistore_desktop/Screens/home_screen.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  void _addUserFirebase() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        CollectionReference firestore = Firestore.instance.collection('users');
        final user = UserModel(
          name: _nameController.text,
          phoneNumber: _phoneController.text,
          address: _addressController.text,
        );
        try {
          var docref = await firestore.add(user.toJson());
          user.docId = docref.id;
          await firestore.document(docref.id).set(user.toJson());

          showToast(
            'User added successfully',
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
              builder: (context) => const HomeScreen(),
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
      } else {
        showToast(
          'Please fill all the fields',
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text('Ganpati Store'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20),
              width: width,
              height: height,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      controller: _nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _nameController.text = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone),
                        labelText: 'Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      controller: _phoneController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a valid number';
                        } else if (value.length != 10) {
                          return 'Your number must be of 10 digits';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _phoneController.text = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.location_on_outlined),
                        labelText: 'Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      controller: _addressController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter address';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _addressController.text = value!;
                      },
                    ),
                    const SizedBox(height: 30),
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green,
                      child: MaterialButton(
                        padding: const EdgeInsets.all(20),
                        minWidth: width,
                        onPressed: () async {
                          _addUserFirebase();
                        },
                        child: const Text('Add',
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
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
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
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
