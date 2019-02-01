import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kerjoy/add_child_dialog.dart';
import 'package:kerjoy/buildgridview.dart';
import 'package:kerjoy/child_list_widget.dart';
import 'package:kerjoy/children.dart';
import 'package:kerjoy/commentbox.dart';
import 'package:kerjoy/eventactions.dart';
import 'package:kerjoy/home.dart';
import 'package:kerjoy/multi_image/asset_view.dart';
import 'package:kerjoy/play.dart';
import 'package:kerjoy/theme.dart';
import 'package:flutter/material.dart';
import 'package:kerjoy/tools/app_data.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kerjoy/localization/localization.dart';
import 'package:kerjoy/tools/app_tools.dart';
import 'package:multi_image_picker/multi_image_picker.dart';


class LeavePage extends StatefulWidget {
  final childList;
  final int time;
  final int minutes;
  LeavePage({
    this.childList,
    this.time,
    this.minutes
  });

  @override
  _LeavePageState createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  int time;
  int minutes;
  bool notify = true;
  bool share = true;
  bool saveData = false;
  TextEditingController _commentController = TextEditingController();
  String _comment = "";
  var currentMonth = DateFormat.M().format(DateTime.now().toUtc());
  var currentYear = DateFormat.y().format(DateTime.now().toUtc());
  var currentday = DateFormat.d().format(DateTime.now().toUtc());
  var hour = DateFormat.H().format(DateTime.now().toUtc());
  var minute = DateFormat.m().format(DateTime.now().toUtc());
  var second = DateFormat.s().format(DateTime.now().toUtc());
  
  List<Asset> uploadImages = List<Asset>();
  String multiImageError;

            

  FocusNode _focus = new FocusNode();
  bool showBottomBar = true;

  var todayUtcTimestamp;
  bool imageLoading = false;
  var sampleImage;
  var todayHourTimestamp;
  String staffId;
  String dayCare;
  
  bool reOrderGrid = false;
  
  @override
  void initState() {
      // TODO: implement initState
      super.initState();
    var timestamp = new DateTime.now().toUtc().millisecondsSinceEpoch;   
    todayUtcTimestamp = new DateTime.utc(int.parse(currentYear), int.parse(currentMonth), int.parse(currentday)).millisecondsSinceEpoch;
    todayHourTimestamp = timestamp - todayUtcTimestamp;  
    _commentController.addListener(onChange);
    time = widget.time;
    minutes = widget.minutes;
    _focus.addListener(focusChange);
    
  }

  fetchLocalData() async {
    var getStaffId = await getDataLocally(key: userId);
    var getDayCare =  await getDataLocally(key: 'dayCare');
    
    setState(() {
      dayCare = getDayCare;
      staffId = getStaffId;          
    });
    print(dayCare);
    print(staffId);
  }

  void onChange() {
    _comment = _commentController.text;
      
  }

  void focusChange() {
    if(_focus.hasFocus) {
      setState(() {
        showBottomBar = false;           
      });
    } else {
      setState(() {
        showBottomBar = true;              
      });
    }
  }

  Future getImage() async {

    setState(() {
      imageLoading = true;      
    });
    
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    
    setState(() {
      sampleImage = tempImage;
      imageLoading = false;
    });
     
  }

