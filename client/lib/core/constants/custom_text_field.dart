import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

AutoDisposeStateProvider showOrHidePasswordProvider = AutoDisposeStateProvider(
  (ref) {
    return true;
  },
);

AutoDisposeStateProvider showEyeIconProvider = AutoDisposeStateProvider(
  (ref) {
    return false;
  },
);

class CustomTextField extends ConsumerWidget {
  final String hintText;
  final TextEditingController? textEditingController;
  final bool isToBeHiddenText;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputAction textInputAction;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.textEditingController,
    this.isToBeHiddenText = false,
    this.readOnly = false,
    this.onTap,
    this.textInputAction = TextInputAction.next,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final obsecureText = ref.watch(showOrHidePasswordProvider);
    final showEyeIcon = ref.watch(showEyeIconProvider);

    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: (isToBeHiddenText == true && showEyeIcon == true)
            ? GestureDetector(
                onTap: () {
                  if (obsecureText == false) {
                    ref.read(showOrHidePasswordProvider.notifier).update(
                      (state) {
                        state = true;
                        return state;
                      },
                    );
                  } else {
                    ref.read(showOrHidePasswordProvider.notifier).update(
                      (state) {
                        state = false;
                        return state;
                      },
                    );
                  }
                },
                child: Icon(
                  obsecureText ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                ),
              )
            : null,
      ),
      onTap: onTap,
      onChanged: (value) {
        if (value.isNotEmpty && isToBeHiddenText == true) {
          ref.read(showEyeIconProvider.notifier).update(
            (state) {
              state = true;
              return state;
            },
          );
        } else {
          ref.read(showEyeIconProvider.notifier).update(
            (state) {
              state = false;
              return state;
            },
          );
        }
      },
      textInputAction: textInputAction,
      readOnly: readOnly,
      obscureText: isToBeHiddenText ? obsecureText : isToBeHiddenText,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "$hintText is missing";
        } else {
          return null;
        }
      },
    );
  }
}
