import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]

  show() {
    if (this.hasContentTarget) {
      this.contentTarget.classList.remove("hidden")
    }
  }

  hide() {
    if (this.hasContentTarget) {
      this.contentTarget.classList.add("hidden")
    }
  }
}
