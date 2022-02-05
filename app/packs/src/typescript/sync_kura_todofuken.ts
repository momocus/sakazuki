// "蔵名（都道府県名）"から"蔵名"と"都道府県名"を抽出する
function stripKuraTodofuken(kuraTodofuken: string) {
  const regexp = /^([^（]+)（([^）]+)）$/
  const result = regexp.exec(kuraTodofuken)

  if (result && result[1] && result[2]) return [result[1], result[2]]
  else return ["", ""]
}

function setElementValueById(id: string, value: string) {
  const form = document.getElementById(id)
  if (form) form.setAttribute("value", value)
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

// Main
{
  document.addEventListener("DOMContentLoaded", function () {
    setSyncEvent()
  })
}
