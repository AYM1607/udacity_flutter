// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// TODO: Import relevant packages
import 'package:http/http.dart' as http;
import 'dart:convert' as converter;
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
  static const _url = 'https://flutter.udacity.com';

  Future<Map<String, dynamic>> _getJson(String url) async {
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        return converter.jsonDecode(response.body);
      }
    } on Exception catch(e) {
      print('$e');
    }
    return null;
  }

  Future<List<Unit>> getUnits(String category) async {
    var json = await _getJson('$_url/$category');
    if (json != null) {
      List<Unit> units = [];
      json['units']
          .forEach((dynamic jsonUnit) => units.add(Unit.fromJson(jsonUnit)));
      return units;
    }
    return null;
  }

  // Fixed url
  String _getConversionUrl(Unit fromUnit, Unit toUnit, double value) {
    return '$_url/currency/convert?from=${fromUnit.name}&to=${toUnit.name}&amount=$value';
  }

  Future<double> convert(Unit fromUnit, Unit toUnit, double value) async {
    var url = _getConversionUrl(fromUnit, toUnit, value);
    var json = await _getJson(url);
    if (json['status'] == 'ok') {
      return json['conversion'].toDouble();
    }
    return null;
  }

}
