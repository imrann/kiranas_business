import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kirnas_business/CommonScreens/AppBarCommon.dart';
import 'package:kirnas_business/CommonScreens/FancyLoader.dart';
import 'package:kirnas_business/CommonScreens/SlideRightRoute.dart';
import 'package:kirnas_business/Controllers/ProductController.dart';
import 'package:kirnas_business/Podo/Product.dart';
import 'package:kirnas_business/Screens/Home.dart';
import 'package:kirnas_business/Screens/ImageProcessing.dart';
import 'package:kirnas_business/Screens/ProductDetails.dart';
import 'package:kirnas_business/StateManager/ProductListState.dart';
import 'package:path/path.dart' as path;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

Future<dynamic> productCategoryList;
File uploadedFile;
String imageURLToUpload;

class AddProduct extends StatefulWidget {
  final bool isUpdateProduct;
  final Product prouctDetail;
  AddProduct({this.isUpdateProduct, this.prouctDetail});

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  ProgressDialog progressDialogProduct;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> categoryList = new List<String>();

  @override
  void initState() {
    super.initState();
    categoryList = [
      "Rice",
      "Wheat",
      "Falooda",
      "Shampoo",
      "Soaps",
      "Masala",
      "Daal",
      "Pulses",
      "Dry Fruits",
      "Others"
    ];

    productCategoryList =
        ProductController().getFilterListByName("productCategoryList");
    productCategoryList.then((value) {
      categoryList.clear();
      categoryList.addAll(value);
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  // final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  // final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  // final GlobalKey<FormState> _formKey4 = GlobalKey<FormState>();
  // final GlobalKey<FormState> _formKey5 = GlobalKey<FormState>();

  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController productBrandController = TextEditingController();
  TextEditingController productUrlController = TextEditingController();
  TextEditingController productNetWeightController = TextEditingController();
  TextEditingController productCategoryController = TextEditingController();
  TextEditingController productCpController = TextEditingController();
  TextEditingController productMrpController = TextEditingController();
  TextEditingController productQtyController = TextEditingController();
  TextEditingController productUnitController = TextEditingController();

  TextEditingController productOffPriceController = TextEditingController();

  bool _autoValidate = false;
  bool _autoValidate1 = false;

  //bool _autoValidate = false;
  var _selectedCategoryType = '';

  @override
  void dispose() {
    productNameController.dispose();
    productCategoryController.dispose();
    productDescriptionController.dispose();
    productBrandController.dispose();
    productUrlController.dispose();
    productNetWeightController.dispose();
    productUnitController.dispose();
    productCpController.dispose();
    productMrpController.dispose();
    productQtyController.dispose();
    productOffPriceController.dispose();
    super.dispose();
  }

  StepState productBasicDetailMapStepState = StepState.indexed;
  StepState productPriceDetailsMapStepState = StepState.indexed;

  List<Map<String, dynamic>> get productBasicDetailMap => [
        {
          "validator": validateEmpty,
          "controller": productNameController,
          "decoration": InputDecoration(
            labelText: "Product Name*",
          ),
          "keyboardType": TextInputType.text,
          "initialvalue": widget.isUpdateProduct
              ? widget.prouctDetail.productData.productName
              : null,
        },
        {
          "validator": null,
          "controller": productDescriptionController,
          "decoration": InputDecoration(
            labelText: "Product Description*",
          ),
          "keyboardType": TextInputType.multiline,
          "initialvalue": widget.isUpdateProduct
              ? widget.prouctDetail.productData.productDescription
              : null,
        },
        {
          "validator": null,
          "controller": productBrandController,
          "decoration": InputDecoration(
            labelText: "Product Brand",
          ),
          "keyboardType": TextInputType.text,
          "initialvalue": widget.isUpdateProduct
              ? widget.prouctDetail.productData.productBrand
              : null,
        },
        {
          "validator": null,
          "controller": productUrlController,
          "decoration": InputDecoration(
            labelText: "Product Image",
          ),
          "keyboardType": TextInputType.multiline,
          "initialvalue": (widget.isUpdateProduct && uploadedFile == null)
              ? widget.prouctDetail.productData.productImageName
              : uploadedFile == null
                  ? null
                  : path.basename(uploadedFile.path)

          //  uploadedFile == null ? null : path.basename(uploadedFile.path)
        },
        {
          "validator": validateEmpty,
          "controller": productNetWeightController,
          "decoration": InputDecoration(
            labelText: "Product NetWeight",
          ),
          "keyboardType": TextInputType.text,
          "initialvalue": widget.isUpdateProduct
              ? widget.prouctDetail.productData.productNetWeight
              : null,
        },
        {
          "validator": validateEmpty,
          "controller": productCategoryController,
          "decoration": InputDecoration(
            labelText: "Product Category",
          ),
          "keyboardType": TextInputType.text,
          "initialvalue": widget.isUpdateProduct
              ? widget.prouctDetail.productData.productCategory
              : null,
          "dropDwonList": categoryList,
          "selectedDDvalue": widget.isUpdateProduct
              ? widget.prouctDetail.productData.productCategory
              : _selectedCategoryType,
          "hintText": "Category"
        },
      ];

  List<Map<String, dynamic>> get productPriceDetailsMap => [
        {
          "validator": validateDecimalNumberFileds,
          "controller": productCpController,
          "decoration": InputDecoration(
            labelText: "Cost Price*",
          ),
          "keyboardType": TextInputType.number,
          "initialvalue": widget.isUpdateProduct
              ? widget.prouctDetail.productData.productCp
              : null,
        },
        {
          "validator": validateDecimalNumberFileds,
          "controller": productMrpController,
          "decoration": InputDecoration(
            labelText: "MRP*",
          ),
          "keyboardType": TextInputType.number,
          "initialvalue": widget.isUpdateProduct
              ? widget.prouctDetail.productData.productMrp
              : null,
        },
        {
          "validator": validateNonDecimalNumberFileds,
          "controller": productQtyController,
          "decoration": InputDecoration(
            labelText: "Quantity",
          ),
          "keyboardType": TextInputType.number,
          "initialvalue": widget.isUpdateProduct
              ? widget.prouctDetail.productData.productQty
              : null,
        },
        {
          "validator": validateEmpty,
          "controller": productUnitController,
          "decoration": InputDecoration(
              labelText: "Unit",
              hintText: "Packaging type. eg:.pac/bottle/loose etc"),
          "keyboardType": TextInputType.text,
          "initialvalue": widget.isUpdateProduct
              ? widget.prouctDetail.productData.productUnit
              : null,
        },
        {
          "validator": validateDecimalNumberFileds,
          "controller": productOffPriceController,
          "decoration": InputDecoration(
            labelText: "Discount Price",
          ),
          "keyboardType": TextInputType.number,
          "initialvalue": widget.isUpdateProduct
              ? widget.prouctDetail.productData.productOffPrice.toString()
              : null,
        },
      ];

  List<Widget> getTextFormField(List<Map<String, dynamic>> d) {
    List<Widget> aa = [];
    for (var i = 0; i < d.length; i++) {
      if (d[i]['decoration'].toString().contains("Product Category")) {
        aa.add(DropdownButtonFormField<String>(
            autofocus: false,
            validator: d[i]['validator'],
            items: _getDropDownListItem(d[i]['dropDwonList']),
            value: d[i]['initialvalue'],
            onChanged: (String newSelectedValue) {
              setState(() {
                d[i]['selectedDDvalue'] = newSelectedValue;
                if (d[i]['decoration'].toString().contains("Category")) {
                  _selectedCategoryType = newSelectedValue;
                }
              });
            },
            hint: new Text("Select " + d[i]['hintText'])));
      } else {
        aa.add(Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.pink[900]),
          child: TextFormField(
            autofocus: false,

            onTap: () {
              if (d[i]['decoration'].toString().contains("Product Image")) {
                //chooseFile();
                Navigator.push(
                    context,
                    SlideRightRoute(
                        widget: ImageProcessing(
                          uploadedFilePreview: uploadedFile ?? null,
                        ),
                        slideAction: "horizontal"));
              }
            },

            //initialValue: d[i]['initialvalue'],

            validator: d[i]['validator'],
            controller: d[i]['controller']
              ..text = d[i]['controller'].text.isNotEmpty
                  ? d[i]['controller'].text.toString()
                  : d[i]['initialvalue'],
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            decoration: d[i]['decoration'],
            keyboardType: d[i]['keyboardType'],
          ),
        ));
      }
    }

    return aa;
  }

  List _getDropDownListItem(List<String> dropDwonList) {
    return dropDwonList.map((String dropDownItem) {
      return DropdownMenuItem<String>(
        value: dropDownItem,
        child: Text(dropDownItem),
      );
    }).toList();
  }

  Step getStep(String title, StepState stepState, Key keyForm,
      bool autovalidate, List<Widget> getTextFormField) {
    return Step(
      title: new Text(title),
      isActive: true,
      state: stepState,
      content: Form(
        key: keyForm,
        autovalidate: autovalidate,
        child: Column(
          children: getTextFormField,
        ),
      ),
    );
  }

  List<Step> get steps => [
        getStep("PRODUCT DETAILS", productBasicDetailMapStepState, _formKey,
            _autoValidate, getTextFormField(productBasicDetailMap)),
        getStep(
            "PRICE & SCHEME DETAILS",
            productPriceDetailsMapStepState,
            _formKey1,
            _autoValidate1,
            getTextFormField(productPriceDetailsMap)),
      ];

  @override
  Widget build(BuildContext context) {
    progressDialogProduct = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialogProduct.style(
        message: "It's almost done !",
        progressWidget: CircularProgressIndicator(),
        progressWidgetAlignment: Alignment.centerRight,
        textAlign: TextAlign.center);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: new AppBarCommon(
        title: widget.isUpdateProduct
            ? Text("UPDATE PRODUCTS")
            : Text("ADD PRODUCTS"),
        centerTile: false,
        context: context,
        notificationCount: Text("i"),
        isTabBar: false,
        searchOwner: "",
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        addProductFormUI(),

                        // Expanded(
                        //   child: Stepper(
                        //     steps: steps,
                        //     type: StepperType.vertical,
                        //     currentStep: currentStep,
                        //     onStepContinue: next,
                        //     // onStepTapped: (step) => goTo(step),
                        //     onStepCancel: cancel,
                        //   ),
                        // )
                      ],
                    ),
                    color: Colors.grey[50]),
              )),
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonTheme(
            minWidth: MediaQuery.of(context).size.width * 0.6,
            height: 45,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: RaisedButton(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                splashColor: Colors.white,
                onPressed: () {
                  widget.isUpdateProduct
                      ? validateUpdateProduct()
                      : validateCreateProduct();
                },
                color: Colors.pink[900],
                child: widget.isUpdateProduct
                    ? Text("UPDATE PRODUCT",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))
                    : Text("CREATE PRODUCT",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget addProductFormUI() {
    return FutureBuilder<dynamic>(
      future: productCategoryList,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error;
          print(error.toString());

          return getForms();
        } else if (snapshot.hasData) {
          List<String> data = snapshot.data;

          if (data.isEmpty || data.length == 0) {
            return getForms();
          } else {
            return getForms();
          }
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 400),
            child: Center(
              child: FancyLoader(
                loaderType: "logo",
              ),
            ),
          );
        }
      },
    );
  }

  previewImage(PickedFile _image) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Preview',
              textAlign: TextAlign.center,
            ),
            content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 500,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Image.asset(
                      _image.path,
                    ),
                  ),
                )),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.pink[900]),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  getForms() {
    return Expanded(
      child: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Colors.pink[900],
        ),
        child: Stepper(
          steps: steps,
          type: StepperType.vertical,
          currentStep: currentStep,
          onStepContinue: next,
          // onStepTapped: (step) => goTo(step),
          onStepCancel: cancel,
        ),
      ),
    );
  }

  int currentStep = 0;
  bool complete = false;

  String validateEmpty(String value) {
    if (value != null) {
      if (value.trim().length < 1) {
        return 'Name cannot be empty';
      } else
        return null;
    } else {
      return 'Name cannot be empty';
    }
  }

