import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PictureShow extends StatelessWidget {
  final List<String> picList;
  final int columnSize;
  final bool isLocal;

  PictureShow({
    @required
    this.picList,
    this.isLocal = false,
    this.columnSize = 3,
  });

  Widget build(BuildContext context) {
    return Container(
//      padding: EdgeInsets.only(left: 10.0,right: 10.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: columnSize,
        children: List.generate(
          picList!=null?picList.length:1,
              (index) => GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(0.5),
              child: buildImage(index),
            ),
            onTap: () {
              Navigator.of(context).push(
                NinePicture(isLocal,picList, index),
              );
            },
          ),
        ),
      ),
    );
  }

  buildImage(int index) {

    if(isLocal){
      return Image.asset(picList[index],fit: BoxFit.cover,key: Key(index.toString()),);
    }else{
      return CachedNetworkImage(
        key: Key(index.toString()),
        fit: BoxFit.cover,
        alignment: Alignment.center,
        placeholder: (context, url) => CircularProgressIndicator(
//                   backgroundColor: Colors.pink,
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
        imageUrl: picList!=null?picList[index]:"12321",
      );
    }
  }
}

class NinePicture<T> extends PopupRoute<T> {
  final String barrierLabel;
  final List picList;
  final int index;
  final bool isLocal;
  int startX;
  int endX;

  NinePicture(this.isLocal,this.picList, this.index, {this.barrierLabel});

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
            child: _PictureWidget(picList, index,isLocal),
          ),
        ),
      ),
    );
  }
}

class _PictureWidget extends StatefulWidget {
  final List picList;
  final int index;
  final isLocal;

  _PictureWidget(this.picList, this.index,this.isLocal);

  @override
  State createState() {
    return _PictureWidgetState();
  }
}

class _PictureWidgetState extends State<_PictureWidget> {
  int startX = 0;
  int endX = 0;
  int index = 0;
  bool isLocal;

  @override
  void initState() {
    super.initState();
    index = widget.index;
    isLocal = widget.isLocal;
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.transparent,
      child: new Container(
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              child: Center(
                child: buildImage(widget.isLocal,index),
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  widget.picList.length,
                      (i) => GestureDetector(
                    child: CircleAvatar(
                      foregroundColor: Theme.of(context).primaryColor,
                      radius: 8.0,
                      backgroundColor: index == i
                          ? Theme.of(context).primaryColor
                          : Colors.white,
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
  buildImage(bool isLocal,int index) {

    if(isLocal){
      return Image.asset(widget.picList[index],fit: BoxFit.cover,key: Key(index.toString()),);
    }else{
      return CachedNetworkImage(
        imageUrl: widget.picList[index],
        fit: BoxFit.cover,
      );
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