
import 'package:flutter/material.dart';
import 'package:flutter_aqi/shop/models/rank_entity.dart';

class RankProvider extends ChangeNotifier {

  RankEntity _rank;
  RankEntity get rank => _rank;

  /// Tab的下标
  int _index = 0;
  int get index => _index;
  /// 商品数量
  final List<int> _goodsCountList = [0, 0, 0];
  List<int> get goodsCountList => _goodsCountList;

  /// 选中商品分类下标
  int _sortIndex = 0;
  int get sortIndex => _sortIndex;
  
  void setRank(RankEntity rank) {
    _rank = rank;
    notifyListeners();
  }

  void setSortIndex(int sortIndex) {
    _sortIndex = sortIndex;
    notifyListeners();
  }

  void setIndex(int index) {
    _index = index;
    notifyListeners();
  }

  void setGoodsCount(int count) {
    _goodsCountList[index] = count;
    notifyListeners();
  }
}