import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:signalr_core/signalr_core.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;

class Camera_screen extends StatefulWidget {
  @override
  _Camera_screen_State createState() => _Camera_screen_State();
}

var myHub;
bool Myhub_connected = false;

// ignore: camel_case_types
class _Camera_screen_State extends State<Camera_screen> {
  RTCPeerConnection? _cameraConnection;
  final RTCVideoRenderer _remoteView = RTCVideoRenderer();
  final configController = TextEditingController();

  @override
  void initState() {
    initialize();
    StartCamera();
    StartSignalR();
    super.initState();
  }

  initialize() async {
    await _remoteView.initialize();
  }

  Future<void> StartCamera() async {
    _cameraConnection = await _createCameraConnecion();
  }

  _createCameraConnecion() async {
    //Open user media
    //_localStream = await _openUserMedia();
    Map<String, dynamic> configuration = {
      "iceServers": [
        {
          "username": "ufokatcher",
          "credential": "12345678",
          "urls": ["stun:128.199.245.217"]
        },
        {
          "username": "ufokatcher",
          "credential": "12345678",
          "urls": ["turn:128.199.245.217"]
        }
      ]
    };

    RTCPeerConnection _connection = await createPeerConnection(configuration);

    //observe ice candidate
    _connection.onIceCandidate = (e) {
      if (e.candidate != null) {
        myHub.invoke("SignalIce", args: <String>[
          json.encode({
            'candidate': e.candidate.toString(),
            'sdpMid': e.sdpMid.toString(),
            'sdpMlineIndex': e.sdpMlineIndex,
          })
        ]);
      }
    };
    //observe state candidat
    _connection.onIceConnectionState = (e) {
      print(e);
    };
    // set stream for remoteView
    _connection.onAddStream = (stream) {
      try {
        setState(() {
          _remoteView.srcObject = stream;
        });
      } catch (e) {
        print(e);
      }
    };

    return _connection;
  }

  void _setRemoteDesc(dynamic msg) async {
    Map session = json.decode(msg[0]);
    try {
      // ignore: avoid_print
      print("......................setRemoteDescription-----Start----------");
      RTCSessionDescription description =
          RTCSessionDescription(session["sdp"], session["type"]);
      await _cameraConnection!.setRemoteDescription(description);
      print("await _peerConnection!.setRemoteDescription OK-----------------");
    } catch (e) {
      print("error setRemoteDescription>>>>>>" + e.toString());
    }
  }

  Future<void> _setRemoteIce(message2) async {
    try {
      print("SignalMessageIce Rx------come in------");
      print(message2.toString());
      Map session = json.decode(message2[0]);
      print("addCandidate.................");

      await _cameraConnection!.addCandidate(RTCIceCandidate(
          session['candidate'], session['sdpMid'], session['sdpMLineIndex']));

      print("addCandidate.....OK........");
    } catch (e) {
      print("error SignalIce----->" + e.toString());
    }
  }

  void _createOffer() async {
    Map<String, dynamic> offerOptions;
    if (kIsWeb) {
      print('Browser detect...');
      offerOptions = {"offerToReceiveAudio": 1, "offerToReceiveVideo": 1};
    } else {
      print('Browser not detect...');
      offerOptions = {
        'mandatory': {
          'OfferToReceiveAudio': true,
          'OfferToReceiveVideo': true,
        },
        'optional': [],
      };
    }

    RTCSessionDescription description =
        await _cameraConnection!.createOffer(offerOptions);
    _cameraConnection!.setLocalDescription(description);
    //print('------------------_createOffering------------');
    myHub.invoke("SignalDesc", args: <String>[jsonEncode(description.toMap())]);
    print('------------------_createOffer---OK-----------');
  }

  Future<void> StartSignalR() async {
    myHub = new HubConnectionBuilder()
        //  .withUrl("https://localhost:44377/myHub")
        .withUrl("https://testturn1.azurewebsites.net/myHub")
        .build();

    try {
      await myHub.start();
      print("boothHub.start() OK.................");
      print(myHub.connectionId);
      Myhub_connected = true;
      _createOffer();
    } catch (e) {}

    myHub.on('SignalMessageDesc', (message) async {
      print("---------------SignalMessageDesc Rx-----------------");
      if (message != null) {
        _setRemoteDesc(message);
      }
    });

    myHub.on('SignalMessageIce', (message) async {
      print("SignalMessageIce Rx------detectttt------");
      if (message.toString().length > 10) {
        await _setRemoteIce(message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: RTCVideoView(_remoteView),
    ));
  }
}
