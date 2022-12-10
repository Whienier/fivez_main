const Spawnmenu = new Vue({
    el: "#Spawnmenu",
    vuetify: new Vuetify(),

    data: {
        ShowMenu: false,
        ResourceName: "fivez_main",
        Locations: {
            0: {label: "Random Position", picture: "randopos"},
            1: {label: "Last Position", picture: "lastpos"},
            2: {label: "Apartments", picture: "apartments"},
            3: {label: "Hospital", picture: "hospital"},
            4: {label: "Police Department", picture: "policedepart"}
        }
    },

    methods: {
        OpenMenu() {
            OpenPage("spawnmenu");
            this.ShowMenu = true;
        },

        CloseMenu() {
            ClosePage("spawnmenu");
            this.ShowMenu = false;
        },

        SelectLocation(_id) {
            axios.post(`http://${this.ResourceName}/select_location`, { id: _id }).then((response) => {console.log(response)}).error((error) => {console.log(error)});
        },

        SpawnLocation(_id) {
            axios.post(`http://${this.ResourceName}/spawn_location`, { id: _id }).then((response) => {console.log(response)}).error((error) => {console.log(error)});
        }
    }
})
