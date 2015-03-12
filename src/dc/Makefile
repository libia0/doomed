debugging:=false
platformsdk:=/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator5.0.sdk
mobileprovision:=../../cert/JNY.mobileprovision
FANTI:=j
APK:=false
IPA:=false
chat:=false
IS_IOS:=false
NO_VOICE:=false
IS_26:=true
ifeq ($(OS),Windows_NT)
FILENAME:=test
NAME:=test
HOME:=d:
FLEX_HOME:= $(HOME)/flex_sdk_4.5
O_O:=
else
NAME:=name
FILENAME:=filename
endif
NDK_HOME:=$(HOME)/android-ndk-r7
ifeq ($(debugging),true)
SWF_DIR:=../../bin/
SWF_DIR:=./
PUBLISH:=false
NORMAL_SCREEN:=true
else
SWF_DIR:=./
PUBLISH:=true
NORMAL_SCREEN:=false
endif
#NORMAL_SCREEN:=false
SERVER:=clients
CLIENT:=smain
ANDROID_EXE:=myserver
extensionID:=libiao
VERSIONNUMBER:=1.0
APP_DIR:=../../app/
CLIENT_AIR:=$(APP_DIR)$(CLIENT)$(VERSIONNUMBER)$(FANTI).air
CLIENT_IPA:=$(APP_DIR)$(CLIENT)1.0$(FANTI).ipa
SERVER_APP_XML:=$(SWF_DIR)$(SERVER)$(FANTI)-app.xml
CLIENT_APP_XML:=$(SWF_DIR)$(CLIENT)$(FANTI)-app.xml

ifeq ($(IPA),true)
ifeq ($(FANTI),f)
ASSET :=Default.png Default-Portrait.png Default-568h@2x.png Default@2x.png #asset 
else
ASSET :=Default.png Default-Portrait.png Default-568h@2x.png Default@2x.png #asset
endif
else
ASSET :=-C $(SWF_DIR)
endif


ifeq ($(IPA),true)
ASSET :=../../icons/ios/icons $(ASSET)
else
ifeq ($(APK),true)
ASSET :=../../icons/android/icons $(ASSET)
endif
endif


