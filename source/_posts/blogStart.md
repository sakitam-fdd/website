---
title: 怎样快速搭建一个博客
date: 2017-04-08 12:11:50
categories:
- 前端
- Hexo
tags:
- 前端
- Hexo
---

# 简介：

hexo是一款基于Node.js的静态博客框架，他可以方便的生成静态网页，
而且不需要你去关注页面布局这些问题，只需要专注于内容。

<!--more-->

# 必要环境

* 首先要安装 [Node.js](https://nodejs.org/en/download/)， Node.js 自带了软件包管理器 npm，hexo 需要 Node.js v0.6 以上支持，建议使用最新版 Node.js。
* 装完node后可以测试一下是否安装成功,命令窗口执行下面命令能正确输出版本号则安装成功。
```bash
node -v
```
* 配置完之后建议将包地址换为国内淘宝镜像源。
```bash
npm config set registry https://registry.npm.taobao.org
// 配置后可通过下面方式来验证是否成功
npm config get registry
// 或npm info express
```

* 全局安装hexo脚手架工具和hexo

```bash
npm i -g hexo-cli
npm i -g hexo
```

* 常用命令

> 1、 help ： 查看帮助信息
  2、 init [文件夹名] ： 创建一个hexo项目，不指定文件夹名，则在当前目录创建
  3、 version ： 查看hexo的版本
  4、 --config config-path ：指定配置文件，代替默认的_config.yml
  5、 --cwd cwd-path ：自定义当前工作目录
  5、 --debug ：调试模式，输出所有日志信息
  6、 --safe ：安全模式，禁用所有的插件和脚本
  7、 --silent ：无日志输出模式
  8、 generate ：编译输出静态文件
  9、 clean ：清空编译后的缓存和文件
  10、server ：开启本地服务器
  11、deploy ：部署

# 开始创建

```bash
hexo init myBlog
```

执行上述命令后会创建一个模板出来，剩下的就需要自己去改了

# 添加文章

文章会自动生成在博客目录下source/_posts/start.md

```bash
hexo new "start"  #新建博文,其中start是博文题目
```

```bash
  ---
  title: 怎样快速搭建一个博客
  date: 2017-04-08 12:11:50
  tags: hexo
  ---
```
---

# 主题

Hexo提供了官网的主题, 初始化hexo时也会自动生成一个主题, Hexo还支持个性定制主题, 可以根据自己的喜好对主题进行修改, 更多主题可以在官网中找到[themes](https://hexo.io/themes/)
更改方法如下

```bash
git clone https://github.com/iissnan/hexo-theme-next themes/next

#在./_config.yml，修改主题为next
theme: writing

#查看本地效果
hexo g       #hexo generate简写
hexo s       #hexo server简写
```
更多设置请查看[next主题官网](http://theme-next.iissnan.com/)

# 部署到github
注意修改配置文件中的deploy配置。
```bash
# Deployment
## Docs: https://hexo.io/docs/deployment.html
deploy:
  type: git
  repository: https://github.com/sakitam-fdd/sakitam-fdd.github.io.git
```

然后执行
```bash
hexo deploy  #进行部署

Initialized empty Git repository in E:\codeRepository\github\website/.deploy/.git/
[master (root-commit) bb3079b] First commit
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 placeholder
[info] Clearing .deploy folder...
[info] Copying files from public folder...
[master 6e24e8d] Site updated: 2017-04-08 11:16:23
 172 files changed, 34969 insertions(+)
 create mode 100644 2017/04/08/Hello-World/index.html
 ...
 create mode 100644 "tags/\345\277\203\350\267\257\346\234\255\350\256\260/index.html"
To git@github.com/sakitam-fdd/sakitam-fdd.github.io.git
 + 11237d0...6e24e8d master -> master (forced update)
Branch master set up to track remote branch master from git@github.com/sakitam-fdd/sakitam-fdd.github.io.git
[info] Deploy done: github

#表示部署成功
```
