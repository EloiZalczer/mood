import 'package:flutter/material.dart';
import 'package:mood/structures.dart';

class NotificationTimeFormField extends FormField<NotificationTime> {
  NotificationTimeFormField({
    super.key,
    Widget? title,
    FormFieldSetter<NotificationTime>? onSaved,
    FormFieldValidator<NotificationTime>? validator,
    NotificationTime? initialValue,
    bool autovalidate = false,
  }) : super(
         onSaved: onSaved,
         validator: validator,
         initialValue: initialValue,
         builder: (FormFieldState<NotificationTime> state) {
           return ListTile(
             dense: state.hasError,
             title: title,
             leading: Checkbox(
               value: (state.value != null) ? state.value!.enabled : false,
               onChanged: (value) {
                 if (value != null) {
                   state.didChange(
                     NotificationTime(
                       enabled: value,
                       time:
                           (state.value != null)
                               ? state.value!.time
                               : TimeOfDay(hour: 0, minute: 0),
                     ),
                   );
                 }
               },
             ),
             trailing: TextButton(
               child: Text(
                 (state.value != null)
                     ? state.value!.time.format(state.context)
                     : "00:00",
               ),
               onPressed: () async {
                 final TimeOfDay? timeOfDay = await showTimePicker(
                   context: state.context,
                   initialTime:
                       (state.value != null)
                           ? state.value!.time
                           : TimeOfDay(hour: 0, minute: 0),
                   initialEntryMode: TimePickerEntryMode.dial,
                 );

                 if (timeOfDay != null) {
                   state.didChange(
                     NotificationTime(
                       enabled:
                           (state.value != null) ? state.value!.enabled : false,
                       time: timeOfDay,
                     ),
                   );
                 }
               },
             ),
           );
         },
       );
}
