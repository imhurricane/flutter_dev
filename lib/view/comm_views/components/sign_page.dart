import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/comm/comm_utils.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/paper.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/riss_complete.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class SignApp extends StatefulWidget {

  final String mPaperXtm;
  final String mRissXtm;

  SignApp({this.mPaperXtm,this.mRissXtm});

  @override
  State<StatefulWidget> createState() {
    return SignAppState();
  }
}

class SignAppState extends State<SignApp> {
  GlobalKey<SignatureState> signatureKey = GlobalKey(); // 使跨组件访问状态

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
        appBar: AppBar(
          title: Text("签名"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Container(child: Signature(key: signatureKey)),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.white,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    color: Colors.lightBlue,
                    textColor: Colors.white,
                    child: Text('返回上一级'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    color: Colors.lightBlue,
                    textColor: Colors.white,
                    child: Text('清除画布'),
                    onPressed: () {
                      signatureKey.currentState.clearPoints();
                    },
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    color: Colors.lightBlue,
                    textColor: Colors.white,
                    child: Text('保存并签收'),
                    onPressed: () {
                      setRenderedImage(context);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  setRenderedImage(BuildContext context) async {
    ui.Image renderedImage = await signatureKey.currentState.rendered; // 转成图片
    setState(() {
      image = renderedImage;
    });
    Directory appDocDirs = await getExternalStorageDirectory();
    Directory directory = await Directory('${appDocDirs.path}/Sign').create();
    var pngBytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final imageFile =
        File(path.join(directory.path, 'sign_${widget.mPaperXtm}.png'));
    imageFile.writeAsBytesSync(pngBytes.buffer.asInt8List());

    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(imageFile.readAsBytesSync()),
    );
    print('result:' + imageFile.path.toString());

    RissComplete rissComplete = RissComplete();
    rissComplete.signImagePath = '${imageFile.path}';
    rissComplete.isUpload = "0";
    rissComplete.xtm = widget.mRissXtm;
    RissCompleteProvider rissCompleteProvider = RissCompleteProvider();
    await rissCompleteProvider.updateWithSignImage(rissComplete);

    PaperProvider paperProvider = PaperProvider();
    Paper paper = Paper();
    paper.xtm=widget.mPaperXtm;
    paper.isSignImage=true;
    paperProvider.updateWithSign(paper);


    if (result['isSuccess']) {
      CommUtils.showDialog(context, "提示", "保存成功！", false, okOnPress: () {});
    } else {
      CommUtils.showDialog(context, "提示", "保存失败！", false, okOnPress: () {});
    }
  }
}

class Signature extends StatefulWidget {
  Signature({Key key}) : super(key: key);

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
    return recorder
        .endRecording()
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
                Offset _locationPoints =
                    _object.localToGlobal(details.globalPosition);
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

  void clearPoints() {
    setState(() {
      _points.clear();
    });
  }
}

class SignaturePainter extends CustomPainter {
  List<Offset> points = <Offset>[];

  SignaturePainter({this.points});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
