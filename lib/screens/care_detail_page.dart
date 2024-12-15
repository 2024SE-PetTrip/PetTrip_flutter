import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pettrip_fe/const/colors.dart';
import 'package:pettrip_fe/const/style.dart';
import 'package:pettrip_fe/models/care_model.dart';
import 'package:pettrip_fe/services/care_community_service.dart';
import 'package:pettrip_fe/services/chat_room_service.dart';

import 'package:pettrip_fe/widgets/info_box.dart';

class CareDetailPage extends StatefulWidget {
  final CareModel item;

  CareDetailPage({super.key, required this.item});

  @override
  State<CareDetailPage> createState() => _CareDetailPageState();
}

class _CareDetailPageState extends State<CareDetailPage> {
  final ChatRoomService _chatRoomService = ChatRoomService();

  late bool _isApplicant = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("돌봄 요청"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.item.title,
                style: titleTextStyle
              ),
            ),
            defaultDivider,
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoBox(title: '지역', content: widget.item.address),
                  SizedBox(height: 10),
                  InfoBox(title: '돌봄 희망일', content: DateFormat('yyyy-MM-dd / HH:mm').format(widget.item.startDate)),
                  SizedBox(height: 20),
                  Text('설명글'),
                  SizedBox(
                    height: 10,
                  ),
                  Text(widget.item.requestDescription),
                ],
              ),
            ),
            SizedBox(height: 10),
            defaultDivider,

            SizedBox(height: 10),
            _isApplicant?
            SizedBox():
            Center(
              child: TextButton(
                onPressed: (){
                  _chatRoomService.createChatRoom(16, 17);
                  setState(() {
                    _isApplicant = true;
                  });
                },
                style: defaultTextButtonStyle,
                child: Text("돌봄 지원하기"),
              ),
            )
          ],
        ),
      ),
    );
  }
}