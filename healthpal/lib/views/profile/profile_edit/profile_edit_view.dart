import 'package:flutter/material.dart';
import 'package:healthpal/core/navigation/navigator.dart';
import 'package:healthpal/utils/app_colors/app_colors.dart';
import 'package:healthpal/utils/app_images/app_images.dart';
import 'package:healthpal/views/favorites_view/my_favorite_view.dart';
import 'package:healthpal/views/login/login_view.dart';
import 'package:healthpal/views/notifications/my_notifications_view.dart';
import 'package:healthpal/views/profile/profile_edit/profile_menu_item/profile_menu_item_view.dart';
import 'package:healthpal/views/profile/profile_view.dart';
import 'package:healthpal/widgets/app_button/app_button.dart';

class ProfileEditView extends StatefulWidget {
  const ProfileEditView({super.key});

  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  final List<Map<String, dynamic>> menuItems = [
    {
      'image': LocalImages.icEditProfileIcon,
      'text': 'Edit Profile',
      'icon': LocalImages.icProfileEditArrowIcon,
      'deeplink': 'Edit Profile',
    },
    {
      'image': LocalImages.icFavoriteIcon,
      'text': 'Favorite',
      'icon': LocalImages.icProfileEditArrowIcon,
      'deeplink': 'Favorite',
    },
    {
      'image': LocalImages.icNotificationIcon,
      'text': 'Notifications',
      'icon': LocalImages.icProfileEditArrowIcon,
      'deeplink': 'Notifications',
    },
    {
      'image': LocalImages.icSettingIcon,
      'text': 'Settings',
      'icon': LocalImages.icProfileEditArrowIcon,
    },
    {
      'image': LocalImages.icHelpAndSupportIcon,
      'text': 'Help and Support',
      'icon': LocalImages.icProfileEditArrowIcon,
    },
    {
      'image': LocalImages.icTermsAndConditionsIcon,
      'text': 'Terms and Conditions',
      'icon': LocalImages.icProfileEditArrowIcon,
    },
    {
      'image': LocalImages.icLogoutIcon,
      'text': 'Log Out',
      'deeplink': 'Log Out',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Text(
              'Profile',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0) +
                const EdgeInsets.only(top: 25),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    maxRadius: 60,
                    child: Icon(
                      Icons.person_4_outlined,
                      color: Colors.grey.shade500,
                      size: 80,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 121,
                  child: Image.asset(
                    LocalImages.icProfileEditLogo,
                    height: 25,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 18.0),
            child: Text(
              'Daniel Martinez',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
              ),
            ),
          ),
          const Text(
            '+123 856479683',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.paleSkyColor,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final menuItem = menuItems[index];
                return InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    onNavigationItemClick(menuItem['deeplink'] ?? '', context);
                  },
                  child: Column(
                    children: [
                      ProfileMenuItemView(
                        image: menuItems[index]['image'],
                        text: menuItems[index]['text'],
                        icon: menuItems[index]['icon'],
                        height: 24,
                        width: 24,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

onNavigationItemClick(String deeplink, BuildContext context) {
  switch (deeplink) {
    case 'Edit Profile':
      Navigation.push(
        context,
        const ProfileView(),
      );
      break;
    case 'Favorite':
      Navigation.push(
        context,
        const MyFavoriteView(),
      );
      break;
    case 'Notifications':
      Navigation.push(
        context,
        const MyNotificationsView(),
      );
      break;
    case 'Log Out':
      _showLogoutBottomSheet(context);
      break;
  }
}

void _showLogoutBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (BuildContext context) {
      return Container(
        height: 199,
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Log Out',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.mirageColor,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              'Are you sure you want to log out?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.paleSkyColor,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: AppButtonView(
                    color: AppColors.athensGrayColor,
                    textColor: AppColors.mirageColor,
                    border: Border.all(color: AppColors.mirageColor),
                    text: 'Cancel',
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButtonView(
                    color: AppColors.mirageColor,
                    textColor: AppColors.athensGrayColor,
                    border: Border.all(color: AppColors.mirageColor),
                    text: 'Yes, Logout',
                    onTap: () {
                      Navigation.removeAllPreviousAndPush(
                        context,
                        const SignInView(),
                      );
                    },
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
