import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/components/list_tile/divider_list_tile.dart';
import 'package:shop/components/network_image_with_loader.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/user.dart';
import 'package:shop/route/screen_export.dart';

import 'components/profile_card.dart';
import 'components/profile_menu_item_list_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<User?> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<User?> _user = _loadUser();

    return Scaffold(
      body: FutureBuilder<User?>(
        future: _user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No home found'));
          } else {
            final _user = snapshot.data!;
            return ListView(
              children: [
                ProfileCard(
                  name: _user.fullName,
                  email: _user.userName,
                  imageSrc:
                      "https://www.vietnamworks.com/hrinsider/wp-content/uploads/2023/12/hinh-anh-cute-anime-001.jpg",
                  // proLableText: "Sliver",
                  // isPro: true, if the user is pro
                  press: () {
                    Navigator.pushNamed(context, userInfoScreenRoute);
                  },
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //       horizontal: defaultPadding, vertical: defaultPadding * 1.5),
                //   child: GestureDetector(
                //     onTap: () {},
                //     child: const AspectRatio(
                //       aspectRatio: 1.8,
                //       child:
                //           NetworkImageWithLoader("https://i.imgur.com/dz0BBom.png"),
                //     ),
                //   ),
                // ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Text(
                    "Account",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const SizedBox(height: defaultPadding / 2),
                ProfileMenuListTile(
                  text: "Đơn hàng",
                  svgSrc: "assets/icons/Order.svg",
                  press: () {
                    Navigator.pushNamed(context, orderListScreen);
                  },
                ),
                // ProfileMenuListTile(
                //   text: "Returns",
                //   svgSrc: "assets/icons/Return.svg",
                //   press: () {},
                // ),
                // ProfileMenuListTile(
                //   text: "Wishlist",
                //   svgSrc: "assets/icons/Wishlist.svg",
                //   press: () {},
                // ),
                ProfileMenuListTile(
                  text: "Địa chỉ nhận hàng",
                  svgSrc: "assets/icons/Address.svg",
                  press: () {
                    Navigator.pushNamed(context, addressesScreenRoute);
                  },
                ),
                // ProfileMenuListTile(
                //   text: "Payment",
                //   svgSrc: "assets/icons/card.svg",
                //   press: () {
                //     Navigator.pushNamed(context, emptyPaymentScreenRoute);
                //   },
                // ),
                // ProfileMenuListTile(
                //   text: "Wallet",
                //   svgSrc: "assets/icons/Wallet.svg",
                //   press: () {
                //     Navigator.pushNamed(context, walletScreenRoute);
                //   },
                // ),
                const SizedBox(height: defaultPadding),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding / 2),
                  child: Text(
                    "Cá nhân",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                DividerListTileWithTrilingText(
                  svgSrc: "assets/icons/Notification.svg",
                  title: "Thông báo",
                  trilingText: "Tắt",
                  press: () {
                    Navigator.pushNamed(context, enableNotificationScreenRoute);
                  },
                ),
                ProfileMenuListTile(
                  text: "Hiển thị",
                  svgSrc: "assets/icons/Preferences.svg",
                  press: () {
                    Navigator.pushNamed(context, preferencesScreenRoute);
                  },
                ),
                const SizedBox(height: defaultPadding),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding / 2),
                  child: Text(
                    "Cài đặt",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                ProfileMenuListTile(
                  text: "Ngôn ngữ",
                  svgSrc: "assets/icons/Language.svg",
                  press: () {
                    Navigator.pushNamed(context, selectLanguageScreenRoute);
                  },
                ),
                ProfileMenuListTile(
                  text: "Địa chỉ",
                  svgSrc: "assets/icons/Location.svg",
                  press: () {},
                ),
                const SizedBox(height: defaultPadding),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding / 2),
                  child: Text(
                    "Hỗ trợ",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                ProfileMenuListTile(
                  text: "Hỗ trợ",
                  svgSrc: "assets/icons/Help.svg",
                  press: () {
                    Navigator.pushNamed(context, getHelpScreenRoute);
                  },
                ),
                ProfileMenuListTile(
                  text: "FAQ",
                  svgSrc: "assets/icons/FAQ.svg",
                  press: () {},
                  isShowDivider: false,
                ),
                const SizedBox(height: defaultPadding),

                // Log Out
                ListTile(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, '/login'); // Điều hướng đến trang đăng nhập
                  },
                  minLeadingWidth: 24,
                  leading: SvgPicture.asset(
                    "assets/icons/Logout.svg",
                    height: 24,
                    width: 24,
                    colorFilter: const ColorFilter.mode(
                      errorColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  title: const Text(
                    "Đăng xuất",
                    style:
                        TextStyle(color: errorColor, fontSize: 14, height: 1),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
