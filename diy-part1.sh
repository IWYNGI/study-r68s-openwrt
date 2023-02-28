#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

# fix upx ucl 不存在;
apt install subversion -y
svn export --force https://github.com/coolsnowwolf/lede/trunk/tools/upx tools/upx
svn export --force https://github.com/coolsnowwolf/lede/trunk/tools/ucl tools/ucl

n=`sed -n '/^tools-y +=/{p;q}' tools/Makefile`
sed -i "/${n}/i\tools-y += ucl upx " tools/Makefile

n=`sed -n '/^$(curdir)/{p;q}' tools/Makefile`
sed -i '1,/${n}/ {/# builddir dependencies/a\
$(curdir)/upx/compile := $(curdir)/ucl/compile
}' tools/Makefile

./scripts/feeds update -a
./scripts/feeds install -a
