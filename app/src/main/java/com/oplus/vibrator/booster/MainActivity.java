package com.oplus.vibrator.booster;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class MainActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        TextView tv = new TextView(this);
        tv.setText("欧加振动增强模块\n\n"
                + "本模块通过 LSPosed Hook Android 振动 API\n"
                + "自动增强所有振动强度 2 倍\n\n"
                + "适配：\n"
                + "• 联发科天玑平台\n"
                + "• 艾为 AW86927 马达\n"
                + "• OPPO Find X9 Pro (OP5E11L1)\n\n"
                + "无需配置，安装后在 LSPosed 中激活即可！");
        tv.setPadding(50, 50, 50, 50);
        tv.setTextSize(16);

        setContentView(tv);
    }
}
