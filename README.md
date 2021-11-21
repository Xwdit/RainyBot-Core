<div id="top"></div>
<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/Xwdit/RainyBot-Core/">
    <img src=".github/images/logo.png" alt="Logo" width="100" height="100">
  </a>

  <h3 align="center">RainyBot</h3>

  <p align="center">
    新手友好，简单易上手的跨平台聊天机器人开发框架
    <br />
    <a href="https://github.com/Xwdit/RainyBot-Core/releases"><strong>立即下载</strong></a>
    <br />
    <br />
    <a href="https://github.com/Xwdit/RainyBot-API">API文档</a>
    ·
    <a href="https://github.com/Xwdit/RainyBot-Core/issues">问题报告</a>
    ·
    <a href="https://github.com/Xwdit/RainyBot-Core/issues">功能请求</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>本页目录</summary>
  <ol>
    <li>
      <a href="#about-the-project">关于本项目</a>
      <ul>
        <li><a href="#built-with">基于的项目</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">开始使用</a>
      <ul>
        <li><a href="#prerequisites">运行需求</a></li>
        <li><a href="#installation">配置与使用</a></li>
      </ul>
    </li>
    <li><a href="#usage">插件示例</a></li>
    <li><a href="#roadmap">开发路线图</a></li>
    <li><a href="#contributing">向项目做出贡献</a></li>
    <li><a href="#license">项目许可</a></li>
    <li><a href="#contact">联系方式</a></li>
    <li><a href="#acknowledgments">知识库</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## 关于本项目

[![截图][product-screenshot]](https://github.com/Xwdit/RainyBot-Core/)

这是一个跨平台，跨协议 (实现中) 的机器人开发框架，基于 Godot Engine 4.0 进行开发。
本项目成立的目的，是为了建立一个低门槛，简单易用的机器人开发框架。
通过提供大量精心设计的交互API/预置功能，结合GDScript脚本语言的简便语法，
来尽可能地提升开发效率且降低开发难度，让更多开发经验不足，乃至无经验的用户也能够轻松开发属于自己的各类机器人应用。


功能特色:
* 模块化设计，大部分API可独立于协议后端存在，通过不同适配器实现即可对接不同协议，实现一次编写多处运行 (当前仅支持Mirai-Http协议后端)
* 简单易懂的配置与管理，配置完成后自动管理各个协议后端的配置/运行/连接，无需每次手动启动或进行设置
* 完善易用的API与插件管理机制，支持插件间交互/热重载/热编辑等功能，同时内置功能较为全面的插件编辑器 (暂不支持自动补全)
* 人性化GUI控制台界面，全中文调试信息输出，未来还将支持插件与GUI的交互（如自定义GUI界面)
* 开箱即用的各类辅助功能接口，可便捷初始化并管理插件配置，插件数据，事件/命令注册等
* 活跃的功能开发与问题修复，且将以社区为驱动，广泛采纳各类建议与需求，共同打造属于所有人的RainyBot
* 更多功能陆续增加中.....


注意：本项目仍处于较早期开发阶段，虽然目前核心功能已基本完备，但依然有在未经提前通知的基础上进行重大API/功能更改的可能，且可能存在未知的Bug/不稳定因素，请谨慎用于生产环境。


<p align="right">(<a href="#top">返回顶部</a>)</p>



### 基于的项目

以下列表列出了本项目所基于的项目，使用本项目时请同时参考它们的许可信息。

* [Godot Engine](https://github.com/godotengine/godot)
* [Mirai-Api-HTTP](https://github.com/project-mirai/mirai-api-http)
* [Mirai](https://github.com/mamoe/mirai)

<p align="right">(<a href="#top">返回顶部</a>)</p>



<!-- GETTING STARTED -->
## 开始使用

接下来的部分将介绍如何配置与使用RainyBot

### 运行需求

支持的操作系统：Windows 7 或以上版本 (Mac OS/Linux支持将在后续版本中添加)

Java 版本 >= 11 (此需求来源于RainyBot默认集成的Mirai协议后端，核心无需任何运行环境)

可选：支持Vulkan渲染器的图形卡 (可通过硬件加速提升性能)

### 配置与使用

1. 从GitHub发布页下载最新的发布版本: <a href="https://github.com/Xwdit/RainyBot-Core/releases"><strong>立即下载</strong></a>
2. 运行RainyBot，随后按照控制台显示的说明，打开指定的配置文件进行配置
3. 配置完毕后请重新启动RainyBot。此时若配置正确，将自动开始加载内置的协议后端（当前版本内置了Mirai协议库)
4. 请留意 *协议后端* 的控制台信息，可能会要求您进行登陆验证等操作，请检查不同协议后端的文档来获取相关帮助
5. 若一切顺利，协议后端的控制台中将出现中文或英文的登录成功/加载成功字样，且RainyBot控制台中将出现加载成功字样
6. 此时起可最小化协议后端的控制台窗口，后续操作均只需在RainyBot控制台中进行即可。从此处开始，将直接使用“控制台”来表示RainyBot的控制台界面
7. 在控制台中输入指令help(或/help)来查看所有可用的控制台指令，如输入/plugins可查看插件管理相关指令
8. 恭喜！您成功完成了RainyBot的基本配置，开始尽情使用吧~

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap

- [x] Add Changelog
- [x] Add back to top links
- [ ] Add Additional Templates w/ Examples
- [ ] Add "components" document to easily copy & paste sections of the readme
- [ ] Multi-language Support
    - [ ] Chinese
    - [ ] Spanish

See the [open issues](https://github.com/othneildrew/Best-README-Template/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Your Name - [@your_twitter](https://twitter.com/your_username) - email@example.com

Project Link: [https://github.com/your_username/repo_name](https://github.com/your_username/repo_name)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

Use this space to list resources you find helpful and would like to give credit to. I've included a few of my favorites to kick things off!

* [Choose an Open Source License](https://choosealicense.com)
* [GitHub Emoji Cheat Sheet](https://www.webpagefx.com/tools/emoji-cheat-sheet)
* [Malven's Flexbox Cheatsheet](https://flexbox.malven.co/)
* [Malven's Grid Cheatsheet](https://grid.malven.co/)
* [Img Shields](https://shields.io)
* [GitHub Pages](https://pages.github.com)
* [Font Awesome](https://fontawesome.com)
* [React Icons](https://react-icons.github.io/react-icons/search)

<p align="right">(<a href="#top">back to top</a>)</p>


[product-screenshot]: .github/images/screenshot.png
