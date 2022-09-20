var selectedRandomKey;
var success = -1; //0 success, 1 fail outta time, 2 fail too early, 3 fail too late, 4 fail wrong button

const FIVEZ_HUD = new Vue({
    el: "#FIVEZ_HUD",
    vuetify: new Vuetify(),
    data: {
        ResourceName: "fivez_main",
        ShowHUD: false,
        ShowCar: false,
        ShowMic: false,
        micvalue: 0,
        ShowSkillcheck: false,
        FinishedSkillcheck: false,
        info: [],
        carInfo: []
    },

    methods: {
        EnableHUD(hudInfo) {
            this.ShowHUD = !this.ShowHUD;
            this.ShowSkillcheck = false;
            this.info = JSON.parse(hudInfo);
            OpenPage("hud");
            console.log(this.ShowHUD);
        },

        UpdateHUD(hudInfo) {
            this.info = JSON.parse(hudInfo);
            this.info.stamina = Math.trunc(this.info.stamina);
        },

        UpdateCarHUD(carInfo){
            this.carInfo = JSON.parse(carInfo);
            this.ShowCar = true;
        },

        DisableVoice(){
            this.ShowVoice = false;
        },

        MicOn(){
            this.ShowMic = true;
            this.micvalue = 100;
        },

        MicOff(){
            this.ShowMic = false;
            this.micvalue = 0;
        },

        RemoveCarHUD(){
            this.ShowCar = false;
        },

        UpdateStress(newVal) {
            this.info.stress = newVal;
        },

        UpdateHunger(newVal) {
            this.info.hunger = newVal;
        },

        UpdateThirst(newVal) {
            this.info.thirst = newVal;
        },

        UpdateHealth(newHealth) {
            this.info.health = newHealth;
        },

        UpdateArmor(newArmor) {
            this.info.armor = newArmor;
        },

        StartSkillCheck() {
            this.ShowSkillcheck = true;
            this.FinishedSkillcheck = false;
            success = -1;

            randomBarPosition();
            randomKey();
            move();
        },

        CompletedSkillcheck(success) {
            this.ShowSkillcheck = false;
            if (this.FinishedSkillcheck) {
                return
            }
            axios.post("https://fivez_main/skillcheck_finish", {success: success});
            this.FinishedSkillcheck = true;
        }
    }
})

/*When the key is pressed*/
function keyPress(e) {
  /*Get the reactionBar and randomBar*/
  var reactionBar = document.getElementById("reactionBar");
  var randomBar = document.getElementById("randomBar");
  /*Get the left and right edges of the random bar*/
  var randomBarLeftPos = randomBar.getBoundingClientRect().left;
  var randomBarRightPos = randomBar.getBoundingClientRect().right;
  /*Get the right edge of the reaction bar*/
  var reactionBarRightPos = reactionBar.getBoundingClientRect().right;
  /*If the reaction bar right edge is greater than the left edge of the random bar*/
  if (reactionBarRightPos > randomBarLeftPos){
    /*If the reaction bar is less than the right edge of the random bar*/
    if (reactionBarRightPos < randomBarRightPos){
      /*If we press the correct key*/
      if (e.which == selectedRandomKey){
        success = 0;
        FIVEZ_HUD.CompletedSkillcheck(success);
        return;
      } else {
        success = 4;
        FIVEZ_HUD.CompletedSkillcheck(success);
        return;
      }
    } else {
      success = 3;
      FIVEZ_HUD.CompletedSkillcheck(success);
      return;
    }
  } else {
    success = 2;
    FIVEZ_HUD.CompletedSkillcheck(success);
    return;
  }
}
window.addEventListener("keydown", keyPress, false);
/*Register keypress event on the documents body, has issue with fast slots*/
//window.document.body.onkeydown = keyPress;

/*Set a random position and width for the random bar*/
function randomBarPosition(){
  var widthRandom = Math.floor(Math.random() * (35 - 10) + 10);
  var transRandom;
  //If the random width is the smallest it can be or close to, we need to offset the position a bit
  if (widthRandom <= 20){
    transRandom = Math.floor(Math.random() * (350 - 350) + 350);
  } else {
    transRandom = Math.floor(Math.random() * (100 - 50) + 50);
  }
  var target = document.getElementById("randomBar");
  target.style.width = widthRandom + "%";
  target.style.transform = "translate("+transRandom+"%)";
}
/*Select a random key from a given array of keycodes*/
function randomKey(){
  var keys = ["49", "50", "51", "52"]
  var randomKey = Math.floor(Math.random() * 4);
  
  selectedRandomKey = keys[randomKey];
  document.getElementById("keytopress").innerHTML = String.fromCharCode(selectedRandomKey);
}
/*Increases the width of the reaction bar until full*/
var i = 0;
function move() {
  if (i == 0) {
    i = 1;
    var elem = document.getElementById("reactionBar");
    var width = 1;
    var id = setInterval(frame, 20);
    function frame() {
      if (success >= 0) {
        return;
      }
      if (width >= 100) {
        clearInterval(id);
        i = 0;
        elem.style.width = "0%";
        success = 1;

        FIVEZ_HUD.CompletedSkillcheck(success);
      } else {
        width++;
        
        elem.style.width = width + "%";
      }
    }
  }
}