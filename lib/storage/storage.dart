import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

String TokenData = "";
Map Map_storage = {};
String data_ = "";

final LocalStorage tokenStorage = LocalStorage('Data');

class Storage_data {
  void Token_Saving(String token) {
    Map_storage['Token'] = token;
    print(Map_storage['Token']);
    tokenStorage.setItem('TokenData', Map_storage);
    print("Token_get...");
    print(Token_Getting());
  }

  Future<void> Token_initial() async {
    print('Storage_initial');
    await tokenStorage.ready;
  }

  String Token_Getting() {
    //Map Read_raw_map = storage.getItem('Storage_data');
    //data_ = Read_raw_map['Token'];

    Map RawTokenData = tokenStorage.getItem('TokenData');
    print(RawTokenData);

    // ignore: unnecessary_null_comparison
    if (RawTokenData == null) {
      TokenData = "0";
      print("RawTokenData=>null");
    } else {
      TokenData = RawTokenData['Token'];
      print(TokenData);
    }

    return TokenData;
  }

  void Token_Erase() {
    tokenStorage.clear();
    print('token_storage.clear()');
  }
}