  Widget buildGridView() {
    
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      primary: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 6,
      itemCount: uploadImages.length,
      itemBuilder: (BuildContext context, int index) { 
      
      return Card(
        child: AssetView(index, uploadImages[index]),  
      );
      },
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, 3),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  
  }  

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var fields = AppLocalizations.of(context);
    return Scaffold(
       
      backgroundColor: Colors.white,
      appBar: AppBar(
        
        iconTheme: new IconThemeData(color: black),  
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: new Text(
          fields.leave.toUpperCase(),
          
          style: TextStyle(
            fontSize: 20.0,
            color: black,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            onPressed: () {
              
            },
            alignment: Alignment.centerRight,
            icon: Icon(
              Icons.calendar_today,
              color: black,
              size: 22.0,
            ),
          ),
          new IconButton(
            alignment: Alignment.center,
            onPressed: null,
            padding: EdgeInsets.all(0.0),
            icon: Icon(
              Icons.more_vert,
              color: black,
              size: 22.0,
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(
              
            ),
          ),
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              Center(
                child: Container(),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0, right: 10.0, left: 10.0, bottom: 10.0),
                
                height: 85.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    
                    Expanded(
                      child: Container(
                        
                        child: ChildListWidget(
                          list: widget.childList,
                          action: (childData) {
                            setState(() {
                              widget.childList.remove(childData);                              
                            });
                          },
                        )
                      ),
                    ),
                    AddChildDialogButton(
                      childList: widget.childList,
                      action: (document) {
                        setState(() {
                          widget.childList.add(document);                                                    
                        });
                        
                      },
                      
                    ),
                  ],
                ),  
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0, top: 0.0),
                child: Container(
                  height: 4.0,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2.0, style: BorderStyle.solid, color: shadowGrey )
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                padding: EdgeInsets.all(50.0),

                decoration: BoxDecoration(
                  border: Border.all(
                    color: shadowGrey,
                    width: 2.0,
                    style: BorderStyle.solid
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3.0,
                      color: shadowGrey
                    )
                  ]
                ),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/images/leave.png",
                      height: 100.0,
                      width: 100.0,
                      ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      fields.leave.toUpperCase(),
                      style: TextStyle(
                        fontSize: 28.0,
                        color: black
                      ),
                    )
                  ],
                ),
                  
              ),
              CommentBox(
                imageLoading: imageLoading,
                errorCallback: (error) {
                  print(error);
                  
                },
                imageCallback: (images) {
                  setState(() {
                    reOrderGrid = !reOrderGrid;
                    uploadImages = images;                                      
                  });
                },
                commentController: _commentController,
                focus: _focus,
              ),
              Container(
                height: sampleImage == null ? 0.0 : 100.0,
                width: double.infinity,
                alignment:Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: sampleImage != null ? FileImage(sampleImage) : AssetImage("assets/images/add_photo.png"),
                    fit: BoxFit.contain,
                    alignment: Alignment.center
                  )
                ),
              ),
              Container(
                height: 20.0,
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: <Widget>[
                    CheckboxContainer(
                      color: darkBlue,
                      submit: (values) {
                        setState(() {
                          notify = !notify;                          
                        });
                      },
                      text: fields.notify,
                      value: notify,
                    ),
                    CheckboxContainer(
                      color: darkBlue,
                      submit: (values) {
                        setState(() {
                          share = !share;                          
                        });
                      },
                      text: fields.share,
                      value: share,
                    )
                  ],
                ),
              ),
              
              reOrderGrid ? BuildPhotoGridView(
                uploadImages: uploadImages,
              ) : buildGridView(),
              SizedBox(
                height: 160.0,
              )
            ]
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Container(
                child: showBottomBar ? EventActions(
                  callback: () => onPressed(),
                  timeCallback: (hour, minute) {
                    setState(() {
                      time = hour;
                      minutes = minute;                                          
                    });
                  },
                  minutes: minutes,
                  time: time,
                ) : Container(),
              ),
            ],
          ),
          Center(
            child: saveData ? CircularProgressIndicator(backgroundColor: blue,) : Container(
              height: 0,
              width: 0,
            ),
          )
        ],
      
      ),
    );
  }

  void onPressed() async {
    var fields = AppLocalizations.of(context);
    if(widget.childList.length == 0) {
      Fluttertoast.showToast(
        msg: "${fields.pleaseSelectAChild}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: shadowGrey,
        textColor: black,
      );
      return;
    }

    setState(() {
      saveData = true;      
    });
    int timestamp = new DateTime.now().millisecondsSinceEpoch;
    String downloadUrl = "";
    

    List<String> imagesUrl = [];
    if(uploadImages.isNotEmpty) {
      for(var i = 0; i < uploadImages.length; i++) {
              ByteData imageData = await uploadImages[i].requestOriginal(quality: 35);
              List<int> byteData = imageData.buffer.asUint8List();
              
              // final Directory tempDir = Directory.systemTemp;
              // final String fileName = "${timestamp}${i}.png";
              // final File file = File('${tempDir.path}/$fileName');
              // file.writeAsBytes(byteData, mode: FileMode.write);

      
              final StorageReference firebaseStorageRef =
                      FirebaseStorage.instance.ref().child('leave_${timestamp}${i}.png');
              final StorageUploadTask task =
                          firebaseStorageRef.putData(byteData);
              
              StorageTaskSnapshot taskSnapshot = await task.onComplete;
      
              var uploadedImageUrl = await taskSnapshot.ref.getDownloadURL();
              imagesUrl.add(uploadedImageUrl);    
              uploadImages[i].requestOriginal();
            }
          }

          

    if(sampleImage != null) {
    final StorageReference firebaseStorageRef =
                FirebaseStorage.instance.ref().child('leave_${timestamp}.jpg');
    final StorageUploadTask task =
                firebaseStorageRef.putFile(sampleImage);
    
    StorageTaskSnapshot taskSnapshot = await task.onComplete;

    downloadUrl = await taskSnapshot.ref.getDownloadURL();
    }
    double hour = todayHourTimestamp / 3600000;
    var hourTransform;
    if(time != null) {
       hourTransform = time;
    } else {
       hourTransform = hour.toStringAsFixed(0);
       hourTransform = int.parse(hourTransform) + 1;
    }

    for(var i = 0; i < widget.childList.length; i++) {
      print(todayUtcTimestamp);
      print(todayHourTimestamp);
      await Firestore.instance.collection('events').document(dayCare.toString()).collection("${todayUtcTimestamp.toString()}/${widget.childList[i]['childId']}/eventData").document("${hourTransform}").setData({
        
        "time": int.parse(hourTransform.toString()),
        "minutes": int.parse(minutes.toString()),
        "hour": int.parse(hour.toStringAsFixed(0)),
        "minute": int.parse(minute.toString()),
        "comment": _comment,
        'picture': downloadUrl,
        'notify': notify,
        'share': share,
        'moreImages': imagesUrl,
        'createdBy': staffId,
        'type': "leave",

      }).then((value) {
        if(widget.childList.length == i+1) {
          setState(() {
            saveData = false;      
          });
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Home()));
        }
      }).catchError((e) {
        print(e);
      });  
    }       
  }

}



class CheckboxContainer extends StatelessWidget {
  final bool value;
  final Color color;
  final String text;
  final submit;

  CheckboxContainer({
    this.value,
    this.color,
    this.text,
    this.submit
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Checkbox(
            value: value,
            onChanged: (values) {
              submit(values);
            },
            activeColor: color,
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
          
          Text(
            text,
            style: TextStyle(
              color: black,
              fontSize: 14.0
            )
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      ),
    );
  }
}
