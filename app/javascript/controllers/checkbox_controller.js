import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox"];

  connect(){
    this.userIds = sessionStorage.getItem("userIds");

    if (this.userIds != null) {
      this.checkboxTargets.forEach(element => {
        let index = this.userIds.indexOf(element.id);
        if (index > -1) {
          element.checked = true;
        }
      });
    }
  }
}