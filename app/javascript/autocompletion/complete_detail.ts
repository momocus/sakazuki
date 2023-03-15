import * as dicts from "./detail_dicts"

/** 補完候補 */
type CompletionCandidate = {
  /** このキーワードが含まれていたら補完を行う */
  keywords: Array<string>
  /** 補完に使う文字列 */
  completion: string
}

/** 補完辞書 */
type CompletionDict = Array<CompletionCandidate>

/**
 * 指定した複数文字列のいずれか1つでも含まれるかをチェックする
 *
 * String.includesの複数候補版。
 *
 * @param target - 検索対象の文字列
 * @param keywords - 検索する複数キーワード
 * @returns 検索対象にいずれかのキーワードが1つでも含まれればtrue
 */
function includesAny(target: string, keywords: Array<string>): boolean {
  return keywords.some((word) => {
    return target.includes(word)
  })
}

/**
 * 補完候補を採用するかチェックする
 *
 * @param name - 酒の名前
 * @param cand - 補完候補
 * @returns 採用されれば補完候補、採用されなければ空文字列を返す
 */
function check(name: string, cand: CompletionCandidate): string {
  return includesAny(name, cand.keywords) ? cand.completion : ""
}

/**
 * 酒の名前と補完辞書から補完する文字列を決定する
 *
 * @param name - 酒の名前
 * @param dict - 補完辞書
 * @returns 補完できるなら補完候補、補完できないなら空文字を返す
 */
function lookup(name: string, dict: CompletionDict): string {
  const found = dict.find((cand) => {
    return check(name, cand) !== ""
  })
  return found?.completion ?? ""
}

/**
 * 酒の名前から指定された酒フォームの補完を行う
 *
 * 未入力状態のときのみ補完を行う。
 * 未入力状態かはフォームの内容`value`が`empty`と同じかで判定する。
 *
 * @param name - 酒の名前
 * @param dict - 補完辞書
 * @param targetId - 補完対象のエレメントID
 * @param empty - 補完対象の未入力状態
 */
function complete(
  name: string,
  dict: CompletionDict,
  targetId: string,
  empty: string
): void {
  const element = document.getElementById(targetId) as
    | HTMLSelectElement
    | HTMLInputElement
  if (element.value === empty) {
    const completion = lookup(name, dict)
    if (completion !== "") {
      element.value = completion
      element.dispatchEvent(new Event("change"))
    }
  }
}

addEventListener("turbo:load", (_event) => {
  // 酒の名前の入力先
  const nameElem = document.getElementById(
    "sake_name"
  ) as HTMLInputElement | null

  if (nameElem != null) {
    nameElem.addEventListener("change", (_event) => {
      const name = nameElem.value
      complete(name, dicts.tokutei_meisho, "sake_tokutei_meisho", "none")
      complete(name, dicts.season, "sake_season", "")
      complete(name, dicts.moto, "sake_moto", "unknown")
      complete(name, dicts.shibori, "sake_shibori", "")
      complete(name, dicts.roka, "sake_roka", "")
      complete(name, dicts.hiire, "sake_hiire", "unknown")
      complete(name, dicts.warimizu, "sake_warimizu", "unknown")
    })
  }
})
