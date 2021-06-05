function syncElement(srcId: string, dstId: string) {
  const srcElement = document.getElementById(srcId) as HTMLSelectElement
  const dstElement = document.getElementById(dstId) as HTMLSelectElement
  srcElement?.addEventListener('change', (_event) => {
    dstElement.value = srcElement.value
  })
}

function setBindumeDateEvent() {
  syncElement('bindume_year', 'sake_bindume_date_1i')
  syncElement('bindume_month', 'sake_bindume_date_2i')
}

// Main
{
  setBindumeDateEvent()
}
