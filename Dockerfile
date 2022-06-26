FROM ubuntu:impish-20220531

ENV ANDROID_BOOTSTRAP_COMMANDLINE_TOOLS=8512546

ENV ANDROID_SDK_ROOT="$HOME/Android"
ENV ANDROID_USER_HOME="$HOME/.android"

RUN mkdir -p "$ANDROID_USER_HOME"
RUN touch "$ANDROID_USER_HOME/repositories.cfg"

RUN apt update
RUN apt -y install wget unzip default-jre

# Install command line tools
RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_BOOTSTRAP_COMMANDLINE_TOOLS}_latest.zip
RUN unzip -q -o -d ./bootstrap-cmdline-tools android-sdk.zip
RUN rm android-sdk.zip
RUN chmod +x ./bootstrap-cmdline-tools/cmdline-tools/bin/sdkmanager
RUN echo y | ./bootstrap-cmdline-tools/cmdline-tools/bin/sdkmanager --sdk_root="$ANDROID_SDK_ROOT" "cmdline-tools;latest"
RUN rm -rf ./bootstrap-cmdline-tools

# Install gradle and the app dependencies
COPY . /bootstrap-gradle
WORKDIR /bootstrap-gradle
RUN ./gradlew app:assembleRelease
WORKDIR /
RUN rm -rf ./bootstrap-gradle
