import 'package:flutter/material.dart';

typedef DialogOptionsBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String description,
  required DialogOptionsBuilder optionsBuilder,
}) {
  final options = optionsBuilder();
  return showDialog<T?>(
    context: context,
    builder: (context){
      return AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: options.keys.map((optionsTitle){
            final value = options[optionsTitle];
            return TextButton(onPressed: (){
              if (value != null){
                Navigator.of(context).pop(value);
              }else{
                Navigator.of(context).pop;
              }
            }, child: Text(optionsTitle),);
          }).toList()
        ,
      );
    },
  );
}
