% Copyright (c) 2026 Zhang Xin. All rights reserved.
% This work may be distributed and/or modified under the conditions of the LaTeX Project Public License.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{nkuthesis}[2026/03/15 v2026.3.15 Nankai University Thesis Template]

% ------------------------------
% 判断xetex引擎
% ------------------------------
\makeatletter
\RequirePackage{ifxetex}                      % 判断编译引擎
\ifxetex \else
  \ClassError{nkuthesis}{%
      This class requires XeLaTeX to compile.%
  }{%
      Please use XeLaTeX engine instead of pdfLaTeX or LuaLaTeX.%
  }
  % 停止，等待用户切换，\expandafter先读取\fi再执行\endinput
  \expandafter\endinput 
\fi


% ------------------------------
% 定义选项
% ------------------------------
\RequirePackage{etoolbox}                     % latex编程逻辑工具

% 定义学位选项
\newcommand{\nku@degree}{none}                % 默认值
\DeclareOption{bachelor}{\renewcommand{\nku@degree}{bachelor}}
\DeclareOption{master}{\renewcommand{\nku@degree}{master}}
\DeclareOption{doctor}{\renewcommand{\nku@degree}{doctor}}

% 定义章节编码方式选项
\newif\ifnku@numberstyle@arabic               % 阿拉伯数字风格
\newif\ifnku@numberstyle@chinese              % 汉字数字风格
\nku@numberstyle@chinesetrue                  % 默认使用汉字数字风格

\DeclareOption{arabicnumber}{
    \nku@numberstyle@arabictrue
    \nku@numberstyle@chinesefalse}
\DeclareOption{chinesenumber}{
    \nku@numberstyle@chinesetrue
    \nku@numberstyle@arabicfalse}

\newif\ifprint\printfalse                     % 是否打印模式
\DeclareOption{print}{\printtrue}

\ProcessOptions\relax  % ← 选项处理到此结束

% 上面只是定义，下面进行检查逻辑
\newif\ifisbachelor\isbachelorfalse
\newif\ifismaster\ismasterfalse
\newif\ifisdoctor\isdoctorfalse

\ifdefstring{\nku@degree}{bachelor}{\isbachelortrue}{}
\ifdefstring{\nku@degree}{master}{\ismastertrue}{}
\ifdefstring{\nku@degree}{doctor}{\isdoctortrue}{}
\ifdefstring{\nku@degree}{none}{%
  \ismastertrue
  \PackageWarning{nkuthesis}{未指定学位类型，默认使用硕士}%
}{}

\newcommand{\useprint}{
  \printtrue
}

% ------------------------------
% 基类设置
% ------------------------------
% 在加载xeCJK之前确认使用伪粗体
\PassOptionsToPackage{AutoFakeBold=3.0}{xeCJK}
\LoadClass[
  zihao=-4,                                   % 小四号字
  scheme=chinese,                             % 中文模式
  fontset=none,                               % 先不加载字体
  openany,                                    % 允许章节从任意页开始（不强制右页）
]{ctexbook}                                   % 基于ctexbook，自动处理字体


% ------------------------------
% 常用宏包导入
% ------------------------------
\RequirePackage{fontspec}                     % 字体设置相关（在loadclass之后使用）
\RequirePackage{graphicx}                     % 插图功能，支持\includegraphics命令
\RequirePackage{caption}                      % 自定义图表标题格式，控制标题字体、间距、编号样式
\RequirePackage{calc}                         % 长度计算
\RequirePackage{fancyhdr}                     % 页眉页脚设置
\RequirePackage{lineno}                       % 设置行号显示
\RequirePackage{kvoptions}                    % 基于xkeyval封装的选项处理工具
\RequirePackage{float}                        % 用于控制浮动体位置
\RequirePackage{multirow}                     % 表格跨行合并
\RequirePackage{makecell}                     % 用于在表格中显示多行文本
\RequirePackage{silence}                      % 去掉部分warning
\RequirePackage{pifont}                       % 特殊符号字体，提供带圈数字等符号
\RequirePackage{emptypage}                    % cleardoublepage的时候清理页面
\RequirePackage{geometry}                     % 页面设置（loadclass之后）
\RequirePackage{titletoc}                     % 目录格式定制，控制目录标题样式
\RequirePackage{amsmath}                      % AMS数学公式增强，提供丰富的数学环境
\RequirePackage{amsthm}                       % 定理环境，提供定理、证明等环境
\RequirePackage{setspace}                     % 行距设置，提供\linespread和\setstretch命令
\RequirePackage{amssymb}                      % AMS符号扩展，提供更多数学符号
\RequirePackage{array}                        % 表格增强，提供更多列格式选项
\RequirePackage{color}                        % 颜色支持，定义和使用颜色
\RequirePackage{listings}                     % 代码列表，支持代码高亮和格式化
\RequirePackage{ulem}                         % 下划线增强，提供\uline等下划线命令
\RequirePackage{CJKfntef}                     % CJK下划线，支持中文下划线效果
\RequirePackage{hyperref}                     % 超链接支持，生成PDF书签和交叉引用链接
\RequirePackage{cleveref}                     % 智能交叉引用，自动识别引用类型
\RequirePackage{enumitem}                     % 枚举enumerate设置
\RequirePackage{booktabs}                     % 提供高质量的表格线
\RequirePackage[table]{xcolor}                % 提供表格颜色支持 


% ------------------------------
% 字体设置
% ------------------------------
% 辅助宏：检查一组字体是否全部存在
\newif\if@nku@allfonts

\newcommand{\nku@check@fonts}[1]{%
  \@nku@allfontstrue
  \@for\@nku@fontname:=#1\do{%
    \if@nku@allfonts
    \IfFontExistsTF{\@nku@fontname}{}{\@nku@allfontsfalse}%
    \fi
  }%
}

% 检查本地 fonts 目录
\newif\ifuselocalwindowsfonts\uselocalwindowsfontsfalse
\newif\if@nku@localallfonts\@nku@localallfontstrue
\IfFileExists{fonts/simsun.ttc}{}{\@nku@localallfontsfalse}
\IfFileExists{fonts/simhei.ttf}{}{\@nku@localallfontsfalse}
\IfFileExists{fonts/simfang.ttf}{}{\@nku@localallfontsfalse}
\IfFileExists{fonts/simkai.ttf}{}{\@nku@localallfontsfalse}
\if@nku@localallfonts
  \uselocalwindowsfontstrue
  \typeout{nkuthesis: 检测到本地 fonts 目录 Windows 字体}
\fi

% 检查系统是否自带windows字体，比如texpage
\newif\ifusesystemwindowsfonts\usesystemwindowsfontsfalse
\ifuselocalwindowsfonts\else
  \nku@check@fonts{SimSun,SimHei,FangSong,KaiTi}
  \if@nku@allfonts
    \usesystemwindowsfontstrue
    \typeout{nkuthesis: 检测到系统 Windows 字体}
  \fi
\fi

\ifusesystemwindowsfonts
  \ctexset{fontset=windows}
\else \ifuselocalwindowsfonts
  \setCJKmainfont{simsun.ttc}[Path = fonts/] % 主字体（宋体）
  \setCJKsansfont{simhei.ttf}[Path = fonts/] % 无衬线字体（黑体）
  \setCJKmonofont{simkai.ttf}[Path = fonts/] % 等宽字体（可以用仿宋或楷体）
  \setCJKfamilyfont{zhsong}{simsun.ttc}[Path = fonts/]
  \setCJKfamilyfont{zhhei}{simhei.ttf}[Path = fonts/]
  \setCJKfamilyfont{zhkai}{simkai.ttf}[Path = fonts/]
  \setCJKfamilyfont{zhfs}{simfang.ttf}[Path = fonts/]
  \newcommand{\songti}{\CJKfamily{zhsong}}
  \newcommand{\heiti}{\CJKfamily{zhhei}}
  \newcommand{\kaishu}{\CJKfamily{zhkai}}
  \newcommand{\fangsong}{\CJKfamily{zhfs}}
  % \setCJKfamilyfont{zhsongcu}{\songtifont}[Path = fonts/, AutoFakeBold=7.5]
  % \newcommand{\songticu}{\CJKfamily{zhsongcu}}
\else
  \PackageWarning{nkuthesis}{您现在使用的平台不包含Windows下的 [宋体｜黑体｜仿宋｜楷体]，当前使用字体可能和官方模版有细微差异！}%
  \ctexset{fontset}
\fi\fi

