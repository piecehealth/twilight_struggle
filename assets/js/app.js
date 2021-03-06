// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../node_modules/bulma/css/bulma.css"
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"
import NProgress from "nprogress"
import {LiveSocket} from "phoenix_live_view"

const html = document.getElementsByTagName("html")[0]
let liveHooks = {}

liveHooks.navBurger = {
  mounted() {
    this.el.addEventListener("click", () => {
      let target = this.el.dataset.target;
      let $target = document.getElementById(target);
      this.el.classList.toggle('is-active');
      $target.classList.toggle('is-active');
    })
  }
}

liveHooks.closeModalButton = {
  mounted() {
    this.el.addEventListener("click", () => {
      let modal = this.el.closest(".modal")
      html.classList.toggle("is-clipped", false)
      modal.classList.toggle("is-active", false)
    })
  }
}

liveHooks.openModalButton = {
  mounted() {
    this.el.addEventListener("click", () => {
      let modalId = this.el.dataset.modalId
      html.classList.toggle("is-clipped", true)
      document.getElementById(modalId).classList.toggle("is-active", true)
    })
  }
}

liveHooks.card = {
  mounted() {
    let card = this.el.getElementsByClassName("card")[0]
    let cardTitle = this.el.getElementsByClassName("card-title")[0]
    let desc = this.el.getElementsByClassName("desc")[0]

    card.addEventListener("mouseover", () => {
      desc.style.display = "block"
    })

    cardTitle.addEventListener("mouseover", () => {
      desc.style.display = "block"
    })

    card.addEventListener("mouseout", () => {
      desc.style.display = "none"
    })

    cardTitle.addEventListener("mouseout", () => {
      desc.style.display = "none"
    })
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

let liveSocket = new LiveSocket("/live", Socket, {
  params: {_csrf_token: csrfToken},
  hooks: liveHooks
})


// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

