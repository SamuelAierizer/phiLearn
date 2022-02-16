import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["hideable", "list"];

  connect() {
    this.mutateHideable();

    const observer = new MutationObserver(mutation => {
      this.mutateHideable();
    });

    observer.observe(this.listTarget, {
      childList: true,
      attributes: true,
      subtree: true,
      characterData: true
    });
  }

  mutateHideable() {
    if (this.listTarget.children.length == 0) {
      this.hideableTarget.classList.add("hidden");
      let noNotif = document.createElement('div');
      noNotif.classList = "flex items-center space-x-2 px-4 py-2 max-h-96 border-b relative";
      noNotif.textContent = "No notifications";
      noNotif.id = "noNotif"
      this.listTarget.appendChild(noNotif);
    } else {
      this.hideableTarget.classList.remove("hidden");
      if (document.contains(document.getElementById("noNotif"))) {
        document.getElementById("noNotif").remove();
      }
    }
  }
}