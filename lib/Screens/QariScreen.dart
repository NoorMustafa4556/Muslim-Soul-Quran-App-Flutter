import 'package:flutter/material.dart';

import 'package:flutter_quran_yt/Constants/Constants.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../Models/Qari.dart';
import '../Services/ApiServices.dart';
import '../Widgets/QariCustomTile.dart';
import 'AudioSurahScreen.dart';

class QariListScreen extends StatefulWidget {
  const QariListScreen({Key? key}) : super(key: key);

  @override
  _QariListScreenState createState() => _QariListScreenState();
}

class _QariListScreenState extends State<QariListScreen> {
  ApiServices apiServices = ApiServices();
  List<Qari> _allQaris = [];
  List<Qari> _filteredQaris = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchQaris();
  }

  void _fetchQaris() async {
    try {
      List<Qari> data = await apiServices.getQariList();
      if (mounted) {
        setState(() {
          _allQaris = data;
          _filteredQaris = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print("Error fetching qaris: $e");
    }
  }

  void _filter(String query) {
    List<Qari> results = [];
    if (query.isEmpty) {
      results = _allQaris;
    } else {
      results = _allQaris
          .where((q) => q.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {
      _filteredQaris = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:
              Text('Reciters', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Constants.kPrimary,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 12, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 12,
              ),
              // Search Field
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Constants.kPrimary.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 0.0,
                        offset: Offset(0, 5),
                      ),
                    ]),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filter,
                  decoration: InputDecoration(
                    hintText: 'Search Qari...',
                    prefixIcon: Icon(Icons.search, color: Constants.kPrimary),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // List View
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            color: Constants.kPrimary))
                    : _filteredQaris.isEmpty
                        ? Center(child: Text('No Reciters found'))
                        : AnimationLimiter(
                            child: ListView.builder(
                              itemCount: _filteredQaris.length,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 500),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: QariCustomTile(
                                          qari: _filteredQaris[index],
                                          ontap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AudioSurahScreen(
                                                            qari:
                                                                _filteredQaris[
                                                                    index])));
                                          }),
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
