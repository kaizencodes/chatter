// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "jquery3"
import "popper"
import "bootstrap-sprockets"

import "@hotwired/turbo-rails"
import "controllers"
import LocalTime from "local-time"

LocalTime.start()