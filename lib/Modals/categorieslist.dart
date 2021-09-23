import 'package:flutter/widgets.dart';

class CategoriesList {

  CategoriesList({
    this.title = '',
    this.imagePath = '',
  });

  String imagePath;
  String title;

  static List<CategoriesList> categoriesList = [
    CategoriesList(
      imagePath: 'assets/icons/flat-tire.svg',
      title: "Flat Tier",
    ),
    CategoriesList(
      imagePath: 'assets/icons/low_fuel.svg',
      title: 'Low Fuel',
    ),
    CategoriesList(
      imagePath: 'assets/icons/tow-truck.svg',
      title: 'Towing',
    ),
    CategoriesList(
      imagePath: 'assets/icons/car_locked.svg',
      title: 'Locked',
    ),
    CategoriesList(
      imagePath: 'assets/icons/breakdown.svg',
      title: 'Break Down',
    ),
    CategoriesList(
      imagePath: 'assets/icons/engine_heat.svg',
      title: 'Engine Heat',
    ),
    CategoriesList(
      imagePath: 'assets/icons/jumpstart.svg',
      title: 'Jump Start',
    ),
    CategoriesList(
      imagePath: 'assets/icons/water_bowzer.svg',
      title: 'Water Bowzer',
    ),
    CategoriesList(
      imagePath: 'assets/icons/car-ditch.svg',
      title: 'Stuck in Ditch',
    ),
    CategoriesList(
      imagePath: 'assets/icons/towing-vehicle.svg',
      title: 'Vehicle Transport',
    ),
  ];
}
