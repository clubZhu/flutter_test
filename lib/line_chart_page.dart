import 'package:flutter/material.dart';
import 'package:flutter_architecture_test/line_chart/line_chart.dart';
import 'package:flutter_architecture_test/line_chart/models/line_chart_data.dart';

/// 折线图页面
class LineChartPage extends StatefulWidget {
  const LineChartPage({super.key});

  @override
  State<LineChartPage> createState() => _LineChartPageState();
}

class _LineChartPageState extends State<LineChartPage>
    with SingleTickerProviderStateMixin {
  // 示例数据
  late List<List<LineChartData>> chartData;
  int selectedChartIndex = 0;
  GridType selectedGridType = GridType.horizontal;

  // 动画控制器
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 初始化数据
    chartData = [
      // 示例 1: 月度销售额
      [
        LineChartData(
          label: '1月',
          value: 0.1,
          description: '新年促销活动\n同比增长15%',
        ),
        LineChartData(
          label: '2月',
          value: 0.01,
          description: '春节销售高峰\n环比增长20%',
        ),
        LineChartData(
          label: '3月',
          value: 0.001,
          description: '春季新品发布\n创历史新高',
        ),
        LineChartData(
          label: '4月',
          value: 0.0001,
          description: '市场调整期\n略有回落',
        ),
        LineChartData(
          label: '5月',
          value: 0.019,
          description: '五一活动火爆\n恢复增长态势',
        ),
        LineChartData(
          label: '6月',
          value: 0.0199,
          description: '618大促\n半年销售额峰值',
        ),
        LineChartData(
          label: '7月',
          value: 0.0189,
          description: '夏季淡季\n正常回落',
        ),
        LineChartData(
          label: '8月',
          value: 0.0100,
          description: '返校季活动\n突破记录！',
        ),
      ],
      // 示例 2: 温度变化
      [
        LineChartData(
          label: '周一',
          value: 18,
          color: Colors.blue,
          description: '多云转晴\n体感舒适',
        ),
        LineChartData(
          label: '周二',
          value: 22,
          color: Colors.blue,
          description: '晴天\n气温回升',
        ),
        LineChartData(
          label: '周三',
          value: 25,
          color: Colors.orange,
          description: '晴转多云\n气温升高',
        ),
        LineChartData(
          label: '周四',
          value: 28,
          color: Colors.orange,
          description: '多云\n夏季感明显',
        ),
        LineChartData(
          label: '周五',
          value: 32,
          color: Colors.red,
          description: '高温天气\n注意防暑',
        ),
        LineChartData(
          label: '周六',
          value: 35,
          color: Colors.red,
          description: '持续高温\n红色预警',
        ),
        LineChartData(
          label: '周日',
          value: 30,
          color: Colors.orange,
          description: '雷阵雨\n气温下降',
        ),
      ],
      // 示例 3: 股票价格
      [
        LineChartData(
          label: '9:00',
          value: 100,
          description: '开盘价100\n平开',
        ),
        LineChartData(
          label: '10:00',
          value: 105,
          description: '快速拉升\n涨幅5%',
        ),
        LineChartData(
          label: '11:00',
          value: 103,
          description: '小幅回调\n市场调整',
        ),
        LineChartData(
          label: '12:00',
          value: 108,
          description: '午前拉升\n创新高',
        ),
        LineChartData(
          label: '13:00',
          value: 110,
          description: '午后走强\n涨幅10%',
        ),
        LineChartData(
          label: '14:00',
          value: 107,
          description: '尾盘跳水\n获利回吐',
        ),
        LineChartData(
          label: '15:00',
          value: 112,
          description: '收盘价112\n涨幅12%',
        ),
      ],
    ];

    // 初始化动画
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _switchChart(int index) {
    setState(() {
      selectedChartIndex = index;
    });
    _animationController.reset();
    _animationController.forward();
  }

  void _switchGridType(GridType type) {
    setState(() {
      selectedGridType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('折线图示例'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 图表切换按钮
            _buildChartSelector(),

            // 网格类型切换按钮
            _buildGridTypeSelector(),

            // 折线图
            SizedBox(
              height: 300,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  // 导入交互式折线图组件
                  return InteractiveLineChart(
                    data: chartData[selectedChartIndex],
                    animationValue: _animation.value,
                    lineColor: _getLineColor(selectedChartIndex),
                    showArea: selectedChartIndex != 2,
                    gridType: selectedGridType,
                    minY: 0,
                    pointRadius: 5,
                  );
                },
              ),
            ),

            // 底部说明
            // _buildInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        children: [
          _buildSelectorChip(0, '销售额趋势'),
          _buildSelectorChip(1, '温度变化'),
          _buildSelectorChip(2, '股票价格'),
        ],
      ),
    );
  }

  Widget _buildSelectorChip(int index, String label) {
    final isSelected = selectedChartIndex == index;
    return ElevatedButton(
      onPressed: () => _switchChart(index),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey.shade300,
        foregroundColor: isSelected ? Colors.white : Colors.grey.shade700,
        elevation: isSelected ? 4 : 0,
      ),
      child: Text(label),
    );
  }

  Widget _buildGridTypeSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        children: [
          _buildGridTypeChip(GridType.both, '全部网格'),
          _buildGridTypeChip(GridType.horizontal, '仅横线'),
          _buildGridTypeChip(GridType.vertical, '仅竖线'),
          _buildGridTypeChip(GridType.none, '无网格'),
        ],
      ),
    );
  }

  Widget _buildGridTypeChip(GridType type, String label) {
    final isSelected = selectedGridType == type;
    return OutlinedButton(
      onPressed: () => _switchGridType(type),
      style: OutlinedButton.styleFrom(
        backgroundColor:
            isSelected ? Colors.green.withOpacity(0.2) : Colors.transparent,
        foregroundColor:
            isSelected ? Colors.green.shade700 : Colors.grey.shade700,
        side: BorderSide(
          color: isSelected ? Colors.green : Colors.grey.shade400,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildChartCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.indigo.shade400, Colors.purple.shade400],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.info_outline, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                '折线图原理',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '• 使用 CustomPaint 自定义绘制\n'
            '• 支持手指滑动查看数据\n'
            '• 提示框悬浮显示详细信息\n'
            '• 松手后提示框自动消失\n'
            '• 支持渐变填充区域\n'
            '• 适用于趋势分析、数据对比等场景',
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _getChartTitle(int index) {
    switch (index) {
      case 0:
        return '示例 1: 月度销售额趋势';
      case 1:
        return '示例 2: 一周温度变化';
      case 2:
        return '示例 3: 股票价格走势';
      default:
        return '折线图';
    }
  }

  String _getChartSubtitle(int index) {
    switch (index) {
      case 0:
        return '展示上半年销售数据变化趋势';
      case 1:
        return '本周气温变化曲线（°C）';
      case 2:
        return '实时股票价格波动';
      default:
        return '';
    }
  }

  Color _getLineColor(int index) {
    switch (index) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
}
