const trsColl = document.getElementsByClassName(
  'clickable'
) as HTMLCollectionOf<HTMLTableRowElement>
const trs = Array.from(trsColl)

for (const tr of trs) {
  const id: string = tr.dataset.sakeId
  const newLocation = '/sakes/' + id
  tr.onclick = () => {
    window.location.assign(newLocation)
  }
}
