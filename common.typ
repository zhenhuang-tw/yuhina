// common.typ
// 共用定義：字體、行內樣式函式、作者與標題區塊、基本排版規則。
// Shared definitions: fonts, inline style functions, title/author blocks, and base typesetting rules.
//
// 本檔不是入口檔：文件請匯入 basic-note.typ 或 large-note.typ。
// 衍生模板（例如 typst-ntulj）會直接匯入本檔，修改既有名稱或參數前請留意相容性。
// This is not an entry point: documents should import basic-note.typ or large-note.typ.
// Derived templates (e.g. typst-ntulj) import this file directly, so renaming or
// changing the parameters of existing definitions is a breaking change.

// 中文字型偽粗體 / Fake bold for Chinese fonts
#import "@preview/cuti:0.4.0": cn-fakebold

// ============================================================
// § 字體定義（方便未來抽換特定字型）
// § Font definitions (makes it easy to swap specific fonts later)
// ============================================================
#let font-song = ("Times New Roman", "PMingLiU")
#let font-hei = ("Arial", "Microsoft JhengHei UI")
#let font-kai = ("Times New Roman", "DFKai-SB")
#let font-yuan = ("TaiwanPearl", "Arial", "Microsoft JhengHei UI") // Source: https://github.com/max32002/TaiwanPearl
#let font-fsong = ("Zhuque Fangsong (technical preview)", "Times New Roman", "PMingLiU") // Source: https://github.com/TrionesType/zhuque

// Latin-only fonts, skipped when finding the font that sets CJK glyphs
#let latin-only-fonts = ("times new roman", "arial")

// CJK fonts that ship a real bold face; fake bold is skipped for them
#let cjk-real-bold-fonts = ("microsoft jhenghei", "microsoft jhenghei ui")

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
// § Inline style functions (shared by notes and papers)
//
//   僅筆記使用的樣式（very-keyword、hypo、thought、rightNote）定義於 basic-note.typ。
//   Note-only styles (very-keyword, hypo, thought, rightNote) live in basic-note.typ.
// ============================================================

// 行內引用 / Inline quoting. Example: #inquote[quoted text]
#let inquote(content) = {
  set text(font: font-kai)
  content
}
// 重點強調 / Emphasis
#let keyword(content) = {
  set text(weight: "bold")
  content
}

// ============================================================
// § 作者與標題區塊
// § Authors and title block
// ============================================================

// 正規化 authors 為陣列（相容純字串、單一 dict、陣列三種傳入方式）
// Normalize authors into an array (accepts a plain string, a single dict, or an array)
#let normalize-authors(authors) = if type(authors) == array { authors } else { (authors,) }

// 渲染作者列表；支援純字串或 dict (name, thanks)，thanks 以腳註呈現
// Render the author list; supports a plain string or a dict (name, thanks); thanks becomes a footnote
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

// 置中的標題區塊：主標題（含 thanks）、副標題、作者
// Centered title block: main title (with thanks), subtitle, authors
#let title-block(title, title-thanks: none, subtitle: none, authors: ()) = align(center)[
  #block(
    text(font: font-hei, weight: 700, size: 1.75em)[
      #title#if title-thanks != none and title-thanks != "" { footnote(title-thanks) }
    ],
  )

  #if subtitle != none and subtitle != "" [
    #v(0.5em)
    #block(text(font: font-hei, weight: "bold", size: 1.25em, subtitle))
  ]

  #v(1em)

  #render-authors(authors)
]

// ============================================================
// § 標題編號
// § Heading numbering
// ============================================================
#let ch-big-numbers = ("壹", "貳", "參", "肆", "伍", "陸", "柒", "捌", "玖", "拾")

// 單一標題的編號，如「(三) 」；n 為各層計數，例如 (1, 2, 3)。
// large 為 true 時，於現有層級上方多加一層「章」。
// The number of one heading, e.g. "(三) "; n holds the count at each level, e.g. (1, 2, 3).
// When large is true, an extra "chapter" level is added on top.
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
  }
}

// 交互參照用的完整路徑，如 (1, 2, 3) →「壹、二、(三)」、(1, 2) →「壹、二」。
// 各層編號去除空白後相連，並去掉結尾的「、」或「.」，以便後接文字或標點。
// The full path used in cross-references, e.g. (1, 2, 3) -> 壹、二、(三), (1, 2) -> 壹、二.
// Level numbers are joined without spaces, and a trailing 、 or . is dropped so
// that text or punctuation can follow.
#let heading-path(n, large: false) = {
  let parts = range(1, n.len() + 1).map(i => heading-number(n.slice(0, i), large: large))
  parts.filter(p => p != none).map(p => p.trim()).join().trim(regex("[、.]"), at: end)
}

// ============================================================
// § 可個別套用的排版規則
// § Composable style rules
//
//   每個函式都以 `show: xxx` 或 `show: xxx.with(...)` 套用，只影響其後的內容，
//   可依需要挑選、調整順序或替換其中幾項。common-style 依下列順序全部套用。
//   Each function is applied with `show: xxx` or `show: xxx.with(...)` and only
//   affects the content after it, so templates can pick, reorder or replace
//   them. common-style applies all of them in the order below.
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

