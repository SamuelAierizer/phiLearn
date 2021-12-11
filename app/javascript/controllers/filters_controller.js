import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["filter"];

  filter() {
    const url = `${window.location.pathname}?${this.params}`;

    Turbo.clearCache();
    Turbo.visit(url);
  }

  get params() {
    return this.filterTargets.map((t) => `${t.name}=${t.value}`).join("&");
  }
}