//Decimal number Validation

  String validateDecimalNumberFileds(String value) {
    Pattern pattern = r'^[0-9]+(\.[0-9]+)?$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'only digits are allowed';
    else
      return null;
  }

//nonDecimal number Validation
  String validateNonDecimalNumberFileds(String value) {
    Pattern pattern = r'^[0-9]*$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'only digits are allowed';
    else
      return null;
  }

  next() {
    bool isNextStep = true;
    if (currentStep == 0) {
      isNextStep = validateAll(
          1, "productBasicDetailMapStepState", _autoValidate, _formKey);
    } else if (currentStep == 1) {
      isNextStep = validateAll(
          2, "productPriceDetailsMapStepState", _autoValidate1, _formKey1);
    }

    if (isNextStep == true) {
      currentStep + 1 != steps.length
          ? goTo(currentStep + 1)
          : setState(() => complete = true);
    } else if (isNextStep == false) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Please, fill all fields displayed in RED!!!!"),
        duration: Duration(seconds: 2),
      ));
    }
  }

  cancel() {
    bool isNextStep = true;
    if (currentStep == 0) {
      isNextStep = validateAll(
          1, "productBasicDetailMapStepState", _autoValidate, _formKey);
    } else if (currentStep == 1) {
      isNextStep = validateAll(
          2, "productPriceDetailsMapStepState", _autoValidate1, _formKey1);
    }
    if (isNextStep == true) {
      if (currentStep > 0) {
        goTo(currentStep - 1);
      }
    } else if (isNextStep == false) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Please, fill all fields displayed in RED!!!!"),
        duration: Duration(seconds: 2),
      ));
    }
  }

  goTo(int step) {
    //  if(_autoValidate == true && stepState ==  StepState.error){
    //        setState(() {
    //       stepState = StepState.editing;

    //     });
    //     }
    setState(() => currentStep = step);
  }

  bool validateAll(int validation, String stepState, bool validate,
      GlobalKey<FormState> formKey) {
    bool isNextStep;

    if (!formKey.currentState.validate()) {
      setState(() {
        if (stepState == "productBasicDetailMapStepState") {
          productBasicDetailMapStepState = StepState.error;
          _autoValidate = true;
        } else if (stepState == "productPriceDetailsMapStepState") {
          productPriceDetailsMapStepState = StepState.error;
          _autoValidate1 = true;
        }
      });
      isNextStep = false;
    } else {
      setState(() {
        if (stepState == "productBasicDetailMapStepState") {
          productBasicDetailMapStepState = StepState.complete;
          _autoValidate = true;
        } else if (stepState == "productPriceDetailsMapStepState") {
          productPriceDetailsMapStepState = StepState.complete;
          _autoValidate1 = true;
        }
      });
      isNextStep = true;
    }

    return isNextStep;
  }

  void validateCreateProduct() {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (_formKey.currentState.validate() && _formKey1.currentState.validate()) {
      progressDialogProduct.show().then((isShown) async {
        if (isShown) {
          _formKey.currentState.save();
          _formKey1.currentState.save();

          if (uploadedFile != null) {
            addProductImage();
          } else {
            Fluttertoast.showToast(
                msg: " Please select an image first!",
                fontSize: 13,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.black);
          }
        }
      });
//    If all data are correct then save data to out variables

    } else {
//    If all data are not valid then start auto validation.

      validateAll(1, "inventoryDetailStepState", _autoValidate, _formKey);
      validateAll(2, "priceStepState", _autoValidate1, _formKey1);

      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Please, fill all fields displayed in RED!!!!"),
        duration: Duration(seconds: 3),
      ));
    }
  }

  void validateUpdateProduct() {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (_formKey.currentState.validate() && _formKey1.currentState.validate()) {
      progressDialogProduct.show().then((isShown) async {
        if (isShown) {
          _formKey.currentState.save();
          _formKey1.currentState.save();

          if (uploadedFile != null) {
            StorageReference storageReferenceDelete = FirebaseStorage.instance
                .ref()
                .child(
                    'Products/${widget.prouctDetail.productData.productImageName}');

            storageReferenceDelete.delete().then((_) {
              print("file Deleted");
              addProductImage();
            }).catchError((err) {
              progressDialogProduct.hide();
              scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(
                  "something went wrong!",
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 5),
              ));
            });
          } else {
            updateProduct(widget.prouctDetail.productData.productUrl,
                widget.prouctDetail.productData.productImageName);
          }
        }
      });
