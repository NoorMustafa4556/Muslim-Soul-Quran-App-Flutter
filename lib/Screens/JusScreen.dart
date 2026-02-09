import 'package:flutter/material.dart';
import 'package:flutter_quran_yt/Constants/Constants.dart';

import '../Models/Juz.dart';
import '../Services/ApiServices.dart';
import '../Widgets/JuzCustomTile.dart';

class JuzScreen extends StatelessWidget {
  static const String id = 'juz_screen';

  ApiServices apiServices = ApiServices();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Juz ${Constants.juzIndex}",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Constants.kPrimary,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: FutureBuilder<JuzModel>(
          future: apiServices.getJuzz(Constants.juzIndex!),
          builder: (context, AsyncSnapshot<JuzModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              print('${snapshot.data!.juzAyahs.length} length');
              return ListView.builder(
                itemCount: snapshot.data!.juzAyahs.length,
                itemBuilder: (context, index) {
                  return JuzCustomTile(
                    list: snapshot.data!.juzAyahs,
                    index: index,
                  );
                },
              );
            } else {
              return Center(
                child: Text('Data not found'),
              );
            }
          },
        ),
      ),
    );
  }
}
