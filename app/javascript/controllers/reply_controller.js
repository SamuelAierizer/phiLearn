import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "parentField", "text" ]

  static values = {
    privilage: String,
    uid: Number
  }

  connect() {
    let privilage = this.privilageValue;
    let user = this.uidValue;
    sessionStorage.setItem("privilage", privilage);
    sessionStorage.setItem("user", user);
  }

  disconnect() {
    sessionStorage.removeItem("privilage");
    sessionStorage.removeItem("user");
  }

  setParent(event) {
    let parentId = event.target.id;
    this.parentFieldTarget.value = parentId;
  }

  setText({ params: { text } }) {
    this.textTarget.textContent = text;
  }
}