//    If all data are correct then save data to out variables

    } else {
//    If all data are not valid then start auto validation.

      validateAll(1, "inventoryDetailStepState", _autoValidate, _formKey);
      validateAll(2, "priceStepState", _autoValidate1, _formKey1);

      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Please, fill all fields displayed in RED!!!!"),
        duration: Duration(seconds: 3),
      ));
    }
  }

  addProductImage() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('Products/${path.basename(uploadedFile.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(uploadedFile);
    await uploadTask.onComplete;

    storageReference.getDownloadURL().then((fileURL) {
      if (widget.isUpdateProduct) {
        updateProduct(fileURL, path.basename(uploadedFile.path));
      } else {
        createProduct(fileURL, path.basename(uploadedFile.path));
      }
    }).catchError((err) {
      progressDialogProduct.hide();
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "problem adding image!",
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 5),
      ));
    });
  }

  updateProduct(String fileURL, String imageName) {
    ProductController()
        .updateProduct(
            productBrandController.text,
            _selectedCategoryType == ""
                ? widget.prouctDetail.productData.productCategory
                : _selectedCategoryType,
            productCpController.text,
            productDescriptionController.text,
            productMrpController.text,
            productNameController.text,
            productOffPriceController.text,
            productQtyController.text,
            productUnitController.text,
            productNetWeightController.text,
            fileURL,
            widget.prouctDetail.productData.productID,
            imageName)
        .then((isProductUpdated) async {
      if (isProductUpdated == "true") {
        dynamic productList =
            await ProductController().getProductList().catchError((error) {
          progressDialogProduct.hide();
          print(error.toString());
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              "Something went wrong",
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 5),
          ));
        });

        productDetails = ProductController()
            .getProductByID(widget.prouctDetail.productData.productID);
        productDetails.then((value) {
          var productState =
              Provider.of<ProductListState>(context, listen: false);
          productState.setProductState(value);

          var productListState =
              Provider.of<ProductListState>(context, listen: false);
          productListState.setProductListState(productList);

          setState(() {
            uploadedFile = null;
          });

          Navigator.of(context).pop();

          progressDialogProduct.hide();
        }).catchError((err) {
          print(err.toString());
          progressDialogProduct.hide();
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              "something went wrong!",
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 5),
          ));
        });
      }
    });
  }

  createProduct(String fileURL, String imageName) {
    ProductController()
        .createProduct(
            productBrandController.text,
            _selectedCategoryType,
            productCpController.text,
            productDescriptionController.text,
            productMrpController.text,
            productNameController.text,
            productOffPriceController.text,
            productQtyController.text,
            productUnitController.text,
            productNetWeightController.text,
            fileURL,
            imageName)
        .then((isProductCreated) async {
      if (isProductCreated == "true") {
        productList = ProductController().getProductList();
        productList.then((value) {
          var productListState =
              Provider.of<ProductListState>(context, listen: false);
          productListState.setProductListState(value);

          setState(() {
            uploadedFile = null;
          });

          Navigator.of(context).pop();

          progressDialogProduct.hide();
        }).catchError((err) {
          progressDialogProduct.hide();
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              "Something went wrong!",
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 5),
          ));
        });
      }
    }).catchError((err) {
      progressDialogProduct.hide();
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Something went wrong!",
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 5),
      ));
    });
    ;
  }
}
