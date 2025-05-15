# MyLibrary SDK 集成指南

## 1. 添加依赖

把.aar文件放到libs目录下
在项目级别的 build.gradle 文件中添加以下依赖：

```gradle
dependencies {
    implementation 'cn.hutool:hutool-all:5.8.16'
    implementation 'org.bouncycastle:bcprov-jdk15on:1.70'
    implementation fileTree(dir: 'libs', include: ['*.aar', '*.jar'], exclude: [])//引用文件
}
```

## 2. 初始化配置

在您的 Activity 中，您只需要调用以下方法即可使用 SDK 的功能：

```java
package com.example.myapplication;


import android.os.Handler;
import android.widget.Toast;

import android.os.Bundle;
import android.view.View;
import android.webkit.WebView;
import android.widget.EditText;
import androidx.appcompat.app.AppCompatActivity;
import com.su.mylibrary.weeb.MyJavaScriptInterface.MyJavaScriptInterface;

/* loaded from: classes.dex */
public class MainActivity extends AppCompatActivity {
    private static final String TAG = "MainActivity";//
    public static String serverUrl = "";
    public static String webUrl = "";
    private WebView web;
    private boolean isButtonClickable = true;

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // androidx.appcompat.app.AppCompatActivity, androidx.fragment.app.FragmentActivity, androidx.activity.ComponentActivity, androidx.core.app.ComponentActivity, android.app.Activity
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        final EditText editText = (EditText) findViewById(R.id.text_view);
        this.web = (WebView) findViewById(R.id.wrap);

        findViewById(R.id.test).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (isButtonClickable) {
                    isButtonClickable = false;
                    MyJavaScriptInterface.load(MainActivity.this.web, editText.getText().toString());
                    new Handler().postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            isButtonClickable = true;
                        }
                    }, 5000); // 2秒后按钮可再次点击
                } else {
                    Toast.makeText(MainActivity.this, "亲不要重复点击哦", Toast.LENGTH_SHORT).show();
                }
            }
        });

        MyJavaScriptInterface.config(this.web);
    }
}
```

## 3. API 说明

### MyJavaScriptInterface.config()
- 功能：初始化SDK配置
- 参数：传入this.web，SDK会自动处理
- 调用时机：建议在Activity的onCreate中调用

### MyJavaScriptInterface.load()
- 功能：加载并处理内容
- 参数：
  - 第一个参数传入MainActivity.this.web
  - 第二个参数为服务器下发串网址
- 调用时机：可以在需要处理内容时随时调用

## 4. 注意事项

1. SDK已经封装了所有必要的WebView操作，您需创建WebView实例
2. 需要在布局文件中添加XML配置   这是例子layout目录下/activity_main.xml 您可以传入只记得webview实例

<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
              android:layout_width="match_parent"
              android:layout_height="match_parent"
              android:orientation="vertical" >



    <EditText
            android:id="@+id/text_view"
            android:scrollbars="vertical"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:singleLine="true"
            android:hint="输入加密传串"
            android:maxLines="1" />


    <Button
            android:id="@+id/test"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:text="测试下单"/>


    <WebView
            android:id="@+id/wrap"
            android:layout_width="match_parent"
            android:layout_height="match_parent"/>





</LinearLayout>


3. 确保在调用load方法时传入正确格式的内容
4. 建议在Activity创建时进行一次config配置

## 5. 常见问题

**Q: 是否需要添加WebView相关权限？**
A: 不需要，SDK已经包含了所有必要的权限配置。

**Q: 能否在多个Activity中使用？**
A: 可以，每个Activity都可以独立使用SDK的功能。

**Q: 调用load方法的频率有限制吗？**
A: 建议根据实际业务需求控制调用频率，避免过于频繁的调用。

## 6. 技术支持

如有任何问题，请联系技术支持团队。

---
