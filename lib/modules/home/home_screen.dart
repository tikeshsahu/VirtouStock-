import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:virtoustack_assignment/modules/home/home_controller.dart';
import 'package:virtoustack_assignment/modules/home/widgets/bottom_sheet_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xffF3EDF7),
          title: const Text('ITEMS'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                controller.logout();
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: const BottomSheetWidget(
                      isEdit: false,
                    ),
                  );
                }).whenComplete(() {
              controller.titleController.clear();
              controller.descriptionController.clear();
              // controller.imageFile = File("");
            });
          },
          backgroundColor: const Color(0xffFFD8E4),
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
            top: true,
            bottom: true,
            child: Column(
              children: [
                const SizedBox(height: 20),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('items').orderBy('createdAt', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 18,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemBuilder: (context, index) {
                        var item = snapshot.data!.docs[index];
                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.startToEnd,
                          confirmDismiss: (direction) {
                            Completer<bool> completer = Completer<bool>();
                            Get.defaultDialog(
                              title: "Delete Item",
                              middleText: "Are you sure you want to delete this item?",
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    completer.complete(false);
                                    Get.back();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    controller.deleteItem(item['itemId'], item['image']);
                                    completer.complete(true);
                                    Get.back();
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                            return completer.future;
                          },
                          background: Container(
                            color: Colors.red,
                            padding: const EdgeInsets.only(left: 16),
                            alignment: Alignment.centerLeft,
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: size.width * 0.18,
                                height: size.height * 0.083,
                                decoration: const BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                ),
                                child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                    child: Image.network(item['image'], fit: BoxFit.fill)),
                              ),
                              Container(
                                width: size.width * 0.75,
                                decoration: BoxDecoration(
                                    color: Colors.white, 
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5),
                                    ]),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                  title: Text(item['title']),
                                  subtitle: Text(item['description']),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return BottomSheetWidget(
                                              id: item['itemId'],
                                              title: item['title'],
                                              description: item['description'],
                                              image: item['image'],
                                              isEdit: true,
                                            );
                                          }).whenComplete(() {
                                        controller.titleController.clear();
                                        controller.descriptionController.clear();
                                      });
                                    },
                                    child: const CircleAvatar(
                                        radius: 18,
                                        backgroundColor: Color.fromARGB(255, 244, 229, 247),
                                        child: Icon(
                                          Icons.edit_outlined,
                                          color: Colors.deepPurple,
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // ),
                        );
                      },
                    );
                  },
                ),
              ],
            )));
  }
}
