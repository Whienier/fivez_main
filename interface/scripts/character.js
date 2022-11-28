const CNR_Character = new Vue({
	el: "#CNR_Character",
    vuetify: new Vuetify(),
	data: {
		ResourceName: "fivez_main",
        ShowMenu: false,
        ShowCreator: false,
        ShowMaxCharacters: true,
		Updating: false,
        Characters: [],
        NewCharacterValid: true,
        NewCharacterData: { FirstName: "", LastName: "", Gender: 0 },
        NewCharacterFormRules: {
            NameRules: [
                v => !!v || "Name is required",
                v => (v && v.length <= 20) || "Name must be less than 10 characters",
                v => (v && v.length > 2) || "Name must be greater than 2 characters"
            ],
            GenderRules: [
                v => !!v || "Gender is required"
            ]
        },
        Genders: {
            0: "Male",
            1: "Female"
        }
	},

	methods: {
		OpenMenu(chars) {
            OpenPage("character");
			this.ShowMenu = true;
            this.Characters = chars;
		},

        CloseMenu() {
            this.ShowMenu = false;
            ClosePage("character");
        },

		CreateCharacter() {
            if (this.Characters.length == 1){
                return;
            }
            axios.post("http://"+this.ResourceName+"/character_createcharacter", {
                first: this.NewCharacterData.FirstName,
                last: this.NewCharacterData.LastName,
                gender: this.NewCharacterData.Gender,
            }).then((response) => {}).catch((error) => { console.log(error); });
            this.Updating = true;
            this.ShowCreator = false;
        },

		SelectCharacter(_id) {
            axios.post(`http://${this.ResourceName}/character_select`, { id: _id }).then((response) => { console.log(response) }).catch((error) => { console.log(error) });
            this.ShowCreator = false;
        },

		DeleteCharacter(_id) {
			axios.post(`http://${this.ResourceName}/character_delete`, {id: _id}).then((response) => { console.log(response) }).catch((error) => { console.log(error) });
            this.Updating = true;
        },

		UpdateCharacters(chars) {
			this.Characters = chars;
			this.Updating = false;
        },

        Creator(){
            this.ShowCreator = !this.ShowCreator;
            console.log(this.ShowCreator);
        },

        Disconnect() {
            axios.post(`http://${this.ResourceName}/disconnect`, {}).then((response) => { console.log(response) }).catch((error) => { console.log(error) });
        }
	}
})