%% doc-man.cls
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{docman}
\RequirePackage{luatexja}
\ProcessOptions
\usepackage{fancyhdr}
\pagestyle{fancy}
%\LoadClass{ltjreport}
\LoadClass{ltjarticle}
% 紙サイズの指定
\setlength{\paperheight}{297mm}
\setlength{\paperwidth}{210mm}
% 横幅の指定
\setlength{\textwidth}{\paperwidth}     % ひとまず紙面を本文領域に
\setlength{\oddsidemargin}{4.6truemm}  % 奇数ペースの左の余白を30mm(=1inch=25.4m+4.6mm)に
\setlength{\evensidemargin}{4.6truemm} % 偶数ペースの左の余白を30mm(=1inch=25.4m+4.6mm)に
\addtolength{\textwidth}{-60truemm}  
%% 高さの設定
\setlength{\textheight}{\paperheight}   % ひとまず紙面を本文領域に
\setlength{\topmargin}{5.6truemm}      % 上の余白を35mm(=1inch=25.4+5.6mm)に
\addtolength{\topmargin}{-\headheight}  % 
\addtolength{\topmargin}{-\headsep}     % ヘッダの分だけ本文領域を移動させる
\addtolength{\textheight}{-60truemm}    % 下の余白も30mmに
\renewcommand{\footrulewidth}{0.4pt}
% 章のスタイル設定
\renewcommand{\section}{%
  \clearpage% 改ページ
  \@startsection{section}% #1 見出し
    {1}% #2 見出しのレベル
    {0\Cvs}% #3 横組みの場合，見出し左の空き(インデント量)
    {1.5\Cvs \@plus.5\Cdp \@minus.2\Cdp}% #4 見出し上の空き
    {.5\Cvs \@plus.3\Cdp}% #5 見出し下の空き (負の値なら見出し後の空き) 
    {\reset@font\LARGE\bfseries}% #6 見出しの属性
}%
% フォント指定
\usepackage[ipa]{luatexja-preset}
\makeatletter
\def\maketitle{%
  \null
  \thispagestyle{empty}%
  \vfill
  \begin{center}\leavevmode
    \normalfont
    {\LARGE \@title\par}%
    \vskip 1cm
    {\Large \@author\par}%
    \vskip 1cm
    {\Large \@date\par}%
  \end{center}%
  \vfill
  \null
  \@thanks%\vfil\null
  \cleardoublepage
  }
\makeatletter
