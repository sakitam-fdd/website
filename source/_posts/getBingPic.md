---
title: 动态抓取bing搜索每日一图
date: 2017-04-09 22:00:20
categories:
- 前端
- nodejs
tags: 
- nodejs
---

# 写在前面
大家都知道微软的Bing搜索引擎首页每天都会提供了一些有趣的图片，而这些图片很多都是有故事含义的，很多网友每天去访问bing首页都是为了这些图片而去的。
而最近在搭建个人博客时的背景图片非常想使用一些漂亮的图片。当然我们可以使用图床和放置高清大图，但是考虑到不方便，所以想到使用bing的每日一图。

<!--more-->

# 思路

我们打开开发者工具，可以看到有个请求是获取图片地址的：
```javascript
var url = 'http://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&nc=1491746841662&pid=hp';

// 结果 url即为图片地址

var res = {
              "images":[
                  {
                      "startdate":"20170408",
                      "fullstartdate":"201704081600",
                      "enddate":"20170409",
                      "url":"/az/hprichbg/rb/TulipFestival_ZH-CN8467334837_1920x1080.jpg",
                      "urlbase":"/az/hprichbg/rb/TulipFestival_ZH-CN8467334837",
                      "copyright":"弗农山上绽放的郁金香，华盛顿 (© Pete Saloutos/plainpicture)",
                      "copyrightlink":"/search?q=%e9%83%81%e9%87%91%e9%a6%99&form=hpcapt&mkt=zh-cn",
                      "quiz":"/search?q=Bing+homepage+quiz&filters=WQOskey:%22HPQuiz_20170408_TulipFestival%22&FORM=HPQUIZ",
                      "wp":true,
                      "hsh":"2587e7cb9ba2b13b50dd321ca94f56b1",
                      "drk":1,
                      "top":1,
                      "bot":1,
                      "hs":[
          
                      ]
                  }
              ],
              "tooltips":{
                  "loading":"Loading...",
                  "previous":"Previous image",
                  "next":"Next image",
                  "walle":"This image is not available to download as wallpaper.",
                  "walls":"Download this image. Use of this image is restricted to wallpaper only."
              }
          }
```

正常我们请求的话直接请求图片就可以了

```javascript
var url = 'http://cn.bing.com/az/hprichbg/rb/TulipFestival_ZH-CN8467334837_1920x1080.jpg'
```

但是不出所料的出现了跨域问题，所以就考虑到使用代理转发的方式来进行请求。

# 解决方案
客户端发起请求到nodejs服务器，nodejs收到后请求第三方服务器取得数据，返回给客户端。

```bash
client ajax --> nodejs recived --> nodejs send request --> respone to client
```
## 范例

### 不使用外部package的代码

```javascript
/**
 * Created by FDD on 2017/4/9.
 */
var http = require('http');
var zlib = require('zlib');
// 创建http服务
var app = http.createServer(function (req, res) {
  // 查询本机ip
  // var base = '/HPImageArchive.aspx?format=js&idx={idx}&n=1&nc={nc}&pid=hp&video=1';
  // var idx = parseInt(Math.random() * 10);
  // var nc = (new Date()).getTime();
  // var url = base.replace('{idx}', idx.toString()).replace('{nc}', nc.toString());
  var sreq = http.request({
    host: 'cn.bing.com', // 目标主机
    path: req.url, // 目标路径
    gzip: true,
    method: req.method // 请求方式
  }, function (sres) {
    // console.log(req.url)
    sres.pipe(res);
    sres.on('end', function () {
      console.log('done');
    });
  });
  if (/POST|PUT/i.test(req.method)) {
    req.pipe(sreq);
  } else {
    sreq.end();
  }
});
// 访问127.0.0.1:3001查看效果
app.listen(3001);
console.log('server started on 127.0.0.1:3001');
```
### 使用superAgent的代码

注意这一段代码是为了解决返回乱码和跨域问题

```javascript
res.writeHead(200, {
    "Content-Type": "text/html;charset=utf-8",
    "Access-Control-Allow-Origin": "*"
  });
```

```javascript
var http = require('http');
// 创建http服务
var app = http.createServer(function (req, res) {
  res.writeHead(200, {
    "Content-Type": "text/html;charset=utf-8",
    "Access-Control-Allow-Origin": "*"
  });
  // 使用了superagent来发起请求
  var charset = require('superagent-charset');
  var superagent = require('superagent');
  charset(superagent);
  // 查询本机ip，这里需要根据实际情况选择get还是post
  var base = 'http://cn.bing.com/HPImageArchive.aspx?format=js&idx={idx}&n=1&nc={nc}&pid=hp&video=1';
  var idx = parseInt(Math.random() * 10);
  var nc = (new Date()).getTime();
  var url = base.replace('{idx}', idx.toString()).replace('{nc}', nc.toString());
  var sreq = superagent.get(url);
  sreq.charset('utf-8');
  // JSON.stringify(res);
  sreq.pipe(res);
  sreq.on('end', function(){
    console.log('done');
  });
});
// 访问127.0.0.1:3002查看效果
app.listen(3002);
console.log('server started on 127.0.0.1:3002');
```
### 使用Express + superAgent的代码

```javascript
/**
 * Created by FDD on 2017/4/9.
 */
var express = require('express');
var app = express();
app.get('/', function (req, res) {
  // 使用了superagent来发起请求
  var superagent = require('superagent');
  // 查询本机ip，这里需要根据实际情况选择get还是post
  var base = 'http://cn.bing.com/HPImageArchive.aspx?format=js&idx={idx}&n=1&nc={nc}&pid=hp&video=1';
  var idx = parseInt(Math.random() * 10);
  var nc = (new Date()).getTime();
  var url = base.replace('{idx}', idx.toString()).replace('{nc}', nc.toString());
  var sreq = superagent.get(url);
  sreq.pipe(res);
  sreq.on('end', function(){
    console.log('done');
  });
});
app.listen(3001);
console.log('Express started on 127.0.0.1:3001');
```