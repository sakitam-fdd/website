---
title: 利用travis持续集成工具自动部署博客
date: 2017-04-08 14:50:00
categories:
- 前端
- hexo
tags: 
- 持续集成
- github
- hexo
---

# 简介

  完善一下早期文章。虽然网上已有很多关于博客自动部署的教程，但是真正实践起来并不是一番丰顺。所以
将踩过的坑记录下来也是必要的。

<!--more-->

# 自动部署方案选择

## Webhook

  Webhook，也就是人们常说的钩子，是一个很有用的工具。你可以通过定制 Webhook 来监测你在 Github 
上的各种事件，包括提交合并分支等事件。并且github和gitlab对webhook的支持比较好。
  主要思路就是当有新的 ``push`` 操作后，触发webhook的回调，进行仓库拉取更新和编译，并且将编译后的
文件推送到 ``git`` 仓库或者特定服务器上，就完成了自动部署。
  但是此方案需要有一个服务器，所以暂时不考虑。
  
## Travis CI

  Travis CI 是目前新兴的开源持续集成构建项目。目前我的大多数的github项目都已经移入到Travis CI的构建队列中。

### travis配置

 - 开启travis中要构建的项目，并指定触发条件。
 
 ![配置](http://oo4em1zi0.bkt.clouddn.com/website/images/travisgitres.jpg)
 ![触发条件](http://oo4em1zi0.bkt.clouddn.com/website/images/travismenu.jpg)
 
 - 配置环境变量Environment Variables，主要目的是将HEXO_ALGOLIA_INDEXING_KEY(algolia的key)和TRAVIS_GITHUB（Github的Access Token）
   以私有方式配置到构建环境中。
   
 - 配置 ``.travis.yml`` 配置文件, 安装node，配置主题，hexo编译，自动配置algolia搜索字段的更新，将构建结果 `push`
   到 ``github`` 对应仓库。
 
  ```bash
    language: node_js
    node_js: node
    cache:
      directories:
        - node_modules
    before_install:
    - npm install -g hexo-cli
    install: npm install
    script:
    - git clone https://github.com/sakitam-fdd/hexo-theme-next.git themes/next
    - hexo clean
    - hexo generate
    - export HEXO_ALGOLIA_INDEXING_KEY=${HEXO_ALGOLIA_INDEXING_KEY}
    - hexo algolia
    after_script:
    - cd ./dist
    - git init
    - git config --global user.name 'sakitam-fdd'
    - git config --global user.email 'smilefdd@gmail.com'
    - git add .
    - git commit -m "update my website"
    - git push --force --quiet "https://${TRAVIS_GITHUB}@github.com/sakitam-fdd/sakitam-fdd.github.io" master:master
  ```
  

## 测试结果

  推送一篇新主题到 ``website`` 仓库，观察 [travis-ci](https://www.travis-ci.org/sakitam-fdd/website)构建过程
当出现 ``Done. Your build exited with 0.``后表示构建并且更新blog成功，稍等一分钟可以刷新你的blog查看最新结果。

![成功](http://oo4em1zi0.bkt.clouddn.com/website/images/travistravis.jpg)
