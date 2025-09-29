import { defineStore } from 'pinia'

export const useWindowSizeStore = defineStore('windowSize', {
  state: () => ({
    usgsHeaderRendered: false,
    windowWidth: 0,
    windowHeight: 0,
    splashRenderedOnInitialLoad: false
  }),

  actions: {
    recordWindowWidth(payload) {
      this.windowWidth = payload
    },
    recordWindowHeight(payload) {
      this.windowHeight = payload
    },
    changeBooleanStateOnSplashRender() {
      this.splashRenderedOnInitialLoad = true
    }
  }
})
