#!/usr/bin/sh
rm ytr-installer.zip
zip -r9v ytr-installer.zip META-INF/ CHANGELOG.md customize.sh module.prop README.md service.sh uninstall.sh ytr-config.prop
