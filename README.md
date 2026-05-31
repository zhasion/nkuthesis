

<div align="center">
<h1 >Nankai University Thesis LaTeX Template</h1>
<h3 >🎓南开大学毕业论文LaTeX模板</h3>
<p ><strong>Version v2026.5</strong></p>
<br>
<div align="center">
<img src='https://img.shields.io/badge/Thesis-PhD-a8211e.svg?&logoColor=white&style=flat-square'>
<img src='https://img.shields.io/badge/Thesis-Master-1d74a6.svg?style=flat-square'>
<!-- <a href=''><img src='https://img.shields.io/badge/Thesis-Bachelor-000000.svg?style=flat-square'></a> -->
<img src='https://img.shields.io/badge/TeXLive->=2019-476727.svg?style=flat-square'>
<a href="https://github.com/zhasion/nkuthesis/releases"><img src='https://img.shields.io/github/v/tag/zhasion/nkuthesis?style=flat-square&label=Version'></a>
<a href="https://www.latex-project.org/lppl/lppl-1-3c/"><img src='https://img.shields.io/badge/License-LPPL%20v1.3c-ea7233?style=flat-square'></a>
</div>
<br>
<p>
  <a href="https://github.com/zhasion/nkuthesis/archive/refs/tags/v2026.5.zip">
    <img src="https://img.shields.io/badge/下载latex模板-7f386d?style=for-the-badge&logo=github&logoColor=white" />
  </a>
  &nbsp;
  <a href="">
    <img src="https://img.shields.io/badge/下载硕博word模板（即将）-1557bb?style=for-the-badge&logo=github&logoColor=white"/ >
  </a>
  &nbsp;
  <a href="https://www.texpage.com/zh/template/e1103083-53b0-4c08-9b86-36c2d1de065f">
    <img src="https://img.shields.io/badge/TeXpage模版-495a80?style=for-the-badge&logo=latex&logoColor=white" />
  </a>
  &nbsp;
  <a href="https://www.overleaf.com/">
    <img src="https://img.shields.io/badge/打开Overleaf-47a141?style=for-the-badge&logo=overleaf&logoColor=white" />
  </a>
</p>
        <a href="https://github.com/zhasion/nkuthesis/releases/latest/download/main.pdf">     <img src="https://img.shields.io/badge/硕博-示例PDF-red?style=for-the-badge&"></a>
    <a href="https://github.com/zhasion/nkuthesis/releases/latest/download/main-bachelor.pdf">     <img src="https://img.shields.io/badge/本科-示例PDF-red?style=for-the-badge&"></a>
    <a href="https://github.com/zhasion/nkuthesis/issues/new">     <img src="https://img.shields.io/badge/反馈问题-Report_Bug-red?style=for-the-badge&logo=githubissues&logoColor=white"></a>
<br><br>
    <p align='center'>
        如果您觉得模板对您有帮助，还请给我点一个star ⭐ 关注更新，谢谢！
    </p>
<br>
</div>




## 说明

本模板参照南开大学学位论文写作规范编写，旨在建立一个简单易用的南开大学学位论文 LaTeX 模板。

模板仅支持使用 XeLaTeX 编译，目前仅支持中文论文。经 TeXPage 测试，本模板支持 TeX Live 2019 及以上版本的编译。

模板主要涵盖硕博毕业论文，并为本科毕业论文预留了接口。硕博部分**已适配《南开大学研究生学位论文写作规范（2026版）》**；本科部分已提供可编译示例，但不同学院要求可能不统一，使用前建议自行核对。

