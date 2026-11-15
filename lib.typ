// lib.typ
// yuhina: a shared typesetting base for zh-Hant-TW docs
// 本套件已有其他模板匯入，倘修改既有名稱或參數，極可能構成破壞性變更
// 上架 Typst Universe 前之使用方式為 `#import "@local/yuhina:0.1.0": *`

// Fake bold for Chinese fonts
#import "@preview/cuti:0.4.0": cn-fakebold

// ============================================================
// § 字體定義（方便未來抽換特定字型）
// ============================================================
// 字型堆疊的順序即優先順序：先列 Windows／Office 字型（維持原本外觀），
// 再依序接上拉丁與 CJK 的降級字型。Typst 會逐字形挑選第一個含有該字形的
// 已安裝字型，找不到的字型家族直接略過，所以缺字型時不會報錯，只會改用後面的字型。
// 各堆疊內「拉丁字型在前、CJK 字型在後」，避免 CJK 字型自帶的拉丁字形蓋過較合適的拉丁字型。
//
// 降級字型 / Fallback fonts
//   拉丁 / Latin: 統一使用 Libertinus 家族 / the Libertinus family throughout
//     襯線 serif: Libertinus Serif（Typst 內建，所有環境皆可用 / bundled with Typst, always available）
//     無襯線 sans: Libertinus Sans（Typst 未內建，需自行安裝 / not bundled, install it separately）
//   CJK 宋/Song: Noto Serif CJK TC、Source Han Serif TC、Noto Serif TC
//   CJK 黑/Hei:  Noto Sans CJK TC、Source Han Sans TC、Noto Sans TC
//   CJK 楷/Kai:  TW-MOE-Std-Kai（教育部標準楷書）、TW-Kai（全字庫正楷體）、LXGW WenKai TC；皆無時改用宋體降級字型
#let fallback-latin-serif = ("Libertinus Serif",)
#let fallback-latin-sans = ("Libertinus Sans",)
#let fallback-cjk-serif = ("Noto Serif CJK TC", "Source Han Serif TC", "Noto Serif TC")
#let fallback-cjk-sans = ("Noto Sans CJK TC", "Source Han Sans TC", "Noto Sans TC")
#let fallback-cjk-kai = ("TW-MOE-Std-Kai", "TW-Kai", "LXGW WenKai TC")

#let font-song = ("Times New Roman", "PMingLiU", ..fallback-latin-serif, ..fallback-cjk-serif)
#let font-hei = ("Arial", "Microsoft JhengHei UI", ..fallback-latin-sans, ..fallback-cjk-sans)
#let font-kai = (
  ("Times New Roman", "DFKai-SB") + fallback-latin-serif + fallback-cjk-kai + fallback-cjk-serif
)
#let font-yuan = ("TaiwanPearl", "Arial", "Microsoft JhengHei UI", ..fallback-latin-sans, ..fallback-cjk-sans) // Source: https://github.com/max32002/TaiwanPearl
#let font-fsong = (
  ("Zhuque Fangsong (technical preview)", "Times New Roman", "PMingLiU") + fallback-latin-serif + fallback-cjk-serif
) // Source: https://github.com/TrionesType/zhuque

// Latin-only fonts, skipped when finding the font that sets CJK glyphs
#let latin-only-fonts = (("Times New Roman", "Arial") + fallback-latin-serif + fallback-latin-sans).map(lower)

// CJK fonts that ship a real bold face; fake bold is skipped for them
// (the check looks at the first CJK family in the font list, not at the font actually used)
#let cjk-real-bold-fonts = (
  "microsoft jhenghei",
  "microsoft jhenghei ui",
  "noto sans cjk tc",
  "noto serif cjk tc",
  "noto sans tc",
  "noto serif tc",
  "source han sans tc",
  "source han serif tc",
)

// Apply fake bold only when the CJK font lacks a real bold face; otherwise use the real one
#let show-cn-fakebold-smart(body) = {
  show text.where(weight: "bold").or(strong): it => context {
    let fams = text.font.map(f => lower(if type(f) == dictionary { f.name } else { f }))
    let cjk-font = fams.find(f => f not in latin-only-fonts)
    if cjk-font in cjk-real-bold-fonts { it } else { cn-fakebold(it) }
  }
  body
}

// ============================================================
// § 行內樣式函式（筆記與論文共用）
// ============================================================

// 行內引用 / Example: #inquote[quoted text]
// 可填寫 font 參數以使用其他字型清單
#let inquote(content, font: font-kai) = {
  set text(font: font)
  content
}
// 重點強調(單純加粗)
#let keyword(content) = {
  set text(weight: "bold")
  content
}

// ============================================================
// § 作者與標題區塊
// ============================================================

// 正規化 authors 為陣列（相容三種傳入方式：純字串、單一 dict、陣列）
#let normalize-authors(authors) = if type(authors) == array { authors } else { (authors,) }

