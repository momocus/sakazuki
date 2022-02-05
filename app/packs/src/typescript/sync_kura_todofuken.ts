// "蔵名（都道府県名）"から"蔵名"と"都道府県名"を抽出する
function stripKuraTodofuken(kuraTodofuken: string) {
  const regexp = /^([^（]+)（([^）]+)）$/
  const result = regexp.exec(kuraTodofuken)

  if (result && result[1] && result[2]) return [result[1], result[2]]
  else return ["", ""]
}

function setElementValueById(id: string, value: string) {
  const form = document.getElementById(id) as HTMLInputElement
  form.value = value
}

function setSyncEvent() {
  const form = document.getElementById(
    "sake_kura_todofuken_autocompletion"
  ) as HTMLInputElement

  form.addEventListener("change", (_event) => {
    const autocompeted = form.value
    const [kura, todofuken] = stripKuraTodofuken(autocompeted)
    setElementValueById("sake_kura", kura)
    setElementValueById("sake_todofuken", todofuken)
  })
}

function loadKuraTodofuken() {
  const kuraForm = document.getElementById("sake_kura") as HTMLInputElement
  const todofukenForm = document.getElementById(
    "sake_todofuken"
  ) as HTMLInputElement
  const visibleForm = document.getElementById(
    "sake_kura_todofuken_autocompletion"
  ) as HTMLInputElement

  if (kuraForm.value && todofukenForm.value)
    visibleForm.value = `${kuraForm.value}（${todofukenForm.value}）`
}

// Main
{
  document.addEventListener("DOMContentLoaded", function () {
    loadKuraTodofuken()
    setSyncEvent()
  })
}
