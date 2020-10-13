################################################################################
#
# puredata
#
################################################################################

PUREDATA_VERSION = 0.49-0
PUREDATA_SITE = https://github.com/pure-data/pure-data/archive
PUREDATA_SOURCE = $(PUREDATA_VERSION).tar.gz
PUREDATA_LICENSE = BSD-3-Clause
PUREDATA_LICENSE_FILES = LICENSE.txt
PUREDATA_DEPENDENCIES = alsa-lib
PUREDATA_AUTORECONF = YES

# Fix for toolchains using the musl libc
ifeq ($(BR2_TOOLCHAIN_USES_MUSL),y)
PUREDATA_CONF_OPTS += CFLAGS="$(TARGET_CFLAGS) -D__off64_t=off64_t"
endif

# Portaudio is for Mac/Windows cross compatibility, we don't need it
PUREDATA_CONF_OPTS += --disable-portaudio

# Create the empty /m4/generated directory
# (In a normal puredata build, this would be done by autogen.sh)
define PUREDATA_POST_EXTRACT_FIXUP
 mkdir -p $(@D)/m4/generated
endef
PUREDATA_POST_EXTRACT_HOOKS += PUREDATA_POST_EXTRACT_FIXUP

ifeq ($(BR2_PACKAGE_PUREDATA_JACK),y)
PUREDATA_DEPENDENCIES += jack2
PUREDATA_CONF_OPTS += --enable-jack
endif

$(eval $(autotools-package))
