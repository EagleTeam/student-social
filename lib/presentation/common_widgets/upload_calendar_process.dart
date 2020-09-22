// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:studentsocial/helpers/logging.dart';

class UploadCalendarProcess extends StatelessWidget {
  const UploadCalendarProcess(this.streamProcess, {Key key}) : super(key: key);

  final Stream<double> streamProcess;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: streamProcess,
        builder: (context, snapshot) {
          logs('data is ${snapshot.data}');
          if (snapshot.hasData) {
            if (snapshot.data < 1.0) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                      child: CircularProgressIndicator(
                    value: snapshot.data,
                  )),
                  Text(
                      'Đang tải lên ${((snapshot.data as double) * 100).toInt()}%')
                ],
              );
            } else {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(
                      child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50,
                  )),
                  const Text('Tải lên hoàn tất!'),
                  OutlineButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Xong'),
                  )
                ],
              );
            }
          } else {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Center(child: CircularProgressIndicator()),
              ],
            );
          }
        });
  }
}
