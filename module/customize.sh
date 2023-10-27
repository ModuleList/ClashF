#!/system/bin/sh

status=""
architecture=""
system_gid="1000"
system_uid="1000"
clash_data_dir="/data/clash"
modules_dir="/data/adb/modules"
ABI=$(getprop ro.product.cpu.abi)

if [ ! -f ${clash_data_dir}/clashkernel/clashMeta ];then
    if [ -f "${MODPATH}/bin/clashMeta-android-${ABI}" ];then
        tar -xjf ${MODPATH}/bin/clashMeta-android-${ABI}.tar.bz2 -C ${clash_data_dir}/clashkernel/
        mv -f ${clash_data_dir}/clashkernel/clashMeta-android-${ABI} ${clash_data_dir}/clashkernel/clashMeta
    else
        ui_print "未找到你的架构: ${ABI}\n请使用 'make --abi ${ABI}' 编译${ABI}架构的clashMeta"
        abort 1
    fi
fi
mkdir -p ${clash_data_dir}
mkdir -p ${clash_data_dir}/run
mkdir -p ${clash_data_dir}/clashkernel

unzip -o "${ZIPFILE}" -x 'META-INF/*' -d ${MODPATH} >&2

if [ -f "${clash_data_dir}/config.yaml" ];then
    ui_print "-config.yaml文件已存在 添加预设文件."
    rm -rf ${MODPATH}/config.yaml
else
    ui_print "-config.yaml文件不存在 添加预设文件."
fi

if [ -f "${clash_data_dir}/clash.yaml" ];then
    ui_print "-clash.yaml文件已存在 不添加预设文件."
    rm -rf ${MODPATH}/clash.yaml
else
    ui_print "-clash.yaml文件不存在 添加预设文件."
fi

if [ -f "${clash_data_dir}/packages.list" ];then
    ui_print "-packages.list文件已存在 不添加预设文件."
    rm -rf ${MODPATH}/packages.list
else
    ui_print "-packages.list文件不存在 添加预设文件."
fi

mv -f ${MODPATH}/clash/* /data/clash/
rm -rf ${MODPATH}/clashkernel

ui_print "- 开始设置环境权限."
set_perm_recursive ${MODPATH} 0 0 0755 0755
set_perm  ${MODPATH}/system/bin/setcap  0  0  0755
set_perm  ${MODPATH}/system/bin/getcap  0  0  0755
set_perm  ${MODPATH}/system/bin/getpcaps  0  0  0755
set_perm  ${MODPATH}${ca_path}/cacert.pem 0 0 0644
set_perm  ${MODPATH}/system/bin/curl 0 0 0755
set_perm_recursive ${clash_data_dir} ${system_uid} ${system_gid} 0755 0644
set_perm_recursive ${clash_data_dir}/scripts ${system_uid} ${system_gid} 0755 0755
set_perm_recursive ${clash_data_dir}/clashkernel ${system_uid} ${system_gid} 6755 6755
set_perm  ${clash_data_dir}/clashkernel/clash  ${system_uid}  ${system_gid}  6755
set_perm  ${clash_data_dir}/clash.config ${system_uid} ${system_gid} 0755
set_perm  ${clash_data_dir}/packages.list ${system_uid} ${system_gid} 0644


ui_print ""
ui_print ""
ui_print "************************************************"
ui_print "模块文件列表:"
ui_print "clash配置文件在/data/clash/目录下"
ui_print "clash.config (clash启动配置)"
ui_print "clash.yaml (clash基本配置 dns配置等)"
ui_print "coning.yaml (订阅配置 分流规则配置)"
ui_print "packages.list (代理黑/白名单包名 一行一个)"
ui_print ""
ui_print "clashMeta配置参考可以看看这个wiki"
ui_print "https://docs.metacubex.one/"
ui_print ""
ui_print "官方clash配置(纯英文)"
ui_print "https://github.com/Dreamacro/clash/wiki/Configuration#introduction"
ui_print "************************************************"
ui_print ""
ui_print ""
ui_print "telegram频道: @wtdnwbzda"
ui_print "博客: https://www.heinu.cc"
ui_print ""
ui_print "！！！为了让你阅读以上消息，安装进度暂停5秒！！！"
sleep 5