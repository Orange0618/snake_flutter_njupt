import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanchishe/utils/snackbar_util.dart';

void main() {
  group('Utils - showSnackBar', () {
    testWidgets('Displays SnackBar with correct message', (WidgetTester tester) async {
      // 创建一个测试环境
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showSnackBar(context, '测试消息');
                    },
                    child: Text('显示 SnackBar'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // 触发按钮，显示 SnackBar
      await tester.tap(find.text('显示 SnackBar'));
      await tester.pump(); // 触发 SnackBar 出现动画
      await tester.pump(Duration(seconds: 1)); // 等待 SnackBar 显示

      // 验证是否显示了包含消息文本的 SnackBar
      expect(find.text('测试消息'), findsOneWidget);

      // 验证 SnackBar 是否存在于 ScaffoldMessenger
      expect(find.byType(SnackBar), findsOneWidget);

      // 等待 3 秒，让 SnackBar 消失
      await tester.pump(Duration(seconds: 3));
      await tester.pumpAndSettle(); // 确保动画完成

      // 验证 SnackBar 确实消失
      expect(find.text('测试消息'), findsNothing);
    });
  });
}