如果你是直接下载压缩包而不是使用 Git，建议优先使用 README 顶部的下载按钮或 [Releases](https://github.com/zhasion/nkuthesis/releases/latest) 页面中的最新版本。



**如果使用中发现模板存在格式错误等问题，请创建**[Issue](https://github.com/zhasion/nkuthesis/issues)**说明问题，一起完善**！也建议使用搜索引擎或各种Chatbot。

> [!Warning]
>
> **免责声明：** 本模板旨在为您的论文写作提供便利，但作者不保证其完全符合学校或各学院的具体要求，亦不对因使用本模板所产生的任何后果承担责任。**如不认同上述内容，请勿使用本模板。**



## 字体兼容问题

- **Windows 本地编译**：一般无需任何配置，开箱即用
- **macOS / Linux / Overleaf**：系统字体与 Windows 存在差异，可能影响排版细节

> ✅ 即使不配置字体，模板也能正常编译通过，仅在笔画细节上与标准 Windows 环境略有差异（会有字体提醒）。



如果你希望在 `macOS` / `Linux` 本地编译时尽量接近 Windows 下的中文字体效果，推荐方案：

1. **使用 [TeXPage](https://www.texpage.com/)**：平台内置标准 Windows 字体，无需手动配置。
2. **手动放入字体文件**：将 `simsun.ttc`、`simhei.ttf`、`simfang.ttf`、`simkai.ttf` 放入 `fonts/` 目录。更详细的说明请参考：[fonts/README.md](./fonts/README.md)



## 1. 项目文件结构

```
.
├── nkuthesis.cls          			# 模板核心文件
├── main.tex               			# 硕博主文档（在此修改个人信息和内容）
├── main.bib               			# 参考文献数据库
├── main-bachelor.tex               # 本科主文档（在此修改个人信息和内容）
├── data/                  			# 章节内容文件夹（建议）
│   ├── abstract.tex       			# 中英文摘要
│   ├── introduction.tex   			# 绪论
│   ├── relatedwork.tex    			# 相关工作
│   ├── methods.tex        			# 方法
│   ├── experiments.tex    			# 实验
│   ├── acknowledgements.tex 		# 致谢
│   └── resume.tex         			# 个人简历
├── assets/                  		# 一些资产文件（请勿删除）
├── figures/                  		# 图片文件夹（建议使用pdf或png格式）
└── fonts/                 			# 可选：按需放入 Windows 字体（目录可留空）
```



## 2. 快速开始

### 2.1 编译器选择

本模板必须使用 `XeLaTeX` 引擎编译，参考文献需配合 `biber` 处理。

**推荐**使用在线编译平台（无需配置环境，开箱即用，下载模版压缩包上传平台即可）：

- [**TeXPage**](https://www.texpage.com/)：国内访问更稳定，原生支持中文模板。
- [**Overleaf**](https://www.overleaf.com/)：新建项目时选择 “XeLaTeX” 作为编译器。（编译容易超时）



如需本地编译，请根据操作系统进行配置（具体步骤可自行搜索）：

- **Windows 本地编译**：安装 [**TeX Live**](https://www.tug.org/texlive/acquire-netinstall.html) 或 [**MiKTeX**](https://miktex.org/download)（建议安装完整版，以免缺少常用宏包）
- **Mac 本地编译**：安装 [**MacTeX**](https://www.tug.org/mactex/) 

- 本地编译推荐使用 [**VS Code**](https://code.visualstudio.com/) + [**LaTeX Workshop 插件**](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop)



### 2.2 编译方式

本模板**必须使用 XeLaTeX** 编译，并配合 `biber` 处理参考文献。**推荐编译命令：**

```shell
# 第一次编译：生成辅助文件
xelatex main.tex
# 处理参考文献
biber main
# 两次编译：确保交叉引用正确
xelatex main.tex
xelatex main.tex
```

或者使用

```shell
latexmk main   # 编译
latexmk -c     # 清理编译文件
```

或在 Overleaf / TeXPage 等在线平台选择 **XeLaTeX** 编译引擎。



### 2.3 学位类型和编号方式

本科使用 `main-bachelor.tex` ，不需要额外设定，默认如下：

```latex
% 学士
\documentclass[bachelor]{nkuthesis}
```

> 本科直接使用 `main-bachelor.tex` 编译即可，无需替换 `main.tex`。

硕博在 `main.tex` 的 `\documentclass` 中指定：

```latex
% 硕士（当前示例）
\documentclass[master, chinesenumber]{nkuthesis}
```

- 可选学位：`master`（硕士，默认）、`doctor`（博士）
- 章节编号样式：`chinesenumber`（第一章样式，默认）或 `arabicnumber`（1.1 样式）



### 2.4. 个人信息填写

所有个人信息通过 `\nkusetup{}` 统一设置（在模版中已有），请根据情况进行个人信息填写，例如：

```latex
\nkusetup{
  论文题目(中文) = {},
  论文题目(英文) = {}
  ...
}
```

**注意**：

- 指导教师姓名与职称之间用 `\quad` 分隔表示空格
- 学位、密级、论文类别等有选项列表，若填写错误会在编译时提示，请注意查看



## 3. 论文内容编写

默认使用模版的用户会基本LaTeX语法，关于图片、表格插入可以参考模版自带示例。

深入学习LaTeX可以参考[一份（不太）简短的 LATEX 2ε 介绍](https://texdoc.org/serve/lshort-zh-cn.pdf/0)



### 3.1 预置页面命令

使用以下命令可以在文中插入相应页面。

| 命令                                 | 用途                                           |
| ------------------------------------ | ---------------------------------------------- |
| `\maketitlepage`                     | 硕博题名页                                     |
| `\anonymoustitlepage`                | 硕博匿名评阅封面                               |
| `\declarationpage`                   | 硕博学位论文原创性声明和非公开学位论文标注说明 |
| `\authorizationpage`                 | 硕博学位论文使用授权书                         |
| `\bibliographypage`                  | 参考文献页                                     |
| `\tableofcontents`                   | 目录页                                         |
| `\listoffigures`                     | 插图清单页                                     |
| `\listoftables`                      | 表格清单页                                     |
| `\makebachelortitlepage`             | 本科标题封面                                   |
| `\makebachelordoubledegreetitlepage` | 本科双学位标题封面                             |
| `\bachelordeclarationpage`           | 本科声明页面                                   |
| `\appendix`                          | 附录                                           |


### 3.1.1 常用设置

以下设置不直接生成页面，但在打印或本科封面调整时可能用到。

- `\useprint`：放在 `\begin{document}` 前，启用双面打印补空白页。
- `信息左对齐 = {是}`：写在 `\nkusetup{}` 中，将本科封面信息改为左对齐。



### 3.2 摘要

在`data/abstract.tex`文件中进行内容填写。

中文摘要：`abstract` 环境，英文摘要：`abstract*` 环境。

关键词通过 `\nkusetup` 中的 `keywords` 和 `keywords*` 设置。



### 3.3 正文

正文内容建议按章节拆分放入 `data/` 文件夹，在 `main.tex` 中使用 `\include{}` 引入：

```latex
\mainmatter
\include{data/introduction}
\include{data/relatedwork}
...
```



### 3.4 参考文献

参考文献数据库默认文件为 `main.bib`，使用其他文件在`main.tex`中修改。在文中使用 `\cite{}` 引用。

```latex
\addbibresource{main.bib} % 修改名字
```



## 4 常见问题❓ 

**Q: 编译时报错 `fontspec` 找不到字体？**  

A: 请参考上方 [字体兼容问题](#字体兼容问题) 章节。

**Q: 参考文献不显示？**  

A: 请确保使用了 `biber main` 命令，且 `main.bib` 中有对应的文献条目。

**Q: 本科和硕博模板有什么区别？**  

A: 硕博模板严格遵循 2026 版规范；本科模板参考了相关文件，但建议与学院要求核对。

**Q: 如何修改页眉页脚？**  

A: 模板已按规范预设，不建议修改。如有特殊需求，可查看 `nkuthesis.cls` 中的相关定义。



## 5 更新记录

建议按时间倒序维护，记录模板的重要调整、适配范围变化和新增功能。

- `2026-05-26`：补充项目地址、首次使用说明与常用开关说明；新增硕士匿名页与打印选项说明；新增 `fonts/` 目录说明；优化 `data/` 中摘要、模板使用说明、可选功能、附录等示例内容；修正若干文案与拼写问题。
- `2026-03-15`：发布 `2026版`，硕博部分适配《南开大学研究生学位论文写作规范（2026版）》。



## 6 规范文档记录

本模板的格式依据和适配状态记录如下，后续若学校或学院更新要求，建议在这里同步补充。

本科部分参考《本科生论文格式要求补充规定2023V2》及《南开大学本科毕业论文（设计）指导手册（2025）》编写了部分接口。由于相关规定存在冲突，且部分内容缺乏严格格式要求，部分设定会沿用硕博格式；使用时请结合学院要求仔细对比。

如果本地文件不是通过 Git 更新，升级时建议对比当前 README 顶部显示的版本号与 [Releases](https://github.com/zhasion/nkuthesis/releases) 页面中的最新版本。若不是最新版本，通常建议重新下载并替换更新，至少同步替换 `nkuthesis.cls`。


| 类型 | 年份 | 文档名称 | 当前状态 | 备注 |
| --- | --- | --- | --- | --- |
| 研究生 | 2026 | 《南开大学研究生学位论文写作规范（2026版）》 | 已参考 | 当前硕博部分主要依据 |
| 本科 | 2025 | 《南开大学本科毕业论文（设计）指导手册（2025）》 | 已参考 | 本科部分参考 |
| 本科 | 2023 | 《本科生论文格式要求补充规定2023V2》 | 已参考 | 本科部分参考 |




## License

本项目采用 [LaTeX项目公共许可证 v1.3c](https://www.latex-project.org/lppl/lppl-1-3c/) 授权。您可以在遵守许可证的前提下自由使用、修改和分发本模板，但修改后的文件需更改名称，避免与原始模板混淆。



## 致谢

写这个项目是一个学习过程，在编写过程中参考了先前模板 [NKThesis](https://github.com/NewFuture/NKThesis) 中的中文键值对实现方式，并借鉴了 [thuthesis](https://github.com/tuna/thuthesis) 的部分格式（也是在这里发现TeXPage支持Windows字体）。此外，还对 [nkthesis](https://github.com/alumik/nkthesis) 中的部分语法进行了学习与参考。



## 为什么做这个项目

最初我用 Microsoft Word 写毕业论文时，发现引用和数学公式的编辑体验并不理想，就想着找一个 LaTeX 模板进行迁移。但是现有的模板大多参照学校几年前的规范，要是有改动我也难以自行调整，最关键的是找不到当年的规范文档，无法逐一核对。也有少数模板维护得比较及时，但在 Overleaf 上编译时常超时；本地使用时，这些模板对 macOS 也不太友好，一上来就是字体报错，还得去 Windows 系统里找字体，在Windows上对编译版本也有较高要求（懒得重新安装）。然后一时兴起，就花了一些时间边写边学，借助 AI 辅助完成了这个模板。

相较于之前的模板，本模板支持较老版本的本地编译；不强制要求不同平台安装特定字体，至少能保证一次编译成功。

不过后来发现，上述所有问题其实都可以直接用 TeXPage 在线编译解决，所以这个项目也算是**重复造轮子**了。
