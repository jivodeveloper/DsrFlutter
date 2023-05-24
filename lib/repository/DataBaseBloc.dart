import 'package:flutter/foundation.dart';
import 'package:promoterapp/models/Item.dart';
import 'package:rxdart/rxdart.dart';
import '../util/LoadAsset.dart';

class SportsDataBaseBloc {

  final LoadAsset _loadAsset = LoadAsset();

  final BehaviorSubject<Category> _categorySubject = BehaviorSubject<Category>();
  final BehaviorSubject<Item> _itemSubject = BehaviorSubject<Item>();

  dispose() {
    _categorySubject.close();
    _itemSubject.close();
  }

  BehaviorSubject<Item> get itemSubject  => _itemSubject;

  BehaviorSubject<Category> get categorySubject => _categorySubject;

  getSports(String userid) async {
    Item itemResponse = await _loadAsset.loaditems(userid);
    _itemSubject.sink.add(itemResponse);
  }

  getCountryLeague(String userid) async {
    Category categoryResponse = await _loadAsset.loadcategories(userid);
    _categorySubject.sink.add(categoryResponse);
  }

  dispose() {
    _itemSubject.close();
    _categorySubject.close();
  }

  void drainStream() {
    countrySports.clear();
    _itemSubject.value = null;
    _categorySubject.value = null;
  }

  int totalLeague() {
    return countryLeagueLength;
  }

  List<CategoryItem> categorylist = [];
  int categorylength;

  Stream<List<CategoryItem>> get getCountryLeagueSports =>
      Rx.combineLatest2(countryLeagueSubject.stream, sportSubject.stream,
              (Catgeory categoryResponse,
              Item itemResponse) {
            for (var league in categoryResponse.countryLeagueList) {
              for (var sports in itemResponse.sportsList) {
                if (league.sportsName == sports.sportsName) {
                  categorylist.add(
                    CategoryItem(
                      league,
                      sports.sportsThumbnailImage,
                   ),
                 );
               }
             }
          }
        return categorylist;
      });

}