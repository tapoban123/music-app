import 'dart:io';

import 'package:client/core/constants/custom_text_field.dart';
import 'package:client/core/constants/loader.dart';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/repository/home_repository.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:client/features/home/widgets/audio_wave.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<UploadSongPage> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final TextEditingController artistNameController = TextEditingController();
  final TextEditingController songNameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Color selectedColor = Pallete.cardColor;
  File? selectedImage;
  File? selectedAudio;

  @override
  void dispose() {
    artistNameController.dispose();
    songNameController.dispose();

    super.dispose();
  }

  Future<void> selectAudio() async {
    final pickedAudio = await pickAudio();

    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  Future<void> selectImage() async {
    final pickedImage = await pickImage();

    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(homeViewModelProvider.select(
      (value) => value?.isLoading == true,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Song"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              if (formKey.currentState!.validate() &&
                  selectedAudio != null &&
                  selectedImage != null) {
                ref.read(homeViewModelProvider.notifier).uploadSong(
                      artistName: artistNameController.text,
                      songName: songNameController.text,
                      selectedColor: selectedColor,
                      songFile: selectedAudio!,
                      thumbnailFile: selectedImage!,
                    );
              } else {
                showSnackBar(
                  context,
                  "Missing fields",
                );
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: isLoading
          ? Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: selectImage,
                        child: SizedBox(
                          width: double.infinity,
                          height: 150,
                          child: selectedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : DottedBorder(
                                  color: Pallete.borderColor,
                                  dashPattern: const [10, 4],
                                  radius: const Radius.circular(10),
                                  borderType: BorderType.RRect,
                                  strokeCap: StrokeCap.round,
                                  child: const SizedBox(
                                    width: double.infinity,
                                    height: 150,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.folder_open,
                                          size: 40,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "Select the thumbnail for your song",
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      selectedAudio != null
                          ? AudioWave(path: selectedAudio!.path)
                          : CustomTextField(
                              hintText: "Pick Song",
                              textEditingController: null,
                              readOnly: true,
                              onTap: selectAudio,
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        hintText: "Artist",
                        textEditingController: artistNameController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        hintText: "Song Name",
                        textEditingController: songNameController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ColorPicker(
                        color: selectedColor,
                        pickersEnabled: const {
                          ColorPickerType.wheel: true,
                        },
                        onColorChanged: (newColor) {
                          setState(() {
                            selectedColor = newColor;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
