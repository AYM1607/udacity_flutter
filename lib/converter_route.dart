// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'dart:math' as math;

import 'unit.dart';

const _padding = EdgeInsets.all(16.0);

/// [ConverterRoute] where users can input amounts to convert in one [Unit]
/// and retrieve the conversion in another [Unit] for a specific [Category].
///
/// While it is named ConverterRoute, a more apt name would be ConverterScreen,
/// because it is responsible for the UI at the route's destination.
class ConverterRoute extends StatefulWidget {
  /// This [Category]'s name.
  final String name;

  /// Color for this [Category].
  final Color color;

  /// Units for this [Category].
  final List<Unit> units;

  /// This [ConverterRoute] requires the name, color, and units to not be null.
  const ConverterRoute({
    @required this.name,
    @required this.color,
    @required this.units,
  })  : assert(name != null),
        assert(color != null),
        assert(units != null);

  @override
  _ConverterRouteState createState() => _ConverterRouteState();
}

class _ConverterRouteState extends State<ConverterRoute> {
  // TODO: Set some variables, such as for keeping track of the user's input
  // value and units
  List<DropdownMenuItem> _menuItems;
  Unit _fromUnit;
  Unit _toUnit;
  double _inputValue;
  String _convertedValue = '';
  bool _showValidationError = false;

  
  void initState() {
    super.initState();
    _createMenuItems();
    _setDefaults();
  }

  void _createMenuItems() {
    setState(() {
      _menuItems = widget.units.map((unit) {
        return DropdownMenuItem(
          value: unit.name,
          child: Container(
            child: Text(
              unit.name,
              softWrap: true,
            ),
          ),
        );
      }).toList();
    });
  }

  void _setDefaults() {
    setState(() {
      _fromUnit = widget.units[0];
      _toUnit = widget.units[1];
    });
  }


  /// Clean up conversion; trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  Unit _getUnit(String unitName) {
    return widget.units.firstWhere(
      (Unit unit) => unit.name == unitName,
      orElse: null
    );
  }

  void _updateConvertedValue() {
    setState(() {
      _convertedValue =
          _format(_inputValue * (_toUnit.conversion / _fromUnit.conversion));
    });
  }

  void _updateInputValue(String value) {
    setState(() { 
      if (value.isEmpty || value == null) {
        _convertedValue = '';
      } else {
        try {
          final inputValue = double.parse(value);
          _inputValue = inputValue;
          _showValidationError = false;
          _updateConvertedValue();
        } on Exception catch (e){
          print('Error: $e');
          _showValidationError = true;
        }
      }
    });
  }

  void _updateFromUnit(dynamic unitName) {
    setState(() {
      _fromUnit = _getUnit(unitName);
    });
    _updateConvertedValue();
  }

  void _updateToUnit(dynamic unitName) {
    setState(() {
      _toUnit = _getUnit(unitName);      
    });
    _updateConvertedValue();
  }

  Widget _createDropdown(String currentValue, ValueChanged<dynamic> onChanged) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[400],
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: currentValue,
              items: _menuItems,
              onChanged: onChanged,
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Create the 'input' group of widgets. This is a Column that
    // includes the input value, and 'from' unit [Dropdown].
    final inputGroup = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            style: Theme.of(context).textTheme.display1,
            decoration: InputDecoration(
              errorText: _showValidationError ? 'Invalid number' : null,
              labelStyle: Theme.of(context).textTheme.display1,
              labelText: 'Input',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            keyboardType: TextInputType.numberWithOptions(),
            onChanged: _updateInputValue,
          ),
          _createDropdown(_fromUnit.name, _updateFromUnit),
        ],
      ),
    );

    final Widget arrowsIcon = Center(
      child: Transform.rotate(
        angle: math.pi / 2,
        child: Icon(Icons.compare_arrows, size: 40.0),
      ),
    );

    final Widget outputGroup = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InputDecorator(
            child: Text(
              _convertedValue,
              style: Theme.of(context).textTheme.display1,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              labelText: 'Output',
              labelStyle: Theme.of(context).textTheme.display1,
            ),
          ),
          _createDropdown(_toUnit.name, _updateToUnit),
        ],
      ),
    );
    // TODO: Create a compare arrows icon.

    // TODO: Create the 'output' group of widgets. This is a Column that
    // includes the output value, and 'to' unit [Dropdown].

    // TODO: Return the input, arrows, and output widgets, wrapped in a Column.

    // TODO: Delete the below placeholder code.
    final converter = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        inputGroup,
        arrowsIcon,
        outputGroup,
      ],
    );
    return converter;
  }
}
