import 'dart:convert';

import 'package:flusher/config/app_settings.dart';
import 'package:flusher/core/widgets/custom_widgets.dart';
import 'package:flusher/features/feature_messaging/domain/entities/user_entity.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/profile/edit_profile_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/screens/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image/image.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  static const String routeName = '/edit-profile-screen';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passController;
  late TextEditingController _rePassController;
  late TextEditingController _usernameController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passController = TextEditingController();
    _rePassController = TextEditingController();
    _usernameController = TextEditingController();

    BlocProvider.of<EditProfileBloc>(context).add(EditProfileStartedEvent());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _rePassController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  bool _isFirst = true;
  @override
  Widget build(BuildContext context) {
    double expandedHeight = context.height * 0.3;
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<EditProfileBloc, EditProfileState>(
          builder: (context, state) {
            if (state is EditProfileLoadingState) {
              return const LoadingAnimation();
            } else if (state is EditProfileCompletedState) {
              final userEntity = state.userEntity;

              if (_isFirst) {
                _initializeControllersValuesFromUserEntity(userEntity);
                _isFirst = false;
              }

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(CupertinoIcons.back),
                    ),
                    expandedHeight: expandedHeight,
                    flexibleSpace: _flexibleAppBarSpace(height: expandedHeight, userEntity: userEntity),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          const SizedBox(height: 16),
                          Theme(
                            // data: context.theme.copyWith(errorColor: Colors.white),
                            data: context.theme,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  customEditTextFormField(
                                    validator: (value) {
                                      if (value != null && value.trim().length < 3) {
                                        return 'لطفاً نامی که انتخاب می کنید، حداقل 3 کاراکتر باشد!';
                                      }
                                      return null;
                                    },
                                    context: context,
                                    controller: _usernameController,
                                    hintText: 'نام کاربری را وارد کنید',
                                    labelText: 'نام کاربری',
                                    maxLength: 50,
                                  ),
                                  const SizedBox(height: 16),
                                  customEditTextFormField(
                                    validator: (value) {
                                      if (value != null && value.trim().length < 14 || !value!.contains('@')) {
                                        return 'لطفاً ایمیل را صحیح و حداقل با 14 کاراکتر وارد کنید!';
                                      }
                                      return null;
                                    },
                                    context: context,
                                    controller: _emailController,
                                    hintText: 'ایمیل را وارد کنید',
                                    labelText: 'ایمیل',
                                    keyboardType: TextInputType.emailAddress,
                                    maxLength: 50,
                                  ),
                                  const SizedBox(height: 16),
                                  customEditTextFormField(
                                    validator: (value) {
                                      if (value != null && value.trim().length < 6) {
                                        return 'لطفاً فیلد رمز عبور را حداقل با 6 کاراکتر پر کنید!';
                                      }
                                      return null;
                                    },
                                    context: context,
                                    controller: _passController,
                                    hintText: 'رمزعبور را وارد کنید',
                                    labelText: 'رمز عبور',
                                    obscureText: true,
                                    maxLength: 50,
                                  ),
                                  const SizedBox(height: 16),
                                  customEditTextFormField(
                                    validator: (value) {
                                      if (value != null && value.trim().length < 6) {
                                        return 'لطفاً فیلد تکرار رمز عبور را حداقل با 6 کاراکتر پر کنید!';
                                      }
                                      return null;
                                    },
                                    context: context,
                                    controller: _rePassController,
                                    hintText: 'تکرار رمز عبور را وارد کنید',
                                    labelText: 'تکرار رمز عبور',
                                    obscureText: true,
                                    maxLength: 50,
                                  ),
                                  const SizedBox(height: 32),
                                  BlocConsumer<EditProfileBloc, EditProfileState>(
                                    listener: (context, state) {
                                      final editProfileCompletedState = state as EditProfileCompletedState;
                                      if (editProfileCompletedState.editButtonPressedStatus is EditButtonPressedCompletedState) {
                                        showCustomSuccessSnackBar(context, 'اطلاعات کاربری با مونقیت به روز شد.');
                                      }
                                      if (editProfileCompletedState.editButtonPressedStatus is EditButtonPressedErrorStatus) {
                                        showCustomErrorSnackBar(
                                          context,
                                          (editProfileCompletedState.editButtonPressedStatus as EditButtonPressedErrorStatus).errorMessage,
                                        );
                                      }
                                    },
                                    buildWhen: (previous, current) {
                                      if ((previous as EditProfileCompletedState).editButtonPressedStatus ==
                                          (current as EditProfileCompletedState).editButtonPressedStatus) {
                                        return false;
                                      }
                                      return true;
                                    },
                                    builder: (context, state) {
                                      final editProfileCompletedState = state as EditProfileCompletedState;
                                      if (editProfileCompletedState.editButtonPressedStatus is EditButtonPressedLoadingState) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(horizontal: context.width * 0.2),
                                          child: ElevatedButton(
                                            onPressed: null,
                                            child: Center(
                                              child: CupertinoActivityIndicator(
                                                color: context.theme.colorScheme.onPrimary,
                                              ),
                                            ),
                                          ),
                                        );
                                      } else if (editProfileCompletedState.editButtonPressedStatus is EditButtonPressedCompletedState) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(horizontal: context.width * 0.2),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _editUser(userEntity);
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'ویرایش',
                                                  style: context.textTheme.button!.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: context.theme.colorScheme.onPrimary,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Icon(
                                                  CupertinoIcons.pencil,
                                                  color: context.theme.colorScheme.onPrimary,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else if (editProfileCompletedState.editButtonPressedStatus is EditButtonPressedErrorStatus) {
                                        // final errorMessage = (editProfileCompletedState.editButtonPressedStatus as EditButtonPressedErrorStatus).errorMessage;
                                        return Container(
                                          padding: EdgeInsets.symmetric(horizontal: context.width * 0.2),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _editUser(userEntity);
                                            },
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(context.theme.colorScheme.error),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'تلاش دوباره',
                                                  style: context.textTheme.button!.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: context.theme.colorScheme.onError,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Icon(
                                                  CupertinoIcons.refresh,
                                                  color: context.theme.colorScheme.onError,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Container(
                                          padding: EdgeInsets.symmetric(horizontal: context.width * 0.2),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _editUser(userEntity);
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'ویرایش',
                                                  style: context.textTheme.button!.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: context.theme.colorScheme.onPrimary,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Icon(
                                                  CupertinoIcons.pencil,
                                                  color: context.theme.colorScheme.onPrimary,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }

                                    },
                                  ),
                                  SizedBox(height: context.height * 0.1),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is EditProfileErrorState) {
              return CustomErrorWidget(errorMessage: state.errorMessage);
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  _initializeControllersValuesFromUserEntity(UserEntity userEntity) {
    _usernameController.text = userEntity.username ?? '';
    _emailController.text = userEntity.email ?? '';
    _passController.text = userEntity.password ?? '';
    _rePassController.text = userEntity.password ?? '';
  }

  _editUser(UserEntity userEntity) {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      if (_passController.text.trim() == _rePassController.text.trim()) {
        // add bloc event
        BlocProvider.of<EditProfileBloc>(context).add(
          EditProfileButtonPressedEvent(userEntity
            ..email = _emailController.text.trim()
            ..password = _passController.text.trim()
            ..username = _usernameController.text.trim()),
        );
      } else {
        showCustomErrorSnackBar(context, 'رمز عبور با تکرار آن مطابقت ندارد!');
      }
    }
  }

  Widget _flexibleAppBarSpace({required double height, required UserEntity userEntity}) {
    return Stack(
      children: [
        Container(
          width: context.width,
          height: height,
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(base64Decode(userEntity.profileImage!)),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          width: context.width,
          height: height,
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: 0.7,
              colors: [
                Colors.transparent,
                Colors.transparent,
                // context.theme.colorScheme.secondary.withOpacity(0.4),
                context.theme.colorScheme.primary.withOpacity(0.4),
              ],
            ),
          ),
          child: FittedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  userEntity.username!,
                  style: context.textTheme.subtitle1!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                Text(
                  userEntity.email!,
                  style: context.textTheme.subtitle2!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

InputDecoration editProfileTextFieldDecoration({
  required BuildContext context,
  required String hintText,
  String? labelText,
  double? radius,
}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: TextStyle(
      fontFamily: 'Vazir',
    ),
    hintText: hintText,
    hintStyle: TextStyle(
      fontFamily: 'Vazir',
      color: Colors.grey.shade500,
      // fontWeight: FontWeight.bold,
    ),
    contentPadding: const EdgeInsets.all(8),
    counterText: "",
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(radius ?? 16)),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: context.theme.colorScheme.primary, width: 2), borderRadius: BorderRadius.circular(radius ?? 16)),
    enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(radius ?? 16)),
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: context.theme.colorScheme.secondary, width: 2), borderRadius: BorderRadius.circular(radius ?? 16)),
  );
}

Widget customEditTextFormField({
  required BuildContext context,
  required TextEditingController controller,
  required String hintText,
  String? labelText,
  double? radius,
  String? Function(String?)? validator,
  bool? obscureText,
  TextInputType? keyboardType,
  int? maxLength,
}) {
  return Material(
    elevation: 6,
    color: Colors.grey.shade200,
    borderRadius: BorderRadius.circular(radius ?? 16),
    child: TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      style: TextStyle(
        color: Colors.grey.shade800,
        // fontWeight: FontWeight.bold,
      ),
      maxLength: maxLength,
      decoration: editProfileTextFieldDecoration(context: context, hintText: hintText, labelText: labelText),
    ),
  );
}
