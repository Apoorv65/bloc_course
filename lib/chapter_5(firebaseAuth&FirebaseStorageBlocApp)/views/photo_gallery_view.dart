import '../bloc/app_bloc.dart';
import '../views/main_popup_menu_button.dart';
import '../views/storage_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class PhotoGalleryView extends HookWidget {
  const PhotoGalleryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    XFile? _image;
    final picker = useMemoized(() => ImagePicker(), [key]);
    final images = context.watch<AppBloc>().state.images ?? [];

    void pickImage() async {
      final image = await picker.pickImage(source: ImageSource.gallery).then((value) => _image = value);
      if (image == null) {
        return;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor:const Color(0xffc70a41),
        title: const Text('Gallery'),
        actions: [
          IconButton(
            onPressed: ()  {
              pickImage();
              context.read<AppBloc>().add(
                    AppEventUploadImage(
                      filePathToUpload: _image!.path,
                    ),
                  );
            },
            icon: const Icon(Icons.upload_rounded),
          ),
          const SizedBox(
            width: 5,
          ),
          const MainPopupMenuButton(),
        ],
      ),
      body: GridView.count(
          crossAxisCount: 3,
          padding: const EdgeInsets.all(8),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: images
              .map(
                (img) => StorageImageView(
                  image: img,
                ),
              )
              .toList(),
        ),

    );
  }
}
