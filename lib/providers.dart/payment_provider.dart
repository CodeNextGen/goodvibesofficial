import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:goodvibes/models/user_model.dart';
import 'package:goodvibes/services/navigation_service.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../config.dart';
import '../locator.dart';
import 'startup_provider.dart';

class PaymentProvider with ChangeNotifier {
  StreamSubscription<List<PurchaseDetails>> _subscription;
  bool paymentStatus = false;
  UserData _userData;

  Dio dio = Dio();
  int selected = 0;
  List<ProductDetails> products = [];
  ProductDetails product;
  bool storeAvailable;

  Set<String> _kIds = {
    isAndroid ? "com.goodvibes.monthly_android" : "monthly.goodvibesofficial",
    isAndroid ? "com.goodvibes.yearly_android" : "com.goodvibes.yearlyautoios",
  };

  PaymentProvider() {
    final Stream purchaseUpdates =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchases) async {
      _handlePurchaseUpdates(purchases);
      print(purchases);
    });

    // print(_subscription);
    checkConnection().then((val) {
      getProducts();
      // restorePurchase();
    });
  }

  Future<bool> checkConnection() async {
    storeAvailable = await InAppPurchaseConnection.instance.isAvailable();
    return storeAvailable;
  }


  void _handlePurchaseUpdates(purchases) async {
    print('uuid is ${_userData.uid}');
    List<PurchaseDetails> details = purchases;
    for (PurchaseDetails purchase in details) {
      if (purchase.status == PurchaseStatus.purchased) {
      // if (true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final NavigationService _navigationService = locator<NavigationService>();
        prefs.setBool('paid', true);

        FormData formData = new FormData.fromMap({
          "purchase_token": purchase.purchaseID,
          "product_id": purchase.productID,
          "order_id": purchase.purchaseID,
          "transaction_date": purchase.transactionDate,
          "subs": selected == 0 ? "monthly" : "yearly"
        });
    
          print(formData);

        try {
         var rsp= await dio.post(
            '$baseUrl/v1/subscriptions',
            data: formData,
            options: Options(
              headers: {'uuid': _userData.uid},
            ),
          );
          print(rsp);
        } catch (e) {
          print(e);
        }
        if (Platform.isIOS) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }

        disposePayment();
        // _user.getUserData();
        _userData.paid =true;
        _navigationService.navigateToReplaceAll(routeName: 'home');
      }

      
    }
    notifyListeners();
  }

  void getProducts() async {
    if (storeAvailable) {
      final ProductDetailsResponse response =
          await InAppPurchaseConnection.instance.queryProductDetails(_kIds);
      products = response.productDetails;
    }
    for (ProductDetails p in products) {
      print('price is ');
      print(p.price);
    }
    productForPurchase(0);
    notifyListeners();
  }

  productForPurchase(int index) {
    product = products[index];
    selected = index;
    notifyListeners();
  }

  void restorePurchase() async {
    final QueryPurchaseDetailsResponse response =
        await InAppPurchaseConnection.instance.queryPastPurchases();
    print('Restore purchase response');
    print(response.toString());
    if (response.error != null) {
      // Handle the error.
      print(response.error);
    } else {
      StartupProvider user = StartupProvider();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('paid', true);
      user.getUserData();

      for (PurchaseDetails purchase in response.pastPurchases) {
        // _verifyPurchase(
        //     purchase); // Verify the purchase following the best practices for each storefront.
        // _deliverPurchase(
        //     purchase); // Deliver the purchase to the user in your app.
        if (Platform.isIOS) {
          // Mark that you've delivered the purchase. Only the App Store requires
          // this final confirmation.
          InAppPurchaseConnection.instance.completePurchase(purchase);
        }
        //update local database for purchased data  and other info
      }
    }
  }

  Future<bool> makePurchase(UserData user) async {
    _userData = user;
    print('User data is  ${_userData.uid}');
    paymentStatus = false;
    // notifyListeners();
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);

    return await InAppPurchaseConnection.instance
        .buyNonConsumable(purchaseParam: purchaseParam);
  }

  void disposePayment() async {
    _subscription.cancel();
  }
}
