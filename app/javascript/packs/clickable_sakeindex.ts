const trsColl =
  document.getElementsByClassName("clickable") as
  HTMLCollectionOf<HTMLTableRowElement>
const trs = Array.from(trsColl)

for (let tr of trs) {
  const id = tr.dataset.sakeId
  const newLocation = "/sakes/" + id
  tr.onclick = (_) => {
    window.location.assign(newLocation)
  }
}
