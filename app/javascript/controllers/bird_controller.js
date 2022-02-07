import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["switch", "like", "unlike", "counter"]

  fly(event) {
    let formData = new FormData()
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

    if (event.target != this.switchTarget) {
      this.switchTarget.checked = !this.switchTarget.checked
    }
  }

  like({ params: {url, count} }) {
    this.likeTarget.classList.toggle('hidden');
    this.unlikeTarget.classList.toggle('hidden');

    this.counterTarget.textContent = count;

    this.likeTarget.dataset.birdCountParam = count + 1;
    this.unlikeTarget.dataset.birdCountParam = count - 1;
    
    if (count > 0) {
      this.counterTarget.parentElement.classList.remove('hidden');
    } else {
      this.counterTarget.parentElement.classList.add('hidden');
    }

    this.call(url, 0, "POST");
  }

  call(url, payload, method) {
    let formData = new FormData()
    let csrf = document.querySelector("meta[name='csrf-token']").getAttribute("content");

    if (method == null){ method = "POST"; }

    formData.append("payload", payload);

    fetch(url, {
      body: formData,
      method: method,
      credentials: "include",
      dataType: "script",
      headers: {
        "X-CSRF-Token": csrf
      },
    })
  }

}