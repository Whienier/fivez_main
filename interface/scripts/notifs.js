const FIVEZ_Notifs = new Vue({
    el: "#FIVEZ_Notifs",
    vuetify: new Vuetify(),

    data: {
        ShowMenu: false,
        ResourceName: "fivez_main",
        anouncements: [],
        notifications: []
    },

    methods: {
        OpenMenu() {
            OpenPage("notifs");
            this.ShowMenu = true;
        },

        AddAnnouncement(anouncement) {
            this.anouncements.push(JSON.parse(anouncement))
            
        },

        RemoveAnnouncement(anouncementId) {
            this.anouncements.splice(anouncementId-1, anouncementId)
        },

        AddNotification(notification) {
            this.notifications.push(JSON.parse(notification));
            //this.notifications.push({test: notification});
            console.log(this.notifications)
        },

        RemoveNotification(notificationId) {
            //Lua tables/arrays start at 1 not 0
            this.notifications.splice(notificationId-1, notificationId);
        }
    }
})
