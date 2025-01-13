import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["viewMode", "editMode", "input"]

  showEdit() {
    this.viewModeTarget.classList.add("hidden")
    this.editModeTarget.classList.remove("hidden")
    this.inputTarget.focus()
  }

  hideEdit() {
    this.viewModeTarget.classList.remove("hidden")
    this.editModeTarget.classList.add("hidden")
  }

  connect() {
    this.element.addEventListener("turbo:submit-end", this.hideEdit.bind(this))
  }
}