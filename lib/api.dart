// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// TODO: Import relevant packages
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'unit.dart';

/// The REST API retrieves unit conversions for [Categories] that change.
///
/// For example, the currency exchange rate, stock prices, the height of the
/// tides change often.
/// We have set up an API that retrieves a list of currencies and their current
/// exchange rate (mock data).
///   GET /currency: get a list of currencies
///   GET /currency/convert: get conversion from one currency amount to another
class Api {
  static const _url = 'https://flutter.udacity.com/';
  // TODO: Add any relevant variables and helper functions
  Future<Map<String, dynamic>> getJson(String url) async {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    }
    return null;
  }


  /// Gets all the units and conversion rates for a given category.
  ///
  /// The `category` parameter is the name of the [Category] from which to
  /// retrieve units. We pass this into the query parameter in the API call.
  ///
  /// Returns a list. Returns null on error.
  Future<List<Unit>> getUnits(String category) async {
    var json = await getJson('$_url$category');
    if (json != null) {
      print(json['units']); 
      List<Unit> units = [];
      json['units']
          .forEach((dynamic jsonUnit) => units.add(Unit.fromJson(jsonUnit)));
      return units;
    }
    return null;
  }

  // TODO: Create convert()
  /// Given two units, converts from one to another.
  ///
  /// Returns a double, which is the converted amount. Returns null on error.

}
