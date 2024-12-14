import 'package:flutter/material.dart';
import 'package:pettrip_fe/const/colors.dart';
import 'package:pettrip_fe/models/care_model.dart';

import 'package:pettrip_fe/widgets/info_box.dart';

class CareDetailPage extends StatelessWidget {
  final CareModel item;

  const CareDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("돌봄 요청"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지
            Center(
              child: ClipRRect(
                child: Image.network(
                  // TODO: 이미지 URL 정보 추가
                  '예시 이미지 URL',
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 제목
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24, color: DARK_GRAY_COLOR, thickness: 1),
            const Text('반려동물 정보', style: const TextStyle(fontSize: 16)),
            //InfoBox(title: '종', content: item.breed),
            InfoBox(title: '지역', content: item.address),
          ],
        ),
      ),
    );
  }
}
