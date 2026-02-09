import 'dart:convert';
import 'dart:math';
import 'package:flutter_quran_yt/Models/AyaOfTheDay.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/Juz.dart';
import '../Models/Qari.dart';
import '../Models/Sajda.dart';
import '../Models/Surah.dart';
import '../Models/Translation.dart';

class ApiServices {
  final endPointUrl = "http://api.alquran.cloud/v1/surah";
  List<Surah> list = [];

  Future<AyaOfTheDay> getAyaOfTheDay() async {
    // Try getting from cache first
    final prefs = await SharedPreferences.getInstance();

    // Check if we have a saved Ayah and if it is from today
    if (prefs.containsKey('aya_day_cache')) {
      String? savedDate = prefs.getString('aya_date');
      String todayDate = DateTime.now().toIso8601String().split('T')[0];

      if (savedDate == todayDate) {
        return AyaOfTheDay.fromJSON(
            json.decode(prefs.getString('aya_day_cache')!));
      }
    }

    // for random Aya we need to generate random number
    // (1,6237) from 1 to 6236
    String url =
        "https://api.alquran.cloud/v1/ayah/${random(1, 6237)}/editions/quran-uthmani,en.asad,en.pickthall";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Save to cache
        await prefs.setString('aya_day_cache', response.body);
        await prefs.setString(
            'aya_date', DateTime.now().toIso8601String().split('T')[0]);

        return AyaOfTheDay.fromJSON(json.decode(response.body));
      } else {
        throw Exception("Failed to Load Post");
      }
    } catch (e) {
      // If net fails and we have OLD cache, return it rather than error
      if (prefs.containsKey('aya_day_cache')) {
        return AyaOfTheDay.fromJSON(
            json.decode(prefs.getString('aya_day_cache')!));
      }
      throw Exception("Failed to load Aya (Offline & No Cache)");
    }
  }

  random(min, max) {
    var rn = new Random();
    return min + rn.nextInt(max - min);
  }

  Future<List<Surah>> getSurah() async {
    // Try getting from cache first
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('surah_cache')) {
      final cachedData = jsonDecode(prefs.getString('surah_cache')!);
      list = [];
      cachedData['data'].forEach((element) {
        if (list.length < 114) {
          list.add(Surah.fromJson(element));
        }
      });
      // Return cached data immediately, then fetch in background if needed (optional strategy)
      // For now, if we have cache, we just return it to ensure speed.
      // Ideally, we could check internet and update, but returning cache provides instant speed.
      // If cache is present, we return it. If the user wants fresh data, they can clear cache (or we implement silent update).
      // To ensure data freshness without slowing down, we will just stick to cache if available for this session.
      return list;
    }

    // If no cache, fetch from network
    try {
      Response res = await http.get(Uri.parse(endPointUrl));
      if (res.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(res.body);

        // Save to cache
        await prefs.setString('surah_cache', res.body);

        json['data'].forEach((element) {
          if (list.length < 114) {
            list.add(Surah.fromJson(element));
          }
        });
        print('ol ${list.length}');
        return list;
      } else {
        throw ("Can't get the Surah");
      }
    } catch (e) {
      print("Network Error: $e");
      // If network fails and we have no cache, return empty or rethrow
      if (list.isNotEmpty) return list;
      throw ("Failed to load Surah (Offline & No Cache)");
    }
  }

  Future<SajdaList> getSajda() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('sajda_cache')) {
      return SajdaList.fromJSON(json.decode(prefs.getString('sajda_cache')!));
    }

    String url = "http://api.alquran.cloud/v1/sajda/en.asad";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        await prefs.setString('sajda_cache', response.body);
        return SajdaList.fromJSON(json.decode(response.body));
      } else {
        print("Failed to load");
        throw Exception("Failed  to Load Post");
      }
    } catch (e) {
      throw Exception("Failed to load Sajda (Offline & No Cache)");
    }
  }

  Future<JuzModel> getJuzz(int index) async {
    // Juz is large, caching each juz might be heavy but useful.
    final prefs = await SharedPreferences.getInstance();
    String cacheKey = 'juz_cache_$index';

    if (prefs.containsKey(cacheKey)) {
      return JuzModel.fromJSON(json.decode(prefs.getString(cacheKey)!));
    }

    String url = "http://api.alquran.cloud/v1/juz/$index/quran-uthmani";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        await prefs.setString(cacheKey, response.body);
        return JuzModel.fromJSON(json.decode(response.body));
      } else {
        throw Exception("Failed  to Load Post");
      }
    } catch (e) {
      throw Exception("Failed to load Juz (Offline & No Cache)");
    }
  }

  Future<SurahTranslationList> getTranslation(
      int index, int translationIndex) async {
    String lan = "";
    if (translationIndex == 0) {
      lan = "urdu_junagarhi";
    } else if (translationIndex == 1) {
      lan = "hindi_omari";
    } else if (translationIndex == 2) {
      lan = "english_saheeh";
    } else if (translationIndex == 3) {
      lan = "spanish_garcia";
    }

    final url = "https://quranenc.com/api/translation/sura/$lan/$index";
    var res = await http.get(Uri.parse(url));

    return SurahTranslationList.fromJson(json.decode(res.body));
  }

  List<Qari> qarilist = [];

  Future<List<Qari>> getQariList() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('qari_cache')) {
      qarilist = [];
      jsonDecode(prefs.getString('qari_cache')!).forEach((element) {
        if (qarilist.length < 20) qarilist.add(Qari.fromjson(element));
      });
      qarilist.sort((a, b) => a.name!.compareTo(b.name!));
      return qarilist;
    }

    final url = "https://quranicaudio.com/api/qaris";
    try {
      final res = await http.get(Uri.parse(url));

      await prefs.setString('qari_cache', res.body);

      jsonDecode(res.body).forEach((element) {
        if (qarilist.length <
            20) // 20 is not mandatory , you can change it upto 157
          qarilist.add(Qari.fromjson(element));
      });
      qarilist.sort(
          (a, b) => a.name!.compareTo(b.name!)); // sort according to A B C
      return qarilist;
    } catch (e) {
      if (qarilist.isNotEmpty) return qarilist;
      throw Exception("Failed to load Qaris");
    }
  }
}
