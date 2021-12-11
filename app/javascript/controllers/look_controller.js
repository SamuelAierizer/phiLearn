import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["nav", "page"]

  connect() {
    if (localStorage.theme === 'dark' || (!'theme' in localStorage && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
      this.pageTarget.classList.add('dark')
    } else if (localStorage.theme === 'dark') {
      this.pageTarget.classList.add('dark')
    }
  }

  show() {
    this.navTarget.classList.toggle('hidden');
  }

  dark() {
    if(localStorage.theme == 'dark') {
      this.pageTarget.classList.remove('dark');
      localStorage.removeItem('theme')
    } else {
      this.pageTarget.classList.add('dark');
      localStorage.theme = 'dark';
    }
  }
}