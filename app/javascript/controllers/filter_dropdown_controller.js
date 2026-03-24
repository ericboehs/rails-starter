import { Controller } from "@hotwired/stimulus"

// Custom dropdown with keyboard navigation for filter forms.
// Replaces native <select> with accessible listbox-style menu.
//
// Usage:
//   <div data-controller="filter-dropdown">
//     <button data-filter-dropdown-target="button" data-action="click->filter-dropdown#toggle keydown->filter-dropdown#handleButtonKeydown">
//       Status <svg>...</svg>
//     </button>
//     <div data-filter-dropdown-target="menu" inert role="listbox">
//       <button data-filter-dropdown-target="item" data-value="" role="option" aria-selected="true">All</button>
//       <button data-filter-dropdown-target="item" data-value="pending" role="option" aria-selected="false">Pending</button>
//     </div>
//     <input type="hidden" data-filter-dropdown-target="input" name="status">
//   </div>
export default class extends Controller {
  static targets = ["button", "menu", "item", "input", "label"]

  connect() {
    this.close = this.close.bind(this)
    this.handleKeydown = this.handleKeydown.bind(this)
  }

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()

    if (this.isOpen()) {
      this.closeMenu()
    } else {
      this.closeOtherDropdowns()
      this.openMenu()
    }
  }

  handleButtonKeydown(event) {
    if ((event.key === "ArrowDown" || event.key === "Enter") && !this.isOpen()) {
      event.preventDefault()
      event.stopPropagation()
      this.closeOtherDropdowns()
      this.openMenu()
    }
  }

  openMenu() {
    this.menuTarget.classList.remove("opacity-0", "scale-95", "pointer-events-none")
    this.menuTarget.classList.add("opacity-100", "scale-100")
    this.menuTarget.removeAttribute("inert")
    this.buttonTarget.setAttribute("aria-expanded", "true")
    this.adjustPosition()

    const items = this.getVisibleItems()
    if (items.length > 0) {
      setTimeout(() => {
        if (this.element.isConnected) items[0].focus()
      }, 50)
    }

    document.addEventListener("click", this.close)
    document.addEventListener("keydown", this.handleKeydown)
  }

  closeMenu() {
    this.dismissMenu()
    this.buttonTarget.focus()
  }

  // Close without returning focus to button (used by Tab and outside click)
  dismissMenu() {
    this.menuTarget.classList.remove("opacity-100", "scale-100")
    this.menuTarget.classList.add("opacity-0", "scale-95", "pointer-events-none")
    this.menuTarget.setAttribute("inert", "")
    this.buttonTarget.setAttribute("aria-expanded", "false")

    document.removeEventListener("click", this.close)
    document.removeEventListener("keydown", this.handleKeydown)
  }

  close(event) {
    if (!this.element.contains(event.target)) {
      this.dismissMenu()
    }
  }

  select(event) {
    const button = event.currentTarget
    const value = button.dataset.value

    // Update hidden input
    this.inputTarget.value = value

    // Update button label
    if (this.hasLabelTarget) {
      this.labelTarget.textContent = button.textContent.trim()
    }

    // Update checkmarks and aria-selected
    this.itemTargets.forEach(item => {
      const isSelected = item.dataset.value === value
      item.setAttribute("aria-selected", isSelected)
      const check = item.querySelector("[data-check]")
      if (check) {
        check.classList.toggle("invisible", !isSelected)
      }
    })

    this.closeMenu()

    // Submit the form
    const form = this.element.closest("form")
    if (form) {
      form.requestSubmit()
    } else {
      console.error("[filter-dropdown] No parent <form> found — filter selection will not take effect.", this.element)
    }
  }

  adjustPosition() {
    const buttonRect = this.buttonTarget.getBoundingClientRect()
    const viewportWidth = window.innerWidth
    const spaceOnRight = viewportWidth - buttonRect.right
    const menuWidth = this.menuTarget.getBoundingClientRect().width || 224
    const buffer = 16

    if (spaceOnRight >= menuWidth + buffer) {
      this.menuTarget.classList.remove("right-0", "origin-top-right")
      this.menuTarget.classList.add("left-0", "origin-top-left")
    } else {
      this.menuTarget.classList.remove("left-0", "origin-top-left")
      this.menuTarget.classList.add("right-0", "origin-top-right")
    }
  }

  closeOtherDropdowns() {
    document.querySelectorAll("[data-controller~='filter-dropdown']").forEach(element => {
      if (element !== this.element) {
        const controller = this.application.getControllerForElementAndIdentifier(element, "filter-dropdown")
        if (controller && controller.isOpen()) {
          controller.dismissMenu()
        }
      }
    })
  }

  isOpen() {
    return this.menuTarget.classList.contains("opacity-100")
  }

  handleKeydown(event) {
    if (!this.isOpen()) return

    switch (event.key) {
      case "Escape":
        event.preventDefault()
        this.closeMenu()
        break
      case "Tab":
        this.dismissMenu()
        break
      case "Enter":
        event.preventDefault()
        if (this.element.contains(document.activeElement) && document.activeElement?.dataset?.value !== undefined) {
          document.activeElement.click()
        }
        break
      case "ArrowDown":
        event.preventDefault()
        this.focusNext()
        break
      case "ArrowUp":
        event.preventDefault()
        this.focusPrevious()
        break
      case "Home":
        event.preventDefault()
        this.focusFirst()
        break
      case "End":
        event.preventDefault()
        this.focusLast()
        break
    }
  }

  focusFirst() {
    const items = this.getVisibleItems()
    if (items.length > 0) items[0].focus()
  }

  focusLast() {
    const items = this.getVisibleItems()
    if (items.length > 0) items[items.length - 1].focus()
  }

  focusNext() {
    const items = this.getVisibleItems()
    const index = items.indexOf(document.activeElement)
    if (index === -1 && items.length > 0) {
      items[0].focus()
    } else if (index < items.length - 1) {
      items[index + 1].focus()
    }
  }

  focusPrevious() {
    const items = this.getVisibleItems()
    const index = items.indexOf(document.activeElement)
    if (index === 0) {
      this.closeMenu()
    } else if (index > 0) {
      items[index - 1].focus()
    }
  }

  getVisibleItems() {
    return this.itemTargets.filter(item => !item.classList.contains("hidden"))
  }

  disconnect() {
    document.removeEventListener("click", this.close)
    document.removeEventListener("keydown", this.handleKeydown)
  }
}