\setmainfont{Times New Roman}                 % 设置罗马字体\rmfamily 或 \textrm{}
\setsansfont{Arial}                           % 设置无衬线字体\sffamily 或 \textsf{}
\hbadness=10000                               % 忽略所有 行内过满 的警告（10000=最大值）
\hfuzz=100pt                                  % 增加容差阈值

% ------------------------------
% 页面基本设置
% ------------------------------
\raggedbottom                                 % 允许页面底部不对齐
\geometry{                                    % 设置页边距、页眉页脚距离
    a4paper,
    top=3.8cm,
    bottom=3.8cm,
    left=3.2cm,
    right=3.2cm,
    headheight=0.5cm,
    headsep=0.3cm,
    footskip=0.8cm,
    bindingoffset=0cm
}

\fancyhf{}                                    % 清除所有默认页眉页脚设置
\fancypagestyle{nku@main}{                    % 定义南开页眉页脚格式
  \fancyhf{}                      
  \fancyhead[C]{\zihao{5}\songti\leftmark}
  \fancyfoot[C]{\zihao{5}\songti\thepage}
  \renewcommand{\headrulewidth}{0.4bp}
}
\pagestyle{nku@main}

\fancypagestyle{plain}{                       % 设置章节首页包含页眉
  \fancyhf{}                      
  \fancyhead[C]{\zihao{5}\songti\leftmark} 
  \fancyfoot[C]{\zihao{5}\songti\thepage}
  \renewcommand{\headrulewidth}{0.4bp}
}

% 小四号(12bp)对应的单倍行距约为 20bp
% 使用 \linespread 设置倍率，而非硬编码 \baselineskip
% 20bp / (12bp * 1.2) = 1.389 （1.2 是 LaTeX 默认 \baselinestretch 对应的系数）

\AtBeginDocument{
  % \setstretch{1.389}
  \linespread{1.0}                           % 设定单倍行距
  \setlength{\baselineskip}{20.0bp}            % 设定基线间距
  \setlength{\parskip}{0bp}                  % 确保段落之间没有额外空行
  % \setlength{\lineskiplimit}{0bp}            % 下面这两行防止 LaTeX 自动增加行间隙
  % \setlength{\lineskip}{0bp}
  \setlength{\parindent}{2em}
}


% ------------------------------
% 行号设置，暂时无用
% ------------------------------
\renewcommand\linenumberfont{\normalfont\tiny\sffamily\color{gray}}
\setlength\linenumbersep{12pt}


