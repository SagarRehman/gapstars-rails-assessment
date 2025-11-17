import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  connect() {
    this.timer = null
  }

  query(event) {
    const q = event.target.value || ""
    clearTimeout(this.timer)
    this.timer = setTimeout(() => this.fetch(q), 150) // debounce 150ms
  }

  async fetch(q) {
    try {
      const url = new URL(this.urlValue, window.location.origin)
      url.searchParams.set("q", q)

      const res = await fetch(url.toString(), {
        headers: {
          "Turbo-Frame": "results",
          "Accept": "text/html" // force HTML so Rails renders the .erb partial
        },
        credentials: "same-origin"
      })

      const html = await res.text()
      const frame = document.querySelector("turbo-frame#results")
      if (frame) frame.innerHTML = html
    } catch (e) {
      // optional: show a simple error message in the results frame
      const frame = document.querySelector("turbo-frame#results")
      if (frame) frame.innerHTML = `<div class="text-danger">Search failed.</div>`
    }
  }
}
