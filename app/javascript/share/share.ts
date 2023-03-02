export {}

const share_text = document.getElementById("share_text") as HTMLTextAreaElement
const shareData: ShareData = {
  title: document.title,
  text: share_text.value,
  url: location.href,
}

const shareButton = document.getElementById("share_button") as HTMLInputElement
shareButton.addEventListener("click", () => {
  void navigator.share(shareData)
})
