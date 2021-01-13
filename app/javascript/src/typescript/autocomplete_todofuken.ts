// '原田酒造合資会社（愛知県）'から'愛知県'のみを抽出する
// 不正な入力の場合は空文字を返す
function stripKura(kuraTodofuken: String) {
  const re = /.+（(.+)）/
  const todofuken = kuraTodofuken.replace(re, '$1')
  return todofuken == kuraTodofuken ? '' : todofuken
}

function setEvent() {
  const kuraForm = document.getElementById('sake_kura') as HTMLInputElement
  const todofukenForm = document.getElementById(
    'sake_todofuken'
  ) as HTMLInputElement
  kuraForm.addEventListener('change', (event) => {
    const kuraForm = event.target as HTMLInputElement
    const inputKura = kuraForm.value
    const todofuken = stripKura(inputKura)
    todofukenForm.value = todofuken
  })
}

// Main
{
  setEvent()
}
