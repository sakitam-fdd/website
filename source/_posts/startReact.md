---
title: 使用webpack4手动构建react项目
date: 2018-02-26 14:50:00
categories: [front-end]
tags: [react, webpack]
---

# webpack

  Webpack 是一个前端资源加载/打包工具。它将根据模块的依赖关系进行静态分析，然后将这些模块按照指定的规则生成对应的静态资源。
自从 ``gulp，Grunt`` 等一些前端工具兴起后，才真正把前端工程化引入，不仅简化了开发流程，更引入了一些前沿思想。

<!--more-->

## webpack 工作方式
   把你的项目当做一个整体，通过一个给定的主文件（entry）（如：index.js），Webpack将从这个文件开始找到你的项目的所有
依赖文件，使用loaders处理它们，最后打包为一个（或多个）浏览器可识别的JavaScript文件。

## webpack 4

  实际上在webpack 4之前，webpack有着很多黑点，也催生了后期`rollup`和`parcel`。而`webpack`主要问题存在于：
  
* 配置过于复杂。
* 文档缺失，尤其中文文档。
* 编译、打包速度过慢。等

原来对于前端来说，打开编辑器就可以撸代码的日子一去不复返，大概配置前端开发环境就需要一天吧 :smile: 。
对于 `webpack4` 来说，这一个大版本升级做了诸多优化，主要包含如下：

* 环境: 不再支持 `node.js 4`, 源代码已升级到更高的`ecmascript`版本。
* 用法: 
    - 您现在必须在`production or development`两种模式之间选择（`mode or --mode`)
    - `production`默认提供所有可能的优化，如代码压缩/作用域提升等
    - `development`模式下允许注释和 `eval` 下的 `source maps`。
    - `production`模式下不支持 `watch`，`development`模式下针对代码变化后的重新打包进行了优化。
    - `production`模式下默认提供模块合并（作用域提升）。
    - 你可以配置 `optimization` 自定义模式。
    - `process.env.NODE_ENV` 的值不需要再定义，默认对应当前模式。
    - 并且可以设置 `none` 模式可以禁用所有的功能。
* 语法
    - 在 webpack 4 中，import() 会返回一个带命名空间(namespace)的对象，这对 ES Module 不会有影响，但对于遵循 commonjs 规范的模块则会加一层包裹。
    - 在`webpack 4` 中如果你使用 `import（）` 导入 `CommonJs` 模块可能会破坏你的代码。
* 配置
> 删除了一些常用内置插件：

    - NoEmitOnErrorsPlugin -> optimization.noEmitOnErrors (生产模式默认)
    - ModuleConcatenationPlugin -> optimization.concatenateModules （生产模式默认）
    - NamedModulesPlugin -> optimization.namedModules （开发模式默认）。
    - 删除了 CommonsChunkPlugin，取而代之的是 optimization.splitChunks 和 optimization.runtimeChunk，这提供了细粒度的缓存策略控制

* JSON处理

    - webpack现在默认处理JSON。
        
        * 将JSON通过加载器转换为JS时，可能需要添加类型：`javascript / auto`.
        * 还支持对 JSON 的 Tree Shaking。当使用 ESM 语法 import json 时，webpack 会处理掉JSON Module 中未使用的导出。
* 优化

    - uglifyjs-webpack-plugin 发布 v1，支持 ES2015
    - 使用 JSONP 数组来代替 JSONP 函数 –> 异步支持   

