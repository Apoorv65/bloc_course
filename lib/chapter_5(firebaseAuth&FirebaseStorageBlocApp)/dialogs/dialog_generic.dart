import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        backgroundColor: const Color(0xfff3c2d0),
        title: Text(title,style: GoogleFonts.kumbhSans(),),
        content: Text(description,style: GoogleFonts.kumbhSans(),),
        actions: options.keys.map((optionsTitle){
            final value = options[optionsTitle];
            return TextButton(onPressed: (){
              if (value != null){
                Navigator.of(context).pop(value);
              }else{
                Navigator.of(context).pop;
              }
            }, child: Text(optionsTitle,style: GoogleFonts.kumbhSans(color: const Color(0xffc70a41),),),);
          }).toList()
        ,
      );
    },
  );
}