#ASSET :=icon db
SERVER_AIR:=$(SERVER).air
ANE_DIR:=.
WIN_ANE:=$(ANE_DIR)/windows.ane
ANDROID_ANE :=$(ANE_DIR)/android.ane
flashplayerversion:=10.2
AS_SERVER:= $(SERVER).as
SERVER_PATH:=.#.as文件所在目录
CLIENT_PATH:=.#.as文件所在目录
#SERVER_AS :=$(foreach x,${SERVER_PATH}, $(wildcard $(addprefix  ${x}/*,.as))) 
SERVER_AS:= $(foreach x,${SERVER_PATH}, $(wildcard $(addprefix ${x}/*,.as))) $(foreach x,.., $(wildcard $(addprefix ${x}/*,.as)))
#CLIENT_AS :=$(foreach x,${CLIENT_PATH}, $(wildcard $(addprefix  ${x}/*,.as))) 
CLIENT_AS := $(foreach x,${SERVER_PATH}, $(wildcard $(addprefix ${x}/*,.as))) $(foreach x,.., $(wildcard $(addprefix ${x}/*,.as)))
C_FILES:=purec.c
AS_CLIENT := $(CLIENT).as
AS_PATH :=..
ANE_SWC_CLASS:=NativeApi
ANE_SWC_CLASS_PATH :=.
EXTENSION_DIR:=extension
ANE_SO_NAME :=libmy.so
ANE_DLL_NAME :=my.dll
ANE_DLL :=$(EXTENSION_DIR)/$(ANE_DLL_NAME)
ANE_SO:=$(EXTENSION_DIR)/$(ANE_SO_NAME)

ifeq ($(IS_26),true)
FLEX_HOME:= $(HOME)/flex_sdk_4.5
SERVER_APP_XML:=$(SWF_DIR)$(SERVER)-26app.xml
CLIENT_APP_XML:=$(SWF_DIR)$(CLIENT)-26app.xml
endif
FLEX_HOME:= $(HOME)/sdk/15

ADL:= $(FLEX_HOME)/bin/adl
#LANG:=-Duser.language=en -Duser.country=US
FLEX:=java $(LANG) -Dsun.io.useCanonCaches=false -Xms32m -Xmx512m -Dflexlib="$(FLEX_HOME)/frameworks" -jar
ADT:=java $(LANG) -Dflexlib="$(FLEX_HOME)/frameworks" -jar "$(FLEX_HOME)/lib/adt.jar"
ADT:=$(FLEX_HOME)/bin/adt 
ifeq ($(IS_26),true)
AMXMLC:=$(FLEX) "$(FLEX_HOME)/lib/mxmlc.jar" +configname=air
ACOMPC:=$(FLEX) "$(FLEX_HOME)/lib/compc.jar" +configname=air
else
AMXMLC:=$(FLEX) "$(FLEX_HOME)/lib/mxmlc-cli.jar" +configname=air
ACOMPC:=$(FLEX) "$(FLEX_HOME)/lib/compc-cli.jar" +configname=air
#AMXMLC:= $(FLEX_HOME)/bin/amxmlc
#ACOMPC:= $(FLEX_HOME)/bin/acompc
endif
AMXMLC:= $(FLEX_HOME)/bin/amxmlc
MXMLC:= $(FLEX_HOME)/bin/amxmlc
#FDB:= $(FLEX_HOME)/bin/fdb
FDB:= java -Dsun.io.useCanonCaches=false -Xms32m -Xmx512m -Dapplication.home="$(FALCON_HOME)" -jar "$(FLEX_HOME)/lib/legacy/fdb.jar"
ANDROID_ANE_XML:=android.xml
WIN_ANE_XML:= windowsane.xml
CC:= $(NDK_HOME)/toolchains/arm-linux-androideabi-4.4.3/prebuilt/windows/bin/arm-linux-androideabi-gcc
#INCLUDE := -I$(NDK_HOME)/platforms/android-8/arch-arm/usr/include
#mv $(NDK_HOME)/platforms/android-8/arch-arm/usr/include $(NDK_HOME)/toolchains/arm-linux-androideabi-4.4.3/prebuilt/windows/lib/gcc/arm-linux-androideabi/4.4.3/include
#LIB     := -L$(NDK_HOME)/platforms/android-8/arch-arm/usr/lib
#mv $(NDK_HOME)/platforms/android-8/arch-arm/usr/lib/* toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/lib/gcc/arm-linux-androideabi/4.4.3/* 
SWC:=greensock.swc #,sound/shine.swc
ANE_SWC:=ane.swc
SERVER_SWF:=$(SWF_DIR)$(SERVER).swf
CLIENT_SWF:=$(SWF_DIR)$(CLIENT).swf
CERT:=../../cert/iphone_dev.p12
CERT:=my.p12
PASSWORD:=db0@qq.com
RM:=rm -f
LINKOBJ:=ane.c
ifeq ($(FANTI),f)
FLAGS:= -define=CONFIG::IS_IOS,$(IS_IOS) -define=CONFIG::debugging,$(debugging) -define=CONFIG::PUBLISH,$(PUBLISH) -define=CONFIG::chat,$(chat) -define=CONFIG::NO_VOICE,$(NO_VOICE) -define=CONFIG::FANTI,true -define=CONFIG::NORMAL_SCREEN,$(NORMAL_SCREEN)
else
FLAGS:= -define=CONFIG::IS_IOS,$(IS_IOS) -define=CONFIG::debugging,$(debugging) -define=CONFIG::PUBLISH,$(PUBLISH) -define=CONFIG::chat,$(chat) -define=CONFIG::NO_VOICE,$(NO_VOICE) -define=CONFIG::FANTI,true -define=CONFIG::NORMAL_SCREEN,$(NORMAL_SCREEN)
endif
#LINKOBJ := $(patsubst %.c,%.o,$(wildcard *.c)) 

all:$(CLIENT_AIR) $(CLIENT_SWF) $(CLIENT_APP_XML)
# $(CLIENT_AIR)
#$(ANDROID_EXE)$(SERVER_AIR)
#	$(ADL) $(SERVER_APP_XML)
#	cp $(FDB).exe $(FLEX_HOME)/lib/fdb.exe
#	run $(FLEX_HOME)/lib/fdb.exe
#	run $(FLEX_HOME)/runtimes/player/$(flashplayerversion)/win/FlashPlayerDebugger.exe $(SERVER_SWF)
#	http://localhost/test.html
#	$(RM) $(ANDROID_EXE)
#	adb shell am start -a android.intent.action.VIEW -d  http://192.168.1.24:8809/smain.swf
	$(ADL) $(CLIENT_APP_XML)
	@echo "all ok"

$(SERVER_AIR): $(SERVER_SWF) $(SERVER_APP_XML)# $(CERT)
#	$(ADT) -package -storetype pkcs12 -keystore $(CERT) -storepass $(PASSWORD) $(SERVER_AIR) $(SERVER_APP_XML) $(SERVER).swf
#	$(ADT) -package -storetype pkcs12 -keystore $(CERT) -storepass $(PASSWORD) -target bundle $(SERVER_AIR) $(SERVER_APP_XML) -extdir $(ANE_DIR) $(SERVER).swf
#	$(ADT) -package -storetype pkcs12 -keystore $(CERT) -storepass $(PASSWORD) -target native $(EXE) $(SERVER_APP_XML) $(SERVER).swf
#	$(ADT) -package -storetype pkcs12 -keystore $(CERT) -tsa none -storepass $(PASSWORD) -target native $(EXE) $(SERVER_APP_XML) -extdir $(ANE_DIR) $(SERVER).swf
#$(ADL) ios.xml -screensize iPhone
#$(ADT) -package -target ipa-debug -keystore $(CERT) -storetype pkcs12 -storepass $(PASSWORD) -provisioning-profile $(mobileprovision) $(SERVER).ipa $(SERVER_APP_XML) $(SERVER).swf
	@echo $(SERVER_AIR) "is ok"

$(CLIENT_AIR): $(CLIENT_SWF) $(CERT) $(CLIENT_APP_XML)
# $(ANDROID_ANE)
ifeq ($(OS),Windows_NT)
ifeq ($(debugging),false)
ifeq ($(APK),true)
#	$(ADT) -package -target apk-captive-runtime -storetype pkcs12 -keystore $(CERT) -storepass $(PASSWORD) $(CLIENT_AIR) $(CLIENT_APP_XML) $(CLIENT).swf $(ASSET)
	$(ADT) -package -target apk -storetype pkcs12 -keystore $(CERT) -storepass $(PASSWORD) $(CLIENT_AIR) $(CLIENT_APP_XML) $(CLIENT).swf $(ASSET)
endif# ($(APK),true)
ifeq ($(IPA),true)
	$(ADT) -package -target ipa-debug-interpreter -keystore iphone_dev.p12 -storetype pkcs12 -storepass 158386185 -provisioning-profile $(mobileprovision) $(CLIENT_IPA) ios-app.xml $(CLIENT).swf $(ASSET)
#	$(ADT) -package -target ipa-app-store -useLegacyAOT yes -keystore iphone_dev.p12 -storetype pkcs12 -storepass 158386185 -provisioning-profile $(mobileprovision) $(CLIENT_IPA) ios-app.xml $(CLIENT).swf $(ASSET)
#	$(ADT) -package -target ipa-test-interpreter-simulator -storetype pkcs12 -keystore Certificates.p12 -storepass 158386185 $(CLIENT_IPA) ios-app.xml $(CLIENT).swf -platformsdk $(platformsdk)
#	$(ADT) -installApp -platform ios -platformsdk $(platformsdk) -device ios-simulator -package $(CLIENT).swf
#	$(ADT) -launchApp -platform ios -platformsdk $(platformsdk) -device ios-simulator -appid com.test.smain
endif # ($(IPA),true)
else# ($(debugging),false)
ifeq ($(APK),true)
	$(ADT) -package -target apk-debug -storetype pkcs12 -keystore $(CERT) -storepass $(PASSWORD) $(CLIENT_AIR) $(CLIENT_APP_XML) $(CLIENT).swf $(ASSET)
	adb install -r $(CLIENT_AIR)
	adb shell am start -a android.intent.action.MAIN -n air.$(CLIENT)/.AppEntry
	adb logcat air.smain:I ActivityManager:I *:S
endif# ($(APK),true)
ifeq ($(IPA),true)
#	$(ADT) -package -target ipa-debug -keystore iphone_dev.p12 -storetype pkcs12 -storepass 158386185 -provisioning-profile $(mobileprovision) $(CLIENT_IPA) ios-app.xml $(CLIENT).swf $(ASSET)
#	$(ADT) -package -target ipa-debug -connect -keystore iphone_dev.p12 -storetype pkcs12 -storepass 158386185 -provisioning-profile $(mobileprovision) $(CLIENT_IPA) ios-app.xml $(CLIENT).swf $(ASSET)
#	$(ADT) -package -target ipa-debug -useLegacyAOT no -keystore iphone_dev.p12 -storetype pkcs12 -storepass 158386185 -provisioning-profile $(mobileprovision) $(CLIENT_IPA) ios-app.xml $(CLIENT).swf $(ASSET)
endif # ($(IPA),true)
#
#	$(ADT) -package -target apk -storetype pkcs12 -keystore $(CERT) -storepass $(PASSWORD) $(CLIENT_AIR) $(CLIENT_APP_XML) $(CLIENT).swf $(ASSET)
#   	-extdir $(ANE_DIR)
#	$(ADT) -package -target ipa-ad-hoc -keystore iphone_dev.p12 -storetype pkcs12 -storepass 123 -provisioning-profile $(mobileprovision) $(CLIENT).ipa ios-app.xml $(CLIENT).swf $(ASSET)
#	$(ADT) -package -target ipa-test-interpreter -keystore iphone_dev.p12 -storetype pkcs12 -storepass 123 -provisioning-profile $(mobileprovision) $(CLIENT).ipa ios-app.xml $(CLIENT).swf $(ASSET)
#	$(ADT) -package -target apk -storetype pkcs12 -keystore $(CERT) -storepass $(PASSWORD) $(CLIENT_AIR) $(CLIENT_APP_XML) $(CLIENT).swf $(ASSET)

#	adb install -r $(CLIENT_AIR)
#	adb shell am start -a android.intent.action.MAIN -n air.$(CLIENT)/.AppEntry

#	$(ADT) -package -target ipa-app-store -keystore $(CERT) -storetype pkcs12 -storepass $(PASSWORD) -provisioning-profile $(mobileprovision) $(CLIENT).ipa $(CLIENT_APP_XML) $(CLIENT).swf $(ASSET) -extdir $(ANE_DIR)
# -extdir $(ANE_DIR)
#	adb uninstall air.$(CLIENT)
#	$(ADL) -profile mobileDevice $(CLIENT_APP_XML) -extdir $(ANE_DIR)
#	$(ADT) -package -target ipa-test-interpreter -keystore ios.p12 -storetype pkcs12 -storepass 1234   -provisioning-profile $(mobileprovision) $(CLIENT)-$(VERSIONNUMBER).ipa $(CLIENT_APP_XML) $(CLIENT).swf $(ASSET)

#	$(ADT) -package -target ipa-test-interpreter -useLegacyAOT no -keystore ios.p12 -storetype pkcs12 -storepass 1234 -provisioning-profile $(mobileprovision) $(CLIENT)$(VERSIONNUMBER).ipa $(CLIENT_APP_XML) $(CLIENT).swf $(ASSET)
#	$(ADL) $(CLIENT_APP_XML)
#	$(ADL) -profile mobileDevice $(CLIENT_APP_XML)
#	$(ADT) -package -target apk -storetype pkcs12 -keystore $(CERT) -storepass $(PASSWORD) $(CLIENT_AIR) $(CLIENT_APP_XML) $(CLIENT).swf $(ASSET)
endif# ($(debugging),false)
#	$(ADT) -package -target apk-captive-runtime -storetype pkcs12 -keystore $(CERT) -storepass $(PASSWORD) $(CLIENT_AIR) $(CLIENT_APP_XML) $(CLIENT).swf -extdir $(ANE_DIR)
#	$(ADT) -package -target apk -storetype pkcs12 -keystore $(CERT) -storepass $(PASSWORD) $(CLIENT_AIR) $(CLIENT_APP_XML) $(CLIENT).swf
#	adb shell am start -n air.$(CLIENT)/.AppEntry
else #($(OS),Windows_NT)
ifeq ($(APK),true)
	$(ADT) -package -target apk -storetype pkcs12 -keystore $(CERT) -storepass $(PASSWORD) $(CLIENT_AIR) $(CLIENT_APP_XML) $(CLIENT).swf $(ASSET)
endif
#	$(ADL) $(CLIENT_APP_XML)
#	$(ADT) -package -target apk -storetype pkcs12 -keystore $(CERT) -storepass $(PASSWORD) $(CLIENT_AIR) $(CLIENT_APP_XML) $(CLIENT).swf $(ASSET)
endif #($(OS),Windows_NT)
#	$(ADT) -package -storetype pkcs12 -keystore $(CERT) -storepass $(PASSWORD) $(CLIENT_AIR) $(CLIENT_APP_XML) $(CLIENT).swf
# $(ASSET)
#	$(ADT) -package -target apk-captive-runtime -storetype pkcs12 -keystore $(CERT) -storepass $(PASSWORD) $(CLIENT_AIR) $(SERVER_APP_XML)  -extdir $(ANE_DIR) $(SERVER).swf $(ASSET)
ifeq ($(AIR),true)
	$(ADT) -package -storetype pkcs12 -tsa none -keystore $(CERT) -storepass $(PASSWORD) $(CLIENT_AIR) $(CLIENT)-26app.xml $(CLIENT).swf
endif
#	$(ADL) -profile mobileDevice $(SERVER_APP_XML)
#	adb install $(CLIENT_AIR)
#	adb shell am start -n air.$(SERVER)/.AppEntry
#	$(ADL) -extdir $(ANE_DIR) -profile mobileDevice $(SERVER_APP_XML)
#	$(ADL) -profile mobileDevice $(CLIENT_APP_XML)
#	@echo $(CLIENT_AIR) "is ok"

$(ANDROID_EXE): $(C_FILES)
	$(CC) -g $(C_FILES) -o $(ANDROID_EXE)
	adb push $(ANDROID_EXE) /sdcard/$(ANDROID_EXE)
	adb shell /sdcard/$(ANDROID_EXE)
	$(RM) $(ANDROID_EXE)

$(CLIENT_SWF): $(CLIENT_AS) 
#	$(RM) $(CLIENT_SWF)
#	$(AMXMLC) -strict=true -metadata.publisher=libiao -omit-trace-statements=$(PUBLISH) -verbose-stacktraces=$(PUBLISH) -locale=en_US -tools-locale=en_US $(FLAGS) $(AS_CLIENT) -source-path=$(AS_PATH) -static-link-runtime-shared-libraries=true -debug=$(debugging) -output $(CLIENT_SWF) -library-path+=$(SWC)
	$(MXMLC) -tools-locale en_US -compiler.strict $(AS_CLIENT) $(FLAGS) -source-path=$(AS_PATH) -debug=$(debugging) -output $(CLIENT_SWF)  -library-path+=$(SWC)
#	$(AMXMLC) -$(FLAGS) $(AS_CLIENT) -source-path=$(AS_PATH) -debug=true -output $(CLIENT_SWF) -library-path+=$(SWC)

$(SERVER_SWF):$(SERVER_AS) Makefile
	$(AMXMLC) -strict=true -metadata.publisher=libiao -omit-trace-statements=$(PUBLISH) -verbose-stacktraces=$(PUBLISH) -locale=en_US -tools-locale=en_US $(FLAGS) $(AS_SERVER) -source-path=$(AS_PATH) -static-link-runtime-shared-libraries=true -debug=$(debugging) -output $(SERVER_SWF) -library-path+=$(SWC)
#	$(AMXMLC) -tools-locale en_US -compiler.strict  $(AS_SERVER) -source-path=$(AS_PATH) -debug=true -output $(SERVER_SWF) -library-path+=$(SWC)
#	cp $(FLEX_HOME)/bin/mxmlc.exe $(FLEX_HOME)/lib/mxmlc.exe
#	$(FLEX_HOME)/lib/mxmlc.exe -static-link-runtime-shared-libraries=true $(AS_SERVER) -source-path=$(AS_PATH) -debug=true -output $(SERVER_SWF) -library-path+=$(SWC) 
#	$(AMXMLC) $(AS_SERVER) -source-path=$(AS_PATH) -library-path+=$(SWC) -debug=true -output $(SERVER_SWF)
#	$(SERVER_SWF):$(AS_SERVER) $(SWC)

$(ANE_SWC):$(ANE_SWC_CLASS)
ifeq ($(debugging),false)
	java $(LANG) -Dsun.io.useCanonCaches=false -Xms32m -Xmx512m -Dflexlib="$(FLEX_HOME)/frameworks" -jar "$(FLEX_HOME)/lib/compc-cli.jar"  +configname=air -source-path $(ANE_SWC_CLASS_PATH) -include-classes $(ANE_SWC_CLASS) -swf-version=14 -output $(ANE_SWC)
#	$(ACOMPC) -source-path $(ANE_SWC_CLASS_PATH) -include-classes $(ANE_SWC_CLASS) -swf-version=14 -output $(ANE_SWC)
#	$(ACOMPC) -source-path $(ANE_SWC_CLASS_PATH) -include-classes $(ANE_SWC_CLASS) -swf-version=19 -output $(ANE_SWC)
#	$(RM) -rf $(EXTENSION_DIR)
#	mkdir $(EXTENSION_DIR) 
	unzip -o $(ANE_SWC) -x catalog.xml && mv library.swf $(EXTENSION_DIR)/library.swf
endif

$(ANDROID_ANE):$(ANDROID_ANE_XML) $(ANE_SWC) $(ANE_SO)
ifeq ($(debugging),false)
	$(ADT) -package -target ane $(ANDROID_ANE) $(ANDROID_ANE_XML) -swc $(ANE_SWC) -platform Android-ARM -C $(EXTENSION_DIR) .
#	$(ADT) -package -target ane $(ANDROID_ANE) $(ANDROID_ANE_XML) -swc $(ANE_SWC) -platform Android-ARM -C $(EXTENSION_DIR) .
endif

$(ANDROID_ANE_XML):
ifeq ($(debugging),false)
	@echo "$(O_O)<extension xmlns=\"http://ns.adobe.com/air/extension/3.1\"$(O_O)> \
		$(O_O)<id$(O_O)>$(extensionID)$(O_O)</id$(O_O)> \
		$(O_O)<versionNumber$(O_O)>$(VERSIONNUMBER)$(O_O)</versionNumber$(O_O)> \
		$(O_O)<platforms$(O_O)> \
		$(O_O)<platform name=\"Android-ARM\"$(O_O)> \
		$(O_O)<applicationDeployment$(O_O)> \
		$(O_O)<nativeLibrary$(O_O)>$(ANE_SO_NAME)$(O_O)</nativeLibrary$(O_O)> \
		$(O_O)<initializer$(O_O)>ExtInitializer$(O_O)</initializer$(O_O)> \
		$(O_O)<finalizer$(O_O)>ExtFinalizer$(O_O)</finalizer$(O_O)> \
		$(O_O)</applicationDeployment$(O_O)> \
		$(O_O)</platform$(O_O)> \
		$(O_O)</platforms$(O_O)> \
		$(O_O)</extension$(O_O)>" \
		> $(ANDROID_ANE_XML)
endif

$(SERVER_APP_XML):
	@sed -e 's/$(O_O)<!-- $(O_O)<aspectRatio$(O_O)>[$(O_O)^$(O_O)<]*$(O_O)<\/aspectRatio$(O_O)> --$(O_O)>/$(O_O)<aspectRatio$(O_O)>landscape$(O_O)<\/aspectRatio$(O_O)>/' \
		-e 's/$(O_O)<id$(O_O)>[$(O_O)^$(O_O)<]*$(O_O)<\/id$(O_O)>/$(O_O)<id$(O_O)>$(SERVER)$(O_O)<\/id$(O_O)>/' \
		-e 's/$(O_O)<content$(O_O)>[$(O_O)^$(O_O)<]*$(O_O)<\/content$(O_O)>/$(O_O)<content$(O_O)>$(SERVER).swf$(O_O)<\/content$(O_O)>/' \
		-e 's/$(O_O)<filename$(O_O)>[$(O_O)^$(O_O)<]*$(O_O)<\/filename$(O_O)>/$(O_O)<filename$(O_O)>$(filename)$(O_O)<\/filename$(O_O)>/' \
		-e 's/$(O_O)<name$(O_O)>[$(O_O)^$(O_O)<]*$(O_O)<\/name$(O_O)>/$(O_O)<name$(O_O)>$(file)$(O_O)<\/name$(O_O)>/' \
		-e 's/$(O_O)<!-- $(O_O)<visible$(O_O)>$(O_O)<\/visible$(O_O)> --$(O_O)>/$(O_O)<visible$(O_O)>true$(O_O)<\/visible$(O_O)>/' \
		-e 's/!-- $(O_O)<android$(O_O)>/$(O_O)<android$(O_O)>/' \
		-e 's/$(O_O)<manifest android:installLocation="auto"$(O_O)>/$(O_O)<manifest android:installLocation="auto"$(O_O)> \
		$(O_O)<uses-permission android:name="android.permission.READ_PHONE_STATE" \/$(O_O)> \
		$(O_O)<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" \/$(O_O)> \
		$(O_O)<uses-permission android:name="android.permission.CAMERA" \/$(O_O)> \
		$(O_O)<uses-permission android:name="android.permission.RECORD_AUDIO" \/$(O_O)> \
		$(O_O)<uses-permission android:name="android.permission.DISABLE_KEYGUARD" \/$(O_O)> \
		$(O_O)<uses-permission android:name="android.permission.WAKE_LOCK" \/$(O_O)> \
		$(O_O)<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" \/$(O_O)> \
		$(O_O)<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" \/$(O_O)> \
		$(O_O)<uses-permission android:name="android.permission.INTERNET"\/$(O_O)> \
		$(O_O)<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"\/$(O_O)> \
		$(O_O)<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"\/$(O_O)>/' \
		-e 's/$(O_O)<\/android$(O_O)> --$(O_O)>/$(O_O)<\/android$(O_O)>/' \
		-e 's/$(O_O)<!-- $(O_O)<supportedProfiles$(O_O)>[$(O_O)^$(O_O)<]*$(O_O)<\/supportedProfiles$(O_O)> --$(O_O)>/$(O_O)<supportedProfiles$(O_O)>desktop extendedDesktop mobileDevice extendedMobileDevice$(O_O)<\/supportedProfiles$(O_O)>/' \
		$(FLEX_HOME)/templates/air/descriptor-template.xml \
		> $(SERVER_APP_XML)

$(CLIENT_APP_XML):
#	$(O_O)<extensions$(O_O)>$(O_O)<extensionID$(O_O)>$(extensionID)$(O_O)<\/extensionID$(O_O)>$(O_O)<\/extensions$(O_O)> \
	sed -e 's/$(O_O)<id$(O_O)>[$(O_O)^$(O_O)<]*$(O_O)<\/id$(O_O)>/$(O_O)<id$(O_O)>$(CLIENT)$(O_O)<\/id$(O_O)>/' \
		-e 's/$(O_O)<content$(O_O)>[$(O_O)^$(O_O)<]*$(O_O)<\/content$(O_O)>/$(O_O)<content$(O_O)>$(CLIENT).swf$(O_O)<\/content$(O_O)>/' \
		-e 's/$(O_O)^[$(O_O)^a-z]*$(O_O)<name$(O_O)>[$(O_O)^$(O_O)<]*$(O_O)<\/name$(O_O)>[$(O_O)^a-z]*/$(O_O)<name$(O_O)>$(NAME)$(O_O)<\/name$(O_O)>/' \
		-e 's/$(O_O)^[$(O_O)^a-z]*$(O_O)<versionNumber$(O_O)>[$(O_O)^$(O_O)<]*$(O_O)<\/versionNumber$(O_O)>[$(O_O)^a-z]*/$(O_O)<versionNumber$(O_O)>$(VERSIONNUMBER)$(O_O)<\/versionNumber$(O_O)>/' \
		-e 's/$(O_O)^[$(O_O)^a-z]*$(O_O)<filename$(O_O)>[$(O_O)^$(O_O)<]*$(O_O)<\/filename$(O_O)>[$(O_O)^a-z]*/$(O_O)<filename$(O_O)>$(FILENAME)$(O_O)<\/filename$(O_O)>/' \
		-e 's/$(O_O)^[$(O_O)^a-z]*$(O_O)<extension$(O_O)>[$(O_O)^$(O_O)<]*$(O_O)<\/extension$(O_O)>[$(O_O)^a-z]*/$(O_O)<extension$(O_O)>extension$(O_O)<\/extension$(O_O)>/' \
		-e 's/$(O_O)^[$(O_O)^a-z]*$(O_O)<contentType$(O_O)>[$(O_O)^$(O_O)<]*$(O_O)<\/contentType$(O_O)>[$(O_O)^a-z]*/$(O_O)<contentType$(O_O)>contentType$(O_O)<\/contentType$(O_O)>/' \
		-e 's/$(O_O)^[$(O_O)^a-z]*$(O_O)<description$(O_O)>[$(O_O)^$(O_O)<]*$(O_O)<\/description$(O_O)>[$(O_O)^a-z]*/$(O_O)<description$(O_O)>description$(O_O)<\/description$(O_O)>/' \
		-e 's/$(O_O)<\/id$(O_O)>/$(O_O)<\/id$(O_O)>/' \
		-e 's/$(O_O)<!-- $(O_O)<visible$(O_O)>$(O_O)<\/visible$(O_O)> --$(O_O)>/$(O_O)<visible$(O_O)>true$(O_O)<\/visible$(O_O)>/' \
		-e 's/$(O_O)<!-- $(O_O)<aspectRatio$(O_O)>[$(O_O)^$(O_O)<]*$(O_O)<\/aspectRatio$(O_O)> --$(O_O)>/$(O_O)<aspectRatio$(O_O)>portrait$(O_O)<\/aspectRatio$(O_O)>/' \
		-e 's/$(O_O)^[$(O_O)^a-z]*$(O_O)<manifest android:installLocation="auto"$(O_O)>/$(O_O)<manifest android:installLocation="auto"$(O_O)> \
		$(O_O)<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" \/$(O_O)> \
		$(O_O)<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" \/$(O_O)> \
		$(O_O)<uses-permission android:name="android.permission.INTERNET" \/$(O_O)> \
		$(O_O)<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" \/$(O_O)>/' \
		-e 's/$(O_O)<!-- $(O_O)<supportedProfiles$(O_O)>[$(O_O)^$(O_O)<]*$(O_O)<\/supportedProfiles$(O_O)> --$(O_O)>/$(O_O)<supportedProfiles$(O_O)>desktop extendedDesktop mobileDevice extendedMobileDevice$(O_O)<\/supportedProfiles$(O_O)>/' \
		-e 's/$(O_O)<image16x16$(O_O)>[$(O_O)^$(O_O)<]*$(O_O)<\/image16x16$(O_O)>/$(O_O)<image16x16$(O_O)>icon\/16.png$(O_O)<\/image16x16$(O_O)>/' \
		-e 's/$(O_O)<image32x32$(O_O)>[$(O_O)^$(O_O)<]*$(O_O)<\/image32x32$(O_O)>/$(O_O)<image32x32$(O_O)>icon\/32.png$(O_O)<\/image32x32$(O_O)>/' \
		-e 's/$(O_O)<image36x36$(O_O)>[$(O_O)^$(O_O)<]*$(O_O)<\/image36x36$(O_O)>/$(O_O)<image36x36$(O_O)>icon\/36.png$(O_O)<\/image36x36$(O_O)>/' \
		-e 's/$(O_O)<image48x48$(O_O)>[$(O_O)^$(O_O)<]*$(O_O)<\/image48x48$(O_O)>/$(O_O)<image48x48$(O_O)>icon\/48.png$(O_O)<\/image48x48$(O_O)>/' \
		-e 's/$(O_O)<image57x57$(O_O)>[$(O_O)^$(O_O)<]*$(O_O)<\/image57x57$(O_O)>/$(O_O)<image57x57$(O_O)>icon\/57.png$(O_O)<\/image57x57$(O_O)>/' \
		-e 's/$(O_O)<image72x72$(O_O)>[$(O_O)^$(O_O)<]*$(O_O)<\/image72x72$(O_O)>/$(O_O)<image72x72$(O_O)>icon\/72.png$(O_O)<\/image72x72$(O_O)>/' \
		-e 's/$(O_O)<image114x114$(O_O)>[$(O_O)^$(O_O)<]*$(O_O)<\/image114x114$(O_O)>/$(O_O)<image114x114$(O_O)>icon\/114.png$(O_O)<\/image114x114$(O_O)>/' \
		-e 's/$(O_O)<image128x128$(O_O)>[$(O_O)^$(O_O)<]*$(O_O)<\/image128x128$(O_O)>/$(O_O)<image128x128$(O_O)>icon\/128.png$(O_O)<\/image128x128$(O_O)>/' \
		-e 's/[$(O_O)^$(O_O)>]*\($(O_O)<[\/]*icon[$(O_O)^$(O_O)>]*$(O_O)>\)[$(O_O)^$(O_O)<]*/\1/' \
		-e 's/[$(O_O)^$(O_O)>]*\($(O_O)<[\/]*android[$(O_O)^$(O_O)>]*$(O_O)>\)[$(O_O)^$(O_O)<]*/\1/' \
		-e 's/[$(O_O)^$(O_O)>]*\($(O_O)<[\/]*manifestAdditions[$(O_O)^$(O_O)>]*$(O_O)>\)[$(O_O)^$(O_O)<]*/\1/' \
		-e 's/[$(O_O)^$(O_O)>]*\($(O_O)<[\/]*fileTypes[$(O_O)^$(O_O)>]*$(O_O)>\)[$(O_O)^$(O_O)<]*/\1/' \
		-e 's/[$(O_O)^$(O_O)>]*\($(O_O)<[\/]*fileType[$(O_O)^$(O_O)>]*$(O_O)>\)[$(O_O)^$(O_O)<]*/\1/' \
		-e 's/[$(O_O)^$(O_O)>]*\($(O_O)<[\/]*iPhone[$(O_O)^$(O_O)>]*$(O_O)>\)[$(O_O)^$(O_O)<]*/\1/' \
		-e 's/[$(O_O)^$(O_O)>]*\($(O_O)<[\/]*InfoAdditions[$(O_O)^$(O_O)>]*$(O_O)>\)[$(O_O)^$(O_O)<]*/\1/' \
		$(FLEX_HOME)/templates/air/descriptor-template.xml > $(CLIENT_APP_XML)

$(WIN_ANE):$(WIN_ANE_XML) $(ANE_SWC)  $(ANE_DLL)
	$(ADT) -package -target ane $(WIN_ANE) $(WIN_ANE_XML) -swc $(ANE_SWC) -platform Windows-x86  -C $(EXTENSION_DIR) .

$(ANE_SO): $(LINKOBJ)
ifeq ($(debugging),false)
	$(CC) -L. -shared -o $(ANE_SO) $(LINKOBJ) FlashRuntimeExtensions.so
endif


$(ANE_DLL):$(LINKOBJ)
	gcc -shared $(LINKOBJ) -L. -lFlashRuntimeExtensions -o $(ANE_DLL)

$(ANE_SWC_CLASS): NativeApi.as
#	echo $<

$(CERT):
ifeq ($(IPA),true)
	openssl genrsa -out mykey.key 2048
	openssl req -new -key mykey.key -out CertificateSigningRequest.certSigningRequest  -subj "/emailAddress=db0@qq.com, CN=Biao Li, C=CN"
	openssl x509 -in ios_distribution.cer -inform DER -out developer_identity.pem -outform PEM
	openssl pkcs12 -export -inkey mykey.key -in developer_identity.pem -out iphone_dev.p12
endif
#endif
#	$(ADT) -certificate -cn db0@qq.com -ou db0@qq.com -o db0@qq.com -c CN -validityPeriod 1 2048-RSA $(CERT) $(PASSWORD)

#$(LINKOBJ): %.o: %.c
#	$(CC) -c   $< -o $@

.PHONY : clean
clean:
	$(RM) $(CLIENT_AIR) $(SERVER_AIR) $(SERVER_SWF) $(CLIENT_SWF) $(WIN_ANE) $(EXE) $(ANE_DLL) $(ANE_SO) win.ane $(EXTENSION_DIR) $(CLIENT_APP_XML) $(SERVER_APP_XML) *.air *.apk abc $(ANE_SWC)

astags:
ifeq ($(OS),Windows_NT)
#	cp $(FLEX_HOME)/bin/swfdump.exe $(FLEX_HOME)/lib/swfdump.exe
else
#	cp $(FLEX_HOME)/bin/swfdump $(FLEX_HOME)/lib/swfdump
endif
#	$(FLEX_HOME)/lib/swfdump.exe -abc $(FLEX_HOME)/frameworks/libs/player/10.2/playerglobal.swc | grep :[a-zA-Z0-9_]*[\(\/] | sed -e "s/^.*private.*//" | sed -e "s/[^\(\)\/:]*:/:/g" > as3.fun
#	$(FLEX_HOME)/lib/swfdump.exe -abc $(FLEX_HOME)/frameworks/libs/player/10.2/playerglobal.swc | grep "extends.*:.*" > as3.ext
	ctags --options=ctags.txt *.fun *.ext *.as
testtags:
#	ctags --options=./ctags.txt --fields=+iaS *.as
