# 調整コンパスアプリ

建物内など磁気干渉により方位がずれる環境でも、ユーザーが手動で補正できるAndroidコンパスアプリです。

## 機能

- **リアルタイムコンパス表示**: デバイスの磁気センサーと加速度センサーを使用して方位を表示
- **オフセット調整**: ユーザーが手動で正しい北の位置を設定可能
- **ロック機能**: 調整したオフセットを保存して固定
- **リセット機能**: オフセットを0にリセット

## 技術スタック

- **言語**: Kotlin
- **最小SDK**: API Level 21 (Android 5.0)
- **ターゲットSDK**: API Level 34 (Android 14)
- **アーキテクチャ**: MVVM (Model-View-ViewModel)
- **UI**: Material Design 3

## プロジェクト構造

```
app/
├── src/main/
│   ├── java/com/adjustablecompass/app/
│   │   ├── data/
│   │   │   ├── CompassRepository.kt      # センサーからの方位データ取得
│   │   │   └── SettingsRepository.kt     # オフセットとロック状態の永続化
│   │   └── ui/
│   │       ├── CompassActivity.kt        # メインActivity
│   │       ├── CompassViewModel.kt      # ビジネスロジック
│   │       └── CompassView.kt            # カスタムコンパスView
│   ├── res/
│   │   ├── layout/
│   │   │   └── activity_compass.xml     # メインレイアウト
│   │   └── values/
│   │       ├── colors.xml               # カラー定義
│   │       ├── strings.xml              # 文字列リソース
│   │       └── themes.xml               # テーマ定義
│   └── AndroidManifest.xml
└── build.gradle.kts
```

## ビルド方法

1. Android Studioでプロジェクトを開く
2. Gradleの同期を実行
3. 実機またはエミュレーターで実行

## 使用方法

1. **コンパス表示**: アプリを起動すると、リアルタイムで方位が表示されます
2. **調整モード**: 「調整」ボタンをタップして調整モードに入ります
3. **オフセット設定**: デバイスを回転させて、コンパスが正しい北を指すようにします
4. **ロック**: 「ロック」ボタンをタップしてオフセットを保存します
5. **リセット**: 「リセット」ボタンでオフセットを0に戻します

## 要件

- Android 5.0 (API Level 21) 以上
- 磁気センサーと加速度センサーが利用可能なデバイス

## ライセンス

このプロジェクトは個人利用を目的としています。


