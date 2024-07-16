import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/features/auth/view_model/auth_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  void logoutUserFunction(WidgetRef ref, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text(
            "You are about to log out from the application.\nDo you want to continue?"),
        actions: [
          ElevatedButton(
            onPressed: () {
              ref.read(authViewModelProvider.notifier).logOutUser();

              Navigator.of(context).pushAndRemoveUntil(
                PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const LoginPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      final tween =
                          Tween(begin: const Offset(1, 0), end: Offset.zero)
                              .chain(
                        CurveTween(curve: Curves.easeIn),
                      );

                      final offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 100)),
                (route) => false,
              );
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: Pallete.errorColor),
            child: const Text(
              "Yes",
              style: TextStyle(
                color: Pallete.whiteColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Pallete.blueColor,
            ),
            child: const Text(
              "No",
              style: TextStyle(
                color: Pallete.whiteColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider)!;

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            const CircleAvatar(
              radius: 100,
              backgroundColor: Pallete.transparentColor,
              child: Icon(
                CupertinoIcons.profile_circled,
                size: 150,
              ),
            ),
            Text(
              currentUser.name,
              style: const TextStyle(
                color: Pallete.whiteColor,
                fontSize: 18,
              ),
            ),
            Text(currentUser.email),
            const Spacer(),
            ElevatedButton(
              onPressed: () => logoutUserFunction(ref, context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Pallete.errorColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text(
                "Log Out",
                style: TextStyle(
                  fontSize: 16,
                  color: Pallete.whiteColor,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
