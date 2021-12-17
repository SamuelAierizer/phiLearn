import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  apply({ params: { old, oldfrom, oldto, next, nextfrom, nextto } }) {
    let oldElement = document.getElementById(old);
    oldElement.classList.remove(oldfrom);
    oldElement.classList.add(oldto);

    let nextElement = document.getElementById(next);
    nextElement.classList.remove(nextfrom);
    nextElement.classList.add(nextto);
  }
}