// PDF 中繼資料：標題與作者 / PDF metadata: title and authors
#let document-style(title: "", authors: (), body) = {
  let author-names = normalize-authors(authors).map(a => {
    if type(a) == dictionary { a.at("name", default: "") } else { str(a) }
  })
  set document(title: title, author: author-names)

  /*
    PDF 後處理指令:
    PDF post-processing command:
    編譯後若需修改 PDF 製作者資訊，請於終端機 (Windows PowerShell) 執行：
    After compiling, to modify the PDF producer info, run this in a terminal (Windows PowerShell):
    exiftool -Producer="國立臺北大學法律學系"
  */

  body
}

// 頁面：紙張、邊距、頁尾置中頁碼 / Page: paper, margins, centered page number in the footer
#let page-style(paper: "a4", margin: (x: 3cm, y: 2.5cm), body) = {
  set page(paper: paper, margin: margin, numbering: "1", number-align: center)
  body
}

// 字型與語言；CJK 粗體依字型改用真粗體或 cuti 偽粗體
// Font and language; CJK bold uses a real bold face or cuti's fake bold depending on the font
#let text-style(font: font-song, size: 12pt, body) = {
  set text(font: font, size: size, lang: "zh", region: "tw")
  show: show-cn-fakebold-smart
  body
}

// 段落：筆記預設不縮排；衍生模板可傳入 first-line-indent 等參數
// Paragraphs: notes default to no indent; derived templates may pass first-line-indent and others
#let par-style(first-line-indent: 0em, leading: 1.1em, spacing: 1.6em, body) = {
  set par(first-line-indent: first-line-indent, leading: leading, justify: true, spacing: spacing)
  body
}

// 區塊引用 / Block quote
#let quote-style(font: font-kai, body) = {
  show quote.where(block: true): set text(font: font)
  body
}

// 編號清單：依層級採臺灣公文常用格式 1. → (1) → A. → (A) → a. → (a)
// Numbered list: formats common in Taiwanese official documents by level
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

// 圖說：楷體；圖片的圖說置於上方 / Figure caption: Kai; image captions go above
#let figure-style(font: font-kai, body) = {
  show figure.caption: set text(font: font)
  show figure.where(kind: image): set figure.caption(position: top)
  body
}

// 註腳：文內標籤黑體上標；頁底懸掛縮排
// Footnotes: sans-serif superscript label in the text; hanging indent at the bottom
#let footnote-style(font: font-song, label-font: font-hei, body) = {
  show footnote: set text(font: label-font)

  show footnote.entry: it => {
    set text(font: font, weight: "regular")
    set par(leading: 0.9em, spacing: 0.9em)

    let loc = it.note.location()

    // 以 grid 切兩欄實現懸掛縮排；以 block 的 bottom inset 控制註腳間距
    // A two-column grid gives the hanging indent; the block's bottom inset sets spacing between footnotes
    block(
      width: 100%,
      inset: (bottom: 0.6em),
      grid(
        columns: (1.25em, 1fr),
        // 左欄放編號、右欄放內文 / Left: number, right: body
        text(font: label-font)[#super[#counter(footnote).display(at: loc)]], it.note.body,
      ),
    )
  }

  body
}

// 標題：編號見 heading-number；外觀如下
// Headings: numbering by heading-number; display as follows
//   - large: 是否在最上層多加一層「第一章」（由 large-note.typ 使用）
//            Whether to add a "Chapter N" level on top (used by large-note.typ)
//   - 第一層：置中；large 時第一層為「章」，字級大一號、另起新頁
//     Level 1: centered; when large, level 1 is the chapter, one size larger, on a new page
//   - 其餘層級：靠左 / Other levels: left-aligned
//   - 無編號（目錄、參考文獻等）：原樣輸出 / Unnumbered (TOC, references, ...): output as-is
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
// Cross-references: @label to a numbered heading prints the full path, e.g.
// 壹、二、(三); a supplement given as @label[見] goes in front of it. Page
// references, ref(form: "page"), and every other reference, citations
// included, are passed through unchanged. large must match heading-style.
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
// § Base typesetting rules (all of the above)
//
//   以 `show: common-style.with(...)` 套用。入口檔可在其後再寫
//   set 規則覆寫（例如段落縮排），較內層的 set 規則優先；
//   需要更細的控制時，改為個別套用上列函式。
//   Apply with `show: common-style.with(...)`. Entry points may
//   override afterwards with their own set rules (e.g. paragraph
//   indent); inner set rules take precedence. For finer control,
//   apply the functions above one by one instead.
//
//   - large: 是否在最上層多加一層「第一章」（由 large-note.typ 使用）
//            Whether to add a "Chapter N" level on top (used by large-note.typ)
// ============================================================
#let common-style(title: "", authors: (), large: false, body) = {
  show: document-style.with(title: title, authors: authors)
  show: page-style
  show: text-style
  show: par-style
  show: quote-style
  show: list-style
  show: figure-style
  show: footnote-style
  show: heading-style.with(large: large)
  show: ref-style.with(large: large)
  body
}

// ============================================================
// § 移除超連結樣式
// § Strip hyperlink styling
//
//   引用（Typst 原生 cite，或衍生模板所用 citrus 的 cite）會被包成
//   指向參考文獻的 link，在註腳中顯示為超連結。以 `show: plain-links` 套用後，
//   其後內容的連結一律只輸出文字。請在 outline 之後才套用，
//   以免目錄失去頁內跳轉。
//   Citations (native, or citrus in derived templates) are wrapped in links to the
//   bibliography and show up as hyperlinks in footnotes. After
//   `show: plain-links`, links in the following content render as
//   plain text. Apply it after the outline so the TOC keeps its jumps.
// ============================================================
#let plain-links(body) = {
  show link: it => it.body
  body
}
