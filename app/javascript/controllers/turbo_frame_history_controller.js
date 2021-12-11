import { Controller } from "@hotwired/stimulus"
import { navigator } from '@hotwired/turbo'

export default class extends Controller {

  mutate ({ params: { url } }) {
    if (url != null) { navigator.history.push(new URL(url)) }
  }
}