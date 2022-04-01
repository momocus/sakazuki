function syncElement(srcId: string, dstId: string): void {
  const srcElement = document.getElementById(srcId) as HTMLSelectElement
  const dstElement = document.getElementById(dstId) as HTMLSelectElement
  dstElement.value = srcElement.value
}

function setSyncEvent(): void {
  // year
  const yearElement = document.getElementById(
    "sake_bindume_year"
  ) as HTMLSelectElement
  yearElement.addEventListener("change", (_event) => {
    syncElement("sake_bindume_year", "sake_bindume_date_1i")
  })
  // month
  const monthElement = document.getElementById(
    "sake_bindume_month"
  ) as HTMLSelectElement
  monthElement.addEventListener("change", (_event) => {
    syncElement("sake_bindume_month", "sake_bindume_date_2i")
  })
}

function loadBindumeDate() {
  syncElement("sake_bindume_date_1i", "sake_bindume_year")
  syncElement("sake_bindume_date_2i", "sake_bindume_month")
}

// Main
{
  document.addEventListener("DOMContentLoaded", function () {
    loadBindumeDate()
    setSyncEvent()
  })
}

export {}
