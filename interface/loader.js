const Pages = 
[
	"notifs",
	"character",
	"hud",
	"inventory"
]

//Opens page code
function OpenPage(pageTo) {	
	let newContainer = document.getElementById(`${pageTo}`);
		
	newContainer.style.position = "absolute";
	newContainer.style.width = "100%";
	newContainer.style.height = "100%";
}
//Closes page code
function ClosePage(page) {
	
	let container = document.getElementById(`${page}`);
	container.style.width = "0%";
	container.style.height = "0%";
}
//Loads page code from pages directory
async function LoadPage(page) {
	return new Promise(resolve => {
		axios.get(`./pages/${page}.html`, { headers: {"Content-Type" : "text/plain"} }).then((response) => {
			resolve(response.data);			
		}).catch((error) => {
			resolve(null);
		});
	});
}
//Adds the corrosponding javascript to the page
async function AddScript(page) {
	return new Promise(resolve => {
		let body = document.body;
		let newScript = document.createElement("script"); newScript.src = `./scripts/${page}.js`;
		body.append(newScript);
		resolve();
	});
}

async function AddCSS(page){
    return new Promise(resolve => {
        let body = document.body;
        let newCSS = document.createElement('style'); newCSS.src = `./pages/${page}.css`;
        body.append(newCSS);
        resolve();
    })
}
//Adds page code to the HTML container
async function AddPage(page, code) {
	return new Promise(resolve => {
		let container = document.getElementById("UI_Container");
		let newContainer = document.createElement("div"); newContainer.setAttribute("id", `${page}`);

        if (page == "hud") {
            container = document.getElementById("HUD_Container");
        }
		container.append(newContainer);
		newContainer.innerHTML = code;

		resolve();
	})
}
//Adds the listener javascript for NUI callbacks
function StartListener() {
	let listenerScript = document.createElement("script");
	listenerScript.src = "./listener.js";
	document.body.append(listenerScript);
	axios.post("http://fivez_main/nui_loaded", {}).then((response) => {}).catch((error) => {});
}
//Checks all pages and adds the code
document.onreadystatechange = async () => {
	if (document.readyState === "complete") {
		Pages.forEach(async page => {
			let pageCode = await LoadPage(page);
			
			if (pageCode != null) {
				await AddScript(page);
				await AddPage(page, pageCode);
				
				if (page == Pages[Pages.length - 1]) {
					StartListener();
				}

				ClosePage(page)
			}
		})
	}
}