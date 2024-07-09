FROM eclipse-temurin:17-alpine

WORKDIR /

ENV ANDROID_HOME="/android-sdk"
ENV PATH="$PATH:/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${ANDROID_HOME}/cmdline-tools/latest/bin:/usr/lib/ninja-build/bin"

COPY ./assert_checksum /
RUN apk update
RUN apk add git curl unzip xz zip glu bash gcompat clang17 cmake ninja-build pkgconf gtk+3.0 gtk+3.0-dev

RUN curl --output commandlinetools-linux.zip "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"
RUN ./assert_checksum 2d2d50857e4eb553af5a6dc3ad507a17adf43d115264b1afc116f95c92e5e258 commandlinetools-linux.zip

RUN mkdir android-sdk
RUN mkdir ${ANDROID_HOME}/cmdline-tools
RUN unzip commandlinetools-linux.zip -d /
RUN rm /commandlinetools-linux.zip
RUN mv /cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest
RUN yes | sdkmanager "platforms;android-34" "build-tools;35.0.0-rc4" "cmdline-tools;latest" "platform-tools" "emulator"

RUN git clone https://github.com/flutter/flutter.git flutter --depth 1 -b stable
RUN flutter config --no-cli-animations
RUN flutter doctor
RUN yes | flutter doctor --android-licenses

