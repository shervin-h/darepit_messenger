import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({Key? key}) : super(key: key);

  static const String routeName = '/coming-soon-screen';

  @override
  Widget build(BuildContext context) {
    double expandedHeight = context.height * 0.3;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: expandedHeight,
              backgroundColor: context.theme.colorScheme.background,
              foregroundColor: context.theme.colorScheme.onBackground,
              flexibleSpace: SizedBox(
                height: expandedHeight,
                child: Lottie.asset('assets/lottie/coming_soon.json'),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(CupertinoIcons.back,),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'ویژگی هایی که به زودی به اپلیکیشن اضافه می شوند...',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: context.textTheme.bodyText1!.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const ListTile(
                    title: Text('آپلود فایل'),
                    subtitle: Text('آپلود فایل تصویر، ویدیو، صوت و .. تا سقف 50 مگابایت '),
                  ),
                  const ListTile(
                    title: Text('ایجاد گروه های شخصی'),
                    subtitle: Text('شما مالک گروه هستید و اجازه عضویت افراد دست شماست'),
                  ),
                  const ListTile(
                    title: Text('ایجاد کانال'),
                    subtitle: Text('فقط شما و یا افرادی که تعیین می کنید پیام می گذارید. بقیه شنونده هستند.'),
                  ),
                  const ListTile(
                    title: Text('اضافه شدن پلیر'),
                    subtitle: Text('فایل های ویدیویی و آهنگ را در داخل همین اپلیکیشن می توانید اجرا کنید. یا در سطح سیستم عامل هم می توانید از پلیر درپیت استفاده کنید.'),
                  ),
                  const ListTile(
                    title: Text('کش کردن اطلاعات گروه ها و کانال ها'),
                    subtitle: Text('در زمان آفلاین هم بتوانید از اپلیکیشن استفاده کنید ...'),
                  ),
                  const ListTile(
                    title: Text('...'),
                    subtitle: Text('...'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
