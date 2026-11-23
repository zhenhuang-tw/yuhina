// 標題外觀：有編號與無編號的第一層標題皆置中；標題下方的間距等於內文段距，
// 因此標題緊接下一個標題時，間距與標題後接內文相同。
// 為使參考圖不受各機器安裝的字型影響，只用 Typst 內建的 Libertinus Serif 與拉丁文字。
#import "/lib.typ": heading-style, par-style

#set page(width: 10cm, height: auto, margin: 1cm)
#set text(font: "Libertinus Serif", size: 10pt)
#show: par-style
#show: heading-style.with(font: ("Libertinus Serif",))
// 中文編號需要 CJK 字型，改用拉丁編號；heading-style 的置中與間距不受影響
#set heading(numbering: "1.1 ")

= Numbered
== Directly after a heading
Body text.
== Second
Body text.

#heading(level: 1, numbering: none)[Unnumbered]
#heading(level: 2, numbering: none)[Directly after a heading]
Body text.
