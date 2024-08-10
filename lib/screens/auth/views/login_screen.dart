import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/models/user.dart';
import 'package:shop/route/route_constants.dart';
import '../../../../constants.dart';
import 'package:shop/service/auth.dart'; // Đảm bảo import AuthService

class LogInForm extends StatelessWidget {
  const LogInForm({
    super.key,
    required this.formKey,
    required this.onSaved,
  });

  final GlobalKey<FormState> formKey;
  final void Function(String email, String password) onSaved;

  @override
  Widget build(BuildContext context) {
    String? email, password;

    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            onSaved: (value) {
              email = value;
            },
            // validator: emaildValidator.call,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email address",
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: SvgPicture.asset(
                  "assets/icons/Message.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.3),
                      BlendMode.srcIn),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            onSaved: (value) {
              password = value;
            },
            // validator: passwordValidator.call,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Password",
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: SvgPicture.asset(
                  "assets/icons/Lock.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.3),
                      BlendMode.srcIn),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                onSaved(email!, password!);
              }
            },
            child: const Text("Log in"),
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleLogin(String email, String password) async {
    final param = {"username": email, "password": password};
    try {
      final res = await AuthService().LoginAsync(param);
      // Tạo đối tượng User từ dữ liệu trả về
      final user = User(
        userId: res['userId'],
        userName: res['userName'],
        password: res['password'],
        fullName: res['fullName'],
        roleId: res['roleId'],
        roleName: res['roleName'],
      );

      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user.toJson()); // Chuyển đổi User thành JSON
      await prefs.setString('user', userJson); // Lưu JSON vào SharedPreferences

      //role =1 user role = 2 admin
      Navigator.pushNamedAndRemoveUntil(
          context,
          res['roleId'] == 1
              ? entryPointScreenRoute
              : managerEntryPointScreenRoute,
          ModalRoute.withName(logInScreenRoute));
    } catch (e) {
      // Xử lý lỗi khi đăng nhập thất bại
      print("Login failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/login_dark.png",
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Chào mừng bạn!",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                    "Hãy đăng nhập để có thể mua sắm thỏa thích",
                  ),
                  const SizedBox(height: defaultPadding),
                  LogInForm(
                    formKey: _formKey,
                    onSaved: _handleLogin,
                  ),
                  Align(
                    child: TextButton(
                      child: const Text("Quên mật khẩu"),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, passwordRecoveryScreenRoute);
                      },
                    ),
                  ),
                  SizedBox(
                    height:
                        size.height > 700 ? size.height * 0.1 : defaultPadding,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Bạn không có tài khoản?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, signUpScreenRoute);
                        },
                        child: const Text("Đăng ký"),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
