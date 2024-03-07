import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:virtoustack_assignment/common/storage_service.dart';
import 'package:virtoustack_assignment/routes/app_routes.dart';
import 'package:virtoustack_assignment/utils/app_utils.dart';

class HomeController extends GetxController {
  dynamic _imageFile;

  final Rx<TextEditingController> _titleController = Rx(TextEditingController());

  final Rx<TextEditingController> _descriptionController = Rx(TextEditingController());

  final RxBool _isSaving = RxBool(false);

  bool get isSaving => _isSaving.value;

  TextEditingController get descriptionController => _descriptionController.value;

  TextEditingController get titleController => _titleController.value;

  File get imageFile => _imageFile;

  final CollectionReference _itemsRef = FirebaseFirestore.instance.collection('items');

  updateIsSaving(bool value) {
    _isSaving.value = value;
    update();
  }

  Future<void> addItem() async {
    updateIsSaving(true);
    try {
      var itemId = AppUtils.generateItemId();
      DocumentReference itemDoc = _itemsRef.doc(itemId);
      String image = await uploadImage(imageFile, itemId);
      await itemDoc.set({
        'itemId': itemId,
        'title': titleController.text,
        'description': descriptionController.text,
        'image': image,
        'createdAt': FieldValue.serverTimestamp(),
      });
      updateIsSaving(false);
      Get.back();
      Get.snackbar("Success", "Item added successfully");
    } catch (e) {
      updateIsSaving(false);
    }
  }

  Future<void> editItem(String id, File? newImage) async {
    updateIsSaving(true);
    try {
      String? image;
      if (newImage != null) {
        image = await uploadImage(newImage, id);
      }
      await _itemsRef.doc(id).update({
        'title': titleController.text,
        'description': descriptionController.text,
        'image': image,
      });
      updateIsSaving(false);
      Get.back();
      Get.snackbar("Success", "Item updated successfully");
    } catch (e) {
      updateIsSaving(false);
    }
  }

  Future<void> deleteItem(String id, String imageUrl) async {
    updateIsSaving(true);
    try {
      DocumentReference itemDoc = _itemsRef.doc(id);
      await itemDoc.delete();
      if (imageUrl.isNotEmpty) {
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      }
      updateIsSaving(false);
      Get.snackbar("Success", "Item deleted successfully");
    } catch (e) {
      updateIsSaving(false);
    }
  }

  Future<String> uploadImage(File image, String itemId) async {
    Reference ref = FirebaseStorage.instance.ref().child('images/$itemId');
    UploadTask uploadTask = ref.putFile(image);
    await uploadTask;
    return ref.getDownloadURL();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);

      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        Get.snackbar("Error", "No image selected");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  logout() {
    StorageService.instance.clearAll();
    Get.offAllNamed(AppRoutes.authRoute);
  }
}