// 渲染作者列表；支援純字串或 dict (name, thanks)，thanks 以腳註呈現
#let render-authors(auths) = {
  let parts = auths.map(a => {
    if type(a) == dictionary {
      let n = a.at("name", default: "")
      let t = a.at("thanks", default: none)
      if t != none { [#n#footnote(t)] } else { [#n] }
    } else {
      [#str(a)]
    }
  })
  parts.join("、")
}

// 置中的標題區塊：主標題（含 thanks）、副標題、作者；font 為標題與副標題的字型
#let title-block(title, title-thanks: none, subtitle: none, authors: (), font: font-hei) = align(center)[
  #block(
    text(font: font, weight: 700, size: 1.75em)[
      #title#if title-thanks != none and title-thanks != "" { footnote(title-thanks) }
    ],
  )

  #if subtitle != none and subtitle != "" [
    #v(0.5em)
    #block(text(font: font, weight: "bold", size: 1.25em, subtitle))
  ]

  #v(1em)

  #render-authors(authors)
]

// ============================================================
// § 標題編號
// ============================================================
#let ch-big-numbers = ("壹", "貳", "參", "肆", "伍", "陸", "柒", "捌", "玖", "拾")

// 單一標題的編號，如「(三) 」；n 為各層計數，例如 (1, 2, 3)。
// 六層依序為「壹、一、(一) 1.(1) ①」；超過六層者無編號（回傳 none）。
// large 為 true 時，於現有層級上方多加一層「章」。
#let heading-number(n, large: false) = {
  let level-offset = if large { 1 } else { 0 }
  let level = n.len() - level-offset
  let val = n.last()
  if large and n.len() == 1 {
    numbering("第一章 ", val)
  } else if level == 1 {
    if val <= 10 { ch-big-numbers.at(val - 1) + "、" } else { str(val) }
  } else if level == 2 {
    numbering("一、", ..n.slice(1 + level-offset))
  } else if level == 3 {
    numbering("(一) ", ..n.slice(2 + level-offset))
  } else if level == 4 {
    numbering("1.", ..n.slice(3 + level-offset))
  } else if level == 5 {
    numbering("(1) ", ..n.slice(4 + level-offset))
  } else if level == 6 {
    numbering("①", ..n.slice(5 + level-offset))
  }
}

// 交互參照用的完整路徑，如 (1, 2, 3) →「壹、二、(三)」、(1, 2) →「壹、二」。
// 各層編號去除空白後相連，並去掉結尾最後一個的「、」或「.」。
#let heading-path(n, large: false) = {
  let parts = range(1, n.len() + 1).map(i => heading-number(n.slice(0, i), large: large))
  parts.filter(p => p != none).map(p => p.trim()).join().trim(regex("[、.]"), at: end)
}

// ============================================================
// § 可個別套用的排版規則
//
//   每個函式都以 `show: xxx` 或 `show: xxx.with(...)` 套用，只影響其後的內容，
//   可依需要挑選、調整順序或替換其中幾項。
//   common-style 則依下列順序全部套用。
//
//   document-style   PDF 標題與作者 / PDF title and authors
//   page-style       紙張、邊距、頁碼 / Paper, margins, page numbers
//   text-style       字型、語言、CJK 粗體 / Fonts, language, CJK bold
//   par-style        段落 / Paragraphs
//   quote-style      區塊引用 / Block quotes
//   list-style       編號與項目清單 / Numbered and bulleted lists
//   figure-style     圖說 / Figure captions
//   footnote-style   註腳 / Footnotes
//   heading-style    標題編號與外觀 / Heading numbering and display
//   ref-style        交互參照 / Cross-references
// ============================================================

// PDF 中繼資料：標題與作者
#let document-style(title: "", authors: (), body) = {
  let author-names = normalize-authors(authors).map(a => {
    if type(a) == dictionary { a.at("name", default: "") } else { str(a) }
  })
  set document(title: title, author: author-names)

  /*
    PDF 後處理指令:
    編譯後若需修改 PDF 製作者資訊，請於 PowerShell 執行：
    `exiftool -Producer="國立臺北大學法律學院115-1公法讀書會"`
  */

  body
}

// 頁面：紙張、邊距、頁尾置中頁碼
#let page-style(paper: "a4", margin: (x: 3cm, y: 2.5cm), body) = {
  set page(paper: paper, margin: margin, numbering: "1", number-align: center)
  body
}

// 字型與語言；CJK 粗體依字型改用真粗體或 cuti 偽粗體
#let text-style(font: font-song, size: 12pt, body) = {
  set text(font: font, size: size, lang: "zh", region: "tw")
  show: show-cn-fakebold-smart
  body
}

// 段落：筆記預設不縮排；衍生模板可傳入 first-line-indent 等參數
#let par-style(first-line-indent: 0em, leading: 1.1em, spacing: 1.6em, body) = {
  set par(first-line-indent: first-line-indent, leading: leading, justify: true, spacing: spacing)
  body
}

// 區塊引用
#let quote-style(font: font-kai, body) = {
  show quote.where(block: true): set text(font: font)
  body
}

