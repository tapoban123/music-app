# Client side of Music App

### Errors and Solutions:

- Always replace 127.0.0.1:8000 with 10.0.2.2:8000 as recommended by the Android Studio docs.
  [Android Studio Docs](https://developer.android.com/studio/run/emulator-networking#:~:text=The%20address%20127.0.,use%20the%20special%20address%2010.0.)
- **Error:**<br>
  _What went wrong: <br>
  Execution failed for task ':app:processDebugMainManifest'.<br>
  com.android.manifmerger.ManifestMerger2$MergeFailureException: Error parsing ..\music_app\client\android\app\src\main\AndroidManifest.xml_
  <br>
  **Solution:** <br> Hello</u>
  Add **_xmlns:tools="http://schemas.android.com/tools"_** to <u>_manifest_</u> tag at the beginning of the file after the <u>_xmlns:android_</u> line in [AndroidManifest.xml](android\app\src\main\AndroidManifest.xml) file.

### For generating riverpod providers visit [this website](https://codewithandrea.com/articles/flutter-riverpod-generator/).

### Here's the command:

_dart run build_runner watch -d_
