import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "display", "select", "search" ];

  connect() {

  }

  selectColor({ params: {color} }) {
    this.selectTarget.value = color;
    let colorCircle = document.createElement('div');
    colorCircle.classList = "h-4 w-4 rounded-full bg-" + color;
    this.displayTarget.innerHTML = '';
    this.displayTarget.appendChild(colorCircle);
  }

  debounce() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
        this.searchTarget.requestSubmit()
      }, 500)
  }

}