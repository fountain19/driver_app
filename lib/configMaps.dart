import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:driver_app/models/allUser.dart';
import 'package:geolocator/geolocator.dart';

String mapKey='AIzaSyBS90FJuaE8n8oklnjTt9MOvZMELlDs_eQ';
User fireBaseUser;
Users userCurrentInfo;
User currentFireBaseUser;
StreamSubscription<Position> homeTabPageStreamSubscription;
final AssetsAudioPlayer assetsAudioPlayer=AssetsAudioPlayer();