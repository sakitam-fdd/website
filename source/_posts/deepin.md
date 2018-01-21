---
title: deepin下前端开发环境搭建
date: 2017-12-11 19:11:50
categories:
- linux
tags:
- linux
- nodejs
- soft
- git
---

# 简介：

deepin下前端相关开发环境搭建，包括nodejs安装，webstorm安装，jdk安装,git安装等。

<!--more-->

# nodejs安装教程

> 

* 下载源码：https://nodejs.org/en/download/，优先选择长期支持版，选择Source Code下载
```bash
wget https://nodejs.org/dist/v8.9.3/node-v8.9.3.tar.gz
```

* 解压并安装
```bash
// 解压源码压缩包
sudo tar xvf node-v8.9.3.tar.gz

// 切换到解压后的文件夹内
cd node-v8.9.3

// 开始安装，编译大概会有20分钟之久
sudo ./configure 
sudo make 
sudo make install 

// 查看当前安装的Node的版本 
node -v 
v8.9.3

// 查看NPM版本
npm -v
5.5.1
```

# git安装教程

```bash
Debian/Ubuntu
For the latest stable version for your release of Debian/Ubuntu

# apt-get install git
For Ubuntu, this PPA provides the latest stable upstream Git version

# add-apt-repository ppa:git-core/ppa # apt update; apt install git
Fedora
# yum install git (up to Fedora 21)
# dnf install git (Fedora 22 and later)
Gentoo
# emerge --ask --verbose dev-vcs/git
Arch Linux
# pacman -S git
openSUSE
# zypper install git
Mageia
# urpmi git
Nix/NixOS
# nix-env -i git
FreeBSD
# pkg install git
Solaris 9/10/11 (OpenCSW)
# pkgutil -i git
Solaris 11 Express
# pkg install developer/versioning/git
OpenBSD
# pkg_add git
Alpine
$ apk add git
```

# JDK环境配置

```bash
下载安装Oracle JDK
下载JDK的tar.gz包

解压压缩包
进入下载目录

cd ~/Download
解压tar.gz包

tar -zxvf jdk-8u152-linux-x64.tar.gz
安装JDK

sudo mv jdk1.8.0_152/  /usr/lib/jvm/jdk1.8.0_152

JDK环境变量配置
修改配置文件
sudo vim /etc/profile
```

在文件的末尾增加内容

```bash
JAVA_HOME=/usr/lib/jvm/jdk1.8.0_152
export PATH=$JAVA_HOME/bin:$PATH 
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
```

注意jdk的路径和版本

使配置生效

```bash
source /etc/profile
```


配置默认JDK
创建新的java版本
在shell用update-alternatives命令创建新的系统命令链接：

```bash
sudo update-alternatives --install /usr/bin/javac javac  /usr/lib/jvm/jdk1.8.0_152/bin/javac  1171
sudo update-alternatives --install /usr/bin/java  java  /usr/lib/jvm/jdk1.8.0_152/bin/java  1171
sudo update-alternatives --install /usr/bin/jar jar /usr/lib/jvm/jdk1.8.0_152/bin/jar 1171   
sudo update-alternatives --install /usr/bin/javah javah /usr/lib/jvm/jdk1.8.0_152/bin/javah 1171   
sudo update-alternatives --install /usr/bin/javap javap /usr/lib/jvm/jdk1.8.0_152/bin/javap 1171 
```

update-alternatives是ubuntu系统中专门维护系统命令链接符的工具，后面的1171是用来指定当前链接的优先级，最高的优先级将自动被设置为默认版本。

可以用下面的命令查看JAVA的版本和优先级：

```bash
update-alternatives --display java
```

选择JAVA的版本
执行命令

```angular2html
update-alternatives --config java
```

输出

 有 2 个候选项可用于替换 java (提供 /usr/bin/java)。

  选择       路径                                          优先级  状态
------------------------------------------------------------
```bash
* 0            /usr/lib/jvm/jdk1.8.0_152/bin/java               1171      自动模式
  1            /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java   1081      手动模式
  2            /usr/lib/jvm/jdk1.8.0_152/bin/java               1171      手动模式
```

要维持当前值[*]请按<回车键>，或者键入选择的编号：

上图可以看到刚刚配置的JDK 1.8优先级配置为1171，高于原有的1081，所以被自动设置为默认。

 

测试
查看JAVA版本
在shell上执行下面命令

```bash
java -version
```

如果得到如下输出，证明JDK已经成功安装配置了。

```bash
Picked up _JAVA_OPTIONS:   -Dawt.useSystemAAFontSettings=gasp
java version "1.8.0_152"
Java(TM) SE Runtime Environment (build 1.8.0_152-b16)
Java HotSpot(TM) 64-Bit Server VM (build 25.152-b16, mixed mode)
```

# webstorm安装

> 官网：http://www.jetbrains.com/webstorm/

安装过程：

```bash
解压

tar zxvf WebStorm-2017.3.tar.gz
移动

sudo mv WebStorm-173.3727.108/ /opt/WebStorm/
创建链接

sudo ln -s /opt/WebStorm/ /opt/WebStorm
启动

/opt/WebStorm/bin/webstorm.sh
添加Dash图标
```

## 激活

> http://www.imsxm.com/jetbrains-license-server.html
