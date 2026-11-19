// 單一標題的編號（內部函式）：六層「壹、一、(一) 1.(1) ①」，第七層起無編號。
#import "/src/heading.typ": heading-number

// 一般模式
#assert.eq(heading-number((1,)), "壹、")
#assert.eq(heading-number((1, 2)), "二、")
#assert.eq(heading-number((1, 2, 3)), "(三) ")
#assert.eq(heading-number((1, 2, 3, 4)), "4.")
#assert.eq(heading-number((1, 2, 3, 4, 5)), "(5) ")
#assert.eq(heading-number((1, 2, 3, 4, 5, 6)), "⑥")
#assert.eq(heading-number((1, 2, 3, 4, 5, 6, 7)), none)
#assert.eq(heading-number((1, 2, 3, 4, 5, 6, 7, 8)), none)

// 第一層超過十：大寫數字進位，且簡體字形（贰、叁、陆）換回貳、參、陸
#assert.eq(heading-number((2,)), "貳、")
#assert.eq(heading-number((3,)), "參、")
#assert.eq(heading-number((6,)), "陸、")
#assert.eq(heading-number((10,)), "拾、")
#assert.eq(heading-number((11,)), "拾壹、")
#assert.eq(heading-number((20,)), "貳拾、")
#assert.eq(heading-number((23,)), "貳拾參、")
#assert.eq(heading-number((1, 11)), "十一、")

// large 模式：最上層多一層「Ch. 1」，其餘各層下移一層
#assert.eq(heading-number((1,), large: true), "Ch. 1 ")
#assert.eq(heading-number((12,), large: true), "Ch. 12 ")
#assert.eq(heading-number((1, 1), large: true), "壹、")
#assert.eq(heading-number((1, 1, 2), large: true), "二、")
#assert.eq(heading-number((1, 1, 2, 3), large: true), "(三) ")
#assert.eq(heading-number((1, 1, 2, 3, 4), large: true), "4.")
#assert.eq(heading-number((1, 1, 2, 3, 4, 5), large: true), "(5) ")
#assert.eq(heading-number((1, 1, 2, 3, 4, 5, 6), large: true), "⑥")
#assert.eq(heading-number((1, 1, 2, 3, 4, 5, 6, 7), large: true), none)
