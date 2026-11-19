// title-block 的 authors 接受字串、單一 dictionary 或陣列（同 normalize-authors）。
#import "/lib.typ": normalize-authors, title-block

#assert.eq(normalize-authors("甲"), ("甲",))
#assert.eq(normalize-authors((name: "甲")), ((name: "甲"),))
#assert.eq(normalize-authors(("甲", "乙")), ("甲", "乙"))

#set text(font: "Libertinus Serif")
#title-block("Title", authors: "A")
#title-block("Title", authors: (name: "A", thanks: [Thanks.]))
#title-block("Title", authors: ("A", (name: "B", thanks: [Thanks.])))
