import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mobileMenu", "mobileOpenIcon", "mobileCloseIcon", "dropdown"]

  connect() {
    this.hideDropdown = this.hideDropdown.bind(this)
    this.handleMenuKeydown = this.handleMenuKeydown.bind(this)
    this.handleMobileMenuKeydown = this.handleMobileMenuKeydown.bind(this)
    document.addEventListener("click", this.hideDropdown)
  }

  disconnect() {
    document.removeEventListener("click", this.hideDropdown)
    document.removeEventListener("keydown", this.handleMenuKeydown)
    document.removeEventListener("keydown", this.handleMobileMenuKeydown)
  }

  // --- Profile dropdown ---

  toggleDropdown() {
    if (this.isDropdownClosed()) {
      this.openDropdown()
    } else {
      this.closeDropdown()
    }
  }

  handleButtonKeydown(event) {
    if ((event.key === "ArrowDown" || event.key === "Enter") && this.isDropdownClosed()) {
      event.preventDefault()
      event.stopPropagation()
      this.openDropdown()
      setTimeout(() => {
        if (!this.element.isConnected) return
        const items = this.getMenuItems()
        if (items.length > 0) items[0].focus()
      }, 50)
    }
  }

  openDropdown() {
    this.dropdownTarget.classList.remove("hidden")
    const button = this.element.querySelector("[aria-haspopup='true']")
    if (button) button.setAttribute("aria-expanded", "true")
    document.addEventListener("keydown", this.handleMenuKeydown)
  }

  closeDropdown() {
    this.dismissDropdown()
    const button = this.element.querySelector("[aria-haspopup='true']")
    if (button) button.focus()
  }

  // Close without returning focus to button (used by Tab and outside click)
  dismissDropdown() {
    this.dropdownTarget.classList.add("hidden")
    const button = this.element.querySelector("[aria-haspopup='true']")
    if (button) button.setAttribute("aria-expanded", "false")
    document.removeEventListener("keydown", this.handleMenuKeydown)
  }

  isDropdownClosed() {
    return this.dropdownTarget.classList.contains("hidden")
  }

  hideDropdown(event) {
    if (!this.element.contains(event.target) && !this.isDropdownClosed()) {
      this.dismissDropdown()
    }
  }

  handleMenuKeydown(event) {
    if (this.isDropdownClosed()) return

    switch (event.key) {
      case "Escape":
        event.preventDefault()
        this.closeDropdown()
        break
      case "Tab":
        this.dismissDropdown()
        break
      case "ArrowDown":
        event.preventDefault()
        this.focusNextMenuItem()
        break
      case "ArrowUp": {
        event.preventDefault()
        const items = this.getMenuItems()
        const index = this.getCurrentIndex(items)
        if (index === 0) {
          this.closeDropdown()
        } else {
          this.focusPreviousMenuItem()
        }
        break
      }
    }
  }

  getMenuItems() {
    return Array.from(this.dropdownTarget.querySelectorAll("a[role='menuitem']"))
  }

  getCurrentIndex(items) {
    return items.findIndex(item => item === document.activeElement)
  }

  focusNextMenuItem() {
    const items = this.getMenuItems()
    const index = this.getCurrentIndex(items)
    if (index === -1 && items.length > 0) {
      items[0].focus()
    } else if (index < items.length - 1) {
      items[index + 1].focus()
    }
  }

  focusPreviousMenuItem() {
    const items = this.getMenuItems()
    const index = this.getCurrentIndex(items)
    if (index > 0) items[index - 1].focus()
  }

  // --- Mobile menu ---

  toggleMobileMenu() {
    if (this.isMobileMenuClosed()) {
      this.openMobileMenu()
    } else {
      this.closeMobileMenu()
    }
  }

  handleMobileButtonKeydown(event) {
    if ((event.key === "ArrowDown" || event.key === "Enter") && this.isMobileMenuClosed()) {
      event.preventDefault()
      event.stopPropagation()
      this.openMobileMenu()
      setTimeout(() => {
        if (!this.element.isConnected) return
        const items = this.getMobileMenuItems()
        if (items.length > 0) items[0].focus()
      }, 50)
    }
  }

  openMobileMenu() {
    this.mobileMenuTarget.classList.remove("hidden")
    this.mobileOpenIconTarget.classList.add("hidden")
    this.mobileOpenIconTarget.classList.remove("block")
    this.mobileCloseIconTarget.classList.remove("hidden")
    this.mobileCloseIconTarget.classList.add("block")

    const button = this.element.querySelector("[aria-controls='mobile-menu']")
    if (button) button.setAttribute("aria-expanded", "true")
    document.addEventListener("keydown", this.handleMobileMenuKeydown)
  }

  closeMobileMenu() {
    this.dismissMobileMenu()
    const button = this.element.querySelector("[aria-controls='mobile-menu']")
    if (button) button.focus()
  }

  // Close without returning focus to button (used by Tab)
  dismissMobileMenu() {
    this.mobileMenuTarget.classList.add("hidden")
    this.mobileOpenIconTarget.classList.remove("hidden")
    this.mobileOpenIconTarget.classList.add("block")
    this.mobileCloseIconTarget.classList.add("hidden")
    this.mobileCloseIconTarget.classList.remove("block")

    const button = this.element.querySelector("[aria-controls='mobile-menu']")
    if (button) button.setAttribute("aria-expanded", "false")
    document.removeEventListener("keydown", this.handleMobileMenuKeydown)
  }

  isMobileMenuClosed() {
    return this.mobileMenuTarget.classList.contains("hidden")
  }

  handleMobileMenuKeydown(event) {
    if (this.isMobileMenuClosed()) return

    switch (event.key) {
      case "Escape":
        event.preventDefault()
        this.closeMobileMenu()
        break
      case "Tab":
        this.dismissMobileMenu()
        break
      case "ArrowDown":
        event.preventDefault()
        this.focusNextMobileItem()
        break
      case "ArrowUp": {
        event.preventDefault()
        const items = this.getMobileMenuItems()
        const index = this.getCurrentIndex(items)
        if (index === 0) {
          this.closeMobileMenu()
        } else {
          this.focusPreviousMobileItem()
        }
        break
      }
    }
  }

  getMobileMenuItems() {
    return Array.from(this.mobileMenuTarget.querySelectorAll("a"))
  }

  focusNextMobileItem() {
    const items = this.getMobileMenuItems()
    const index = this.getCurrentIndex(items)
    if (index === -1 && items.length > 0) {
      items[0].focus()
    } else if (index < items.length - 1) {
      items[index + 1].focus()
    }
  }

  focusPreviousMobileItem() {
    const items = this.getMobileMenuItems()
    const index = this.getCurrentIndex(items)
    if (index > 0) items[index - 1].focus()
  }
}
