import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/view/comm_views/moudel/detail_info.dart';

class PictureShow extends StatelessWidget {
  final List<LocalMedia> image;
  final int columnSize;
  final FocusNode blankNode = FocusNode();
  PictureShow({
    @required this.image,
    this.columnSize = 3,
  });

  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context:context,
      removeTop: true,
      removeRight: true,
      removeLeft: true,
      removeBottom: true,
//      padding: EdgeInsets.only(left: 10.0,right: 10.0),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: columnSize,
        children: List.generate(
          image != null ? image.length : 1,
          (index) => GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(0.5),
              child: buildImage(index),
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(blankNode);
              Navigator.of(context).push(
                NinePicture(image[index].loadPictureType, image, index),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<bool> checkPictureISLocal(int index) async {
    File txt = File(image[index].realPath);
    return await txt.exists(); //返回真假
  }

  //
  buildImage(int index) {
    if (image[index].loadPictureType==LoadPictureType.asset) {
      return Image.asset(
        image[index].path,
        fit: BoxFit.cover,
        key: Key(index.toString()),
      );
    } else if(image[index].loadPictureType==LoadPictureType.netWork){
      return CachedNetworkImage(
        key: Key(index.toString()),
        fit: BoxFit.cover,
        alignment: Alignment.center,
        placeholder: (context, url) => CircularProgressIndicator(
//                   backgroundColor: Colors.pink,
            ),
        errorWidget: (context, url, error) => Icon(Icons.error),
        imageUrl: image != null
            ? image[index].realPath == null ? "" : image[index].realPath
            : "12321",
      );
    }else{
      return Image.file(
        File(image[index].path),
        fit: BoxFit.cover,
        alignment: Alignment.center,
      );
    }
  }
}

class NinePicture<T> extends PopupRoute<T> {
  final String barrierLabel;
  final List picList;
  final int index;
  final LoadPictureType loadPictureType;
  int startX;
  int endX;

  NinePicture(this.loadPictureType, this.picList, this.index, {this.barrierLabel});

  @override
  Duration get transitionDuration => Duration(milliseconds: 2000);

  @override
  @override
  Color get barrierColor => Colors.black54;

  @override
  bool get barrierDismissible => true;

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator.overlay);
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: GestureDetector(
        child: AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget child) => GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: _PictureWidget(picList, index, loadPictureType),
          ),
        ),
      ),
    );
  }
}

class _PictureWidget extends StatefulWidget {
  final List<LocalMedia> picList;
  final int index;
  final loadPictureType;

  _PictureWidget(this.picList, this.index, this.loadPictureType);

  @override
  State createState() {
    return _PictureWidgetState();
  }
}

class _PictureWidgetState extends State<_PictureWidget> {
  int startX = 0;
  int endX = 0;
  int index = 0;
  LoadPictureType loadPictureType;

  @override
  void initState() {
    super.initState();
    index = widget.index;
    loadPictureType = widget.loadPictureType;
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.transparent,
      child: new Container(
        padding: EdgeInsets.all(0),
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              child: Center(
                child: _buildImage(index,loadPictureType),
              ),
              onHorizontalDragDown: (detail) {
                startX = detail.globalPosition.dx.toInt();
              },
              onHorizontalDragUpdate: (detail) {
                endX = detail.globalPosition.dx.toInt();
              },
              onHorizontalDragEnd: (detail) {
                _getIndex(endX - startX);
                setState(() {});
              },
              onHorizontalDragCancel: () {},
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.picList.length,
                  (i) => GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(
                        foregroundColor: Theme.of(context).primaryColor,
                        radius: 4.0,
                        backgroundColor: index == i
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        startX = endX = 0;
                        index = i;
                      });
                    },
                  ),
                ).toList(),
              ),
            )
          ],
        ),
        alignment: Alignment.center,
      ),
    );
  }

  _buildImage(int index,LoadPictureType loadPictureType) {
    if (loadPictureType == LoadPictureType.asset) {
      return Image.asset(
        widget.picList[index].path,
        fit: BoxFit.cover,
        key: Key(index.toString()),
      );
    } else if(loadPictureType == LoadPictureType.netWork){
      return CachedNetworkImage(
        imageUrl: widget.picList[index].realPath,
        fit: BoxFit.cover,
      );
    }else{
      return Image.file(File(widget.picList[index].path),fit: BoxFit.cover,);
    }
  }

  void _getIndex(int delta) {
    if (delta > 50) {
      setState(() {
        index--;
        index = index.clamp(0, widget.picList.length - 1);
      });
    } else if (delta < 50) {
      setState(() {
        index++;
        index = index.clamp(0, widget.picList.length - 1);
      });
    }
  }
}
