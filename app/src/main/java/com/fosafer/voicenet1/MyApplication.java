package com.fosafer.voicenet1;

import android.app.Application;

import androidx.multidex.MultiDex;

import com.squareup.leakcanary.LeakCanary;

public class MyApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();
        // 主要是添加下面这句代码
//        MultiDex.install(this);
//        if (LeakCanary.isInAnalyzerProcess(this)) {//1
//// This process is dedicated to LeakCanary for heap analysis.
//// You should not init your app in this process.
//            return;
//        }
//        LeakCanary.install(this);
    }
}
