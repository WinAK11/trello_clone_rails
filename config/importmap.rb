# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "jkanban", to: "https://ga.jspm.io/npm:jkanban@1.3.1/jkanban.js"
pin "atoa", to: "https://ga.jspm.io/npm:atoa@1.0.0/atoa.js"
pin "contra/emitter", to: "https://ga.jspm.io/npm:contra@1.9.4/emitter.js"
pin "crossvent", to: "https://ga.jspm.io/npm:crossvent@1.5.5/src/crossvent.js"
pin "custom-event", to: "https://ga.jspm.io/npm:custom-event@1.0.1/index.js"
pin "dragula", to: "https://ga.jspm.io/npm:dragula@3.7.3/dragula.js"
pin "process", to: "https://ga.jspm.io/npm:@jspm/core@2.0.1/nodelibs/browser/process-production.js"
pin "ticky", to: "https://ga.jspm.io/npm:ticky@1.0.1/ticky-browser.js"
pin "axios", to: "https://cdn.skypack.dev/axios@1.2.0"
pin "lodash-es", to: "https://ga.jspm.io/npm:lodash-es@4.17.21/lodash.js"
pin "el-transition", to: "https://ga.jspm.io/npm:el-transition@0.0.7/index.js"
