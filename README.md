# yuhina

A shared typesetting base for Traditional Chinese documents in Taiwan, designed for [Typst](https://typst.app/) templates to import. Out of the box it favors:

1. The Traditional Chinese fonts DFKai-SB and PMingLiU bundled with Windows — the most widely used operating system in Taiwan — while also offering automatic fallback to open-source fonts for other environments.
2. Headings default to the Traditional Chinese numbering convention common in Taiwanese word processing, such as 壹、一、(一).

The name `yuhina` comes from the [Taiwan yuhina](https://en.wikipedia.org/wiki/Taiwan_yuhina), a bird species endemic to Taiwan.

臺灣繁體中文文件的共通排版基礎，供 [Typst](https://typst.app/) 模板匯入：字體、行內樣式函式、作者與標題區塊，以及可個別套用的排版規則（頁面、段落、註腳、「壹、一、(一)」六層標題編號、「見壹、二、(三)」交互參照等）。

本套件的名稱 `yuhina` 得名於臺灣特有種[冠羽鳳眉](https://zh.wikipedia.org/zh-tw/褐头凤鹛)（Taiwan yuhina）。

本套件的姊妹作 [bluemagpie](https://github.com/zhenhuang-tw/bluemagpie) （筆記用）與 [flamegold](https://github.com/zhenhuang-tw/flamegold) （法學寫作）依賴本套件。

## 環境需求

1. [Typst](https://github.com/typst/typst#installation) 0.14 以上。
2. 字型：預設優先使用 Windows／Office 內建的 Times New Roman、Arial、新細明體、標楷體、Microsoft JhengHei UI。缺少時會依[字型降級](#字型降級)改用其他字型。

首次編譯時，Typst 會自動下載 `@preview/cuti`。

## 字型降級

Linux 等非 Windows 環境通常沒有上述字型。本套件不支援 macOS，因此降級清單不含 macOS 專有字型（如 Songti TC、PingFang TC）。每組字型（`font-song`、`font-hei`、`font-kai`、`font-yuan`、`font-fsong`）都是一份依優先順序排列的清單，Typst 會逐字形挑選第一個已安裝且含有該字形的字型，找不到的字型直接略過，不會報錯。因此在缺字型的環境，會依下表順序降級：

| 用途               | 優先（Windows／Office）                    | 降級字型                                                                                                     |
| ------------------ | ------------------------------------------ | ------------------------------------------------------------------------------------------------------------ |
| 內文（宋體）       | Times New Roman、新細明體（PMingLiU）      | Libertinus Serif（Typst 內建）；Noto Serif CJK TC、Source Han Serif TC、Noto Serif TC                        |
| 標題（黑體）       | Arial、Microsoft JhengHei UI               | Libertinus Sans；Noto Sans CJK TC、Source Han Sans TC、Noto Sans TC                                          |
| 引用、圖說（楷體） | Times New Roman、標楷體（DFKai-SB）        | 拉丁同宋體；TW-MOE-Std-Kai（教育部標準楷書）、TW-Kai（全字庫正楷體）、LXGW WenKai TC；皆無時改用宋體降級字型 |
| 圓體、仿宋         | TaiwanPearl、Zhuque Fangsong（需自行安裝） | 圓體同黑體降級字型；仿宋同宋體降級字型                                                                       |

注意事項：

- 降級字型需自行安裝。建議安裝 Noto Serif／Sans CJK TC 與 [Libertinus](https://github.com/alerque/libertinus) 家族的 Libertinus Sans；拉丁宋體的降級字型 Libertinus Serif 由 Typst 內建，不必另外安裝。**請安裝「TC」（繁體中文）版本**：若只有 JP、SC 等其他地區版本，Typst 可能改用它們，同一個漢字的字形會與臺灣用字不同。
- 清單中的拉丁字型排在 CJK 字型之前，所以拉丁字母與數字由 Libertinus Serif（宋體）或 Libertinus Sans（黑體）呈現，漢字與全形標點由 CJK 字型呈現。未安裝 Libertinus Sans 時，黑體的拉丁字母與數字改由 CJK 黑體字型自帶的拉丁字形呈現。Libertinus Sans 與 Arial 的字寬不同，因此降級後的換行與頁數可能與 Windows 上的結果有差異。
- 粗體：`text-style` 以清單中第一個 CJK 字型判斷是否使用 [cuti](https://typst.app/universe/package/cuti) 偽粗體，而不是實際使用的字型。預設清單的第一個 CJK 字型是新細明體等，沒有粗體，因此降級到有真粗體的 Noto 等字型時，仍會再疊加偽粗體，粗體會略粗。需要精確控制時，請以 `text-style.with(font: (...))` 自訂字型清單，把要用的 CJK 字型排在第一個 CJK 位置。
- 降級字型清單依各平臺的常見家族名稱整理，並非每個平臺都逐一實測。若您的環境字型名稱不同，請以 `text-style.with(font: (...))` 自訂清單，或在 repo 開 issue。

### 選用字型：圓體與仿宋

`font-yuan`（圓體）與 `font-fsong`（仿宋）使用的字型不是系統內建的，需要自行取得；沒有安裝時，會依上表降級為黑體或宋體的降級字型。本套件不內含任何字型，字型的授權與本套件的 MIT 授權各自獨立。以下資訊整理自各專案頁面（2026 年 11 月），實際以專案頁面與隨附的授權文件為準。

| 字型                                                              | 清單中的名稱                          | 授權                                                                              | 取得方式                                                        | 注意                                                                                                                                     |
| ----------------------------------------------------------------- | ------------------------------------- | --------------------------------------------------------------------------------- | --------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| [台灣圓體 TaiwanPearl](https://github.com/max32002/TaiwanPearl)   | `TaiwanPearl`                         | SIL Open Font License 1.1，可免費商用                                             | 從專案頁下載 ZIP，或到 `ttf` 資料夾下載所需字型檔，再安裝到系統 | 字形改自思源黑體與小杉圓體；作者說明這不是專業字型檔，部分符號或罕用字可能缺漏。頁面只提到 Regular，沒有說明是否有粗體，粗體會套用偽粗體 |
| [朱雀仿宋 Zhuque Fangsong](https://github.com/TrionesType/zhuque) | `Zhuque Fangsong (technical preview)` | SIL Open Font License 1.1，可免費商用、複製與再散布，但不可單獨販售原始版或修改版 | 從專案頁的 Releases 取得（頁面另提供 AtomGit 鏡像）             | 專案頁說明正式版尚未發布；清單中的名稱對應預覽版，字型家族名稱改變時需自訂清單。頁面未說明字形是否符合臺灣標準，使用前請自行確認         |

OFL 1.1 允許在文件中使用字型並散布產出的 PDF，但若要再散布字型檔本身，必須遵守授權條款，包括隨附授權文件與不得單獨販售。

### 覆寫字型

`common-style` 的 `fonts` 參數可覆寫字型。鍵為 `song`（內文與註腳）、`hei`（標題與註腳編號）、`kai`（區塊引用與圖說），值為字型清單；沒列出的鍵維持預設。寫了其他鍵會直接報錯，以免打錯字而沒有生效。

```typ
// 完全自訂：只使用指定的字型
#show: common-style.with(
  fonts: (song: ("Libertinus Serif", "Noto Serif CJK TC")),
)

// 保留預設的降級順序，只在最前面加上自己的字型
#show: common-style.with(
  fonts: (hei: ("My Sans", ..font-hei)),
)
```

不經過 `common-style` 的 `title-block` 與 `inquote` 另以 `font` 參數指定，例如 `#title-block("標題", font: font-song)`、`#inquote(font: font-song)[文字]`。個別套用的樣式函式（`text-style`、`heading-style` 等）本來就有 `font` 參數。

自訂完整清單時，請把要用的 CJK 字型排在清單中第一個 CJK 位置，因為粗體判斷（見上）是看它。

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

因本套件的名稱與參數，供其他模板依賴，擬採用〈[語意化版本 2.0.0](https://semver.org/lang/zh-TW/)〉：向前相容的功能新增，升次版號；修改、移除既有名稱或參數，則升主版號。

## LICENSE

[MIT](LICENSE).
