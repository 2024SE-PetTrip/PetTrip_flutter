import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pettrip_fe/const/colors.dart';
import 'package:pettrip_fe/models/care_model.dart';
import 'package:pettrip_fe/services/care_community_service.dart';
import 'package:pettrip_fe/widgets/filter_button.dart';

import 'package:pettrip_fe/screens/care_detail_page.dart';
import 'package:pettrip_fe/screens/care_request_page.dart';

import '../const/style.dart';

class CareFindPage extends StatefulWidget {
  const CareFindPage({super.key});

  @override
  State<CareFindPage> createState() => _CareFindPageState();
}

class _CareFindPageState extends State<CareFindPage> {
  String? _searchTitle;
  String? _searchLocation;
  String? _breed;

  List<CareModel> _items = [];
  bool _isLoading = false;

  final CareCommunityService careCommunityService = CareCommunityService();

  Future<void> _fetchItems() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final items = await careCommunityService.fetchItems(
        title: _searchTitle,
        location: _searchLocation,
        breed: _breed,
      );
      setState(() {
        _items = items;
      });
    } catch (e) { //예외 처리
      if(!mounted) return;
      debugPrint('Failed to load items: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _textController = TextEditingController();

    return Scaffold(
      body: Column(
        children: [
          Divider(
            color: DARK_GRAY_COLOR,
            height: 1.0,
            thickness: 1.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // 검색창
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      labelText: '검색어',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          color: MAIN_COLOR,
                          width: 1.0
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          color: MAIN_COLOR,
                          width: 1.0
                        )
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          _searchTitle = _textController.text;
                        },
                      )
                    ),
                    onChanged: (value) {
                      // 검색어 입력 시 동작
                      _searchTitle = value;
                    },
                  ),
                ),
                const SizedBox(width: 8), // 간격 추가
                const FilterButton(), // 필터 버튼
              ],
            ),
          ),
          SizedBox(width: 8),
          if (_isLoading) Center(child: CircularProgressIndicator()) else Expanded(
              child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CareDetailPage(item: item)),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: LIGHT_GRAY_COLOR),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: titleTextStyle,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  item.address,
                                  style: smallTextStyle,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ),


        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CareRequestPage()
              )
          );
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: MAIN_COLOR,
        child: const Icon(
          color: Colors.white,
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}
