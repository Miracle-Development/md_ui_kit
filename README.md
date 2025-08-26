# Miracle Development UI Kit

## Структура

* В папке _stories хранятся стори для виджетов и страниц, там же можно задавать необходимые изменяемые параметры (knobs) для них
* В подпапках screens хранятся готовые страницы для проекта, в widgets - только отдельные элементы
* Тема проекта расположена в папке _core и основана на пакете `flex_color_scheme`

[!] Сначала создается сам виджет или страница, затем - его стори, чтобы проверить различные параметры, и только после этого в сторибуке прикрепляется стори в соответствующий раздел

## Обновление

При добавлении элемента в сторибук убедитесь, что:
* Версия пакета поднята (x.0.x -> x.1.0)
* Указаны изменения в changelog.md
* Добавлены виджеты в файл md_ui_kit.dart для экспорта
* Структура корректна
* Виджет открывается и изменяется через knobs

## Мелкие правки

* При мелких правках поднимите минорную версию пакета (x.x.0 -> x.x.1) и укажите изменения в changelog.md

## XCode build

#### Step-by-step code (run one after one from `lib` folder):
* `fvm flutter clean                                       
rm -rf ios/Pods
rm -rf ios/.symlinks
rm -rf ios/Flutter/Flutter.framework
rm -rf ios/Flutter/Flutter.podspec
rm -rf ios/Flutter/App.framework
rm -rf ios/Flutter/Generated.xcconfig
rm -rf ios/Flutter/app.flx
rm -rf ios/Flutter/app.zip
rm -rf ios/Flutter/flutter_assets
rm -rf ios/Flutter/flutter_export_environment.sh`
* `rm -rf Podfile.lock Pods`
* `fvm flutter pub get`
* `cd ios`
* `pod install --repo-update`

#### Global code (run from `lib` folder):
`
fvm flutter clean                                       
rm -rf ios/Pods
rm -rf ios/.symlinks
rm -rf ios/Flutter/Flutter.framework
rm -rf ios/Flutter/Flutter.podspec
rm -rf ios/Flutter/App.framework
rm -rf ios/Flutter/Generated.xcconfig
rm -rf ios/Flutter/app.flx
rm -rf ios/Flutter/app.zip
rm -rf ios/Flutter/flutter_assets
rm -rf ios/Flutter/flutter_export_environment.sh
rm -rf Podfile.lock Pods
fvm flutter pub get
cd ios
pod install --repo-update
cd ../
`

#### To update package:
* `pod update <Firebase/Messaging>`

#### To update gems/pods:
* `gem install cocoapods`

## Добавление Golden Tests
Для того, чтобы отслеживать будущие изменения компонента, а также протестировать функциональные особенности (возможное переполнение текста, ошибки отрисовки), добавляем Golden Tests.
### [!] Golden Tests не умеют работать с интернетом, поэтому все тесты, где будет подгрузка внешних данных, будут падать. Необходимо это учесть
Для того, чтобы создать golden test необходимо:
* `packages/txchat_flutter_ui_kit/test/components` создать новую папку с названием компонента. 
* Создать файл `название_компонента_test.dart`.
* Для примера написания теста можно взять `packages/txchat_flutter_ui_kit/test/components/technical_message/technical_message_test.dart`
Самой важной здесь является функция `_testBuilder` . Она определяет варианты, которые будут перебираться в ходе тестирования. Сами варианты определяются в списке `variants`. Это вложенный список, в котором выбираются значения для подстановки в параметры. После они передаются в компонент, используя `GoldenTestGroup`. 

После того, как тест создан, необходимо сгенерировать .png файлы. Для этого перейдите в папку txchat_flutter_ui_kit командой `cd ./packages/txchat_flutter_ui_kit`, примените команду `flutter test --update-goldens --tags=golden --dart-define=golden=true`. Изображения появятся в папке `goldens`. 