import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kirnas_business/CommonScreens/ErrorPage.dart';
import 'package:kirnas_business/CommonScreens/FancyLoader.dart';
import 'package:kirnas_business/CommonScreens/MainCategoryList.dart';
import 'package:kirnas_business/Controllers/ProductController.dart';
import 'package:kirnas_business/StateManager/FilterListState.dart';
import 'package:kirnas_business/StateManager/ProductListState.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

Future<dynamic> filterSubList;

class ProductFilter extends StatefulWidget {
  @override
  _ProductFilterState createState() => _ProductFilterState();
}

class _ProductFilterState extends State<ProductFilter> {
  List<String> cat = new List<String>();
  List<String> dis = new List<String>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ProgressDialog progressDialog;

  List<String> cachedSubFilters = new List<String>();
  @override
  void initState() {
    List<String> cachedSubFilters = [];
    // TODO: implement initState
    super.initState();
    filterSubList =
        ProductController().getFilterListByName("productCategoryList");

    filterSubList.then((value) {
      var filter = Provider.of<FilterListState>(context, listen: false);
      cat.addAll(filter.getSFilterProductCategory());
      dis.addAll(filter.getSFilterDiscountCategory());
      filter.setFilterProductCategory(value);
      filter.setActiveFilter("productCategoryList");
      cachedSubFilters.add("Category");
    });
  }

  int selectedIndex;

