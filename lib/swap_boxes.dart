import 'package:flutter/material.dart';

/// 交换位置示例页面
/// 演示如何使用 Key 来保持 Widget 状态
class SwapBoxes extends StatefulWidget {
  @override
  _SwapBoxesState createState() => _SwapBoxesState();
}

class _SwapBoxesState extends State<SwapBoxes> {
  // 盒子列表，每个盒子都有唯一的 Key
  List<Widget> boxes = [
    Box(color: Colors.blue, key: ValueKey('1')),
    Box(color: Colors.red, key: ValueKey('2')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('交换盒子示例'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 说明文字
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '点击按钮交换两个盒子的位置\n每个盒子都保持自己的计数状态',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            // 横向排列盒子
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: boxes,
            ),
            SizedBox(height: 20),
            // 交换按钮
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // 移除第二个元素并插入到第一个位置
                  boxes.insert(0, boxes.removeAt(1));
                });
              },
              child: Text('交换盒子位置'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 盒子组件
/// 包含颜色属性和独立的计数器状态
class Box extends StatefulWidget {
  final Color color;

  const Box({Key? key, required this.color}) : super(key: key);

  @override
  _BoxState createState() => _BoxState();
}

class _BoxState extends State<Box> {
  // 计数器状态
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: widget.color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 显示计数器值
          Text('Counter: $_counter'),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _counter++;
              });
            },
            child: Text('Increment'),
          ),
        ],
      ),
    );
  }
}

