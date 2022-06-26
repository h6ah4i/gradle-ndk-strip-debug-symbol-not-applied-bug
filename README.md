## About this repo.

This is a minimal bug reproduction code for the bug of AGP that fails to strip debug symbols of native libraries.

## 🐛 About the BUG 🐛

Debug symbols are not stripped when `ndkVersion` is not specified in the app gradle module.

Following warning messages are displayed during the build process.

```
Unable to strip the following libraries, packaging them as they are: libExampleNativeLib.so.
```

```
Unable to extract native debug metadata from /root/myapp/app/build/intermediates/merged_native_libs/release/out/lib/******/libExampleNativeLib.so because unable to locate the objcopy executable for the ****** ABI.
```

### 🩹 Workaround 🩹

Specify `ndkVersion` in the **app module** (even if the app module does not use NDK directly).

## Reproduction

### Prerequisites

- Docker Compose

### Procedure to reproduce the issue

1. Clone this repository
2. Build a Docker image with docker-compose.
  ```bash
  cd [THIS REPOSITORY]
  docker-compose build
  ```
3. Check warning messages displayed when `ndkVesion` is NOT specified in the app module.

  ```bash
  $ docker-compose run build_env bash -c "./gradlew clean && ./gradlew assembleRelease"

  Creating gradle-ndk-strip-debug-symbol-not-applied-bug_build_env_run ... done
  Starting a Gradle Daemon, 1 incompatible and 1 stopped Daemons could not be reused, use --status for details

  > Task :nativelib:externalNativeBuildCleanRelease
  Clean ExampleNativeLib-armeabi-v7a
  Clean ExampleNativeLib-arm64-v8a
  Clean ExampleNativeLib-x86
  Clean ExampleNativeLib-x86_64

  BUILD SUCCESSFUL in 9s
  4 actionable tasks: 4 executed

  > Task :app:stripReleaseDebugSymbols
  Unable to strip the following libraries, packaging them as they are: libExampleNativeLib.so.

  > Task :app:extractReleaseNativeSymbolTables
  Unable to extract native debug metadata from /root/myapp/app/build/intermediates/merged_native_libs/release/out/lib/armeabi-v7a/libExampleNativeLib.so because unable to locate the objcopy executable for the armeabi-v7a ABI.
  Unable to extract native debug metadata from /root/myapp/app/build/intermediates/merged_native_libs/release/out/lib/x86_64/libExampleNativeLib.so because unable to locate the objcopy executable for the x86_64 ABI.
  Unable to extract native debug metadata from /root/myapp/app/build/intermediates/merged_native_libs/release/out/lib/x86/libExampleNativeLib.so because unable to locate the objcopy executable for the x86 ABI.
  Unable to extract native debug metadata from /root/myapp/app/build/intermediates/merged_native_libs/release/out/lib/arm64-v8a/libExampleNativeLib.so because unable to locate the objcopy executable for the arm64-v8a ABI.

  BUILD SUCCESSFUL in 11s
  89 actionable tasks: 81 executed, 8 up-to-date
  ```

4. Check the issue is gone when `ndkVesion` is specified in the app module. (testing the workaround)

  ```bash
  $ docker-compose run build_env bash -c "./gradlew clean && SET_NDK_VERSION_IN_APP_MODULE=1 ./gradlew assembleRelease"

  Creating gradle-ndk-strip-debug-symbol-not-applied-bug_build_env_run ... done
  Starting a Gradle Daemon, 1 incompatible and 1 stopped Daemons could not be reused, use --status for details

  > Task :nativelib:externalNativeBuildCleanRelease
  Clean ExampleNativeLib-armeabi-v7a
  Clean ExampleNativeLib-arm64-v8a
  Clean ExampleNativeLib-x86
  Clean ExampleNativeLib-x86_64

  BUILD SUCCESSFUL in 9s
  4 actionable tasks: 4 executed

  BUILD SUCCESSFUL in 11s
  90 actionable tasks: 82 executed, 8 up-to-date

  ```
