// 交互參照路徑（內部函式）：各層編號去除空白後相連，並去掉結尾的「、」或「.」。
#import "/src/heading.typ": heading-path

#assert.eq(heading-path((1,)), "壹")
#assert.eq(heading-path((1, 2)), "壹、二")
#assert.eq(heading-path((1, 2, 3)), "壹、二、(三)")
#assert.eq(heading-path((1, 2, 3, 4)), "壹、二、(三)4")
#assert.eq(heading-path((1, 2, 3, 4, 5)), "壹、二、(三)4.(5)")
#assert.eq(heading-path((1, 2, 3, 4, 5, 6)), "壹、二、(三)4.(5)⑥")
// 第七層起無編號，路徑停在第六層
#assert.eq(heading-path((1, 2, 3, 4, 5, 6, 7, 8)), "壹、二、(三)4.(5)⑥")
#assert.eq(heading-path((11, 1)), "拾壹、一")

// large 模式
#assert.eq(heading-path((1,), large: true), "Ch. 1")
#assert.eq(heading-path((1, 1, 2), large: true), "Ch. 1壹、二")
#assert.eq(heading-path((2, 3, 1, 4), large: true), "Ch. 2參、一、(四)")
