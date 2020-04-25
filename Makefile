include $(THEOS)/makefiles/common.mk

export TARGET = iphone:clang:12.1.2:12.0
export ARCHS = arm64 arm64e

TWEAK_NAME = EasyEditAlarms
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 MobileTimer"
