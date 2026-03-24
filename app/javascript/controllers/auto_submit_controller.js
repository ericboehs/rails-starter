import { Controller } from "@hotwired/stimulus"

// Automatically submits a form when any of its inputs change.
// Usage: <form data-controller="auto-submit">
export default class extends Controller {
  submit() {
    this.element.requestSubmit()
  }
}
