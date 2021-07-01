## 宿主机以及 docker 相关设置

### 1. 配置宿主机网络环境

- 临时开启宿主机网卡混杂模式
```ini
ip link set eth0 promisc on
```
- 永久开启宿主机网卡混杂模式
```ini
vim /etc/rc.local
```
> 在 **`exit 0`** 之上添加 **`ifconfig eth0 promisc`** 保存即可

### 2. 配置 docker 网络环境

- 创建 `docker` 虚拟网络
```ini
docker network create -d macvlan \
    --subnet=10.10.10.0/24 \
    --gateway=10.10.10.1 \
    -o parent=eth0 \
    macnet
```
> 虚拟网络名称为 `macnet`，驱动为 `macvlan` 模式  
> 
> 将 `subnet 10.10.10.0`  修改为你自己主路由的网段  
> 
> 将 `geteway 10.10.10.1` 修改为你自己的主路由网关


### 3. 配置 docker 容器 - openwrt 

- 配置 openwrt **`network 映射文件`** 以便于后续更新

```ini
cat > /home/network <<EOF

config interface 'loopback'
  option ifname 'lo'
  option proto 'static'
  option ipaddr '127.0.0.1'
  option netmask '255.0.0.0'

config globals 'globals'

config interface 'lan'
  option ifname 'eth0'
  option _orig_ifname 'eth0'
  option _orig_bridge 'true'
  option proto 'static'
  option ipaddr '10.10.10.11'
  option netmask '255.255.255.0'
  option gateway '10.10.10.1'
  option dns '119.29.29.29'
  
EOF
```
> 将 `ipaddr '10.10.10.11'`  # 修改为将创建的容器的IP  
> 
> 将 `gateway '10.10.10.1`   # 修改为你自己主路由的IP  

</br>

- 创建 `openwrt` 容器
```ini
docker run -d \
  --restart always \
  --name openwrt \
  --network macnet \
  --privileged \
  -v /home/network:/etc/config/network \
  xtoys/openwrt
```

## 容器 OpenWrt 的相关设置

- 接口

> `网络` > `接口` > `修改`  
> 
> `忽略此接口` ☑️ > `保存&应用` 

- 防火墙

> `网络` > `防火墙`  
> 
> `基本设置` > `启用FullCone-NAT`☑️ > `转发` - `接受`  > `保存&应用`  
> 
>  `自定义规则` >  `复制粘贴下列代码` > `保存&应用` 
```ini
# 国内慢速或无法联网则添加此条命令
iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE
```

- 网络加速

> `网络` > `网络加速`  
> 
> `启用 BBR` ☑️ > `保存&应用` 


## 旁路网关的相关设置

- 个体设备 

> 设置 `旁路由` 为网关，个别设备独自通过 `旁路由` 上网
> 
> 优点：折腾旁路由时，不影响其他设备网络  
> 
> 缺点：重复设置每个设备  

- 所有设备 

>  `路由器` 设置 `旁路由` 为该路由器网关，该路由器下所有内网设备都通过 `旁路由` 上网
> 
> 优点：该路由器下所有内网设备都能以旁路由模式上网，无需每台单独设置
> 
> 缺点：折腾時可能会影响其他设备网络