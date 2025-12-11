import 'package:flutter/material.dart';
import '../models/response.dart';

class ResponseTile extends StatelessWidget {
  final ResponseData response;
  const ResponseTile({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(response.level)),
      title: Text(response.name),
      subtitle: Text('Roll: ${response.roll}'),
      trailing: Text(DateTime.fromMillisecondsSinceEpoch(response.timestamp)
          .toLocal()
          .toString()),
    );
  }
}
