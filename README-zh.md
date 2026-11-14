# yuhina

臺灣繁體中文文件的共通排版基礎，供 [Typst](https://typst.app/) 模板匯入：字體、行內樣式函式、作者與標題區塊，以及可個別套用的排版規則（頁面、段落、註腳、「壹、一、(一)」標題編號、「見壹、二、(三)」交互參照等）。

本套件的名稱 `yuhina` 得名於臺灣特有種[冠羽鳳眉](https://zh.wikipedia.org/zh-tw/褐头凤鹛)（Taiwan yuhina）。

## 環境需求

1. [Typst](https://github.com/typst/typst#installation) 0.14 以上。
2. 字型：Times New Roman、Arial、新細明體、標楷體、Microsoft JhengHei UI。缺少時 Typst 會改用其他字型，外觀會不同。

首次編譯時，Typst 會自動下載 `@preview/cuti`。

## 安裝為 local package

尚未發布到 Typst Universe，請以本機套件的方式使用。Typst 會在 `%APPDATA%\typst\packages\local\<名稱>\<版本>` 尋找本機套件；建立一個指向本 repo 的目錄連結（junction），修改 repo 後不必重新複製：

```powershell
$pkg = "$env:APPDATA\typst\packages\local\yuhina\0.1.0"
New-Item -ItemType Directory -Force (Split-Path $pkg) | Out-Null
New-Item -ItemType Junction -Path $pkg -Target (Resolve-Path .)
```

在本 repo 根目錄執行。建立 junction 不需要系統管理員權限。

若同時使用 [bluemagpie](https://github.com/zhenhuang-tw/bluemagpie)，改執行其 `install.ps1` 即可一併安裝兩個套件，不必另外執行上述指令。

## 使用方式

```typ
#import "@local/yuhina:0.1.0": *

#show: common-style.with(title: "文件標題", authors: "王小明")

= 緒論 <intro>

見@intro。#keyword[重點]
```

`common-style` 依序套用下列所有規則。需要更細的控制時，改為個別套用，每個函式都以 `#show: 函式` 或 `#show: 函式.with(...)` 套用，只影響其後的內容：

| 函式             | 作用                     | 參數（預設值）                                               |
| ---------------- | ------------------------ | ------------------------------------------------------------ |
| `document-style` | PDF 標題與作者           | `title: ""`、`authors: ()`                                   |
| `page-style`     | 紙張、邊距、頁尾置中頁碼 | `paper: "a4"`、`margin: (x: 3cm, y: 2.5cm)`                  |
| `text-style`     | 字型、語言、CJK 粗體     | `font: font-song`、`size: 12pt`                              |
| `par-style`      | 段落                     | `first-line-indent: 0em`、`leading: 1.1em`、`spacing: 1.6em` |
| `quote-style`    | 區塊引用                 | `font: font-kai`                                             |
| `list-style`     | 編號與項目清單           | 無                                                           |
| `figure-style`   | 圖說                     | `font: font-kai`                                             |
| `footnote-style` | 註腳                     | `font: font-song`、`label-font: font-hei`                    |
| `heading-style`  | 標題編號與外觀           | `font: font-hei`、`large: false`                             |
| `ref-style`      | 交互參照                 | `large: false`（須與 `heading-style` 一致）                  |

其他公開名稱：

| 名稱                                                           | 用途                                   |
| -------------------------------------------------------------- | -------------------------------------- |
| `font-song`、`font-hei`、`font-kai`、`font-yuan`、`font-fsong` | 字型組合                               |
| `keyword`、`inquote`                                           | 行內樣式：重點強調、行內引用（楷體）   |
| `title-block`、`normalize-authors`、`render-authors`           | 標題與作者區塊                         |
| `heading-number`、`heading-path`                               | 標題編號與交互參照路徑，供模板自訂顯示 |
| `plain-links`                                                  | 移除其後內容的超連結樣式               |

## 版本

本套件的名稱與參數供其他模板依賴：新增功能升次版號，修改或移除既有名稱、參數升主版號。

備註：本套件由 [bluemagpie](https://github.com/zhenhuang-tw/bluemagpie)的 `common.typ` 拆分而來（bluemagpie 已改為匯入本套件），保留其修改歷史。論文模板 [typst-ntulj](https://github.com/zhenhuang-tw/typst-ntulj) 將改為匯入本套件。
