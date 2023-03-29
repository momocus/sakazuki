function stripKuraTodofuken(kuraTodofuken: string) {
  // フォーマットは"蔵名（県名）"
  const formatRegexp = /^([^（]+)（([^）]+)）$/
  const result = formatRegexp.exec(kuraTodofuken)

  if (result && result[1] && result[2]) return [result[1], result[2]]
  else return [kuraTodofuken, ""]
}

function setInputValueById(id: string, value: string) {
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
    setInputValueById("sake_kura", kura)
    setInputValueById("sake_todofuken", todofuken)
  })
}

function loadKuraTodofuken() {
  const kuraForm = document.getElementById(
    "sake_kura"
  ) as HTMLInputElement | null
  if (kuraForm == null) return false

  const todofukenForm = document.getElementById(
    "sake_todofuken"
  ) as HTMLInputElement
  const visibleId = "sake_kura_todofuken_autocompletion"

  if (kuraForm.value && todofukenForm.value)
    setInputValueById(visibleId, `${kuraForm.value}（${todofukenForm.value}）`)
  else if (kuraForm.value) setInputValueById(visibleId, kuraForm.value)
  return true
}

addEventListener("turbo:load", (_event) => {
  loadKuraTodofuken() && setSyncEvent()
})

export {}
