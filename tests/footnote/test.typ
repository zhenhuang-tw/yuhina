// 註腳：頁底懸掛縮排（編號一欄，內文另一欄，換行後對齊內文）。
// 為使參考圖不受各機器安裝的字型影響，只用 Typst 內建的 Libertinus Serif 與拉丁文字。
#import "/lib.typ": footnote-style

#set page(width: 10cm, height: auto, margin: 1cm)
#set text(font: "Libertinus Serif", size: 10pt)
#show: footnote-style.with(font: ("Libertinus Serif",), label-font: ("Libertinus Serif",))

Body text#footnote[A long footnote that wraps onto a second line so that the hanging indent is visible.]
and another#footnote[Short note.].
