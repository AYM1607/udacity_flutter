// To keep your imports tidy, follow the ordering guidelines at
// https://www.dartlang.org/guides/language/effective-dart/style#ordering
import 'package:flutter/material.dart';
import 'converter_route.dart';
import 'unit.dart';

final _height = 100.0;
final _radius = BorderRadius.circular(_height / 2);

/// A custom [Category] widget.
///
/// The widget is composed on an [Icon] and [Text]. Tapping on the widget shows
/// a colored [InkWell] animation.
class Category extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final List<Unit> units;

  /// Creates a [Category].
  ///
  /// A [Category] saves the name of the Category (e.g. 'Length'), its color for
  /// the UI, and the icon that represents it (e.g. a ruler).
  const Category(
      {Key key,
      @required this.name,
      @required this.icon,
      @required this.color,
      @required this.units})
      : super(key: key);

  void _navigateToConverter(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: color,
            title: Text(name),
          ),
          body: ConverterRoute(
            units: this.units,
            color: this.color,
            name: this.name,
          ),
        );
      }),
    );
  }

  /// Builds a custom widget that shows [Category] information.
  ///
  /// This information includes the icon, name, and color for the [Category].
  @override
  // This `context` parameter describes the location of this widget in the
  // widget tree. It can be used for obtaining Theme data from the nearest
  // Theme ancestor in the tree. Below, we obtain the display1 text theme.
  // See https://docs.flutter.io/flutter/material/Theme-class.html
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(8.0),
        height: _height,
        child: InkWell(
          borderRadius: _radius,
          splashColor: color,
          highlightColor: color,
          onTap: () => _navigateToConverter(context),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16),
                child: Icon(
                  icon,
                  size: 60.0,
                ),
              ),
              Center(
                child: Text(
                  name,
                  style: TextStyle(fontSize: 24.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
