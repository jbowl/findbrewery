<template>
  <v-app>
    <v-main>
      <DatatableComponent/>
    </v-main>
  </v-app>
</template>

<script>
import DatatableComponent from './components/DatatableComponent';


export default {
  name: 'App',

  components: {

    DatatableComponent
  },

  data: () => ({
    //
  }),
};
</script>
