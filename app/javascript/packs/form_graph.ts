import { TasteGraph, domZeroP } from './taste_graph'

// DOMにデータがない場合はデータセットをする副作用がある
function syncAndGetDomValue(): Chart.Point {
  const tasteInput = document.getElementById(
    'sake_taste_value'
  ) as HTMLInputElement
  const aromaInput = document.getElementById(
    'sake_aroma_value'
  ) as HTMLInputElement
  if (tasteInput.value && aromaInput.value) {
    const taste = parseInt(tasteInput.value)
    const aroma = parseInt(aromaInput.value)
    if (taste != NaN && aroma != NaN) return { x: taste, y: aroma }
  }
  // データがとれなかった場合はグラフの原点をセットする
  updateDomValue(domZeroP)
  return domZeroP
}

function updateDomValue(data: Chart.Point): void {
  const tasteInput = document.getElementById(
    'sake_taste_value'
  ) as HTMLInputElement
  const aromaInput = document.getElementById(
    'sake_aroma_value'
  ) as HTMLInputElement
  tasteInput.setAttribute('value', data.x.toString())
  aromaInput.setAttribute('value', data.y.toString())
}

// Main
{
  // get datas from DOM
  const canvas = document.getElementById('taste_graph') as HTMLCanvasElement
  const domData = syncAndGetDomValue() // dataは0~6の二次元データ
  // make graph
  new TasteGraph(canvas, domData, updateDomValue)
}
