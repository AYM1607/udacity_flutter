// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'category.dart';
import 'unit.dart';

const appColor = Colors.lightBlue;

/// Category Route (screen).
///
/// This is the 'home' screen of the Unit Converter. It shows a header and
/// a list of [Categories].
///
/// While it is named CategoryRoute, a more apt name would be CategoryScreen,
/// because it is responsible for the UI at the route's destination.
class CategoryRoute extends StatelessWidget {
  const CategoryRoute();

  static const _categoryNames = <String>[
    'Length',
    'Area',
    'Volume',
    'Mass',
    'Time',
    'Digital Storage',
    'Energy',
    'Currency',
  ];

  static const _baseColors = <Color>[
    Colors.teal,
    Colors.orange,
    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.yellow,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.red,
  ];

  static const _appBarStyle = TextStyle(
    fontSize: 30.0,
    color: Colors.black,
  );

  /// Returns a list of mock [Unit]s.
  List<Unit> _retrieveUnitList(String categoryName) {
    return List.generate(10, (int i) {
      i += 1;
      return Unit(
        name: '$categoryName Unit $i',
        conversion: i.toDouble(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Category> _categories = <Category>[];

    for (var i = 0; i < _categoryNames.length; i++) {
      _categories.add(Category(
        name: _categoryNames[i],
        color: _baseColors[i],
        icon: Icons.cake,
        units: _retrieveUnitList(_categoryNames[i]),
      ));
    }

    final listView = Container(
      color: appColor,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) => _categories[index],
        itemCount: _categories.length,
      ),
    );

    final appBar = AppBar(
      backgroundColor: appColor,
      elevation: 0,
      title: Text(
        'Unit Converter',
        style: _appBarStyle,
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }
}
