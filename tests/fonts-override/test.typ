// common-style 的 fonts 參數：覆寫、保留降級順序、未知鍵報錯。
#import "/lib.typ": common-style, font-hei, font-kai, font-song

// text.font 只有一個字型時回傳字串，故統一為陣列
#let as-array(f) = if type(f) == str { (f,) } else { f }
#let lower-all(fonts) = fonts.map(lower)

// 1. 未知鍵：直接報錯，以免打錯字而沒有生效
#let msg = catch(() => common-style(fonts: (sogn: ("X",)), []))
#assert(msg != none, message: "unknown key should panic")
#assert(msg.contains("sogn"), message: "the message should name the unknown key")

// 2. 正常覆寫 song，並在最前面加字型以保留 hei 的降級順序；kai 維持預設
#show: common-style.with(fonts: (
  song: ("Libertinus Serif",),
  hei: ("My Sans", ..font-hei),
))

#context assert.eq(as-array(text.font), ("libertinus serif",))

= #context assert.eq(as-array(text.font), lower-all(("My Sans", ..font-hei)))

#quote(block: true)[#context assert.eq(as-array(text.font), lower-all(font-kai))]
