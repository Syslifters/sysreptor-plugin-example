// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  extends: [
    '@sysreptor/plugin-base-layer',
  ],

  appConfig: {
    pluginId: 'b81af746-c3ed-4735-830b-a772ec7a61327',
  },

  nitro: {
    output: {
      publicDir: '../static/'
    }
  },
})
