import 'package:flutter/material.dart';
import 'package:flutter_quran_yt/Constants/Constants.dart';
import 'package:flutter_quran_yt/Screens/SurahDetail.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../Models/Sajda.dart';
import '../Models/Surah.dart';
import '../Services/ApiServices.dart';
import '../Widgets/SajdaCustomTile.dart';
import '../Widgets/SurahCustemTile.dart';
import 'JusScreen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({Key? key}) : super(key: key);

  @override
  _QuranScreenState createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen>
    with AutomaticKeepAliveClientMixin {
  ApiServices apiServices = ApiServices();
  late Future<List<Surah>> _surahFuture;
  late Future<SajdaList> _sajdaFuture;

  @override
  bool get wantKeepAlive => true; // Keeps state alive when switching tabs

  @override
  void initState() {
    super.initState();
    _surahFuture = apiServices.getSurah();
    _sajdaFuture = apiServices.getSajda();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Quran',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Constants.kPrimary,
            bottom: TabBar(
              indicatorColor: Constants.kGold,
              indicatorWeight: 3,
              tabs: [
                Tab(
                    child: Text(
                  'Surah',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                )),
                Tab(
                    child: Text(
                  'Sajda',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                )),
                Tab(
                    child: Text(
                  'Juz',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                )),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              // Surah Tab
              FutureBuilder(
                future: _surahFuture,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Surah>> snapshot) {
                  if (snapshot.hasData) {
                    List<Surah>? surah = snapshot.data;
                    return AnimationLimiter(
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: surah!.length,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: SurahCustomListTile(
                                    surah: surah[index],
                                    context: context,
                                    ontap: () {
                                      setState(() {
                                        Constants.surahIndex = (index + 1);
                                      });
                                      Navigator.pushNamed(
                                          context, Surahdetail.id);
                                    }),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(color: Constants.kPrimary),
                  );
                },
              ),
              // Sajda Tab
              FutureBuilder(
                future: _sajdaFuture,
                builder: (context, AsyncSnapshot<SajdaList> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Something went wrong'),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child:
                          CircularProgressIndicator(color: Constants.kPrimary),
                    );
                  }
                  return AnimationLimiter(
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: snapshot.data!.sajdaAyahs.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: SajdaCustomTile(
                                  snapshot.data!.sajdaAyahs[index], context,
                                  onTap: () {
                                setState(() {
                                  Constants.surahIndex = snapshot
                                      .data!.sajdaAyahs[index].surahNumber;
                                });
                                Navigator.pushNamed(context, Surahdetail.id);
                              }),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              // Juz Tab
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10),
                    itemCount: 30,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            Constants.juzIndex = (index + 1);
                          });
                          Navigator.pushNamed(context, JuzScreen.id);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Constants.kPrimary.withOpacity(0.2)),
                              boxShadow: [
                                BoxShadow(
                                    color: Constants.kPrimary.withOpacity(0.1),
                                    blurRadius: 5,
                                    offset: Offset(0, 2))
                              ]),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                      color: Constants.kPrimary,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Juz',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
