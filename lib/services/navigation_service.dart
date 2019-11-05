
import 'package:flutter/material.dart';

class NavigationService{
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo({String routeName}){
   return navigationKey.currentState.pushNamed(routeName);
  }
  Future<dynamic> navigateToReplaceAll({String routeName}){
   return navigationKey.currentState.pushNamedAndRemoveUntil(routeName,(Route<dynamic> route)=>false);
  }

  bool goBack(){
    return navigationKey.currentState.pop();
  }
}