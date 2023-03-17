import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:kurumi/config/app_route_constant.dart';
import 'package:kurumi/config/app_router.dart';
import 'package:kurumi/presentation/login/functions/app_login.function.dart';
import 'package:kurumi/presentation/login/functions/oauth.function.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      body: Container(
        height: mediaQueryData.size.height,
        width: mediaQueryData.size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Kurumi',
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.yellow,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Powered by AniList',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              offset: !isVisible ? Offset.zero : const Offset(0, 2),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isVisible ? 0 : 1,
                child: Card(
                  elevation: 20,
                  margin: const EdgeInsets.all(0),
                  color: isVisible ? Colors.transparent : Colors.black26,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Welcome to Kurumi',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              child: Text(
                                'Get Started',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  shadows: [const Shadow(color: Colors.grey)],
                                ),
                              ),
                            ),
                            IconButton(
                              style: IconButton.styleFrom(
                                foregroundColor: Colors.white,
                                shape: const CircleBorder(),
                                backgroundColor: Colors.blue.withOpacity(0.7),
                              ),
                              onPressed: () async {
                                setState(() {
                                  isVisible = true;
                                });
                                await Future.delayed(
                                    const Duration(milliseconds: 300));
                                await showLoginDialog(context);
                                setState(() {
                                  isVisible = false;
                                });
                              },
                              icon: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 30,
                                shadows: [
                                  Shadow(
                                    color: Colors.grey,
                                    blurRadius: 3,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> showLoginDialog(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Colors.black38,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
          side: BorderSide(color: Colors.grey)),
      elevation: 50,
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Login with AniList',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.greenAccent,
                  shadows: [const Shadow(color: Colors.grey)],
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: 'You\'ll be redirected to ',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white,
                    shadows: [const Shadow(color: Colors.grey)],
                  ),
                  children: const <TextSpan>[
                    TextSpan(
                      text: 'anilist.co',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orangeAccent),
                    ),
                    TextSpan(
                        text:
                            ' to login/resister. Make sure the URL is anilist.co before entering your email and password.'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size.fromWidth(100),
                      foregroundColor: const Color(0xfff7f2f9),
                      backgroundColor: Colors.transparent,
                      side: const BorderSide(
                        color: Color(0xfff7f2f9),
                      ),
                    ),
                    onPressed: () async {
                      launchUrlString('https://anilist.co/signup');
                    },
                    child: const Text('Register'),
                  ),
                  Consumer(
                    builder: (context, ref, child) => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size.fromWidth(100),
                        backgroundColor: const Color(0xfff7f2f9),
                        foregroundColor: Colors.blueGrey,
                      ),
                      onPressed: () async {
                        String? accessToken = await Oauth().auth();
                        appLogIn(ref);
                        if (accessToken != null) {
                          if (context.canPop()) {
                            context.pop();
                          }
                          context.goNamed(AppRouteConstant.HomeScreen.name);
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
