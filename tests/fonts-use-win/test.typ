/// [input: USE_WIN=1]
// USE_WIN：只用 Windows／Office 字型，加上 Typst 內建的 Libertinus Serif。
#import "/lib.typ": font-fsong, font-hei, font-kai, font-song, font-yuan

#assert.eq(font-song, ("Times New Roman", "PMingLiU", "Libertinus Serif"))
#assert.eq(font-hei, ("Arial", "Microsoft JhengHei UI"))
#assert.eq(font-kai, ("Times New Roman", "DFKai-SB", "Libertinus Serif"))
#assert.eq(font-yuan, ("TaiwanPearl", "Arial", "Microsoft JhengHei UI"))
#assert.eq(font-fsong.slice(1), font-song)
