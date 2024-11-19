// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sellers/constants/custom_button.dart';
import 'package:sellers/constants/custom_snackbar.dart';
import 'package:sellers/constants/custom_text.dart';
import 'package:sellers/controllers/firebase_firestore_helper.dart';
import 'package:sellers/providers/app_provider.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({
    super.key,
    required,
  });

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  File? image;
  void takePicture() async {
    XFile? value = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (value != null) {
      setState(() {
        image = File(value.path);
      });
    }
  }

  final FirebaseFirestoreHelper _firestoreHelper = FirebaseFirestoreHelper();

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController discount = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController size = TextEditingController();
  TextEditingController measurement = TextEditingController();

  List<String> measurments = ['gram', 'ML'];
  String? _selectedUnit;
  bool isDiscountEnabled = false;
  DateTime? startDate;
  DateTime? endDate;

  Future<void> pickEndDate() async {
    showCustomDateRangePicker(
      context,
      dismissible: true,
      minimumDate: DateTime.now().subtract(const Duration(days: 30)),
      maximumDate: DateTime.now().add(const Duration(days: 30)),
      endDate: endDate,
      startDate: startDate,
      backgroundColor: Colors.white,
      primaryColor: Colors.green,
      onApplyClick: (start, end) {
        setState(() {
          endDate = end;
          startDate = start;
        });
      },
      onCancelClick: () {
        setState(() {
          endDate = null;
          startDate = null;
        });
      },
    );
    ;
  }

  String? selectedCategoryId;
  String? selectedCategoryName;

  Future<QuerySnapshot?> getCategoriesList() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    return querySnapshot;
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Product ')),
        // drawer: CustomDrawer(),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          children: [
            image == null
                ? CupertinoButton(
                    onPressed: () {
                      takePicture();
                    },
                    child: const CircleAvatar(
                      radius: 55,
                      child: Icon(Icons.camera_alt),
                    ),
                  )
                : CupertinoButton(
                    onPressed: () {
                      takePicture();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: Image.file(image!),
                    ),
                  ),
            SizedBox(height: 12),
            TextFormField(
              controller: name,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Product name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter product name';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            FutureBuilder<QuerySnapshot?>(
                future: getCategoriesList(),
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedCategoryName,
                        hint: Text('Select Category'),
                        items: snapshot.data!.docs.map((e) {
                          return DropdownMenuItem<String>(
                            value: e['name'],
                            child: Text(e['name']),
                          );
                        }).toList(),
                        onChanged: (selectedCategory) {
                          setState(() {
                            selectedCategoryName = selectedCategory;
                            selectedCategoryId = snapshot.data!.docs
                                .firstWhere(
                                    (doc) => doc['name'] == selectedCategory)
                                .get('id');
                          });
                        },
                      )
                    ],
                  );
                }),
            const SizedBox(height: 12),
            TextFormField(
              controller: description,
              minLines: 2,
              maxLines: 10,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Product discription'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter product description';
                }
              },
            ),
            const SizedBox(height: 12),
            Expanded(
                child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: price,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Price',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter product price';
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                text(
                    title: isDiscountEnabled
                        ? 'Disable Discount'
                        : 'Enable Discount'),
                Checkbox(
                  value: isDiscountEnabled,
                  onChanged: (value) {
                    setState(() {
                      isDiscountEnabled = value!;
                    });
                  },
                ),
              ],
            )),
            if (isDiscountEnabled)
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: discount,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Discount',
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            pickEndDate();
                          },
                          icon: Icon(Icons.date_range)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      text(title: 'Discount Until'),
                      text(title: endDate.toString()),
                    ],
                  ),
                ],
              ),
            //  if (discount.text.isNotEmpty)

            const SizedBox(height: 12),
            Expanded(
                child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: quantity,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Quantity',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter product quantity';
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: size,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Size',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter product size';
                      }
                    },
                  ),
                ),
              ],
            )),
            const SizedBox(height: 12),
            DropdownButtonFormField(
              dropdownColor: Colors.white,
              value: _selectedUnit,
              hint: Text('Measurement unit'),
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  _selectedUnit = value;
                });
              },
              items: measurments
                  .map<DropdownMenuItem<String>>((String selectedUnit) {
                return DropdownMenuItem<String>(
                  value: selectedUnit,
                  child: Text(selectedUnit),
                );
              }).toList(),
            ),
            SizedBox(height: 12),
            const SizedBox(height: 20),
            SizedBox(
                child: CustomButton(
                    color: Colors.green.shade300,
                    onPressed: () async {
                      if (image == null) {
                        customSnackbar(
                            context: context,
                            message: 'Please add image of product',
                            backgroundColor: Colors.red);
                      } else if (selectedCategoryName == null) {
                        customSnackbar(
                            context: context,
                            message: 'Category not selected',
                            backgroundColor: Colors.red);
                      } else if (_selectedUnit == null) {
                        customSnackbar(
                            message: 'Measurment unit not selected',
                            context: context);
                      } else if (image != null &&
                          _formKey.currentState!.validate()) {
                        appProvider.addProduct(
                          image!,
                          name.text.trim(),
                          description.text.trim(),
                          selectedCategoryId!,
                          price.text.toString(),
                          discount.text.toString(),
                          quantity.text.toString(),
                          size.text.toString(),
                          _selectedUnit!,
                          startDate.toString(),
                          endDate.toString(),
                        );

                        customSnackbar(
                            context: context,
                            message: 'Product successfully Added',
                            backgroundColor: Colors.green.shade400);
                        setState(() {
                          image = null;
                          name.clear();
                          description.clear();
                          price.clear();
                          discount.clear();
                          quantity.clear();
                          size.clear();
                          endDate = null;
                          startDate = null;
                          selectedCategoryName = null;
                          _selectedUnit = null;
                        });
                      }
                    },
                    title: 'Add')),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
