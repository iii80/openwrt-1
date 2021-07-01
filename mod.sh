#!/bin/bash
# Copyright (c) P3TERX <https://p3terx.com>
#

# 配置自定义主题
#
# > 清除旧版argon主题并拉取最新版
rm -rf package/lean/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon package/community/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config package/community/luci-app-argon-config
#
# > 修改默认主题为 Argon
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
#

# 集成自定义插件
#
# > Dockerman
git clone https://github.com/lisaac/luci-lib-docker package/community/luci-lib-docker
git clone https://github.com/lisaac/luci-app-dockerman package/community/luci-app-dockerman
#
# > HelloWorld (vssr)
git clone https://github.com/jerrykuku/lua-maxminddb package/community/lua-maxminddb
git clone https://github.com/jerrykuku/luci-app-vssr package/community/luci-app-vssr
#
# > OpenClash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/community/luci-app-openclash
#

# 个性化配置修改
#
# > Mod
#sed -i '$i '"sed -i '/luciname/d' /usr/lib/lua/luci/version.lua"'' package/lean/default-settings/files/zzz-default-settings
#sed -i '$i '"echo 'luciname = \"Limitless\"' >> /usr/lib/lua/luci/version.lua"'' package/lean/default-settings/files/zzz-default-settings
sed -i '$i '"sed -i '/luciversion/d' /usr/lib/lua/luci/version.lua"'' package/lean/default-settings/files/zzz-default-settings
sed -i '$i '"echo 'luciversion = \"Mod\"' >> /usr/lib/lua/luci/version.lua"'' package/lean/default-settings/files/zzz-default-settings
#
# > 修改插件位置
sed -i 's/\"services\"/\"network\"/g' feeds/luci/applications/luci-app-upnp/luasrc/controller/upnp.lua
sed -i 's/\"system\"/\"services\"/g' package/lean/luci-app-ttyd/luasrc/controller/terminal.lua
sed -i '/\"NAS\"/d' package/lean/luci-app-zerotier/luasrc/controller/zerotier.lua
sed -i 's/\"vpn\"/\"services\"/g' package/lean/luci-app-zerotier/luasrc/controller/zerotier.lua
#
# > 修改插件名字
sed -i 's/\"CPU 使用率（%）\"/\"CPU负载\"/g' feeds/luci/modules/luci-base/po/zh-cn/base.po
sed -i 's/\"Docker CE 容器\"/\"DockerCE\"/g' package/lean/luci-app-docker/po/zh-cn/docker.po
sed -i 's/\"DDNS.to内网穿透\"/\"内网穿透\"/g' feeds/nas/luci/luci-app-ddnsto/po/zh-cn/ddnsto.po
sed -i 's/\"DNSFilter\"/\"广告过滤\"/g' package/lean/luci-app-dnsfilter/po/zh-cn/dnsfilter.zh-cn.po
sed -i 's/\"TTYD 终端\"/\"网页终端\"/g' package/lean/luci-app-ttyd/po/zh-cn/terminal.po
sed -i 's/\"Argon 主题设置\"/\"主题设置\"/g' package/community/luci-app-argon-config/po/zh-cn/argon-config.po
sed -i 's/\"解锁网易云灰色歌曲\"/\"音乐解锁\"/g' package/lean/luci-app-unblockmusic/po/zh-cn/unblockmusic.po
sed -i 's/\"Turbo ACC 网络加速\"/\"网络加速\"/g' package/lean/luci-app-turboacc/po/zh-cn/turboacc.po
#