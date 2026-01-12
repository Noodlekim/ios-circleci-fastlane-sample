# TCA Unit Test Automation with CircleCI & fastlane
CircleCI+fastlaneでUnit test

## 1. Summary
本プロジェクトは、The Composable Architecture (TCA) を採用した iOS アプリにおいて、CircleCI と fastlaneで Unit Test を自動化したリポジトリです。

## 2. About
- **Framework:** [The Composable Architecture (TCA)](https://github.com/pointfreeco/swift-composable-architecture)
- **CI/CD:** [CircleCI](https://circleci.com/ja/)
- **Automation:** [fastlane](https://fastlane.tools/)
- **Point:** 
  - PR作成時Unit testが自動に行います
    - ブランチを選別してfastlaneのworkを走らせます。
  - fastlaneでTestFlightとAppStore配布もできます。
    - 要Apple Developerアカウント情報、認証書ファイル、Provisioningファイル


## 3. Setup
プロジェクトを CI に対応させるための手順は以下の通りです。

### 1) `xcode-select --install`
```bash
xcode-select --install
```
### 2) リポジトリのRoot経路でcircleCI設定ディレクトリとファイル生成
```bash
# circleCIインストール
brew install circleci 
# .circleciディレクトリ生成
mkdir .circleci
# config.yml生成
touch .circleci/config.yml
```

### 3) `config.yml`ファイルを設定
```bash
version: 2.1

commands:
  setup_env:
    steps:
      - checkout
      - restore_cache:
          keys:
            - v1-gems-{{ checksum "Gemfile.lock" }}
      - run:
          name: Bundle Install
          command: bundle install
      - save_cache:
          key: v1-gems-{{ checksum "Gemfile.lock" }}
          paths:
            - vendor/bundle

# Jobs
jobs:
  run_unit_tests:
    macos:
      xcode: "26.2" 
    environment:
      # SPMパッケージ依存関係チェック
      - RESOLVE_PACKAGE_WITH_FIXED_REVISIONS: "1"
      # TCA マクロ検証スキップ設計
      - SWIFT_DETERMINISTIC_MACRO_FINGERPRINTS: "1"
    steps:
      - setup_env
      - run:
          name: Run Unit Tests via Fastlane
          command: bundle exec fastlane test
      - store_test_results:
          path: test_output/report.xml

# Workflows
workflows:
  version: 2
  unit_test_flow:
    jobs:
      - run_unit_tests:
          filters:
            branches:
              only: 
                - main
                - develop
                - /feature\/.*/
```

### 4) fastlane の初期化と設定
プロジェクトルートで以下のコマンドを実行します。
```bash
# fastlane のインストール
brew install fastlane

# fastlane の初期化 (Manual 設定を選択)
fastlane init

# Gemfile の作成と依存関係の追加
bundle init
echo 'gem "fastlane"' >> Gemfile
bundle install
```

### 5) `FastFile`を設定
```bash
default_platform(:ios)

platform :ios do
  # 
  lane :test do 
    sh("cd .. && xcodebuild -resolvePackageDependencies -scheme TCA_Sample")    

    scan(
      scheme: "./{スキーマ名}",   # Rootからスキーマの経路を指定
      device: "iPhone 17",
      xcargs: "-skipMacroValidation"   # TCA マクロエラー防止
    )
  end
end
```