* 重大功能性更新

  1. Modules(模块)： 
    - webpack 现在支持以下文件类型：
        * javascript/auto: (webpack 3中的默认类型)支持所有的JS模块系统：CommonJS、AMD、ESM
        * javascript/esm: EcmaScript 模块，在其他的模块系统中不可用。
        * javascript/dynamic: 仅支持 CommonJS & AMD，ES moudle 不可用。
        * json: 可通过 require 和 import 导入的 JSON 格式的数据(默认为 .json 的文件)
        * webassembly/experimental: WebAssembly 模块(试验阶段，默认为 .wasm 的文件)。
    - 与`javascript/auto`相比，`javascript/esm`更严格地处理`ESM`文档
        * 导入的名称需要在导入的模块上存在。
        * 动态模块（非esm，即CommonJs）只能通过`default`导入，其他方式（包括命名空间导入）都会发出错误。
    - 以后缀名为`.mjs`的模块默认为 `javascript/esm`。
    - WebAssembly模块
        * 可以导入其他模块（JS和WASM）。
        * 从`WebAssembly`模块导出的模块将通过ESM导入进行验证。
        * 只能用于异步模块。
        * WebAssembly为实验性功能。
        
  2. Optimization(优化):
    - sideEffects: `package.json`现在支持配置`false`。
        * `package.json`中的`sideEffects`还支持`glob`表达式和`glob`表达式的数组。
    - 使用 `JSONP` 数组替代 `JSONP` 函数，异步脚本支持，不再依赖于加载顺序。
    - 引入了新的`optimization.splitChunks`选项 [detail](https://gist.github.com/sokra/1522d586b8e5c0f5072d7565c2bee693)。
    - 无用代码现在由`webpack`自动处理。
        * Before: 在 `Uglify` 中处理无用代码。
        * 现在： `webpack` 默认处理。
        * 这可以防止无用代码中存在`import()`时出现错误。
        
  3. Syntax(语法):
    - 通过`import()`可以支持`webpackInclude`和`webpackExclude`。它们允许在使用动态表达式过滤文件。
    - 减少使用`System.import()`现在` 使用`System.import()`会发出警告。
        * 你可以配置 `Rule.parser.system: true` 禁用警告。
        * 配置 `Rule.parser.system: false`可以禁用 `System.import`。
  4. Configuration(配置)：
    - 现在可以使用`module.rules[].resolve`来配置解析。它将合并到全局配置中。
    - 在`production` 模式，`optimization.minimize` 默认打开； `development` 模式默认关闭。
  5. Usage(用法)：
    - 部分插件配置现在将被验证。
    - `CLI`已转移到`webpack-cli`，您需要安装`webpack-cli`才能使用`CLI`。
    - []
  6. Performance(性能提升)：
    - `UglifyJs` 现在默认进行缓存。
    - 多重性能改进，特别是对于频繁修改的文件的重新编译。
    - 对于`RemoveParentModulesPlugin`的性能改进。
  7. Stats(统计)：
    - 统计信息可以显示嵌套中的模块。

其他更多信息可以查看 [releases](https://github.com/webpack/webpack/releases)。

# 从 angular1.x 到 vue 再到 react 的心路历程

  网上有太多的文章去讨论目前前端三大框架的优缺点，其实有些时候可以说适合你的才是
最好的，没必要过多的纠结好或不好的问题。从开始的 ``jquery`` 的原生态开发到 ``angularjs``
的双向绑定再到部门技术选型从而切到 ``vuejs`` （从1到2）再到现在对 ``react``的尝试，
可谓是三大框架走了个遍。有些时候不得不感叹 `我圈真乱 斜眼笑`。

# 准备工作

  因为目前项目使用的 `vue` 框架，并且对 `vue` 相关项目配置有所了解，所以项目架构直接采用
`webpack + es2015 + react` 构建，并且采用手撸 `webpack` 配置加深印象。

## 创建项目

* ``mkdir react-map`` // 创建 react-map 文件夹
* ``cd react-map`` // 进入文件夹
* 使用 ``npm init`` 初始化项目，按需要进行配置。

## 安装依赖

* ``npm install webpack-cli webpack webpack-bundle-analyzer webpack-dev-server webpack-merge uglifyjs-webpack-plugin html-webpack-plugin extract-text-webpack-plugin optimize-css-assets-webpack-plugin friendly-errors-webpack-plugin --save-dev`` // 安装 webpack （目前已升级到 4）
* ``npm install react react-dom --save`` // 参考：https://facebook.github.io/react/docs/installation.html

| 包名 | 简介 | 作用 | 版本 |
| --- | --- | --- | --- |
| `webpack` | 模块打包器 | 对 `react` 项目的打包，`ES2015+` 的代码转换，静态资源处理等 | `^4.0.1` |
| `react` | js 框架 | `react` 基础框架 | `^16.2.0` |
| `react-dom` | 操作 DOM | 搭配 `react` 用了操作dom的 | `^16.2.0` |

因为需要采用 `es2015` 语法 所以还应当安装babel-loader以及其他相关依赖, 具体也可以参考 vue 项目配置。

* ``npm install babel-loader babel-core babel-preset-es2015 babel-preset-react babel-eslint --save-dev``

样式预处理器保持和现有项目保持一致，任然采用 ``scss``, 但是任然需要处理内联样式和 css 文件。

* ``npm install css-loader style-loader node-sass sass-loader --save-dev``

安装 ``eslint`` 相关

* ``npm install eslint eslint-config-airbnb eslint-plugin-babel eslint-plugin-import eslint-plugin-jsx-a11y eslint-plugin-react eslint-friendly-formatter --save-dev``

安装静态文件 loader 相关

* ``npm install url-loader file-loader portfinder --save-dev``
* ``npm install postcss-url postcss-loader postcss-import autoprefixer --save-dev``

## webpack 配置

> 编写对应的webpack 配置