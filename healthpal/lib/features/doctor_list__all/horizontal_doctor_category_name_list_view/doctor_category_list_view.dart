import 'package:flutter/material.dart';
import 'package:healthpal/core/utils/app_colors/app_colors.dart';

class DoctorCategoryListView extends StatefulWidget {
  const DoctorCategoryListView({super.key});

  @override
  State<DoctorCategoryListView> createState() => _DoctorCategoryListViewState();
}

class _DoctorCategoryListViewState extends State<DoctorCategoryListView> {
  int selectedIndex = 0;

  final List<String> items = [
    'Todos',
    'General',
    'Cardiólogo',
    'Dentista',
    'Neumólogo',
    'Neurólogo'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? AppColors.mirageColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.mirageColor),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    items[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: selectedIndex == index
                          ? Colors.white
                          : AppColors.mirageColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