% ------------------------------
% nkusetup 键值解析（xkeyval）
% ------------------------------
% 定义键值对
\def\nku@definekey#1#2{
  \expandafter\def\csname nku@key@#2\endcsname{}
  \define@key{nku@key}{#1}{
    \expandafter\def\csname nku@key@#2\endcsname{##1}}}

\def\nkuget#1{\csname nku@key@#1\endcsname}

% 摘要关键词信息
\nku@definekey{keywords}{keywords}
\nku@definekey{keywords*}{keywords@en}

% 封面信息
\nku@definekey{中图分类号}{classification}       
\nku@definekey{UDC}{udc}                     
\nku@definekey{学校代码}{schoolcode}
\nku@definekey{密级}{security}    
\nku@definekey{题名页/论文类别}{thesistype}      

% 封面基本信息
\nku@definekey{论文题目(中文)}{titlecn}
\nku@definekey{论文题目(英文)}{titleen}
\nku@definekey{论文作者}{author}
\nku@definekey{指导教师}{supervisor}
\nku@definekey{申请学位}{degree}
\nku@definekey{培养单位}{department}
\nku@definekey{学科专业}{major}
\nku@definekey{研究方向}{research}
\nku@definekey{答辩委员会主席}{chairman}
\nku@definekey{评阅人}{reviewer}
\nku@definekey{论文完成时间}{date}

% 原创性声明页面
\nku@definekey{申请密级}{applysecurity}
\nku@definekey{保密开始时间}{securitystart}
\nku@definekey{保密结束时间}{securityend}
\nku@definekey{审批表编号}{applyid}
\nku@definekey{批准日期}{approvedate}

% 授权页面
\nku@definekey{学号}{studentid}
\nku@definekey{答辩日期}{defensedate}
\nku@definekey{作者信息/论文类别}{thesistype2}  
\nku@definekey{联系电话}{phone}
\nku@definekey{电子邮箱}{email}
\nku@definekey{通信地址(邮编)}{address}
\nku@definekey{非公开论文编号}{nonpublicid}
\nku@definekey{备注}{remark}

% 匿名评审页（硕士博士）
\nku@definekey{一级学科}{firstsubject}
\nku@definekey{二级学科}{secondsubject}
\nku@definekey{论文编号}{paperid}

% 匿名评审页（硕士专业/博士专业）
\nku@definekey{专业学位类别}{profmajor}
\nku@definekey{专业领域}{proffield}
\nku@definekey{学位论文/实践成果编号}{profpaperid}

% 本科部分
\nku@definekey{年级}{bachelorgrade}
\nku@definekey{专业}{bachelormajor}
\nku@definekey{系别}{bachelordepartment}
\nku@definekey{学院}{bachelorcollege}
\nku@definekey{完成日期}{bachelorfinishdate}
\nku@definekey{指导教师(副)}{cosupervisor}
\nku@definekey{信息左对齐}{bachelorinfoleftalign}
\nku@definekey{双修专业}{doublemajor}
\nku@definekey{双修院系}{doublecollege}

% 公开就不填写非公开标注信息，直接空白；非公开则填写信息并打钩
\newif\ifissecurity\issecurityfalse
\newif\ifiscosupervisor\iscosupervisortrue
\newif\ifisbachelorinfoleftalign\isbachelorinfoleftalignfalse

% 定义必填项检查宏
\newcommand{\checkrequired}[2]{%
  \expandafter\ifx\csname nku@key@#1\endcsname\empty
    \PackageWarning{nkuthesis}{必填项 [#2] 未填写，请在 \string\nkusetup 中设置}%
  \fi
}

\newcommand{\nkusetup}[1]{%
  \setkeys{nku@key}{#1}%
  % 严谨的范围判断
  \IfStrEqCase{\nkuget{applysecurity}}{%
    {公开}{\issecurityfalse}%
    {限制}{\issecuritytrue}%
    {秘密}{\issecuritytrue}%
    {机密}{\issecuritytrue}%
    {}{}%
  }[%
    \PackageWarning{nkuthesis}{未知的密级: \nkuget{applysecurity}，将视为公开}%
    \issecurityfalse 
  ]%
  \IfStrEqCase{\nkuget{thesistype}}{{硕士}{}{博士}{}{硕士专业}{}{博士专业}{}{}{}}[%
    \PackageError{nkuthesis}{未知的论文类别: [\nkuget{thesistype}] 可选项为 [硕士/博士/硕士专业/博士专业]}{请检查类别设置}%
  ]%
  \IfStrEqCase{\nkuget{thesistype2}}{{学术博士}{}{专业学位博士}{}{学术硕士}{}{专业学位硕士}{}{同等学力硕士}{}{}{}}[%
    \PackageWarning{nkuthesis}{未知的作者信息/论文类别: [\nkuget{thesistype2}] 可选项为 [学术博士/专业学位博士/学术硕士/专业学位硕士/同等学力硕士]}{请检查类别设置}%
  ]%
  \IfStrEqCase{\nkuget{cosupervisor}}{{}{\iscosupervisorfalse}}[\iscosupervisortrue]%
  \IfStrEqCase{\nkuget{bachelorinfoleftalign}}{{是}{\isbachelorinfoleftaligntrue}}[\isbachelorinfoleftalignfalse]%

  % \StrSubstitute{\nkuget{supervisor}}{,}{\quad}
}


% ------------------------------
% 设置标题格式
% ------------------------------
\newcommand{\chapterformat}{\zihao{3}\bfseries\heiti\centering}                        % 黑体16磅加粗居中
\newcommand{\sectionformat}{\zihao{4}\bfseries\heiti\centering}                        % 黑体14磅加粗居中
\newcommand{\subsectionformat}{\fontsize{13bp}{20.28bp}\selectfont\heiti\raggedright}   % 黑体13磅加粗居中 # TODO:18.2bp
\newcommand{\subsubsectionformat}{\zihao{-4}\heiti\raggedright}                        % 黑体12磅加粗居中

% 其他地方可以单独设置章节居中，黑体16磅加粗居中
\newcommand{\setchaptercenter}{\ctexset{chapter = {format= \chapterformat}}}

\ctexset{
  % 章标题
  chapter = {
    format     = \chapterformat,
    name       = {第,章},
    number     = \chinese{chapter},
    aftername  = \hspace{1em},              % 空一个汉字符
    beforeskip = 24bp + 3bp,                      % 段前24磅
    afterskip  = 18bp + 8bp,                % 段后18磅
    fixskip  = true,                        % 固定间距
  },
  % 一级标题（节）
  section = {
    format     = \sectionformat,
    name       = {第,节},
    number     = \chinese{section},
    aftername  = \hspace{1em},             
    beforeskip = 24bp + 10bp,                 
    afterskip  = 6bp + 10bp,              
    fixskip  = true,
  },
  % 二级标题（小节）
  subsection = {
    format     = \subsectionformat,
    name       = {,、},
    number     = \chinese{subsection},
    indent     = 2em,      
    aftername  = \hspace{1em}, 
    beforeskip = 12bp + 10bp,         
    afterskip  = 6bp + 10bp,       
    fixskip  = true,
  },
  % 三级标题
  subsubsection = {
    format     = \subsubsectionformat,
    name       = {（,）},
    number     = \chinese{subsubsection},
    aftername  = \hspace{1em},  
    indent     = 2em,
    beforeskip = 12bp + 10bp,        
    afterskip  = 6bp + 10bp,          
    fixskip  = true,
  },
}

% 如果使用数字编码方式
\newcommand{\usearabicstyle}{
  \ctexset{
    chapter = {
        format     = \chapterformat\raggedright,
        name       = {},
        number     = \arabic{chapter},
    },
    section = {
        format     = \sectionformat\raggedright,
        name       = {\arabic{chapter}.},
        number     = \arabic{section}
    },
    subsection = {
        format     = \subsectionformat,
        indent     = 0bp,
        name       = {\arabic{chapter}.\arabic{section}.},
        number = \arabic{subsection}
    },
    subsubsection = {
        format     = \subsubsectionformat,
        indent     = 0bp,
        name    = {\arabic{chapter}.\arabic{section}.\arabic{subsection}.},
        number = \arabic{subsubsection}
    },
  }
}

\ifnku@numberstyle@arabic
  \usearabicstyle
\fi

% ------------------------------
% 设置图表格式
% ------------------------------
% 定义caption字体
\DeclareCaptionFont{nkucaptionfont}{%
  \zihao{5}\selectfont\songti
}

% 图表标题通用设置
\captionsetup{
  font = nkucaptionfont,              % 五号宋体，单倍行距
  labelsep = quad,                    % 空一个汉字符宽度
  singlelinecheck = false,            % 即使单行也按设置排版
  justification = centering,          % 居中
}

% 图标题单独设置
\captionsetup[figure]{
  name = {图},
  position = bottom,                  % 置于图下方
  aboveskip = 6bp,                    % 段前6磅
  belowskip = 12bp,                   % 段后12磅
}

% 表标题单独设置
\captionsetup[table]{
  name = {表},
  position = top,                     % 置于表上方
  aboveskip = 6bp,                    % 段前6磅
  belowskip = 6bp,                    % 段后6磅
}

% 设置图表编号格式为"图2.1"、"表2.1"
\renewcommand{\thefigure}{\thechapter.\arabic{figure}}
\renewcommand{\thetable}{\thechapter.\arabic{table}}

% 确保每章重置计数器
\@addtoreset{figure}{chapter}
\@addtoreset{table}{chapter}


% ------------------------------
% 设置摘要
% ------------------------------
% 中文摘要
\newenvironment{abstract}{%
  \clearpage
  \phantomsection
  \addcontentsline{toc}{chapter}{摘要}
  \markboth{摘要}{摘要}
  {
    \ctexset{
      chapter = {
        format = \centering\zihao{-2}\heiti,
        beforeskip = 24bp + 4bp,
        afterskip = 18bp + 10bp,
      }
    }
    \chapter*{摘要}
  }
  \@afterheading
}{%
  \par
  \vskip 20bp
  \noindent{\bfseries 关键词：} \nku@key@keywords
}

% 英文摘要
\newenvironment{abstract*}{%
  \clearpage
  \phantomsection
  \addcontentsline{toc}{chapter}{Abstract}
  \markboth{Abstract}{Abstract}
  {
    \ctexset{
      chapter = {
        format = \centering\zihao{-2}\bfseries\fontspec{Arial},
        beforeskip = 24bp + 4bp,
        afterskip = 18bp + 10bp,
      }
    }
    \chapter*{Abstract}
  }
  \@afterheading
}{%
  \par
  \vskip 20bp
  \noindent{\textbf{Key Words：}} \nku@key@keywords@en
}


% ------------------------------
% 页码编号设置
% ------------------------------
\renewcommand\frontmatter{%
  \ifprint \cleardoublepage \else \clearpage \fi
  \@mainmatterfalse
  \pagenumbering{Roman}%                  % 大写罗马数字编号
}
\renewcommand\mainmatter{%
  \ifprint \cleardoublepage \else \clearpage \fi
  \@mainmattertrue
  \pagenumbering{arabic}%
}
\renewcommand\backmatter{%
  \clearpage
  \@mainmatterfalse
}


% ------------------------------
% 目录标题格式设置
% ------------------------------
% 设置页面页眉格式
\let\oldtableofcontents\tableofcontents
\renewcommand{\tableofcontents}{%
  \ifisbachelor
  \oldtableofcontents
  \else
  \begingroup  % 开启局部作用域
    \ctexset{
      contentsname = {目\quad 录},
      chapter = {format = \chapterformat\centering}
    }
    \oldtableofcontents
  \endgroup    % 恢复所有设置
  \fi
}

% 目录章标题（一级标题）
\titlecontents{chapter}
    [0pt]                                 % 左缩进0
    {\zihao{4}\songti\addvspace{6bp}}     % 宋体14磅，段前6磅
    {\thecontentslabel\quad}              % 编号 + 空格
    {}                                    % 无编号时的格式
    {\dotfill\contentspage}               % 页码右对齐
    [\addvspace{0bp}]                     % 段后0磅

% 目录节标题（二级标题）
\titlecontents{section}
    [1em]                                 % 左缩进1个汉字符
    {\zihao{-4}\songti\addvspace{6bp}}    % 宋体12磅，段前6磅
    {\thecontentslabel\quad}
    {}
    {\dotfill\contentspage}
    [\addvspace{0bp}]
  
% 目录子节标题（对应你的三级标题）
\titlecontents{subsection}
    [2em]                                 % 左缩进2个汉字符
    {\zihao{5}\songti\addvspace{6bp}}     % 宋体10.5磅，段前6磅
    {\thecontentslabel\quad}
    {}
    {\dotfill\contentspage}
    [\addvspace{0bp}]

% 设置目录深度
\setcounter{tocdepth}{2}                  % 目录显示的深度，硕博应该前三个
\setcounter{secnumdepth}{3}               % 章节编号的深度


% ------------------------------
% 公式编号格式设置
% ------------------------------
% 设置公式编号字体格式
% \makeatletter
\def\tagform@#1{%
  \maketag@@@{%
    {\fontspec{Times New Roman}\zihao{5}\selectfont
     (\ignorespaces#1\unskip\@@italiccorr)}%
  }%
}
\@addtoreset{equation}{chapter}
% \makeatother

% 只输出数字
\renewcommand{\theequation}{\thechapter.\arabic{equation}}

\renewcommand{\eqref}[1]{%
  {\normalsize(\ref{#1})\unskip}                   % 强制用正文字体大小
}


% ------------------------------
% 智能交叉引用（可能意义不大）
% ------------------------------
\crefformat{figure}{图~#2#1#3}
\crefformat{table}{表~#2#1#3}
\crefformat{equation}{式~(#2#1#3)}
\crefformat{theorem}{定理~#2#1#3}
\crefformat{lemma}{引理~#2#1#3}
\crefformat{definition}{定义~#2#1#3}
\crefformat{chapter}{第#2#1#3章}
\crefformat{section}{第#2#1#3节}


% ------------------------------
% 定理环境
% ------------------------------
\newtheoremstyle{nkuplain}
  {6bp}{6bp}                                % 上下间距
  {\songti\zihao{-4}
  \linespread{1.389}\selectfont}            % 正文字体
  {2em}                                     % 缩进
  {\heiti\zihao{-4}}                        % 标题字体
  {}                                        % 标题后标点
  {1em}                                     % 标题后间距
  {}                                        % 标题格式

\theoremstyle{nkuplain}
\newtheorem{theorem}{定理}[chapter]
\newtheorem{lemma}[theorem]{引理}
\newtheorem{proposition}[theorem]{命题}
\newtheorem{corollary}[theorem]{推论}
\newtheorem{definition}{定义}[chapter]
\newtheorem{example}{例}[chapter]
\newtheorem{remark}{注}[chapter]

\renewenvironment{proof}[1][\proofname]{%
  \par\pushQED{\qed}%
  \normalfont \topsep6\p@\@plus6\p@\relax
  \trivlist\item[\hskip\labelsep
    \heiti #1\@addpunct{.}]\ignorespaces
}{%
  \popQED\endtrivlist\@endpefalse
}
\renewcommand{\proofname}{证明}


% ------------------------------
% 图表清单部分
% ------------------------------
\renewcommand{\listfigurename}{插图清单}
\renewcommand{\listtablename}{表格清单}

\let\oldlistoffigures\listoffigures
\renewcommand{\listoffigures}{
  {
    \setchaptercenter
    \oldlistoffigures
  }
}

\let\oldlistoftables\listoftables
\renewcommand{\listoftables}{
  {
    \setchaptercenter
    \oldlistoftables
  }
}


% ------------------------------
% 引用色彩和参考文献设置
% ------------------------------
\hypersetup{
  colorlinks = true,                     % 彩色链接
  linkcolor = black,                     % 内部链接黑色
  citecolor = black,                     % 引用黑色
  urlcolor  = black,                     % URL黑色
}

\RequirePackage[
  backend=biber,                         % 推荐使用 biber 后端
  style=gb7714-2015,                     % 中国国家标准格式（适用于中文论文）
  % style=authoryear,                      % 作者-年份格式
  % style=numeric,                         % 数字序号格式
  % defernumbers=true,                     % 推迟编号，直到所有文献都被处理
  sorting=none,                          % 按引用顺序排序
  sortcites=true,                        % 压缩多个引用
  hyperref=true,                         % 支持超链接
  % backref=true,                        % 显示引用页码
  % safeinputenc=false,
]{biblatex}

% 设定参考文献页面页眉格式
\newcommand{\bibliographypage}{%
  \clearpage
  \phantomsection
  \addcontentsline{toc}{chapter}{参考文献}
  \markboth{参考文献}{参考文献}
  {
    \setchaptercenter
    \chapter*{参考文献}
  }
  \def\bibfont{\fontsize{10.5}{16}\selectfont}
  \setlength{\bibitemsep}{0pt}
  \printbibliography[heading=none]
}


% ------------------------------
% 代码框设置
% ------------------------------
\renewcommand{\lstlistingname}{代码}
\lstset{
    basicstyle=\ttfamily\small,               % 设置等宽字体和字号
    breaklines=true,                          % 自动折行
    frame=single,                             % 代码框（single 是单线框）
    backgroundcolor=\color{gray!5},           % 背景颜色
    numbers=left,                             % 行号显示在左侧
    numberstyle=\tiny\color{gray},            % 行号字体设置
    commentstyle=\color{green!60!black},      % 注释颜色
    keywordstyle=\color{blue},                % 关键字颜色
    showstringspaces=false,                   % 不显示字符串中的空格
    captionpos=b                              % 标题放在下方
}


% ------------------------------
% 硕博封面标题页
% ------------------------------
% 使用伪粗体用于封面等
% \newCJKfontfamily\songticu{STSong}[AutoFakeBold=7.5]

\newcommand{\nkufill}[3][11em]{%
  #2 \hskip 0.5em \underline{\makebox[#1][c]{#3}}%
}

\newcommand{\maketitlepage}{%
  \ifprint \cleardoublepage \else \clearpage \fi
  \thispagestyle{empty}
  \checkrequired{titlecn}{论文题目(中文)}%
  \checkrequired{titleen}{论文题目(英文)}%
  \checkrequired{author}{论文作者}%
  \checkrequired{supervisor}{指导教师}%
  \checkrequired{degree}{申请学位}%
  \checkrequired{department}{培养单位}%
  \checkrequired{major}{学科专业}%
  {
    \parindent=0pt
    \fontsize{10.5bp}{10.5bp}\songti\selectfont
    \renewcommand{\arraystretch}{1.5}
    \setlength{\tabcolsep}{0pt}
    \begin{tabular}{r@{\hspace{1em}} p{0.6\textwidth} r@{\hspace{1em}} p{0.1\textwidth}}
      中图分类号： & {\nkuget{classification}}  & 学校代码： &  {\nkuget{schoolcode}}  \\
      UDC：      &  {\nkuget{udc}} & 密级： & {\nkuget{security}} \\
    \end{tabular}
  }
  
  \vspace{3mm}
  \begin{center}
    % 校徽
    \includegraphics[width=3.5cm]{assets/nku_logo.pdf}
    
    % 学位论文类型
    {\zihao{2}\bfseries\songti\ziju{0.5}\selectfont \nkuget{thesistype}学位论文\par}
    
    % 论文标题
    \vspace{11.5mm}
    \begin{minipage}[t][75mm]{\textwidth}
      \centering
      {\zihao{2}\songti\linespread{1.2}\selectfont \nkuget{titlecn}\par}
      \vspace{5mm}
      {\zihao{2}\songti\linespread{1.2}\selectfont \nkuget{titleen}\par}
    \end{minipage}
    
    % 作者信息表格
    \vspace{10mm}
    {\zihao{-4}\songti
      \renewcommand{\arraystretch}{1.8}
      \linespread{1.3}\selectfont
      \setlength{\tabcolsep}{0pt}
      \begin{tabular}{l @{\hspace{3em}} l}
          \nkufill{论文作者}{\nkuget{author}} & \nkufill{指导教师}{\nkuget{supervisor}} \\
          \nkufill{申请学位}{\nkuget{degree}} & \nkufill{培养单位}{\nkuget{department}} \\
          \nkufill{学科专业}{\nkuget{major}} & \nkufill{研究方向}{\nkuget{research}} \\
          \nkufill[8em]{答辩委员会主席}{\nkuget{chairman}} & \nkufill{评~~阅~~人}{\nkuget{reviewer}} \\
      \end{tabular}
    }

    % 落款
    \vspace{14.5mm}
    {\zihao{4}\songti\linespread{1.78}\selectfont
      南开大学研究生院\par
      \nkuget{date}\par}
  \end{center}
}


% ------------------------------
% 匿名评阅封面
% ------------------------------
\newcommand{\anonymoustitlepage}{%
  \ifprint \cleardoublepage \else \clearpage \fi
  \thispagestyle{empty}
  \ifthenelse{\equal{\nkuget{thesistype}}{硕士专业}\OR\equal{\nkuget{thesistype}}{博士专业}}{
    % ----硕士专业/博士专业----
    \ifthenelse{\equal{\nkuget{thesistype}}{硕士专业}}{
      % 硕士专业
      {\bfseries\centering\heiti\fontsize{20}{30}\selectfont 南开大学硕士学位论文/实践成果报告\par}
      
      \vspace{2mm}
      {\centering\fangsong\zihao{-2} （匿名评阅学位论文/实践成果报告封面）\par}
    
    }{
      % 博士专业
      \centering\includegraphics[width=7.0cm]{assets/nku_logo.pdf}

      \vspace{0.8\baselineskip}
      {\bfseries\centering\heiti\zihao{-1}\selectfont 南开大学博士学位论文/实践成果报告\par}
      
      \vspace{0.8\baselineskip}
      {\fangsong \zihao{-2}\selectfont （匿名评阅封面）\par}
    }

    \vspace{15mm}
    {\raggedright\fangsong\zihao{3} 学位论文/实践成果报告题目（含英文题目）：\par}
    
    \vspace{5mm}
    \noindent
    \begin{minipage}[t][50mm]{\textwidth}
      \centering
      {\zihao{3}\fangsong\linespread{1.3}\selectfont\nkuget{titlecn}\par}
      \vspace{5mm}
      {\zihao{3}\songti\linespread{1.3}\selectfont\nkuget{titleen}\par}
    \end{minipage}

    \vspace{15mm}
    {\raggedright\fangsong\zihao{3} 专业学位类别：\nkuget{profmajor}\par}

    \vspace{5mm}
    {\raggedright\fangsong\zihao{3} 专业领域：\nkuget{proffield}\par}

    \vspace{15mm}
    {\raggedright\fangsong\zihao{3} 学位论文/实践成果编号：\nkuget{profpaperid}\par}

  }{
    % ----博士或者硕士----
    \vspace*{1mm}
    \begin{center}
      \includegraphics[width=7.0cm]{assets/nku_logo.pdf}
      
      \vspace{0.2\baselineskip}
      {\bfseries \heiti \fontsize{28}{36}\selectfont
        南开大学\nkuget{thesistype}毕业（学位）论文\par}

      \vspace{1.2\baselineskip}
      {\fangsong \zihao{-2}\selectfont
        （匿名评阅封面）\par}
    \end{center}

    \vspace{25mm}
    \hspace{13.5mm}
    \begin{minipage}[t][60mm]{\textwidth-24mm}
      {\zihao{3}\kaishu 论文题目：\par}
      \vspace{5mm}
      {\zihao{3}\linespread{1.3}\fangsong\nkuget{titlecn}\par}
      \vspace{5mm}
      {\zihao{3}\linespread{1.3}\songti\nkuget{titleen}\par}
    \end{minipage}

    {\kaishu \zihao{3}\selectfont
      \vspace{5mm}
      \hspace{10mm}
      一级学科：\nkuget{firstsubject}\par
      \vspace{5mm}
      \hspace{10mm}
      二级学科：\nkuget{secondsubject}\par
      \vspace{15mm}
      \hspace{10mm}
      论文编号：\nkuget{paperid}\par}
  }
}


% ------------------------------
% 致谢部分
% ------------------------------
\newenvironment{acknowledgements}{%
  \clearpage
  \phantomsection
  \addcontentsline{toc}{chapter}{致谢}
  \markboth{致谢}{致谢}
  {
    \setchaptercenter
    \chapter*{致谢}
  }
  % \@afterheading
  \setlength{\parindent}{2em}
  \zihao{-4}\fangsong
  \setlength{\baselineskip}{16bp}
}{%
  \par
}

% ------------------------------
% 附录部分设置
% ------------------------------
\let\oldappendix\appendix
\renewcommand{\appendix}{%
  \oldappendix
  % 会持续到结束
  \setchaptercenter                       
}

% ------------------------------
% 个人简历部分
% ------------------------------
\newenvironment{resume}{%
  \clearpage
  \phantomsection
  \addcontentsline{toc}{chapter}{个人简历}
  \markboth{个人简历}{个人简历}
  {
    \setchaptercenter
    \chapter*{个人简历}
  }
  \usearabicstyle
  % \@afterheading
  \setlength{\parindent}{2em}
  \zihao{5}\songti
  \setlength{\baselineskip}{16bp}
}{}

% 论文发表情况、其他获奖情况格式
\newenvironment{achievements}{%
  % \begin{enumerate}[leftmargin=1.85em]
  \begin{enumerate}[rightmargin=0.2em]
  \setlength{\parskip}{0bp}
  \setlength{\itemsep}{0bp}
  \renewcommand{\labelenumi}{[\theenumi]}
  \fontsize{10.5}{16}\songti\selectfont
}{%
  \end{enumerate}
  \par
}


% ------------------------------
% 原创性声明、非公开学位论文标注说明
% ------------------------------
\newcommand{\declarationpage}{%
  \ifprint \cleardoublepage \else \clearpage \fi
  \thispagestyle{empty}
  \vspace*{5mm}
  
  {\zihao{3}\bfseries\heiti\centering\linespread{1.5}\selectfont
    南开大学学位论文原创性声明
    \par}

  \vspace{10mm}
  {\zihao{-4}\songti\linespread{1.65}\selectfont
    本人郑重声明：所呈交的学位论文，是本人在导师指导下进行研究工作所取得的研究成果。
    除文中已经注明引用的内容外，本学位论文的研究成果不包含任何他人创作的、已公开发
    表或者没有公开发表的作品的内容。对本论文所涉及的研究工作做出贡献的其他个人和集
    体，均已在文中以明确方式标明。本学位论文原创性声明的法律责任由本人承担。
    \par}

  \vspace{10mm}
  学位论文作者签名：\underline{\hspace{10em}} \hspace{5em} 年\hskip 2.5em 月 \hskip 2.5em 日\par

  % 虚线
  \noindent\makebox[\linewidth]{\xleaders\hbox to 2.0mm{\hss\rule{1.25mm}{0.6pt}\hskip 0.75mm}\hfill}

  \vspace{3mm}
  {\zihao{3}\heiti\centering\linespread{1.5}\selectfont
    非公开学位论文标注说明
    \par}
    
  {\zihao{-4}\kaishu\centering\linespread{1.5}\selectfont
    （本页表中填写内容须打印）
    \par}

  \vspace{-1mm}
  {\zihao{-4}\songti\linespread{1.65}\selectfont
    根据南开大学有关规定，非公开学位论文须经指导教师同意、作者本人申请和相关部门批准方能标注。
    \heiti{未经批准的均为公开学位论文，公开学位论文本说明为空白。}
    \par
  }

  \begin{center}
    \zihao{-4}
    \renewcommand{\arraystretch}{1.5} % 控制行高

    \begin{tabular}{|p{6em}|p{10em}|p{5em}|p{10em}|}
      \hline
      \centering \heiti 论文题目 & \multicolumn{3}{>{\centering\arraybackslash}p{25em}|}{
        \parbox[c][1.8cm][c]{\linewidth}{
        \centering
        \ifthenelse{\boolean{issecurity}}{\nkuget{titlecn}}{}
        }
      } \\ 
      
      \hline
      \rule[-0.3cm]{0pt}{1.0cm}\centering
      \heiti 申请密级 & \multicolumn{3}{c|}{
        \ifthenelse{\equal{\nkuget{applysecurity}}{限制} \and \boolean{issecurity}}{\checkedcheckbox}{\checkbox} 限制（$\le$2 年） \quad 
        \ifthenelse{\equal{\nkuget{applysecurity}}{秘密} \and \boolean{issecurity}}{\checkedcheckbox}{\checkbox} 秘密（$\le$10 年） \quad 
        \ifthenelse{\equal{\nkuget{applysecurity}}{机密} \and \boolean{issecurity}}{\checkedcheckbox}{\checkbox} 机密（$\le$20 年）
      } \\
      
      \hline
      \rule[-0.3cm]{0pt}{1.0cm}\centering
      \heiti 保密期限 & \multicolumn{3}{c|}{
        \ifthenelse{\boolean{issecurity}}{\nkuget{securitystart}}{20\hskip 2.2em 年\hskip 2.2em 月\hskip 2.2em 日}
        \quad 至 \quad
        \ifthenelse{\boolean{issecurity}}{\nkuget{securityend}}{20\hskip 2.2em 年\hskip 2.2em 月\hskip 2.2em 日}} \\
      \hline
      \rule[-0.3cm]{0pt}{1.0cm}\centering
      \heiti 审批表编号 & \ifthenelse{\boolean{issecurity}}{\centering{\nkuget{applyid}}}{} & \heiti \centering 批准日期& \multicolumn{1}{c|}{
        \ifthenelse{\boolean{issecurity}}{\nkuget{approvedate}}{20\hskip 1.7em 年\hskip 1.7em 月\hskip 1.7em 日}}  \\
      \hline
    \end{tabular}
  \end{center}

  {\raggedleft\heiti 南开大学学位评定委员会办公室盖章（有效）\par}

  \vspace{5mm}
  {\noindent\zihao{5}\songti\linespread{1.5}\selectfont
    {\heiti 注：} 限制$\bigstar$2年（可少于2年）;秘密$\bigstar$10年（可少于10年）;机密$\bigstar$20年（可少于20年）
  }
}


% ------------------------------
% 学位论文使用授权书
% ------------------------------
\newcommand{\justify}[2]{
   \makebox[#1][s]{\hspace{5pt}#2\hspace{3pt}}
}

\newcommand{\checkedcheckbox}{%
  \makebox[0pt][l]{$\square$}%
  \raisebox{0.15ex}{\hspace{0.1em}$\checkmark$}%
}

\newcommand{\checkbox}{%
  \makebox[0pt][l]{$\square$}
  \hspace{0.2em}
}

\newcommand{\authorizationpage}{%
  \ifprint \cleardoublepage \else \clearpage \fi
  \thispagestyle{empty}
  \vspace*{5mm}

  {\zihao{3}\heiti\centering\linespread{1.5}\selectfont
    南开大学学位论文使用授权书
    \par}

  {\zihao{5}\songti\linespread{1.25}\selectfont
    \setlength{\parskip}{0.5\baselineskip}
    本人完全了解《南开大学关于研究生学位论文收藏和利用管理办法》关于南开大学（简称``学校''）
    研究生学位论文收藏和利用的管理规定，即：
    
    南开大学拥有在著作权法规定范围内学位论文的使用权，其中包括：

    已获学位的研究生必须按学校规定提交学位论文，学校可以采用影印、缩印或其他复制手段保存学位论
    文；学校根据规定向教育部指定的收藏和存档单位提交学位论文；并向教育主管部门提供包括但不限于内容复制等权限。

    为教学和科研目的，学校可以将公开的学位论文作为资料在图书馆、资料室等场所供校内师生阅读，或
    在校园网范围内供师生检索、浏览；

    非公开学位论文在解密后的使用权同公开论文。

    本人承诺：本人的学位论文是在南开大学学习期间创作完成的作品，并已通过论文答辩；提交的学位论
    文电子版与纸质本论文的内容一致，如因不同造成不良后果由本人自负。

    本人签署本授权书一份（此授权书为论文中一页），交图书馆留存。
    \par}

    \vspace{12mm}
    {\songti\zihao{5}\raggedleft 学位论文作者暨授权人（亲笔）签字：\makebox[10em]{} \par}
    
    \vspace{3mm}
    {\songti\zihao{5}\raggedleft 20\hskip 2em 年\hskip 2em 月\hskip 2em 日\par}
    
    \vspace{15mm}
    {\heiti\zihao{4}\heiti\centering
    南开大学研究生学位论文作者信息
    \par}

    \begin{center}
      \zihao{5}
      \songti\bfseries
      \renewcommand{\arraystretch}{1.5} 
      \setlength{\tabcolsep}{0pt}
      % \setlength{\leftskip}{-3em}
      \addtolength{\leftskip}{-20mm}
      \addtolength{\rightskip}{-22mm}
      \begin{tabular}{|l|}
        \hline
        \justify{6em}{论文题目}\vline \hspace{4pt} \parbox[t][\dimexpr\height+6pt\relax]{\dimexpr\linewidth-2em\relax}{\centering \nkuget{titlecn}}\\
        \hline
        \justify{6em}{姓名}\vline\makebox[8em]{\nkuget{author}}\vline\justify{5em}{学号}
        \vline\makebox[7em]{\nkuget{studentid}}\vline\justify{6em}{答辩日期}\vline \justify{12em}{\nkuget{defensedate}} \\  
        \hline
        \justify{6em}{论文类别}\vline 
        \begin{tabular}[c]{@{} p{6em} p{24em} p{6em} @{}}
          & % 第一列留空，用来把中间的选项往右推
          % 第二列：居中放置所有复选框选项
          \begin{tabular}[c]{@{}c@{}}
            学术博士\ifthenelse{\equal{\nkuget{thesistype2}}{学术博士}}{\checkedcheckbox}{\checkbox} \quad 
            专业学位博士\ifthenelse{\equal{\nkuget{thesistype2}}{专业学位博士}}{\checkedcheckbox}{\checkbox} \quad 
            学术硕士\ifthenelse{\equal{\nkuget{thesistype2}}{学术硕士}}{\checkedcheckbox}{\checkbox} \\
            专业学位硕士\ifthenelse{\equal{\nkuget{thesistype2}}{专业学位硕士}}{\checkedcheckbox}{\checkbox} \quad 
            同等学力硕士\ifthenelse{\equal{\nkuget{thesistype2}}{同等学力硕士}}{\checkedcheckbox}{\checkbox}
          \end{tabular} & 
          % 第三列：靠右对齐的提示文字
          \hfill 划\checkedcheckbox 选择
        \end{tabular}\\
        \hline

        \justify{6em}{学院（单位）}\vline\makebox[13em]{\nkuget{department}}\vline\justify{13em}{学科/专业（专业学位）名称}\hspace{3pt}\vline\makebox[12em]{\nkuget{major}}\\
        \hline
        \justify{6em}{联系电话}\vline\makebox[13em]{\nkuget{phone}}\vline\justify{5em}{电子邮箱}\vline\makebox[20em]{\nkuget{email}}\\
        \hline
        \hspace{5pt}通信地址（邮编）：\nkuget{address}\\
        \hline
        \justify{8em}{非公开论文编号}\vline\hspace{3pt}\makebox[11em]{\nkuget{nonpublicid}}\vline\justify{3em}{备注}\vline\hspace{4pt}\nkuget{remark}\\
        \hline
      \end{tabular}
    \end{center}

    % {\heiti\zihao{-5}\selectfont
    %   \setlength{\baselineskip}{15bp}
    %   \noindent 注：本授权书适用我校授予的所有博士、硕士的学位论文。如已批准为非公开学位论文，须向图书馆提供批准通过的《南开大学研究生申请非公开学位论文审批表》复印件和``非公开学位论文标注说明''页原件。
    % \par
    % }
    {\heiti\zihao{-5}\heiti\selectfont
      \setlength{\baselineskip}{15bp}
      \noindent
      \addtolength{\leftskip}{-12mm}
      \addtolength{\rightskip}{-22mm}
      \makebox[7.1mm][l]{注：}%
      \begin{minipage}[t]{162mm}
        \setlength{\parindent}{0pt}  % 取消首行缩进
        \raggedright
        本授权书适用我校授予的所有博士、硕士的学位论文。如已批准为非
        公开学位论文，须向图书馆提供批准通过的《南开大学研究生申请非公开学位
        论文审批表》复印件和``非公开学位论文标注说明''页原件。
      \end{minipage}
      \par
    }
}


% ------------------------------
% 本科格式重载
% ------------------------------

% 章节格式重载
\newcommand{\chapterformatbachelor}{\zihao{3}\bfseries\heiti\centering}%
\newcommand{\sectionformatbachelor}{\zihao{-3}\bfseries\heiti\centering}% 
\newcommand{\subsectionformatbachelor}{\zihao{4}\bfseries\heiti\selectfont\heiti\raggedright}%
\newcommand{\chapterheitisihaocenterdouble}{
  \ctexset{
    chapter = {
      format = \centering\zihao{4}\heiti \selectfont,
      beforeskip = 8bp,
      afterskip = 22bp,
      fixskip = true
    }
  }
}

\ifisbachelor
  % ------设置行间距--------
  \AtBeginDocument{
      \setlength{\baselineskip}{23.4bp} % 小四宋体1.5倍 12bp × 1.3 × 1.5 = 23.4bp
      \setlength{\parskip}{0bp}         % 确保段落之间没有额外空行
      \setlength{\parindent}{2em}
  }
  % ------设置章节格式--------
  \ctexset{
    chapter = {
        format     = \chapterformatbachelor,
        name       = {第,章},
        % name       = {,、},
        number     = \chinese{chapter},
        aftername  = \hspace{0.5em},
        beforeskip = 17bp,                               
        afterskip  = 17bp,     
    },
    section = {
        format     = \sectionformatbachelor,
        name       = {第,节},
        % name       = {（,）},
        number     = \chinese{section},
        aftername  = \hspace{0.5em},
        beforeskip = 13bp,                           
        afterskip  = 13bp,    
    },
    subsection = {
        format     = \subsectionformatbachelor,
        indent     = 0bp,
        name       = {\arabic{chapter}.\arabic{section}.},
        % name       = {.},
        number = \arabic{subsection},
        aftername  = \hspace{0.5em},
        beforeskip = 13bp,                              
        afterskip  = 13bp,    
    },
  }
  % ------设置页面边距--------
  \geometry{
    a4paper,
    top=2.54cm,
    bottom=2.54cm,
    left=3.17cm,
    right=3.17cm,
    headheight=0.5cm,
    headsep=0.54cm, % headheight+headsep=top-yemei
    footskip=0.79cm, % footskip=bottom-yemei
    bindingoffset=0cm
  }
  % ------本科中文摘要-------
  \renewenvironment{abstract}{%
    \clearpage
    \phantomsection
    \addcontentsline{toc}{chapter}{摘\hspace{1em}要}
    \markboth{摘\hspace{1em}要}{摘\hspace{1em}要}
    {
      \chapterheitisihaocenterdouble
      \chapter*{摘\hspace{1em}要}
    }
    \@afterheading
  }{%
    \par\vspace{2mm}
    \noindent{\heiti 关键词：} \nku@key@keywords
  }
  % ------本科英文摘要-------
  \renewenvironment{abstract*}{%
    \clearpage
    \phantomsection
    \addcontentsline{toc}{chapter}{Abstract}
    \markboth{Abstract}{Abstract}
    {
      \chapterheitisihaocenterdouble
      \chapter*{Abstract}
    }
    \@afterheading
  }{%
    \par\vspace{2mm}
    \noindent{\textbf{Key Words：}} \nku@key@keywords@en
  }
  % ------本科目录-------
  \let\benketableofcontents\tableofcontents
  \renewcommand{\tableofcontents}{%
    \ifisbachelor
    {
      \addcontentsline{toc}{chapter}{目\hspace{1em}录}
      \ctexset{
        contentsname = {目\hspace{1em}录},
        chapter = {
          format = \centering\zihao{3}\heiti \selectfont,
          beforeskip = 8bp,
          afterskip = 8bp,
          fixskip = true
        }
      }
      \benketableofcontents
    }
    \fi
  }

  \titlecontents{chapter}
      [0pt]  
      {\zihao{-3}\songti\addvspace{6bp}} 
      {\thecontentslabel\quad}  
      {}  
      {\dotfill\contentspage}  
      [\addvspace{0bp}]  
  \titlecontents{section}
      [2em]  
      {\zihao{4}\songti\addvspace{6bp}}
      {\thecontentslabel\quad}
      {}
      {\dotfill\contentspage}
      [\addvspace{0bp}]
  \titlecontents{subsection}
      [2em]  
      {\zihao{-4}\songti\addvspace{6bp}}
      {\thecontentslabel\quad}
      {}
      {\dotfill\contentspage}
      [\addvspace{0bp}]
  \setcounter{tocdepth}{2}                % 目录显示的深度（本科只需要两级）
  % ------本科参考文献-------
  \renewcommand{\bibliographypage}{%
    \clearpage
    \phantomsection
    % 恢复目录深度
    \addtocontents{toc}{\protect\setcounter{tocdepth}{3}}%
    \addcontentsline{toc}{chapter}{参考文献}
    \markboth{参考文献}{参考文献}
    {
      \chapterheitisihaocenterdouble
      \chapter*{参考文献}
    }
    \def\bibfont{\fontsize{10.5}{16}\selectfont}
    \printbibliography[heading=none]
    \clearpage
  }
  % ------本科致谢-------
  \renewenvironment{acknowledgements}{%
    \clearpage
    \phantomsection
    % 恢复目录深度
    \addtocontents{toc}{\protect\setcounter{tocdepth}{3}}%
    \addcontentsline{toc}{chapter}{致\hspace{1em}谢}
    \markboth{致\hspace{1em}谢}{致\hspace{1em}谢}
    {
      \chapterheitisihaocenterdouble
      \chapter*{致\hspace{1em}谢}
    }
    % \@afterheading
  }{%
    \par
  }
  % ------本科附录-------
  \let\bachelorappendix\appendix
  \renewcommand{\appendix}{%
    \clearpage
    \phantomsection
    \addcontentsline{toc}{chapter}{附\hspace{1em}录}
    \markboth{附\hspace{1em}录}{附\hspace{1em}录}

    % {
    %   \chapterheitisihaocenterdouble
    %   \chapter*{附\hspace{1em}录}
    % }
    \bachelorappendix
    % \setcounter{chapter}{1}%

    \let\orig@makechapterhead\@makechapterhead
    % 重定义，使第一个 chapter 前面带上"附录"总标题
    \renewcommand{\@makechapterhead}[1]{%
      {%
        \vspace*{-22bp}
        \centering\zihao{4}\heiti \linespread{2}\selectfont 附\hspace{1em}录\par
      }%
      \vspace{12bp}
      \orig@makechapterhead{##1}%
      \let\@makechapterhead\orig@makechapterhead
    }%

    \renewcommand{\chaptermark}[1]{\markboth{附\hspace{1em}录}{附\hspace{1em}录}}%
    \renewcommand{\sectionmark}[1]{\markright{}}%

    \addtocontents{toc}{\protect\setcounter{tocdepth}{-10}}%
  }
  % ------脚注相关-------
  \usepackage[%
    perpage,                           % 每页独立编号
    multiple,                          % 处理连续脚注
    symbol,                            % 使用符号编号（①等需要额外设置）
    ragged,                            % 脚注文本左对齐
    % norule                             % 不使用默认分隔线
  ]{footmisc}

  \newcommand{\circled}[1]{%
    \ifcase#1\or
      \ding{172}\or\ding{173}\or\ding{174}\or
      \ding{175}\or\ding{176}\or\ding{177}\or
      \ding{178}\or\ding{179}\or\ding{180}\or
      \ding{181}\or\ding{182}\or\ding{183}\or
      \ding{184}\or\ding{185}\or\ding{186}\or
      \ding{187}\or\ding{188}\or\ding{189}\or
      \ding{190}\or\ding{191}%
    \else
      #1%
    \fi
  }

  % 重新定义脚注标记
  \renewcommand{\thefootnote}{\circled{\arabic{footnote}}}

  % 设置脚注字体
  \renewcommand{\footnotesize}{\zihao{5}\songti}  % 小五号宋体
  
  % 脚注格式
  \renewcommand{\@makefntext}[1]{%
    \noindent
    \hb@xt@ 1.0em{\hss\@makefnmark}% 脚注标记
    \hspace{1em}#1% 空一格后跟注释文字
  }
\fi


% ------------------------------
% 本科封面标题页
% ------------------------------
\newlength{\tempwidth}   % 临时测量宽度
\newlength{\actualmax}   % 最终确定的最长宽度（用于封面）

% 获取最大长度
\newcommand{\updatemax}[1]{%
  \settowidth{\tempwidth}{#1}
  \ifdim\tempwidth > \actualmax
    \setlength{\actualmax}{\tempwidth}
  \fi
}

% 根据最长的内容动态调整表格的宽度
\newcommand{\adaptivefill}[1]{
  \underline{\makebox[\actualmax][\ifisbachelorinfoleftalign l\else c\fi]{#1}}%
}

\newcommand{\makebachelortitlepage}{%
  \clearpage
  \thispagestyle{empty}
  
  % 让所有可能变长的参数排队测量
  \updatemax{\nkuget{studentid}}
  \updatemax{\nkuget{author}}
  \updatemax{\nkuget{bachelorgrade}}
  \updatemax{\nkuget{bachelormajor}}
  \updatemax{\nkuget{bachelordepartment}}
  \updatemax{\nkuget{bachelorcollege}}
  \updatemax{\nkuget{bachelorfinishdate}}
  \updatemax{\nkuget{supervisor}}
  \updatemax{\nkuget{cosupervisor}}

  % 给最长的那行额外加 2em 的边距，避免文字紧贴横线边缘
  \ifisbachelorinfoleftalign \addtolength{\actualmax}{4em} \else \addtolength{\actualmax}{6em}\fi
  
  % 设定一个最小保底宽度（比如 8cm），防止内容太少时横线太短难看
  \ifdim\actualmax < 8em \setlength{\actualmax}{8em} \fi

  \vspace*{5mm}
  \begin{center}
    {\bfseries\songti \fontsize{56bp}{56bp}\selectfont
      南~~开~~大~~学\par}

    \vspace{10mm}
    {\songti \zihao{2}\selectfont
      本科生毕业论文（设计）\par}

    \vspace{30mm}
    \begin{minipage}[t][70mm]{\textwidth}
      \centering
      \setstretch{1.1}
      {\zihao{3} \songti
      \begin{tabular}{p{5em}p{17em}}
        \raggedleft 中文题目：& 
        \CJKunderline{\nkuget{titlecn}\hfill\mbox{}} \vspace{7mm}\\
        \raggedleft 外文题目：& 
        % \begingroup
        %   \def\temptitle{\nkuget{titleen}} % 使用 \def 即可，不需要 \edef
        %   \CJKunderline[width=21em]{\temptitle} % 这里的 width 可以根据你的表格列宽调整
        % \endgroup \\
        \begingroup
          \edef\temptitle{\nkuget{titleen}} % 强制完全展开题目内容
          \expandafter\uline\expandafter{\temptitle\hfill\mbox{}} % 把展开后的内容给 uline
        \endgroup \\
      \end{tabular}
      }
    \end{minipage}
    
    {\zihao{3}\songti
      \renewcommand{\arraystretch}{1.1}
      \begin{tabular}{rl}
        学\hspace{2em}号：& \adaptivefill{\nkuget{studentid}}\\
        姓\hspace{2em}名：& \adaptivefill{\nkuget{author}}\\
        年\hspace{2em}级：& \adaptivefill{\nkuget{bachelorgrade}}\\
        专\hspace{2em}业：& \adaptivefill{\nkuget{bachelormajor}}\\
        系\hspace{2em}别：& \adaptivefill{\nkuget{bachelordepartment}}\\
        学\hspace{2em}院：& \adaptivefill{\nkuget{bachelorcollege}}\\
        指导教师：& \adaptivefill{\nkuget{supervisor}}\\
        \ifiscosupervisor
          & \adaptivefill{\nkuget{cosupervisor}}\\
        \fi
        完成日期：& \adaptivefill{\nkuget{bachelorfinishdate}}\\

      \end{tabular}
    }
  \end{center}
}


% ------------------------------
% 本科生双学位封面标题页
% ------------------------------
\newcommand{\makebachelordoubledegreetitlepage}{%
  \clearpage
  \thispagestyle{empty}
  
  % 让所有可能变长的参数排队测量
  \updatemax{\nkuget{studentid}}
  \updatemax{\nkuget{author}}
  \updatemax{\nkuget{bachelorgrade}}
  \updatemax{\nkuget{bachelormajor}}
  \updatemax{\nkuget{bachelordepartment}}
  \updatemax{\nkuget{bachelorcollege}}
  \updatemax{\nkuget{bachelorfinishdate}}
  \updatemax{\nkuget{supervisor}}
  \updatemax{\nkuget{cosupervisor}}
  \updatemax{\nkuget{doublemajor}}
  \updatemax{\nkuget{doublecollege}}

  % 给最长的那行额外加 2em 的边距，避免文字紧贴横线边缘
  \ifisbachelorinfoleftalign \addtolength{\actualmax}{4em} \else \addtolength{\actualmax}{6em}\fi
  
  % 设定一个最小保底宽度（比如 8cm），防止内容太少时横线太短难看
  \ifdim\actualmax < 8em \setlength{\actualmax}{8em} \fi

  \vspace*{5mm}
  \begin{center}
    {\bfseries\songti \fontsize{48bp}{48bp}\selectfont
      南~~开~~大~~学\par}

    \vspace{10mm}
    {\songti \zihao{-2}\selectfont
      本科生毕业论文（设计）\\（双学位专用）\par}

    \vspace{25mm}
    \begin{minipage}[t][65mm]{\textwidth}
      \centering
      \setstretch{1.1}
      {\zihao{3} \songti
      \begin{tabular}{p{5em}p{17em}}
        \raggedleft 中文题目：& 
        \CJKunderline{\nkuget{titlecn}\hfill\mbox{}} \vspace{7mm}\\
        \raggedleft 外文题目：& 
        \begingroup
          \edef\temptitle{\nkuget{titleen}} % 强制完全展开题目内容
          \expandafter\uline\expandafter{\temptitle\hfill\mbox{}} % 把展开后的内容给 uline
        \endgroup \\
      \end{tabular}
      }
    \end{minipage}
    
    {\zihao{3}\songti
      \renewcommand{\arraystretch}{1.1}
      \begin{tabular}{rl}
        学\hspace{2em}号：& \adaptivefill{\nkuget{studentid}}\\
        姓\hspace{2em}名：& \adaptivefill{\nkuget{author}}\\
        年\hspace{2em}级：& \adaptivefill{\nkuget{bachelorgrade}}\\
        专\hspace{2em}业：& \adaptivefill{\nkuget{bachelormajor}}\\
        系\hspace{2em}别：& \adaptivefill{\nkuget{bachelordepartment}}\\
        学\hspace{2em}院：& \adaptivefill{\nkuget{bachelorcollege}}\\
        双修专业：& \adaptivefill{\nkuget{doublemajor}}\\
        双修院系：& \adaptivefill{\nkuget{doublecollege}}\\
        指导教师：& \adaptivefill{\nkuget{supervisor}}\\
        \ifiscosupervisor
          & \adaptivefill{\nkuget{cosupervisor}}\\
        \fi
        完成日期：& \adaptivefill{\nkuget{bachelorfinishdate}}\\

      \end{tabular}
    }
  \end{center}
}


% ------------------------------
% 本科生毕业论文（设计）的声明
% ------------------------------
\newcommand{\bachelordeclarationpage}{%
  \clearpage
  \thispagestyle{empty}
  \vspace*{10mm}
  {\centering\heiti\zihao{3}
  关于南开大学本科生毕业论文（设计）的声明
  \par}
  
  \vspace{20mm}
  {\songti\zihao{-4}\linespread{1.3}\selectfont
  本人郑重声明：所呈交的学位论文，是本人在指导教师指导下，进行研究工作所取得的成果。
  除文中已经注明引用的内容外，本学位论文的研究成果不包含任何他人创作的、已公开发表或
  没有公开发表的作品内容。对本论文所涉及的研究工作做出贡献的其他个人和集体，均已在文
  中以明确方式标明。本学位论文原创性声明的法律责任由本人承担。\par
  
  \vspace{10mm}
  \raggedleft 学位论文作者签名：\makebox[9em][c]{}\par
  
  \vspace{8mm}
  \raggedleft 年\hspace{3em}月\hspace{3em}日\par
  \par}

  \vspace{40mm}
  {\songti\zihao{-4}\linespread{1.3}\selectfont
  本人声明：该学位论文是本人指导学生完成的研究成果，已经审阅过论文的全部内容，并能够
  保证题目、关键词、摘要部分中英文内容的一致性和准确性。

  \vspace{10mm}
  \raggedleft 学位论文指导教师签名：\makebox[9em][c]{}\par
  
  \vspace{8mm}
  \raggedleft 年\hspace{3em}月\hspace{3em}日\par
  \par}

}
\makeatother


% ------------------------------
% 错误检查
% ------------------------------

% 排查overfull错误，超出部分用黑色显示
% \overfullrule=5pt

% 内存分析
% \tracingstats=2
% \tracinglostchars=2

\makeatletter
% \let\@font@warning\@gobble  % 忽略所有字体警告
\newcommand{\printfontinfo}{%
  \par\noindent
  \hangindent=2em
  字体名称：\fontname\font\\
  % 字体族：\f@family\\
  字体粗细：\f@series\\
  % 字体形状：\f@shape\\
  % 字体大小：\f@size\\
  \par
}
\makeatother

\newcommand{\fontinfo}{
  % 这里要加上括号，不然bfseries影响其他字体
  {\noindent\songti\zihao{3} 恭喜您成功编译\\本页是字体检验，在main.tex中注释掉即可\par}
  \ifusesystemwindowsfonts
    {\noindent\songti\zihao{3} 您已成功加载系统自带Windows字体！}
  \else \ifuselocalwindowsfonts
    {\noindent\songti\zihao{3} 您已成功加载fonts文件夹下Windows字体！}
  \else
    {\noindent\songti\zihao{3} 您当前没有使用Windows字体！}
  \fi\fi
  \par
  \vspace{10mm}
  {\noindent \songti 以下为具体字体列表：\par}
  \vspace{10mm}

  {\small
  {默认正文宋体  \printfontinfo}
  {\songti   宋体 (\textbackslash songti)   \printfontinfo}
  {\heiti    黑体 (\textbackslash heiti)    \printfontinfo}
  {\kaishu   楷书 (\textbackslash kaishu)   \printfontinfo}
  {\fangsong 仿宋 (\textbackslash fangsong) \printfontinfo}
  {\songti \bfseries 宋体加粗 (\textbackslash bfseries \textbackslash songti)  \printfontinfo}
  {\heiti \bfseries 黑体加粗 (\textbackslash bfseries \textbackslash heiti)  \printfontinfo}
  {\par
  \textrm{Times New Roman\\ \fontname\font}}
  {\par
  \textsf{Arial\\ \fontname\font}}}
}

% 在 nkuthesis.cls 的末尾添加
% \RequirePackage{pdftexcmds} % 确保加载了此宏包

% \makeatletter
% % 使用 pdftexcmds 提供的跨引擎命令
% \edef\compilation@start{\pdf@elapsedtime}

% \AtEndDocument{%
%   \edef\compilation@end{\pdf@elapsedtime}
%   % 进行计算
%   \count@=\numexpr\compilation@end-\compilation@start\relax
%   % 转换为秒（1秒 = 65536单位）
%   \dimen@=\count@ sp\relax
%   \typeout{^^J=== Total compilation time: \strip@pt\dimen@\space seconds ===^^J}
% }
% \makeatother
