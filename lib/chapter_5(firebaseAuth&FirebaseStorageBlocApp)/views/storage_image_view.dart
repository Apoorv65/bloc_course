import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageImageView extends StatelessWidget {
  final Reference image;
  const StorageImageView({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: image.getData(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xffc70a41),
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasData) {
              final data = snapshot.data!;
              return Image.memory(
                data,
                fit: BoxFit.cover,
              );
            } /*else if (snapshot.hasError) {
              print(snapshot.data);
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xffff0000),
                ),
              );
            }*/ else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xffc70a41),
                ),
              );
            }
        }
      },
    );
  }
}
