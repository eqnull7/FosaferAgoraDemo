package com.fosafer.voicenet1;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.Nullable;

//import android.support.annotation.Nullable;

public class FOSResultAct extends Activity {
    int resultCode;
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.act_result_layout);
        Intent intent = getIntent();
        resultCode = intent.getIntExtra("resultCode", 0);
        initView();
    }

    private void initView() {
        View l_top_tv_left = findViewById(R.id.l_top_tv_left);
        l_top_tv_left.setVisibility(View.VISIBLE);
        TextView l_top_tv_title = findViewById(R.id.l_top_tv_title);
        l_top_tv_title.setText("账户实名信息");
        ImageView image_result = findViewById(R.id.image_result);
        if(resultCode == RESULT_OK){
            image_result.setImageResource(R.mipmap.fos_check_success);
        }else{
            image_result.setImageResource(R.mipmap.fos_check_fail);
        }
        Button a_entry_btn_enter = findViewById(R.id.a_entry_btn_enter);
        a_entry_btn_enter.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        l_top_tv_left.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
    }
}
