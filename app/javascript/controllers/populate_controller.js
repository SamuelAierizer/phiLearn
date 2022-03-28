import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "form", "field", "display", "inputIds", "inputUsernames"];

  initialize() {
    this.userIds = [];
    this.usernames = [];
  }

  connect() {
    this.userIds = JSON.parse(this.inputIdsTarget.innerHTML);
    this.usernames = JSON.parse(this.inputUsernamesTarget.innerHTML);

    this.displayAdded();
  }

  update_ids(event) {
    const element = event.target;

    if (element.checked) {
      if (this.userIds.indexOf(element.id) < 0)
        this.userIds.push(element.id);
    } else {
      const index = this.userIds.indexOf(element.id)
      if (index > -1) {
        this.userIds.splice(index, 1);
      }
    }
    
    sessionStorage.setItem("userIds", this.userIds);
  }

  commit() {
    this.fieldTarget.value = this.userIds
    // Rails.fire(this.formTarget, 'submit');
    this.formTarget.dispatchEvent(new CustomEvent('submit', {bubbles: true}));
    
    sessionStorage.setItem("userIds", "");
    sessionStorage.removeItem("userIds");
  }

  disconnect() {
    sessionStorage.setItem("userIds", "");
    sessionStorage.removeItem("userIds");
  }

  addUser({ params: {id, username} }) {
    if (this.userIds.indexOf(id) < 0) {
      this.userIds.push(id);
      this.usernames.push(username);
    }

    document.getElementById(username).classList.toggle("hidden");
    
    this.displayAdded();
  }

  displayAdded() {
    // this.fieldTarget.value = this.userIds;
    this.fieldTargets.forEach(element => {
      element.value = this.userIds;
    })
    
    let users = "";
    this.usernames.forEach((element, index) => {
      users += "<div id='populate_" + element + "' class='px-4 py-2 hover:bg-gray-300 dark:hover:bg-black cursor-pointer' data-populate-id-param=" + this.userIds[index] 
        + " data-populate-username-param=" + element + " data-action='click->populate#removeUser'> <i class='fas fa-minus text-red-600 mr-4'></i> "
        + element
      +" </div>"
    });
    this.displayTarget.innerHTML = users;
  }

  removeUser({ params: {id, username} }) {
    const indexId = this.userIds.indexOf(id)
    if (indexId > -1) {
      this.userIds.splice(indexId, 1);
    }

    const index = this.usernames.indexOf(username)
    if (index > -1) {
      this.usernames.splice(index, 1);
    }

    // this.fieldTarget.value = this.userIds;
    this.fieldTargets.forEach(element => {
      element.value = this.userIds;
    })

    document.getElementById('populate_'+username).remove();
    document.getElementById(username).classList.toggle("hidden");
  }
}