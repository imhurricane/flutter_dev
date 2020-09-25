import 'dart:io';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
//import 'package:flutter_spterp/api.dart';
import 'package:flutter/cupertino.dart';

class SignApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignAppState();
  }
}

class SignAppState extends State<SignApp> {
  GlobalKey<SignatureState> signatureKey = GlobalKey();// 使跨组件访问状态

  var image;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(title: Text("签名"),centerTitle: true,
//          leading: IconButton(
//            onPressed: () {
//              Navigator.of(context).pop();
//            },
//            icon: Icon(Icons.arrow_back_ios),
//          ),
//          actions: [
//
//          ],
          ),
        extendBodyBehindAppBar: true,
        body: Container(child: Signature(key: signatureKey)),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 0.5,color: Colors.white,),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  child: Text('返回上一级'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('清除画布'),
                  onPressed: () {
                    signatureKey.currentState.clearPoints();
                  },
                ),
                FlatButton(
                  child: Text('保存并签收'),
                  onPressed: () {
                    setRenderedImage(context);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
  setRenderedImage(BuildContext context) async {
    ui.Image renderedImage = await signatureKey.currentState.rendered;  // 转成图片
    setState(() {
      image = renderedImage;
    });
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var pngBytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final imageFile = File(path.join(appDocPath, 'dart.png'));
    await imageFile.writeAsBytesSync(pngBytes.buffer.asInt8List());

//    FormData formData =FormData.from({"image": UploadFileInfo(imageFile, 'image.jpg')});
//    String feedback =await feedbackHeader(formData);

//    Navigator.pop(context,feedback);
//    showImage(context);
  }
  String formattedDate() {
    DateTime dateTime = DateTime.now();
    String dateTimeString = 'Signature_' +
        dateTime.year.toString() +
        dateTime.month.toString() +
        dateTime.day.toString() +
        dateTime.hour.toString() +
        ':' + dateTime.minute.toString() +
        ':' + dateTime.second.toString() +
        ':' + dateTime.millisecond.toString() +
        ':' + dateTime.microsecond.toString();
    return dateTimeString;
  }

}

class Signature extends StatefulWidget {
  Signature({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SignatureState();
  }
}

class SignatureState extends State<Signature> {
  List<Offset> _points = <Offset>[];
  Future<ui.Image> get rendered {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    SignaturePainter painter = SignaturePainter(points: _points);
    var size = context.size;
    painter.paint(canvas, size);
    return recorder.endRecording()
        .toImage(size.width.floor(), size.height.floor());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
          child: GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              setState(() {
                RenderBox _object = context.findRenderObject();
                Offset _locationPoints = _object.localToGlobal(details.globalPosition);
                _points = new List.from(_points)..add(_locationPoints);
              });
            },
            onPanEnd: (DragEndDetails details) {
              setState(() {
                _points.add(null);
              });
            },
            child: CustomPaint(
              painter: SignaturePainter(points: _points),
              size: Size.infinite,
            ),
          ),
        ),
      ),
    );
  }

  // clearPoints method used to reset the canvas
  // method can be called using
  //   key.currentState.clearPoints();
  void clearPoints() {
    setState(() {
      _points.clear();
    });
  }
}


class SignaturePainter extends CustomPainter {
  // [SignaturePainter] receives points through constructor
  // @points holds the drawn path in the form (x,y) offset;
  // This class responsible for drawing only
  // It won't receive any drag/touch events by draw/user.
  List<Offset> points = <Offset>[];

  SignaturePainter({this.points});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 5.0;

    for(int i=0; i < points.length - 1; i++) {
      if(points[i] != null && points[i+1] != null) {
        canvas.drawLine(points[i], points[i+1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) {
    return oldDelegate.points != points;
  }

}