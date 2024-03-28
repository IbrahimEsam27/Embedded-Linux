################################################################################
#
# my_package
#
################################################################################

MY_PACKAGE_VERSION = 1.0
MY_PACKAGE_SITE = $(TOPDIR)/package/my_package
MY_PACKAGE_SITE_METHOD = local

define MY_PACKAGE_BUILD_CMDS
    $(TARGET_CC) $(TARGET_CFLAGS) -o $(@D)/hello_world $(@D)/hello_world.c
endef

define MY_PACKAGE_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 755 $(@D)/hello_world $(TARGET_DIR)/usr/bin/hello_world
endef

$(eval $(generic-package))
