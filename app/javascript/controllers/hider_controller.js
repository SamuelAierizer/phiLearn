import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["hideable", "list"];

  connect() {
    if (this.hasListTarget) {
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
      if (!document.contains(document.getElementById("noNotif"))) {
        this.hideableTarget.classList.remove("hidden");
      } else if (this.listTarget.children.length > 1) {
        document.getElementById("noNotif").remove();
      }
    }
  }

  hideGroup({ params: {group} }) {
    let elements = document.getElementsByClassName(group);

    for(let i = 0; i < elements.length; i++) {
      elements[i].classList.toggle("hidden");
    }
  }
}