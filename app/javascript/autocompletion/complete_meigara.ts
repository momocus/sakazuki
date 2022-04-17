import * as meigaras from "./meigaras"

interface MeigarasHash {
  [index: string]: string
}

function checkMeigara(words: Array<string>, meigaras: MeigarasHash): string {
  const matched_words = words
    .map((word) => {
      return meigaras[word]
    })
    .filter((word) => {
      return word
    })

  if (matched_words.length == 1) return matched_words[0]
  else return ""
}

{
  const nameForm = document.getElementById("sake_name") as HTMLInputElement
  const kuraForm = document.getElementById(
    "sake_kura_todofuken_autocompletion"
  ) as HTMLInputElement

  nameForm.addEventListener("change", (_event) => {
    // まだ蔵が入力されてないときに補完を試みる
    if (kuraForm.value == "") {
      const name = nameForm.value
      const words = name.split(RegExp(/\s/))
      const completion = checkMeigara(words, meigaras.dict)
      kuraForm.value = completion
      // changeイベントを発火する
      const event = new Event("change")
      kuraForm.dispatchEvent(event)
    }
  })
}
