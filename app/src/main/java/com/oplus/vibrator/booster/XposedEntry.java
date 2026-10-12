package com.oplus.vibrator.booster;

import android.os.VibrationEffect;
import android.os.Vibrator;
import android.os.VibratorManager;
import android.util.Log;

import java.lang.reflect.Method;

import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

/**
 * 欧加振动增强 - LSPosed Hook 入口
 *
 * 拦截 Android 振动 API 并增强振动强度 2 倍
 * 适配：联发科天玑平台 + 艾为 AW86927 马达
 */
public class XposedEntry implements IXposedHookLoadPackage {

    private static final String TAG = "OPlusVibratorBoost";
    private static final float BOOST_MULTIPLIER = 2.0f;

    @Override
    public void handleLoadPackage(XC_LoadPackage.LoadPackageParam lpparam) throws Throwable {
        // 只 Hook 系统框架和系统 UI
        if (!lpparam.packageName.equals("android") &&
            !lpparam.packageName.equals("com.android.systemui")) {
            return;
        }

        Log.i(TAG, "Hooking package: " + lpparam.packageName);

        hookVibrator(lpparam.classLoader);
        hookVibrationEffect(lpparam.classLoader);
    }

    /**
     * Hook Vibrator.vibrate() 方法
     */
    private void hookVibrator(ClassLoader classLoader) {
        try {
            Class<?> vibratorClass = XposedHelpers.findClass("android.os.Vibrator", classLoader);

            // Hook vibrate(VibrationEffect)
            XposedBridge.hookAllMethods(vibratorClass, "vibrate", new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                    for (int i = 0; i < param.args.length; i++) {
                        if (param.args[i] instanceof VibrationEffect) {
                            VibrationEffect original = (VibrationEffect) param.args[i];
                            VibrationEffect boosted = boostVibrationEffect(original);
                            if (boosted != null) {
                                param.args[i] = boosted;
                                Log.d(TAG, "Boosted VibrationEffect by " + BOOST_MULTIPLIER + "x");
                            }
                        }
                    }
                }
            });

            Log.i(TAG, "Successfully hooked Vibrator.vibrate()");

        } catch (Throwable t) {
            Log.e(TAG, "Failed to hook Vibrator", t);
        }
    }

    /**
     * Hook VibrationEffect 创建方法
     */
    private void hookVibrationEffect(ClassLoader classLoader) {
        try {
            Class<?> effectClass = XposedHelpers.findClass("android.os.VibrationEffect", classLoader);

            // Hook createOneShot(long, int)
            XposedHelpers.findAndHookMethod(effectClass, "createOneShot",
                    long.class, int.class,
                    new XC_MethodHook() {
                        @Override
                        protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                            int amplitude = (int) param.args[1];
                            if (amplitude > 0 && amplitude < 255) {
                                int boosted = Math.min(255, (int) (amplitude * BOOST_MULTIPLIER));
                                param.args[1] = boosted;
                                Log.d(TAG, "createOneShot: " + amplitude + " -> " + boosted);
                            }
                        }
                    });

            // Hook createWaveform(long[], int[], int)
            XposedHelpers.findAndHookMethod(effectClass, "createWaveform",
                    long[].class, int[].class, int.class,
                    new XC_MethodHook() {
                        @Override
                        protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                            int[] amplitudes = (int[]) param.args[1];
                            if (amplitudes != null) {
                                for (int i = 0; i < amplitudes.length; i++) {
                                    if (amplitudes[i] > 0 && amplitudes[i] < 255) {
                                        amplitudes[i] = Math.min(255, (int) (amplitudes[i] * BOOST_MULTIPLIER));
                                    }
                                }
                                Log.d(TAG, "createWaveform: boosted " + amplitudes.length + " amplitudes");
                            }
                        }
                    });

            Log.i(TAG, "Successfully hooked VibrationEffect creation methods");

        } catch (Throwable t) {
            Log.e(TAG, "Failed to hook VibrationEffect", t);
        }
    }

    /**
     * 增强 VibrationEffect 对象的振动强度
     */
    private VibrationEffect boostVibrationEffect(VibrationEffect original) {
        try {
            // 尝试通过反射读取原始振幅并创建增强版本
            Method getAmplitudeMethod = original.getClass().getMethod("getAmplitude");
            int amplitude = (int) getAmplitudeMethod.invoke(original);

            if (amplitude > 0 && amplitude < 255) {
                int boosted = Math.min(255, (int) (amplitude * BOOST_MULTIPLIER));

                // 尝试获取持续时间并创建新的 VibrationEffect
                Method getDurationMethod = original.getClass().getMethod("getDuration");
                long duration = (long) getDurationMethod.invoke(original);

                return VibrationEffect.createOneShot(duration, boosted);
            }

        } catch (Exception e) {
            // 反射失败时静默降级，使用原始效果
            Log.w(TAG, "Failed to boost VibrationEffect via reflection, using original", e);
        }

        return null;
    }
}