// 編號清單：依層級採臺灣公文常用格式 1. → (1) → A. → (A) → a. → (a)
#let list-style(body) = {
  set enum(
    full: true,
    numbering: (..nums) => {
      let n = nums.pos()
      let pats = ("1.", "(1)", "A.", "(A)", "a.", "(a)")
      numbering(pats.at(calc.min(n.len(), pats.len()) - 1), n.last())
    },
  )
  set list(marker: ([•], [▪], [◆]))
  body
}

// 圖說：楷體；圖片的圖說置於上方
#let figure-style(font: font-kai, body) = {
  show figure.caption: set text(font: font)
  show figure.where(kind: image): set figure.caption(position: top)
  body
}

// 註腳：文內標籤黑體上標；頁底懸掛縮排
#let footnote-style(font: font-song, label-font: font-hei, body) = {
  show footnote: set text(font: label-font)

  show footnote.entry: it => {
    set text(font: font, weight: "regular")
    set par(leading: 0.9em, spacing: 0.9em)

    let loc = it.note.location()

    // 以 grid 切兩欄實現懸掛縮排；以 block 的 bottom inset 控制註腳間距
    block(
      width: 100%,
      inset: (bottom: 0.6em),
      grid(
        columns: (1.25em, 1fr),
        // Left: number, right: 內文
        text(font: label-font)[#super[#counter(footnote).display(at: loc)]], it.note.body,
      ),
    )
  }

  body
}

// 標題：編號見 heading-number；外觀如下
//   - large: 是否在最上層多加一層「第一章」（由 large-note.typ 使用）
//   - 第一層：置中；large 時第一層為「章」，字級大一號、另起新頁
//   - 其餘層級：靠左
//   - 無編號（目錄、參考文獻等）：原樣輸出
#let heading-style(font: font-hei, large: false, body) = {
  show heading: set text(font: font, weight: "bold")

  set heading(numbering: (..nums) => heading-number(nums.pos(), large: large))

  show heading: it => {
    if it.numbering != none {
      let displayed = {
        counter(heading).display(it.numbering)
        it.body
      }
      set par(first-line-indent: 0em)
      if it.level == 1 {
        if large {
          set text(size: 1.25em)
          pagebreak(weak: true)
        }
        set align(center)
        displayed
      } else {
        set align(left)
        displayed
      }
    } else {
      if large and it.level == 1 { pagebreak(weak: true) }
      it
    }
  }

  body
}

// 交互參照：@label 指向有編號的標題時，輸出完整層級路徑，例如「壹、二、(三)」；
// 以 @label[見] 傳入的補充文字會接在路徑前面。頁碼參照 ref(form: "page") 與
// 其餘參照（含文獻引用）原樣交回。large 須與 heading-style 一致。
#let ref-style(large: false, body) = {
  show ref: it => {
    if it.form != "normal" { return it }
    let el = it.element
    if el == none or el.func() != heading or el.numbering == none { return it }
    let path = heading-path(counter(heading).at(el.location()), large: large)
    let supplement = if it.supplement == auto { none } else { it.supplement }
    link(el.location(), [#supplement#path])
  }
  body
}

// ============================================================
// § 基本排版規則（全部套用）
//
//   以 `show: common-style.with(...)` 套用。入口檔可在其後再寫
//   set 規則覆寫（例如段落縮排），較內層的 set 規則優先；
//   需要更細的控制時，改為個別套用上列函式。
//
//   - large: 是否在最上層多加一層「第一章」（由 large-note.typ 使用）
//   - fonts: 覆寫字型的 dictionary，可用的鍵為 song、hei、kai，值為字型清單；
//            未列出的鍵使用預設。例如 fonts: (song: ("Libertinus Serif", "Noto Serif CJK TC"))。
//            song 用於內文與註腳，hei 用於標題與註腳編號，kai 用於區塊引用與圖說。
//            若要保留預設的降級順序，只在前面加字型：("My Font", ..font-song)。
//            title-block 與 inquote 不經過 common-style，請另以各自的 font 參數指定。
// ============================================================
#let common-style(title: "", authors: (), large: false, fonts: (:), body) = {
  for key in fonts.keys() {
    assert(
      key in ("song", "hei", "kai"),
      message: "common-style: unknown key `" + key + "` in fonts; expected song, hei or kai",
    )
  }
  let song = fonts.at("song", default: font-song)
  let hei = fonts.at("hei", default: font-hei)
  let kai = fonts.at("kai", default: font-kai)

  show: document-style.with(title: title, authors: authors)
  show: page-style
  show: text-style.with(font: song)
  show: par-style
  show: quote-style.with(font: kai)
  show: list-style
  show: figure-style.with(font: kai)
  show: footnote-style.with(font: song, label-font: hei)
  show: heading-style.with(font: hei, large: large)
  show: ref-style.with(large: large)
  body
}

// ============================================================
// § 移除超連結樣式
//
//   引用（Typst 原生 cite，或衍生模板所用 citrus 的 cite）會被包成
//   指向參考文獻的 link，在註腳中顯示為超連結。以 `show: plain-links` 套用後，
//   其後內容的連結一律只輸出文字。請在 outline 之後才套用，
//   以免目錄失去頁內跳轉。
// ============================================================
#let plain-links(body) = {
  show link: it => it.body
  body
}
