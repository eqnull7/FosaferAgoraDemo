package com.fosafer.voicenet1;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Log;
import android.view.SurfaceView;
import android.view.View;
import android.widget.TextView;

import com.fosafer.voicenet.FOSCheckResult;
import com.fosafer.voicenet.FOSSilentKeys;
import com.fosafer.voicenet.FosaferManager;
import com.google.gson.Gson;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Arrays;

import io.agora.rtc2.Constants;
import io.agora.rtc2.IMediaExtensionObserver;
import io.agora.rtc2.IRtcEngineEventHandler;
import io.agora.rtc2.RtcEngine;
import io.agora.rtc2.RtcEngineConfig;
import io.agora.rtc2.video.VideoCanvas;

public class SilentActivity extends AppCompatActivity {
    private String TAG = "SilentActivitylog";
    private RtcEngine mRtcEngine = null;
    Handler handler;
    SurfaceView surface;
    TextView tv_top;
    private String oldString = "";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_silent);
        handler = new Handler(Looper.getMainLooper());
        initPermission();
        initView();
    }

    private void initView() {
        tv_top = findViewById(R.id.a_face_collect_tv_tips);
    }

    private void initPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            requestPermissions(new String[]{Manifest.permission.CAMERA,
                            Manifest.permission.RECORD_AUDIO},
                    0);
        } else {
            initRtcEngine();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        Log.d(TAG, "onRequestPermissionsResult "+requestCode);
        if (requestCode == 0) {
            if (Arrays.equals(grantResults, new int[]{0, 0})) {
                initRtcEngine();
            }
        }
    }

    private void initRtcEngine() {
        RtcEngineConfig config = new RtcEngineConfig();
        config.mContext = getApplicationContext();
        config.mAppId = com.fosafer.voicenet1.Constants.mAppId;
        config.mEventHandler = new IRtcEngineEventHandler() {
            @Override
            public void onWarning(int warn) {
                Log.w(TAG, String.format("onWarning %d", warn));
            }

            @Override
            public void onError(int err) {
                Log.e(TAG, String.format("onError %d", err));
            }

            @Override
            public void onJoinChannelSuccess(String channel, int uid, int elapsed) {
                Log.i(TAG, String.format("onJoinChannelSuccess %s %d %d", channel, uid, elapsed));
            }
        };
        config.mExtensionObserver = new IMediaExtensionObserver() {
            @Override
            public void onEvent(String vendor, String extension, String key, String value) {
                // 添加插件事件的回调处理逻辑
                Log.d(TAG, "eventMsg "+vendor+".."+extension+".."+key+".."+value);
                if(TextUtils.equals(key, "text")){
                    updateTextView(value);
                }else if(TextUtils.equals(key, "result")){
                    Intent resultIntent = new Intent();
                    String checkResultTip;
                    FOSCheckResult checkResult;
                    int resultCode = -1, code;
                    try {
                        JSONObject jsonObject = new JSONObject(value);
                        String result = jsonObject.getString("result");
                        if(TextUtils.equals(result, "0")){
                            String imageResult = jsonObject.getString("imageResult");
                            Gson gson = new Gson();
                            FOSCheckResult fosCheckResult = gson.fromJson(imageResult, FOSCheckResult.class);
                            checkResultTip = "检测成功:检测通过";
                            checkResult = new FOSCheckResult(0, checkResultTip, fosCheckResult.getImages());
                            resultCode = RESULT_OK;
                            code = RESULT_OK;
                        }else{
                            int errorcode = jsonObject.getInt("errorcode");
                            String tips = jsonObject.getString("tips");
                            checkResult = new FOSCheckResult(errorcode, tips);
                            resultCode = jsonObject.getInt("resultcode");
                            code = RESULT_CANCELED;
                        }
                        resultIntent.putExtra(FOSSilentKeys.DET_RESULT, checkResult);
                        setResult(resultCode, resultIntent);
                        Intent intent = new Intent(SilentActivity.this, FOSResultAct.class);
                        intent.putExtra("resultCode", code);
                        startActivity(intent);
                        finish();
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }else {
                    try {
                        JSONObject jsonObject = new JSONObject(value);
                        int errorcode = jsonObject.getInt("errorcode");
                        String tips = jsonObject.getString("tips");
                        updateTextView(tips);
                        FOSCheckResult checkResult = new FOSCheckResult(errorcode, tips);
                        Intent resultIntent = new Intent();
                        resultIntent.putExtra(FOSSilentKeys.DET_RESULT, checkResult);
                        setResult(jsonObject.getInt("resultcode"), resultIntent);
                        finish();
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                }
            }

            @Override
            public void onStarted(String s, String s1) {

            }

            @Override
            public void onStopped(String s, String s1) {

            }

            @Override
            public void onError(String s, String s1, int i, String s2) {

            }
        };
        try {
            mRtcEngine = RtcEngine.create(config);
        } catch (Exception e) {
            Log.e(TAG, e.toString());
        }
        if (mRtcEngine == null) {
            return;
        }
        enableExtension(true);
        mRtcEngine.enableVideo();
        mRtcEngine.setChannelProfile(Constants.CHANNEL_PROFILE_LIVE_BROADCASTING);
        mRtcEngine.setClientRole(Constants.CLIENT_ROLE_BROADCASTER);
        mRtcEngine.startPreview();
        VideoCanvas canvas = new VideoCanvas(findViewById(R.id.surface));
        mRtcEngine.setupLocalVideo(canvas);
    }
    FosaferManager fosaferManager;
    private void enableExtension(boolean enabled) {
        Log.d(TAG, "enableExtension");
        fosaferManager = new FosaferManager();
        fosaferManager.init(this, mRtcEngine, com.fosafer.voicenet1.Constants.mAppkey, com.fosafer.voicenet1.Constants.mAppsecret, UUID.randomUUID().toString());
        mRtcEngine.enableExtension("fosafer", "alive", enabled);
    }

    private void setExtensionProperty(String key, String property) {
        mRtcEngine.setExtensionProperty("fosafer", "alive", key, property);
    }

    private void updateTextView(String text){
        if(!TextUtils.equals(text, oldString)){
            handler.post(new Runnable() {
                @Override
                public void run() {
                    tv_top.setText(text);
                }
            });
        }
        oldString = text;
    }

    @Override
    protected void onPause() {
        super.onPause();
    }

    @Override
    protected void onDestroy() {
        if(mRtcEngine != null){
            mRtcEngine.stopPreview();
            handler.post(RtcEngine::destroy);
        }
        mRtcEngine = null;
        super.onDestroy();
    }
}