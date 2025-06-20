import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mobileMenu", "mobileOpenIcon", "mobileCloseIcon", "dropdown"]

  toggleMobileMenu() {
    this.mobileMenuTarget.classList.toggle("hidden")
    this.mobileOpenIconTarget.classList.toggle("hidden")
    this.mobileOpenIconTarget.classList.toggle("block")
    this.mobileCloseIconTarget.classList.toggle("hidden")
    this.mobileCloseIconTarget.classList.toggle("block")

    // Update aria-expanded
    const button = this.element.querySelector('[aria-controls="mobile-menu"]')
    const expanded = button.getAttribute("aria-expanded") === "true"
    button.setAttribute("aria-expanded", !expanded)
  }

  toggleDropdown() {
    this.dropdownTarget.classList.toggle("hidden")

    // Update aria-expanded
    const button = this.element.querySelector('[aria-haspopup="true"]')
    const expanded = button.getAttribute("aria-expanded") === "true"
    button.setAttribute("aria-expanded", !expanded)
  }

  hideDropdown(event) {
    if (!this.element.contains(event.target)) {
      this.dropdownTarget.classList.add("hidden")
      const button = this.element.querySelector('[aria-haspopup="true"]')
      button.setAttribute("aria-expanded", "false")
    }
  }

  connect() {
    // Close dropdown when clicking outside
    document.addEventListener("click", this.hideDropdown.bind(this))
  }

  disconnect() {
    document.removeEventListener("click", this.hideDropdown.bind(this))
  }
}
