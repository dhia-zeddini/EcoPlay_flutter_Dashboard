import 'package:flutter/material.dart';

enum ButtonType { PRIMARY, PLAIN }

class AppButton extends StatelessWidget {
  final ButtonType? type;
  final VoidCallback? onPressed;
  final String? text;

  AppButton({this.type, this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onPressed,
      child: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          color:
              _getButtonColor(context, type ?? ButtonType.PRIMARY), // Updated
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(169, 176, 185, 0.42),
              spreadRadius: 0,
              blurRadius: 3.0,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Center(
          child: Text(
            text ?? '', // Safely unwrap the text using null-aware operator
            style:
                _getTextStyle(context, type ?? ButtonType.PRIMARY), // Updated
          ),
        ),
      ),
    );
  }

  Color _getButtonColor(BuildContext context, ButtonType type) {
    switch (type) {
      case ButtonType.PRIMARY:
        return Theme.of(context).colorScheme.primary; // Updated
      case ButtonType.PLAIN:
        return Colors.white;
      default:
        return Theme.of(context).colorScheme.primary; // Updated
    }
  }

  TextStyle _getTextStyle(BuildContext context, ButtonType type) {
    switch (type) {
      case ButtonType.PLAIN:
        return Theme.of(context)
            .textTheme
            .subtitle2!
            .copyWith(color: Theme.of(context).colorScheme.primary); // Updated
      case ButtonType.PRIMARY:
        return Theme.of(context)
            .textTheme
            .subtitle2!
            .copyWith(color: Colors.white); // Updated
      default:
        return Theme.of(context)
            .textTheme
            .subtitle2!
            .copyWith(color: Theme.of(context).colorScheme.primary); // Updated
    }
  }
}
