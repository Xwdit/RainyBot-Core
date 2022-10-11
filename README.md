<div id="top"></div>
<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/Xwdit/RainyBot-Core/">
	<img src=".github/images/logo.png" alt="Logo" width="100" height="100">
  </a>

  <h3 align="center">RainyBot</h3>

  <p align="center">
	新手友好，功能强大，简单易上手的跨平台聊天机器人开发框架
	<br />
	<a href="https://github.com/Xwdit/RainyBot-Core/releases"><strong>立即下载</strong></a>
	<br />
	<br />
	<a href="https://docs.rainybot.dev">在线文档</a>
	 ·
	<a href="https://godoter.cn/t/rainybot">交流论坛</a>
	 ·
	<a href="https://godoter.cn/t/rainybot-plugins">插件市场</a>
	 ·
	<a href="https://godoter.cn/t/rainybot-tutorials">教程分享</a>
	·
	<a href="https://godoter.cn/t/rainybot-qa">问与答</a>
	·
	<a href="https://qm.qq.com/cgi-bin/qm/qr?k=1nKmcY2qdc-q2Q8BYkn1MyhHrfc3oZ58&jump_from=webapi">社区群聊</a>

  </p>
</div>


## 欢迎使用RainyBot!
[![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/Xwdit/RainyBot-Core?include_prereleases)](https://github.com/Xwdit/RainyBot-Core/releases)
[![Total Lines](https://img.shields.io/tokei/lines/github/Xwdit/RainyBot-Core)](https://github.com/Xwdit/RainyBot-Core)
[![Godot Engine](https://img.shields.io/badge/Powered%20By-Godot%20Engine%204.0-blue)](https://godotengine.org)
[![License](https://img.shields.io/github/license/Xwdit/RainyBot-Core)](LICENSE)
### 概览
RainyBot是一个跨平台的机器人开发框架，基于 [Godot Engine 4.0](https://godotengine.org/) 进行开发。 本项目成立的目的，是为了建立一个低门槛，简单易用的机器人开发框架。 通过提供大量精心设计，智能且极简的交互API与预置功能，结合[GDScript脚本语言](https://docs.godotengine.org/en/latest/tutorials/scripting/gdscript/gdscript\_basics.html)的简便语法， 来尽可能地提升开发效率且降低开发难度，且让更多开发经验不足，乃至无经验的用户也能够轻松开发属于自己的各类社交平台机器人应用。

例如，RainyBot为开发过程中常见的，诸如上下文的连续交互，命令/事件/关键词的注册，消息的构建等操作均提供了大量高度封装且人性化的API接口，可以通过极少的代码来实现复杂的功能。

并且，得益于[Godot Engine](https://godotengine.org/)强大的图形渲染能力，RainyBot拥有显著优于其他Bot的静态/动态图像生成功能；通过Godot引擎简单易用的编辑器，与RainyBot精心设计的极简图像生成相关API，您可以在几分钟内以极低的难度完成图像生成相关功能的开发。

RainyBot精心设计了一系列的便于使用的抽象API，并在底层将各类API调用关联到各个适配器并与对应的社交平台进行交互。目前，RainyBot通过WebSocket协议实现了基于[Mirai Api Http](https://github.com/project-mirai/mirai-api-http)的适配器，后者是[Mirai QQ](https://github.com/mamoe/mirai)的一个插件，允许开发者通过Http/Websocket等协议与[Mirai QQ](https://github.com/mamoe/mirai)进行交互，从而实现QQ平台机器人的相关功能。

对于各类性能关键的任务，RainyBot在内部均使用 [await异步](https://docs.godotengine.org/en/latest/tutorials/scripting/gdscript/gdscript\_basics.html#awaiting-for-signals)及多线程来保障高负载状态下的并发及消息吞吐量。并且， RainyBot的所有需要异步执行的API均灵活使用了[await](https://docs.godotengine.org/en/latest/tutorials/scripting/gdscript/gdscript\_basics.html#awaiting-for-signals)相关特性进行封装，从而实现单行代码即可进行异步任务的请求及结果获取。

### 功能特色

* 模块化设计，大部分API可独立于协议后端存在，通过不同适配器实现即可对接不同协议，实现一次编写多处运行 (当前支持[Mirai-Api-Http](https://github.com/project-mirai/mirai-api-http)协议后端)
* 简单易懂的配置与管理，一次配置完成后自动管理各个协议后端的配置/运行/连接，无需每次手动启动或进行设置
* 简单，完善，易用且智能的API，可通过极少代码实现复杂功能，且可自动根据传入内容的类型决定与机器人的交互行为；同时内置大量诸如上下文交互，关键词触发，事件阻塞一类的便捷功能
* 极易上手且极其强大的图像生成功能，可以通过内置场景编辑器可视化创建从简单的2D到复杂的3D的图像场景，并使用简单易用的API将插件与场景进行交互并生成静态/动态图像
* 灵活的插件管理机制，支持插件间交互/热重载/热编辑/依赖设定等功能，同时内置功能较为全面的插件编辑器，可便捷地即时开发与修改插件
* 人性化GUI控制台界面，全中文调试信息输出，并且可以轻松实现插件与GUI的交互（如自定义GUI界面，自定义控制台命令等)
* 开箱即用的各类辅助功能接口，无需操作文件读写，即可便捷初始化并管理插件配置，插件数据，事件/命令注册等
* 活跃的功能开发与问题修复，且将以社区为驱动，广泛采纳各类建议与需求，共同打造属于所有人的RainyBot


## 开始使用

请访问[RainyBot在线文档](https://docs.rainybot.dev)来获取有关使用RainyBot的各项说明，以及各项API的文档


### 从源码运行

如果您希望从项目源码顺利运行RainyBot，请确保遵循以下条目：
- 请使用 Godot-4.0.beta2 或以上版本的 [Godot Engine](https://github.com/godotengine/godot) 来打开本项目。
- 请将 [Mirai](https://github.com/mamoe/mirai) 与 [Mirai-Console](https://github.com/mamoe/mirai-console) 的`v2.12.3`版Jar文件及相关依赖文件置于*与Godot编辑器可执行文件同目录下*的`adapters/mirai/libs`路径中
- 请将 [Mirai-Api-HTTP](https://github.com/project-mirai/mirai-api-http) 的`v2.6.2`版Jar文件置于*与Godot编辑器可执行文件同目录下*的`adapters/mirai/plugins`路径中

RainyBot的[发布版本](https://github.com/Xwdit/RainyBot-Core/releases)中已包含以上所需文件，因此无需额外进行配置。若您在配置以上文件时遇到问题，可以直接从最新的发布版本文件包中复制`adapters`文件夹以及其中的内容，并置于*Godot编辑器可执行文件同目录下*即可。


## 主要功能开发路线图

- [x] 核心功能完备
- [x] 整理并将项目开源
- [x] 支持插件间依赖/加载顺序判断功能
- [x] 实现上下文交互功能
- [x] 实现关键词注册与触发功能
- [x] 完善事件系统，支持事件优先级与阻塞模式
- [x] 各类API大幅简化/智能化
- [x] 关键词相关功能的大幅改进
- [x] 上下文交互功能的大幅改进与简化
- [x] 完善Http请求功能，支持更多类型的请求与响应
- [x] 实现插件编辑器的自动补全与错误检查
- [x] 添加版本检测功能
- [x] 添加在线插件社区
- [x] 初步支持插件加载场景来实现可视化图片生成/GUI制作
- [x] 简化对内部图形相关API的调用
- [x] 为更多内置功能实现GUI化
- [x] 添加自动增量更新与自动修复功能
- [ ] 实现节点化的权限系统
- [ ] 支持通过聊天消息来使用命令系统
- [ ] 支持多机器人账号同时运行

对于更详细的功能计划，已知问题或功能建议，请访问储存库的 [Issues](https://github.com/Xwdit/RainyBot-Core/issues) 页面


## 贡献指南

我们非常感谢您有兴趣为本项目贡献源码来让它变得更好。对于代码贡献的流程，我们建议您遵循以下贡献指南：

1. 在您的储存库中Fork本项目
2. 创建一个您准备开发的功能或修复的问题的分支 (`git checkout -b feature/AmazingFeature`)
3. 提交您的更改 (`git commit -m '添加一些功能'`)
4. 将更改上传到您的储存库 (`git push origin feature/AmazingFeature`)
5. 在本项目储存库中打开一个此分支的Pull Request，来让我们看到并对其进行审阅


## 基于的项目

以下列表列出了本项目所基于的项目，使用本项目时请同时参考它们的许可信息。

* [Godot Engine](https://github.com/godotengine/godot)
* [Mirai-Api-HTTP](https://github.com/project-mirai/mirai-api-http)
* [Mirai](https://github.com/mamoe/mirai)


## 项目许可

项目基于AGPL-3.0许可进行开源，具体内容请参见[LICENSE文件](https://github.com/Xwdit/RainyBot-Core/blob/main/LICENSE)


## 联系信息

交流QQ群: 429787496

Xwdit - xwditfr@gmail.com

项目官网: [https://rainybot.dev](https://rainy.love/rainybot)

项目社区: [https://godoter.cn/t/rainybot](https://godoter.cn/t/rainybot)

项目开源地址: [https://github.com/Xwdit/RainyBot-Core](https://github.com/Xwdit/RainyBot-Core)


## 相关链接

此处提供了一些可能与本项目有关，或对您有帮助的链接

* [Godot使用文档](https://docs.godotengine.org/en/latest/)
* [GDScript语言教程](https://docs.godotengine.org/en/latest/tutorials/scripting/gdscript/)
* [Godot类参考API](https://docs.godotengine.org/en/latest/classes/index.html)
* [Mirai-Api-Http文档](https://github.com/project-mirai/mirai-api-http/blob/master/docs/api/API.md)
