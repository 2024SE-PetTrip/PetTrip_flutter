import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pettrip_fe/const/colors.dart';
import 'package:pettrip_fe/models/care_model.dart';
import 'package:pettrip_fe/service/care_community_service.dart';
import 'package:pettrip_fe/widgets/filter_button.dart';

import 'package:pettrip_fe/screens/care_detail_page.dart';

class CareFindPage extends StatefulWidget {
  const CareFindPage({super.key});

  @override
  State<CareFindPage> createState() => _CareFindPageState();
}

class _CareFindPageState extends State<CareFindPage> {
  //TODO: 필터링 관련 변수
  String? _searchTitle;
  String? _searchLocation;
  String? _breed;

  List<Item> _items = [];
  bool _isLoading = false;

  Future<void> _fetchItems() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final items = await CareCommunityService.fetchItems(
        //TODO:필터링 관련 넘겨줄 파라미터
        title: _searchTitle,
        location: _searchLocation,
        breed: _breed,
      );
      setState(() {
        _items = items;
      });
    } catch (e) { //예외 처리
      if(!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load items: $e')));
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: LIGHT_GRAY_COLOR,
                        ),
                        title: Text(item.title),
                        subtitle: Text(item.breed),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item.status, style: TextStyle(color: MAIN_COLOR)),
                            Text(item.location),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CareDetailPage(item: item)),
                          );
                        },
                      ),
                    );
                  },
                ),
          )
        ],
      ),
    );
  }
}
