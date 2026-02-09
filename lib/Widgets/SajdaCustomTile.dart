import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Models/Sajda.dart';
import '../Constants/Constants.dart';

Widget SajdaCustomTile(SajdaAyat sajdaAyat, context, {VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
                  sajdaAyat.juzNumber.toString(),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: '${sajdaAyat.surahEnglishName} \n',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16)),
                      TextSpan(
                          text: sajdaAyat.revelationType,
                          style: TextStyle(color: Colors.grey)),
                    ]),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              Spacer(),
              Text(
                sajdaAyat.surahName,
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
