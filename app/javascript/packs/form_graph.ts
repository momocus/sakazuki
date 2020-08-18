import { GraphP, TasteGraph, domZeroP } from './taste_graph'

function updateDomValue(data: GraphP): void {
  const x = data ? data.x.toString() : ''
  const y = data ? data.y.toString() : ''
  const tasteInput = document.getElementById(
    'sake_taste_value'
  ) as HTMLInputElement
  const aromaInput = document.getElementById(
    'sake_aroma_value'
  ) as HTMLInputElement
  tasteInput.setAttribute('value', x)
  aromaInput.setAttribute('value', y)
}

// DOMにデータがない場合はデータセットをする副作用がある
function syncAndGetDomValue(): GraphP {
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
  return null // データがない場合
}

{
  // DOMから味・香りの値を取る
  const canvas = document.getElementById('taste_graph') as HTMLCanvasElement
  const domData = syncAndGetDomValue() // dataは0~6の二次元データ

  // グラフをセットする
  const graph = new TasteGraph(canvas, domData, updateDomValue)

  // グラフのリセットボタンをセットする
  const button = document.getElementById('graph-reset') as HTMLDivElement
  button.onclick = () => {
    graph.update(null)
    updateDomValue(null)
  }
}
