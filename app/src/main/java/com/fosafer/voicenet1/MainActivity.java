package com.fosafer.voicenet1;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.fosafer.voicenet.FOSCheckResult;
import com.fosafer.voicenet.FOSSilentKeys;

public class MainActivity extends AppCompatActivity implements View.OnClickListener{
    private String TAG = MainActivity.class.getSimpleName();
    /**
     * 跳转请求码
     */
    private static final int REQUEST_CODE = 1000;
    private static final String CANCELED_TIP = "用户取消检测";

    private TextView act_main_tv_result;
    private TextView act_main_tv_version;
    private ImageView act_main_iv_head;
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.act_main);
        act_main_tv_result = findViewById(R.id.act_main_tv_result);
        act_main_tv_version = findViewById(R.id.act_main_tv_version);
        act_main_iv_head = findViewById(R.id.act_main_iv_head);
        Button act_main_btn_enter = findViewById(R.id.act_main_btn_enter);

        act_main_tv_version.setText(String.format(getString(R.string.fmt_app_version), getVersionName(this)));
        act_main_btn_enter.setOnClickListener(this);
    }

    /**
     * 获取版本号
     *
     * @return 当前应用的版本号
     */
    public static String getVersionName(Context context) {
        try {
            if (null == context) {
                return "";
            }
            PackageManager manager = context.getPackageManager();
            PackageInfo info = manager.getPackageInfo(context.getPackageName(), 0);
            return info.versionName;
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.act_main_btn_enter:
                break;
        }
        reset();
        Intent intent = new Intent();
        intent.setClass(MainActivity.this, SilentActivity.class);
        startActivityForResult(intent, REQUEST_CODE);
    }

    /**
     * 重置头像及检测结果.
     */
    private void reset() {
        act_main_iv_head.setImageResource(R.drawable.ic_person);
        act_main_tv_result.setText("");
    }

    Bitmap bitmap;
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            FOSCheckResult checkResult = (FOSCheckResult) data.getSerializableExtra(FOSSilentKeys.DET_RESULT);
            int code = checkResult.getCode();
            if (code == 0) {
                //动作检测结果图像
                byte[] image = checkResult.getImages().get(0);
                Log.d(TAG, "onActivityResult image"+image.toString());
                if(bitmap != null){
                    try {
                        bitmap.recycle();
                    }catch (Exception e){
                        e.printStackTrace();
                    }
                }
                bitmap= BitmapFactory.decodeByteArray(image, 0, image.length);
                Log.d(TAG, "onActivityResult bitmap "+bitmap);
                act_main_iv_head.setImageBitmap(bitmap);
            }
            act_main_tv_result.setText(checkResult.getMsg());
        } else if (resultCode == RESULT_CANCELED) {
            act_main_tv_result.setText(CANCELED_TIP);
        }
    }
}
