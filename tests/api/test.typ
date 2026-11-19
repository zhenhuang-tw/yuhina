// 公開 API：以 `*` 匯入時只能取得下列名稱。
// 新增公開名稱時，請同步更新本清單、README 與 CHANGELOG；
// 若本測試因多出名稱而失敗，代表有內部名稱外洩。
#import "/lib.typ" as yuhina

#let expected = (
  // 字型清單
  "font-fsong",
  "font-hei",
  "font-kai",
  "font-song",
  "font-yuan",
  // 行內樣式
  "inquote",
  "keyword",
  // 作者與標題區塊
  "normalize-authors",
  "title-block",
  // 排版規則
  "common-style",
  "document-style",
  "figure-style",
  "footnote-style",
  "heading-style",
  "list-style",
  "page-style",
  "par-style",
  "plain-links",
  "quote-style",
  "ref-style",
  "text-style",
)

#assert.eq(dictionary(yuhina).keys().sorted(), expected.sorted())
