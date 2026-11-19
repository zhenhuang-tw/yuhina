// ref-style：@label 指向有編號的標題時，輸出完整層級路徑；
// @label[見] 的補充文字接在路徑前面；其他參照原樣交回。
// 以外層的 show link 記錄 ref-style 產生的連結文字，不依賴字型。
#import "/lib.typ": heading-style, ref-style

// 將 content 轉為純文字
#let plain(it) = {
  if type(it) == str { it }
  else if it == none { "" }
  else if it.has("text") { it.text }
  else if it.has("children") { it.children.map(plain).join() }
  else if it.has("body") { plain(it.body) }
  else if it == [ ] { " " }
  else { "" }
}

#let links = state("links", ())
#show link: it => {
  links.update(l => l + (plain(it.body),))
  it
}

#show: heading-style
#show: ref-style

= 緒論 <intro>
== 背景 <bg>
=== 細節 <detail>
#heading(numbering: none)[無編號] <plain>

@detail、@detail[見]、@bg[參照]、@intro

#figure(rect(), caption: [圖]) <fig>
@fig

#context assert.eq(
  links.final(),
  ("壹、一、(一)", "見壹、一、(一)", "參照壹、一", "壹"),
)
