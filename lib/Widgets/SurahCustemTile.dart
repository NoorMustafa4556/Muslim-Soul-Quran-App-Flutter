import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Models/Surah.dart';
import '../Constants/Constants.dart';

Widget SurahCustomListTile(
    {required Surah surah,
    required BuildContext context,
    required VoidCallback ontap}) {
  return GestureDetector(
    onTap: ontap,
    child: Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.only(bottom: 12), // Added spacing
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Constants.kPrimary.withOpacity(0.1),
              blurRadius: 8.0,
              offset: Offset(0, 4),
            ),
          ]),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                height: 40,
                width: 40,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Constants.kPrimary,
                ),
                child: Text(
                  (surah.number).toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.englishName!,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      overflow: TextOverflow.ellipsis, // Add ellipsis
                    ),
                    Text(
                      surah.englishNameTranslation!,
                      style: TextStyle(color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Spacer renamed/removed or handled by Expanded
              SizedBox(width: 8),
              Text(
                surah.name!,
                style: TextStyle(
                    color: Constants.kPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    fontFamily: 'Amiri'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
