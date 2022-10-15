import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:ganpatistore_desktop/Models/user_model.dart';
import 'package:ganpatistore_desktop/Screens/user_details_screen.dart';

import 'add_user_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  CollectionReference userCollection = Firestore.instance.collection('users');

  Future<List<Document>> getUsers() async {
    var users = await userCollection.orderBy('name').get();
    return users;
  }

  late Future resultsLoaded;
  final List _allUsers = [];
  final List _resultsList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getAllUserData();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];
    if (_searchController.text.isNotEmpty) {
      for (var user in _allUsers) {
        var userName = UserModel.fromMap(user).name.toLowerCase();
        if (userName.contains(_searchController.text.toLowerCase())) {
          showResults.add(user);
        }
      }
    } else {
      showResults = _allUsers;
    }
    setState(() {
      _resultsList.clear();
      _resultsList.addAll(showResults);
    });
  }

  getAllUserData() async {
    var data = await getUsers();
    setState(() {
      _allUsers.addAll(data);
    });
    searchResultsList();
    return "done";
  }

  userCard() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: _resultsList.length,
        itemBuilder: (context, index) {
          var user = _resultsList[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.015),
              side: const BorderSide(
                  color: Colors.blueGrey, width: 1.0, style: BorderStyle.solid),
            ),
            child: InkWell(
              child: ListTile(
                title: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.015),
                  child: Text(
                    user['name'].toString().toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                subtitle: Text(
                  (' Address: ${user['address']}\n Number: ${user['phoneNumber']}'),
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(212, 7, 31, 120),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDetailsScreen(
                      user: UserModel(
                        docId: user['docId'],
                        name: user['name'],
                        phoneNumber: user['phoneNumber'],
                        address: user['address'],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Ganpati Store',
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddUserScreen(),
                    ),
                  );
                },
                iconSize: 30,
              ),
              const SizedBox(width: 30),
            ],
          ),
          body: Container(
            margin: const EdgeInsets.all(20),
            width: width,
            height: height,
            child: Column(
              children: <Widget>[
                Card(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: userCard(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
