import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

// Import and register all TailwindCSS Components*
import { Alert, Dropdown, Modal, Tabs, Popover, Toggle } from "tailwindcss-stimulus-components"
application.register('alert', Alert)
application.register('dropdown', Dropdown)
application.register('modal', Modal)
application.register('tabs', Tabs)
application.register('popover', Popover)
application.register('toggle', Toggle)

import CheckboxSelectAll from "stimulus-checkbox-select-all"
application.register("checkbox-select-all", CheckboxSelectAll)

import NestedForm from "stimulus-rails-nested-form"
application.register("nested-form", NestedForm)

import Flatpickr from 'stimulus-flatpickr'
application.register('flatpickr', Flatpickr)

export { application }
