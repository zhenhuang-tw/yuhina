/// [input: USE_LINUX=true]
// USE_LINUX：不列 Windows 字型，每種 CJK 降級字型只留一個（TC 版本）。
#import "/lib.typ": font-fsong, font-hei, font-kai, font-song, font-yuan

#assert.eq(font-song, ("Libertinus Serif", "Noto Serif CJK TC"))
#assert.eq(font-hei, ("Libertinus Sans", "Noto Sans CJK TC"))
#assert.eq(font-kai, ("Libertinus Serif", "TW-MOE-Std-Kai", "Noto Serif CJK TC"))
#assert.eq(font-yuan, ("TaiwanPearl", ..font-hei))
#assert.eq(font-fsong.slice(1), font-song)
