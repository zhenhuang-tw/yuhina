// 標題內的註腳：以 hfn 撰寫的註腳不會在目次中重複產生；
// 標題與內文的註腳依序編號（1、2、3…），不因目次而錯號。
// 第二個目次以自訂的 outline.entry 重組項目，hfn 仍須有效。
// 為使參考圖不受各機器安裝的字型影響，只用 Typst 內建的 Libertinus Serif 與拉丁文字。
#import "/lib.typ": heading-style, hfn

#set page(width: 10cm, height: auto, margin: 1cm)
#set text(font: "Libertinus Serif", size: 10pt)
#show: heading-style.with(font: ("Libertinus Serif",))
#set heading(numbering: "1.1 ")

#outline()
#[
  #show outline.entry: it => block(it.body())
  #outline(title: [Custom entries])
]

= First#hfn[Note in the first heading.]
Body text#footnote[Note in the body.]
== Second#hfn[Note in the second heading.]
Body text#footnote[Another note in the body.]
