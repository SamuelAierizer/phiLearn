import { Controller } from "@hotwired/stimulus"
// import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = ["test", "id", "switch", "form"]

  toggle(event) {
    let formData = new FormData()
    formData.append("user_id", this.data.get("variable"));
    let csrf = document.querySelector("meta[name='csrf-token']").getAttribute("content");

    fetch(this.data.get("update-url"), {
      body: formData,
      method: 'POST',
      credentials: "include",
      dataType: "script",
      headers: {
        "X-CSRF-Token": csrf
      },
    }).then(function(response) {
      if (response.status != 204) {
        event.target.checked = !event.target.checked
      }
    })
  }

  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      // Rails.fire(this.formTarget, 'submit')
      this.formTarget.dispatchEvent(new CustomEvent('submit', {bubbles: true}))
    }, 200)
  }
}
