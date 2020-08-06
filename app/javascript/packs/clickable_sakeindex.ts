const trsColl = document.getElementsByClassName(
  'clickable'
) as HTMLCollectionOf<HTMLTableRowElement>
const trs = Array.from(trsColl)

for (const tr of trs) {
  const id = tr.dataset.sakeId
  if (id != null) {
    const newLocation = '/sakes/' + id
    tr.onclick = () => {
      window.location.assign(newLocation)
    }
  }
}
