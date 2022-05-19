import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
  connect(){
    if (this.element.dataset.handler != 'border-2 text-black') {
      let handler = document.getElementById(this.element.dataset.handler + " toggle");
      
      if (!handler.checked) {
        this.element.classList.toggle('hidden');
      }
    }
  }
}