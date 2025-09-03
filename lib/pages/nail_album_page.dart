import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';

class NailAlbumPage extends StatefulWidget {
  const NailAlbumPage({super.key});

  @override
  State<NailAlbumPage> createState() => _NailAlbumPageState();
}

class _NailAlbumPageState extends State<NailAlbumPage> {
  final ImagePicker _picker = ImagePicker();
  final List<dynamic> _images = [
    'assets/images/nail_art.jpg',
    'assets/images/promo1.jpg',
  ];

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _images.add(File(image.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getTranslation('my_nail_album')),
        backgroundColor: AppColors.emmiWhite,
        foregroundColor: AppColors.emmiBlack,
        elevation: 1,
      ),
      backgroundColor: AppColors.emmiWhite,
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _images.length,
        itemBuilder: (context, index) {
          final image = _images[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: image is String
                ? Image.asset(image, fit: BoxFit.cover)
                : Image.file(image as File, fit: BoxFit.cover),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        backgroundColor: AppColors.emmiRed,
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
