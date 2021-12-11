import { Controller } from "@hotwired/stimulus"
// import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = ["checkbox", "form", "field"];

  initialize() {
    this.userIds = [];
  }

  update_ids(event) {
    const element = event.target;

    if (element.checked) {
      if (this.userIds.indexOf(element.id) < 0)
        this.userIds.push(element.id);
    } else {
      const index = this.userIds.indexOf(element.id)
      if (index > -1) {
        this.userIds.splice(index, 1);
      }
    }
    
    sessionStorage.setItem("userIds", this.userIds);
  }

  commit() {
    this.fieldTarget.value = this.userIds
    // Rails.fire(this.formTarget, 'submit');
    this.formTarget.dispatchEvent(new CustomEvent('submit', {bubbles: true}));
    
    sessionStorage.setItem("userIds", "");
    sessionStorage.removeItem("userIds");
  }

  disconnect() {
    sessionStorage.setItem("userIds", "");
    sessionStorage.removeItem("userIds");
  }
}