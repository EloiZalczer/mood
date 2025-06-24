import 'package:flutter/material.dart';

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField({
    super.key,
    Widget? title,
    FormFieldSetter<bool>? onSaved,
    FormFieldValidator<bool>? validator,
    bool initialValue = false,
    bool autovalidate = false,
  }) : super(
         onSaved: onSaved,
         validator: validator,
         initialValue: initialValue,
         builder: (FormFieldState<bool> state) {
           return ListTile(
             dense: state.hasError,
             title: title,
             leading: Checkbox(value: state.value, onChanged: state.didChange),
           );
         },
       );
}

class BoolController extends ChangeNotifier {
  int? value;

  BoolController({this.value});

  changeValue(int value) {
    this.value = value;
    notifyListeners();
  }
}
