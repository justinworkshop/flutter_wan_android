import 'package:flutter/material.dart';
import 'package:flutterwanandroid/ui/page/develop/develop_widget.dart';

class DevelopPage extends StatefulWidget {
  @override
  _DevelopPageState createState() => _DevelopPageState();
}

class _DevelopPageState extends State<DevelopPage> {
  ScrollController _controller = new ScrollController();
  List develops = ["TimePicker", "DayPicker", "MonthPicker", "YearPicker"];

  @override
  void setState(fn) {
    super.setState(fn);

    _controller.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("开发者模式"),
      ),
      body: Offstage(
        offstage: false,
        child: ListView.builder(
          controller: _controller,
          itemCount: develops.length,
          itemBuilder: (context, i) => _buildItem(i),
        ),
      ),
    );
  }

  _buildItem(int i) {
    Column column = new Column(
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.all(10),
          child: Text(develops[i]),
        ),
      ],
    );

    return new Card(
      /// 阴影效果
      elevation: 4.0,
      child: InkWell(
        child: column,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return DevelopWidget(
              develops[i],
            );
          }));
        },
      ),
    );
  }
}