  @override
  Widget build(BuildContext context) {
    progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialog.style(
        message: "Applying Filters...",
        progressWidget: CircularProgressIndicator(),
        progressWidgetAlignment: Alignment.centerRight,
        textAlign: TextAlign.center);

    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Filters",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              FlatButton(
                  onPressed: () {
                    setState(() {
                      dis.clear();
                      cat.clear();
                    });
                  },
                  child: Text(
                    "CLEAR ALL",
                    style: TextStyle(fontSize: 12, color: Colors.pink[900]),
                  )),
            ],
          ),
          Divider(
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.grey[300], Colors.white])),
                      height: MediaQuery.of(context).size.height * 0.73,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: filtercategoryMainList(),
                    )
                  ],
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.grey[100], Colors.white])),
                      height: MediaQuery.of(context).size.height * 0.73,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: filtercategorySubList(),
                    )
                  ],
                )
              ],
            ),
          ),
          ButtonTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            minWidth: MediaQuery.of(context).size.width * 0.4,
            height: 30,
            child: RaisedButton(
              splashColor: Colors.white,
              color: Colors.pink[900],
              elevation: 5,
              onPressed: () {
                applyFilters();
              },
              child: Text("APPLY",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  applyFilters() {
    progressDialog.show().then((isShown) {
      if (isShown) {
        var filter = Provider.of<FilterListState>(context, listen: false);

        filter.clearSFilterDiscountCategory();
        filter.clearSFilterProductCategory();

        filter.setSFilterDiscountCategory(dis);
        filter.setSFilterProductCategory(cat);

        print(filter.getSFilterDiscountCategory().toString());
        print(filter.getSFilterProductCategory().toString());

        if ((filter.getSFilterDiscountCategory().length == 0) &&
            (filter.getSFilterProductCategory().length == 0)) {
          filter.setProductFilterNotification(false);
        } else {
          filter.setProductFilterNotification(true);
        }

        ProductController()
            .getFilterSearchList(filter.getSFilterProductCategory(),
                filter.getSFilterDiscountCategory())
            .then((value) {
          var productState =
              Provider.of<ProductListState>(context, listen: false);
          productState.setProductListState(value);
          Navigator.of(context).pop();
          progressDialog.hide();
          Fluttertoast.showToast(
              msg: productState.getProductListState().length.toString() +
                  " filter result!",
              fontSize: 13,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.black);
        }).catchError((err) {
          progressDialog.hide();
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              "$err",
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 5),
          ));
        });
      }
    });
  }

  filtercategorySubList() {
    return FutureBuilder<dynamic>(
      future: filterSubList,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error;

          return ErrorPage(error: error.toString());
        } else if (snapshot.hasData) {
          var data = snapshot.data;

          if (data.isEmpty || data.length == 0) {
            return Center(
              child: Text("0 Filters !!!",
                  style: TextStyle(
                      color: Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 15)),
            );
          } else {
            return Scrollbar(child:
                Consumer<FilterListState>(builder: (context, filter, child) {
              var filterState;
              var filterListLocal;
              var activeFilter = filter.getActiveFilter();
              if (filter.getActiveFilter().contains("productCategoryList")) {
                filterState = filter.getFilterProductCategory();
                filterListLocal = cat;
              } else if (filter
                  .getActiveFilter()
                  .contains("productDiscountList")) {
                filterState = filter.getFilterDiscountCategory();
                filterListLocal = dis;
              }
              if (filterState.length > 0) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,

                          //controller: _scrollController,

                          itemCount: filterState.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      if (!filterListLocal
                                          .contains(filterState[index])) {
                                        switch (activeFilter) {
                                          case "productCategoryList":
                                            setState(() {
                                              cat.add(filterState[index]);
                                            });
                                            break;
                                          case "productDiscountList":
                                            setState(() {
                                              dis.clear();
                                              dis.add(filterState[index]);
                                            });

                                            break;
                                          default:
                                        }
                                      } else if (filterListLocal
                                          .contains(filterState[index])) {
                                        switch (activeFilter) {
                                          case "productCategoryList":
                                            setState(() {
                                              cat.remove(filterState[index]);
                                            });

                                            break;
                                          case "productDiscountList":
                                            setState(() {
                                              dis.remove(filterState[index]);
                                            });
                                            break;
                                          default:
                                        }
                                      }
                                    },
                                    dense: true,
                                    title: Row(
                                      children: [
                                        Icon(
                                          Icons.check,
                                          size: 20,
                                          color: (filterListLocal
                                                  .contains(filterState[index]))
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          activeFilter == "productDiscountList"
                                              ? filterState[index] +
                                                  "% and above"
                                              : filterState[index],
                                          style: TextStyle(
                                              color: (filterListLocal.contains(
                                                      filterState[index]))
                                                  ? Colors.red
                                                  : Colors.grey),
                                        )
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0,
                                  )
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: Text("0 Filters!!!!"),
                );
              }
            }));
          }
        } else {
          return FancyLoader(
            loaderType: "logo",
          );
        }
      },
    );
  }

  filtercategoryMainList() {
    return Scrollbar(
      child: ListView.builder(
        itemCount: MainCategoryList().getMainCategoryList().length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              setState(() {
                selectedIndex = index;
                print(MainCategoryList().getMainCategoryList()[index]);
              });
              setFilterStateByName(
                  MainCategoryList().getMainCategoryList()[index]);
            },
            selected: selectedIndex == index ? true : false,
            selectedTileColor: Colors.grey[100],
            title: Text(MainCategoryList().getMainCategoryList()[index],
                style: TextStyle(color: Colors.black, fontSize: 13)),
          );
        },
      ),
    );
  }

  setFilterStateByName(String mainFilterName) {
    var filter = Provider.of<FilterListState>(context, listen: false);
    switch (mainFilterName) {
      case "Category":
        if (cachedSubFilters.contains("Category")) {
          filter.setActiveFilter("productCategoryList");
        } else {
          filterSubList =
              ProductController().getFilterListByName("productCategoryList");
          filterSubList.then((value) {
            filter.setFilterProductCategory(value);
          });
          cachedSubFilters.add("Category");
        }

        break;
      case "Discount":
        if (cachedSubFilters.contains("Discount")) {
          filter.setActiveFilter("productDiscountList");
        } else {
          filterSubList =
              ProductController().getFilterListByName("productDiscountList");
          filterSubList.then((value) {
            filter.setFilterDiscountCategory(value);
            filter.setActiveFilter("productDiscountList");
          });
          cachedSubFilters.add("Discount");
        }

        break;
      default:
    }
  }
}
