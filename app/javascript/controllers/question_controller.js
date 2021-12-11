import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["single", "multi", "select", "option"]

  connect() {
    if (this.selectTarget.value === "open") {
      this.set(false, true);
    } else {
      this.set(true, false);
    }
  }

  changed(event) {
    if (this.selectTarget.value === "open") {
      this.set(false, true);
    } else {
      this.set(true, false);
    }
  }

  set(single, multi) {
    this.singleTarget.hidden = single;
    this.multiTarget.hidden = multi;
  }

  selectRadioOption(event) {
    if (this.selectTarget.value === "radial"){
      this.optionTargets.forEach((el, i) => {
        if (el.checked) {
          el.checked = false;
        }        
      })
      event.target.checked = true;
    }
  }
}