// ignore_for_file: curly_braces_in_flow_control_structures, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dohamaid/core/config/app_color.dart';

import '../../core/presentation/cubit/localization_cubit.dart';
import '../drawer/cubit/drawer_cubit.dart';
import '../drawer/presentation/drawer_screen.dart';

class WebViewContainer extends StatefulWidget {
  final String url;
  final bool forBayingOnline;
  final Function()? onSuccess;
  final Function()? onFailed;

  const WebViewContainer(this.url, {super.key,  this.forBayingOnline=false,  this.onSuccess,  this.onFailed});

  @override
  State<WebViewContainer> createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  late InAppWebViewController webViewController;
  bool isLoading = true;

  // ── Permission gating ────────────────────────────────────────────────
  static const _kPermissionsAskedKey = 'webview_permissions_requested_v1';

  @override
  void initState() {
    super.initState();
    _requestPermissionsIfFirstTime();
  }

  Future<void> _requestPermissionsIfFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyAsked = prefs.getBool(_kPermissionsAskedKey) ?? false;

    if (alreadyAsked) return; // skip entirely on every subsequent open

    await [
      Permission.location,
      Permission.camera,
      Permission.photos,
      Permission.storage,
    ].request();


    await prefs.setBool(_kPermissionsAskedKey, true);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColor.mainColor,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColor.mainColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColor.mainColor,
        appBar: AppBar(
          backgroundColor: AppColor.appBarBackground,
          elevation: 3,
          title: Image.asset(
            "assets/logo with out background.png",
            scale: 4.5,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: AppColor.mainColor),
            onPressed: () {
              showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: 'drawer',
                pageBuilder: (ctx, anim1, anim2) {
                  return BlocProvider(
                    create: (_) => DrawerCubit()..load(),
                    child: const CustomDrawer(),
                  );
                },
                transitionBuilder: (ctx, anim, secAnim, child) {
                  return FadeTransition(opacity: anim, child: child);
                },
              );
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.maybePop(context);
              },
              icon: const Icon(Icons.arrow_forward_ios, color: AppColor.mainColor),
            ),
          ],
        ),
        body: SafeArea(
          child: WillPopScope(
            onWillPop: () async {
              if (await webViewController.canGoBack()) {
                webViewController.goBack();
                return false;
              }
              return true;
            },
            child: Stack(
              children: [
                InAppWebView(
                  initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(widget.url))),
                  initialSettings: InAppWebViewSettings(
                    javaScriptEnabled: true,
                    geolocationEnabled: true,
                    allowsInlineMediaPlayback: true,
                    mediaPlaybackRequiresUserGesture: false,
                    useOnDownloadStart: true,
                    allowUniversalAccessFromFileURLs: true,
                    allowFileAccess: true,
                    allowContentAccess: true,
                    domStorageEnabled: true,
                    databaseEnabled: true,
                    clearSessionCache: true,
                    thirdPartyCookiesEnabled: true,
                  ),
                  onWebViewCreated: (c) => webViewController = c,


                  androidOnGeolocationPermissionsShowPrompt: (ctrl, origin) async {
                    return GeolocationPermissionShowPromptResponse(
                        origin: origin, allow: true, retain: true);
                  },
                  androidOnPermissionRequest: (_, __, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },

                  onLoadStart: (_, __) => setState(() => isLoading = true),
                  onLoadStop: (_, __) => setState(() => isLoading = false),
                  onProgressChanged: (_, prog) {
                    if (prog < 100 && !isLoading) {
                      setState(() => isLoading = true);
                    } else if (prog == 100) setState(() => isLoading = false);
                  },

                  shouldOverrideUrlLoading: (controller, navigationAction) async {
                    final url = navigationAction.request.url.toString().toLowerCase();
                    if (widget.forBayingOnline){
                      final url = navigationAction.request.url.toString().toLowerCase();
                      if (
                          url.contains("dohamaid.com/ar/success")) {
                        widget.onSuccess?.call();
                        return NavigationActionPolicy.CANCEL;
                      } else if (url.contains("dohamaid.com/ar/failed")) {
                        widget.onFailed?.call();
                        return NavigationActionPolicy.CANCEL;
                      }

                    }

                    final externalSchemes = [
                      "wa.me", "whatsapp", "facebook.com", "m.me", "fb.me",
                      "fb-messenger", "instagram.com", "youtube.com",
                      "mailto:", "tel:", "twitter.com", "t.me", "snapchat.com", "www.google.com/maps"
                    ];

                    final shouldOpenExternally = externalSchemes.any((scheme) => url.contains(scheme));

                    if (shouldOpenExternally) {
                      final uri = Uri.parse(url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                      return NavigationActionPolicy.CANCEL;
                    }

                    return NavigationActionPolicy.ALLOW;
                  },
                ),

                if (isLoading)
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: AppColor.overlayDark,
                    child: Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [AppColor.white, AppColor.mainColor],
                          ),
                          border: Border.all(width: 1, color: AppColor.white),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColor.grey,
                              blurRadius: 5,
                              spreadRadius: 0,
                              offset: Offset(0.0, 3.0),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 150,
                                height: 150,
                                child: Image.asset("assets/logo with out background.png", fit: BoxFit.fitWidth),
                              )
                                  .animate(onPlay: (controller) => controller.repeat())
                                  .shimmer(duration: 1200.ms, color: AppColor.mainColor)
                                  .animate()
                                  .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
                                  .slide(),
                              const SizedBox(height: 10),
                              Text(
                                "جار التحميل...",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  fontFamily: context.read<LocalizationCubit>().isArabic() ? "Cairo" : "Montserrat",
                                  height: 1,
                                  letterSpacing: -1,
                                ),
                              )
                                  .animate(onPlay: (controller) => controller.repeat())
                                  .shimmer(duration: 1200.ms, color: AppColor.mainColor)
                                  .animate()
                                  .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
                                  .slide(),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      )
                          .animate(onPlay: (controller) => controller.repeat())
                          .animate()
                          .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
                          .slide(),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}