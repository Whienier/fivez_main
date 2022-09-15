window.addEventListener("message", async (event) => {
    if (event.data.type == "message") {
        return;
    }
	switch(event.data.type) {
		case "cnr_character":
			switch(event.data.name) {
				case "OpenMenu":
					CNR_Character.OpenMenu(event.data.data);
					break;
				case "CloseMenu":
					CNR_Character.CloseMenu();
					break;
				case "UpdateCharacters":
					CNR_Character.UpdateCharacters(event.data.data);
				break;
				default:
					console.log(`Couldn't Find Event Name: ${event.data.name} for Type: ${event.data.type}`);
				break;
			}
		break;
		case "fivez_hud":
			switch(event.data.name) {
				case "EnableHUD":
					FIVEZ_HUD.EnableHUD(event.data.data);
				    break;
				case "UpdateHUD":
					FIVEZ_HUD.UpdateHUD(event.data.data);
					break;
                case "UpdateCarHUD":
                    FIVEZ_HUD.UpdateCarHUD(event.data.data);
                    break;
                case "RemoveCarHUD":
                    FIVEZ_HUD.RemoveCarHUD();
                    break;
                case "DisableVoice":
                    FIVEZ_HUD.DisableVoice();
                    break;
                case "MicOn":
                    FIVEZ_HUD.MicOn();
                    break;
                case "MicOff":
                    FIVEZ_HUD.MicOff();
                    break;
                case "UpdateHunger":
                    FIVEZ_HUD.UpdateHunger(event.data.data)
                    break;
                case "UpdateThirst":
                    FIVEZ_HUD.UpdateThirst(event.data.data)
                    break;
                case "UpdateHealth":
                    FIVEZ_HUD.UpdateHealth(event.data.data);
                    break;
                case "UpdateArmor":
                    FIVEZ_HUD.UpdateArmor(event.data.data);
                    break;
                case "SkillCheck":
                    FIVEZ_HUD.StartSkillCheck();
                    break;
				default:
					break;
			}
		break;
		case "cnr_garage":
			switch(event.data.name) {
				case "OpenMenu":
					CNR_Garage.OpenGarageMenu(event.data.data);
					break;
				case "CloseMenu":
					CNR_Garage.CloseMenu();
					break;
				case "UpdateGarage":
					CNR_Garage.UpdateGarage(event.data.data);
					break;
				default:
					console.log(`Couldn't Find Event Name: ${event.data.name} for type: ${event.data.type}`);
				break;
			}
		break;
		case "fivez_notifications":
			switch(event.data.name){
				case "EnableNotifications":
					FIVEZ_Notifs.OpenMenu();
				break;
                case "AddNotification":
                    FIVEZ_Notifs.AddNotification(event.data.data);
                break;
                case "RemoveNotification":
                    FIVEZ_Notifs.RemoveNotification(event.data.data);
                break;
                case "AddAnnouncement":
                    FIVEZ_Notifs.AddAnnouncement(event.data.data);
                break;
                case "RemoveAnnouncement":
                    FIVEZ_Notifs.RemoveAnnouncement(event.data.data);
                break;
			}
		break;
		// Default Catcher
		default:
			if (event.data.type != "message") {
				console.log(`Couldn't Find Event Type: ${event.data.type}`);
			}
		break;
	}
});