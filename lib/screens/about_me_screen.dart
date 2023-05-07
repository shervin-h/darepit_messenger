
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMeScreen extends StatefulWidget {
  const AboutMeScreen({Key? key}) : super(key: key);

  static const String routeName = '/about-me-screen';

  @override
  State<AboutMeScreen> createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _depthAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _depthAnimation = Tween<double>(begin: -8, end: 8).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade600,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NeumorphicIcon(
                  CupertinoIcons.person_alt_circle,
                  size: context.width * 0.3,
                  style: NeumorphicStyle(
                    shadowDarkColor: context.theme.colorScheme.secondary.withOpacity(0.6),
                  ),
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return NeumorphicText(
                      'شروین\nحسن‌زاده',
                      textAlign: TextAlign.center,
                      // curve: ElasticInCurve(),
                      style: NeumorphicStyle(
                        // shape: _depthAnimation.value < 0 ? NeumorphicShape.concave : NeumorphicShape.convex,
                        color: context.theme.scaffoldBackgroundColor,
                        depth: _depthAnimation.value,

                        // shadowLightColor: context.theme.colorScheme.primary.withOpacity(0.6),
                        shadowDarkColor: context.theme.colorScheme.primary.withOpacity(0.6),
                        // shadowDarkColor: Colors.black.withOpacity(0.6),
                      ),
                      textStyle: NeumorphicTextStyle(
                        fontFamily: 'Vazir',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                NeumorphicText(
                  'برنامه نویس فلاتر، پایتون و جنگو',
                  textAlign: TextAlign.center,
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.concave,
                    color: context.theme.scaffoldBackgroundColor,
                    depth: 8,
                    shadowLightColor: Colors.white.withOpacity(0.6),
                    shadowDarkColor: Colors.black.withOpacity(0.6),
                  ),
                  textStyle: NeumorphicTextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                InkWell(
                  onTap: ()  async {
                    await launchMyEmail();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NeumorphicText(
                        'shervin.hz07@gmail.com',
                        textAlign: TextAlign.center,
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.concave,
                          color: context.theme.scaffoldBackgroundColor,
                          depth: 8,
                          shadowLightColor: Colors.white.withOpacity(0.6),
                          shadowDarkColor: Colors.black.withOpacity(0.6),
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontFamily: 'Vazir',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const FaIcon(FontAwesomeIcons.envelope, color: Colors.red,),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () async {
                    await launchMyTelegram();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NeumorphicText(
                        '@shervin_hz07',
                        textAlign: TextAlign.center,
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.concave,
                          color: context.theme.scaffoldBackgroundColor,
                          depth: 8,
                          shadowLightColor: Colors.white.withOpacity(0.6),
                          shadowDarkColor: Colors.black.withOpacity(0.6),
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontFamily: 'Vazir',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const FaIcon(FontAwesomeIcons.telegram, color: Colors.lightBlueAccent,),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () async {
                    await launchMyLinkedIn();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NeumorphicText(
                        'shervin-hassanzadeh',
                        textAlign: TextAlign.center,
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.concave,
                          color: context.theme.scaffoldBackgroundColor,
                          depth: 8,
                          shadowLightColor: Colors.white.withOpacity(0.6),
                          shadowDarkColor: Colors.black.withOpacity(0.6),
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontFamily: 'Vazir',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const FaIcon(FontAwesomeIcons.linkedin, color: Colors.lightBlue,),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                NeumorphicText(
                  '...این صفحه در دست ساخت است',
                  textAlign: TextAlign.center,
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.concave,
                    color: context.theme.scaffoldBackgroundColor,
                    depth: 2,
                    shadowLightColor: Colors.white.withOpacity(0.6),
                    shadowDarkColor: Colors.black.withOpacity(0.6),
                  ),
                  textStyle: NeumorphicTextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'قطعاً این اپلیکیشن باگ زیاد دارد. باگ ها رو گزارش کنید ممنون\n ایده ها، انتقادات و پیشنهاد ها را ارایه کنید. \n آن چیزی که می بینید، 20 درصد اهداف تعیین شده برای این پروژه هست که به مرور گسترش می یابند ...\n باشد که...',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 10,
                  style: context.textTheme.bodyText1!.copyWith(
                    color: Colors.white
                  ),
                ),
                const SizedBox(height: 24),
                NeumorphicText(
                  '   ❤️',
                  textAlign: TextAlign.center,
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.concave,
                    color: context.theme.scaffoldBackgroundColor,
                    depth: 2,
                    shadowLightColor: Colors.white.withOpacity(0.6),
                    shadowDarkColor: Colors.black.withOpacity(0.6),
                  ),
                  textStyle: NeumorphicTextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> launchMyEmail() async {
  try {
    await launchUrl(Uri.parse('mailto:shervin.hz07@gmail.com'));
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> launchMyTelegram() async {
  try {
    await launchUrl(Uri.parse('https://t.me/shervin_hz07'));
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> launchMyLinkedIn() async {
  try {
    await launchUrl(Uri.parse('https://www.linkedin.com/in/shervin-hassanzadeh'));
  } catch (e) {
    debugPrint(e.toString());
  }
}
