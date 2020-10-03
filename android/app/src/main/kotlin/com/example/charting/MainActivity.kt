package com.example.charting

import androidx.annotation.NonNull;
import com.github.hiteshsondhi88.libffmpeg.FFmpeg
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    internal  var ffmpeg:FFmpeg
    init{
        ffmpeg = FFmpeg.getInstance(getApplicationContext())
    }
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,"videoconvertor")
                .setMethodCallHandler({call,result->
                    if(call.method.equals("video")){
                        result.success("hello praveen");
                    }


                }

        )
    }
}
