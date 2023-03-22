/**
 * 蔵名の補完辞書
 *
 * 銘柄と蔵は数がそれなりに多い。
 * そのため、銘柄から一意の蔵が決まる辞書を使う。
 */
export type Dict = {
  [index: string]: string
}

/**
 * 酒の名前と補完辞書から補完する文字列を探す
 *
 * @param name - 酒の名前
 * @param dict - 補完辞書
 * @returns 補完できるなら補完候補、補完できないなら空文字を返す
 */
export function lookup(name: string, dict: Dict): string {
  const words = name.split(RegExp(/\s/))
  const matchedWords = words
    .map((word) => {
      return dict[word]
    })
    .filter((word) => {
      return word
    })
  if (matchedWords.length === 1) return matchedWords[0]
  else return ""
}
