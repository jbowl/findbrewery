<template>
  <div class="">
    <h1 style="text-align: center">It's beer o'clock somewhere.</h1>
    <form @submit.prevent="handleSubmit">
      <br /><br />
      <v-container grid-list-md text-xs-center align-start justify-start>
        <v-layout row wrap>
          <v-flex xs6>
            <v-text-field
              v-model="query"
              label="Query:"             
            ></v-text-field>
            <v-btn
              v-on:click="readDataFromAPI()"
              depressed
              elevation="2"
              outlined
              roundedsd
              >Search:</v-btn
            >

            <br /><br />

            <b>by_city=Alpharetta</b><br />
            <b>by_state=Colorado</b> <br />
            <b>by_name=Sweetwater</b> <br />
            <b>by_postal=30004</b> <br />
            <b>by_city=san_diego&sort=-name</b>
          </v-flex>
          <v-flex xs6 a>
            <v-img              
              align="center"
              v-model="mapurl"
              max-height="640"
              max-width="640"
              v-bind:src="mapurl"
            ></v-img>
          </v-flex>
        </v-layout>
      </v-container>

      <br /><br />
    </form>
    <v-data-table
      :page="page"
      :pageCount="numberOfPages"
      :headers="headers"
      :items="breweries"
      :options.sync="options"
      :server-items-length="totalBreweries"
      :loading="loading"
      class="elevation-1 spacing"
      @click:row="handleClick"
    >
      <template v-slot:item.website_url="{ item }">
        <a :href="item.website_url">{{ item.website_url }}</a>
      </template>
    </v-data-table>
    <br />
  </div>
</template>
<style scoped></style>
<script>
import axios from "axios";
export default {
  name: "DatatableComponent",
  data() {
    return {
      page: 1,
      totalBreweries: 0,
      numberOfPages: 0,
      breweries: [],
      loading: true,
      options: {},
      headers: [
        { text: "Brewery Name", value: "name" },
        { text: "Address", value: "street" },
        { text: "City", value: "city" },
        { text: "State", value: "state" },
        { text: "Zip___", value: "postal_code" },
        { text: "Phone", value: "phone" },
        { text: "Website", value: "website_url" },
      ],
      mapurl: "https://i.redd.it/6jc3selm1cp31.jpg",
      query: "",
    };
  },
  watch: {
    options: {
      handler() {
        this.readDataFromAPI();
      },
    },
    deep: true,
  },
  methods: {
    handleClick(value) {

        let str = "https://maps.googleapis.com/maps/api/staticmap?size=640x640&maptype=roadmap&key=";
        str += process.env.VUE_APP_MAP_KEY;
        str +=  "&center= "
        str += value.street;
        str +=  " ";
        str += value.city;
        str +=  " ";
        str += value.state;

      this.mapurl = str;

    },
    handleSubmit() {},

    readDataFromAPI() {
      this.loading = true;
      const { page, itemsPerPage } = this.options;
      console.log("Page Number ", page, itemsPerPage);
      let pageNumber = page;

      axios
        .get(
          //   "http://localhost:50000/breweries" )
          // https://api.openbrewerydb.org/breweries?

          "https://findbrewery.jbowl.dev/breweries?" +
            this.query +
            "&per_page=" +
            itemsPerPage +
            "&page=" +
            pageNumber
        )
        .then((response) => {
          this.loading = false;
          this.breweries = response.data;

          this.totalBreweries = response.data.length;
          //this.numberOfPages = 10;
        })
        .catch(function (error) {
          console.log(error);
        });
    },
  },
  mounted() {
    this.readDataFromAPI();
  },
};
</script>
<style scoped>
.input {
  width: 200px;
  padding: 10px;
}

.spacing {
  padding: 50px;
}
</style>