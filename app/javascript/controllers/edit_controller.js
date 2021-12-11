import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "options" ];

  connect() {
    let privilage = sessionStorage.getItem("privilage");
    let user = sessionStorage.getItem("user");
    if(privilage != 'admin' && user != this.optionsTarget.id) {
      this.optionsTarget.remove();
    }
  }
}