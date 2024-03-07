import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:virtoustack_assignment/modules/home/home_controller.dart';

class BottomSheetWidget extends StatefulWidget {
  final String? id;
  final String? title;
  final String? description;
  final String? image;
  final bool isEdit;
  const BottomSheetWidget({Key? key, required this.isEdit, this.title, this.description, this.image, this.id}) : super(key: key);

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  void initState() {
    super.initState();
    HomeController controller = Get.find<HomeController>();
    if (widget.isEdit) {
      controller.titleController.text = widget.title!;
      controller.descriptionController.text = widget.description!;
      // controller.imageFile = File(widget.image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.find<HomeController>();
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height / 2,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Colors.white,
        ),
        child: Obx(
          () => controller.isSaving
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25),
                      Text(
                        widget.isEdit ? "Edit Item" : "Add Item",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: Get.context!,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Select Image'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.camera),
                                      title: const Text('Take a Photo'),
                                      onTap: () {
                                        Get.back();
                                        controller.pickImage(ImageSource.camera);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.photo),
                                      title: const Text('Choose from Gallery'),
                                      onTap: () {
                                        Get.back();
                                        controller.pickImage(ImageSource.gallery);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: const Center(child: Text("Image")),
                            ),
                            Container(
                              width: 80,
                              height: 15,
                              decoration: BoxDecoration(
                                color: Colors.grey[500],
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              child: const Center(
                                  child: Text(
                                "Pick",
                                style: TextStyle(fontSize: 8),
                              )),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: controller.titleController,
                        decoration: const InputDecoration(
                          hintText: "Enter Title",
                          labelText: "Title",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: controller.descriptionController,
                        decoration: const InputDecoration(
                          hintText: "Enter Description",
                          labelText: "Description",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: size.width - 30,
                            child: ElevatedButton(
                              onPressed: () {
                                widget.isEdit ? controller.editItem(widget.id!, controller.imageFile) : controller.addItem();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6750A4),
                                shape: const StadiumBorder(),
                              ),
                              child: const Text(
                                "SAVE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ));
  }
}
