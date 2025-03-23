let playerData = {};

window.addEventListener('message', function (event) {
    if (event.data.action === "openUI") {
        playerData = event.data;

        document.getElementById("jobcenter-box").style.display = "flex";

        loadTab('ciudadano');
    }
});



document.getElementById("close-btn").addEventListener("click", function () {
    clickSound.currentTime = 0;
    clickSound.play();

    document.getElementById("jobcenter-box").style.display = "none";
    fetch(`https://${GetParentResourceName()}/closeUI`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
});


const clickSound = new Audio("sounds/click.mp3");
clickSound.volume = 0.5; 


const tabs = document.querySelectorAll('.tab');
tabs.forEach(tab => {
    tab.addEventListener('click', () => {
        clickSound.currentTime = 0;
        clickSound.play();

        tabs.forEach(t => t.classList.remove('active'));
        tab.classList.add('active');
        const tabName = tab.getAttribute('data-tab');
        loadTab(tabName);
    });
});





function loadTab(tabName) {
    const contentDiv = document.getElementById("content");
    contentDiv.innerHTML = '';

    if (tabName === 'ciudadano') {
        fetch(`https://${GetParentResourceName()}/getPlayerData`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        })
        .then(resp => resp.json())
        .then(data => {
            playerData = data;
            loadCiudadanoTab(contentDiv);
        })
        .catch(error => {
            console.error('Error al actualizar datos del jugador:', error);
            contentDiv.innerHTML = `<p>Error al cargar datos.</p>`;
        });
    } else if (tabName === 'trabajos') {
        loadTrabajosTab(contentDiv);
    } else if (tabName === 'documentacion') {
        loadDocumentacionTab(contentDiv);
    } else {
        contentDiv.innerHTML = `<p>Selecciona una pestaña para ver el contenido.</p>`;
    }
}

function loadCiudadanoTab(contentDiv) {
    const template = document.getElementById('template-ciudadano');
    const clone = document.importNode(template.content, true);
    contentDiv.appendChild(clone);

    if (playerData.charinfo) {
        document.getElementById('char-citizenid').textContent = playerData.citizenid || 'N/A';
        document.getElementById('char-fullname').textContent = `${playerData.charinfo.firstname || ''} ${playerData.charinfo.lastname || ''}`.trim() || 'N/A';
        document.getElementById('char-birthdate').textContent = playerData.charinfo.birthdate || 'N/A';
        const gender = playerData.charinfo.gender === 0 ? 'Masculino' : 'Femenino';
        document.getElementById('char-gender').textContent = gender;
        document.getElementById('char-nationality').textContent = playerData.charinfo.nationality || 'N/A';
        document.getElementById('char-phone').textContent = playerData.charinfo.phone || 'N/A';

        document.getElementById('char-cash').textContent =
            playerData.money && playerData.money.cash !== undefined
                ? `$${playerData.money.cash.toLocaleString()}`
                : 'N/A';
        document.getElementById('char-bank').textContent =
            playerData.money && playerData.money.bank !== undefined
                ? `$${playerData.money.bank.toLocaleString()}`
                : 'N/A';

        document.getElementById('char-job').textContent =
            playerData.job ? playerData.job.label || playerData.job.name || 'N/A' : 'N/A';
        document.getElementById('char-grade').textContent =
            playerData.job ? playerData.job.gradelabel || playerData.job.grade || 'N/A' : 'N/A';

        loadApartments();
        loadVehicles();
    }
}

function loadDocumentacionTab(contentDiv) {
    const template = document.getElementById('template-documentacion');
    const clone = document.importNode(template.content, true);

    const licenseList = clone.querySelector('#license-list');
    const licenses = playerData.licenses || {
        driver: false,
        business: false,
        weapon: false
    };

    const licenseLabels = {
        driver: "Licencia de Conducir",
        business: "Licencia Comercial",
        weapon: "Licencia de Armas"
    };

    for (const [key, value] of Object.entries(licenseLabels)) {
        const li = document.createElement('li');
        li.textContent = value;
        const status = document.createElement('span');
        status.textContent = licenses[key] ? "✅" : "❌";
        li.appendChild(status);
        licenseList.appendChild(li);
    }

    const solicitarBtns = clone.querySelectorAll('.solicitar-btn');
    solicitarBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            const docType = btn.getAttribute('data-doc');

            fetch(`https://${GetParentResourceName()}/solicitarDocumento`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ doc: docType })
            });
        });
    });

    contentDiv.appendChild(clone);
}

function loadTrabajosTab(contentDiv) {
    contentDiv.innerHTML = `<div id="jobs-container"></div>`;
    loadJobs();
}

function loadJobs() {
    const jobsContainer = document.getElementById('jobs-container');
    jobsContainer.innerHTML = '<div class="loading">Cargando trabajos...</div>';

    fetch(`https://${GetParentResourceName()}/getJobsConfig`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    })
    .then(resp => resp.json())
    .then(response => {
        jobsContainer.innerHTML = '';

        if (response.jobs && response.jobs.length > 0) {
            response.jobs.forEach(job => {
                const template = document.getElementById('template-job-item');
                const clone = document.importNode(template.content, true);

                const defaultImage = "./img/z8eML7a.png";
                const imageElement = clone.querySelector('.job-item-image');
                imageElement.src = (job.image && job.image.trim() !== "") ? `./img/${job.image}` : defaultImage;

                clone.querySelector('.job-label').textContent = job.label;
                clone.querySelector('.job-description').textContent = job.description;

                clone.querySelector('.job-view-button').addEventListener('click', () => {
                    showJobDetails(job);
                });

                jobsContainer.appendChild(clone);
            });
        } else {
            jobsContainer.innerHTML = '<div class="empty-message">No hay trabajos disponibles</div>';
        }
    })
    .catch(error => {
        console.error('Error al cargar los trabajos:', error);
        jobsContainer.innerHTML = '<div class="empty-message">Error al cargar los trabajos</div>';
    });
}


function showJobDetails(job) {
    const contentDiv = document.getElementById("content");
    contentDiv.innerHTML = '';

    const template = document.getElementById('template-job-details');
    const clone = document.importNode(template.content, true);

    clone.querySelector('.job-details-label').textContent = job.label || 'Sin título';
    clone.querySelector('.job-details-description').textContent = job.description || '';
    clone.querySelector('.job-details-text').innerHTML = (job.text || '').replace(/\n/g, "<br>");

    const defaultImage = "./img/z8eML7a.png";
    const jobImage = clone.querySelector('.job-details-image');
    jobImage.src = (job.image && job.image.trim() !== "") ? `./img/${job.image}` : defaultImage;

    clone.querySelector('#back-to-jobs').addEventListener('click', () => {
        loadTab('trabajos');
    });

    clone.querySelector('#assign-job-button').addEventListener('click', () => {
        fetch(`https://${GetParentResourceName()}/assignJob`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ job: job.job })
        });
    });

    contentDiv.appendChild(clone);
}

function loadApartments() {
    const apartmentsContainer = document.getElementById('apartments-container');
    apartmentsContainer.innerHTML = '<div class="loading">Cargando apartamentos...</div>';

    fetch(`https://${GetParentResourceName()}/getPlayerApartments`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    })
    .then(resp => resp.json())
    .then(response => {
        apartmentsContainer.innerHTML = '';

        if (response.apartments && response.apartments.length > 0) {
            response.apartments.forEach(apartment => {
                const item = document.createElement('div');
                item.className = 'apartment-item';

                const name = document.createElement('div');
                name.className = 'apartment-name';
                name.textContent = apartment.label || apartment.name || 'Apartamento';

                const type = document.createElement('div');
                type.className = 'apartment-type';
                type.textContent = apartment.type || 'Estándar';

                item.appendChild(name);
                item.appendChild(type);
                apartmentsContainer.appendChild(item);
            });
        } else {
            apartmentsContainer.innerHTML = '<div class="empty-message">No tienes apartamentos</div>';
        }
    })
    .catch(error => {
        console.error('Error al cargar apartamentos:', error);
        apartmentsContainer.innerHTML = '<div class="empty-message">Error al cargar apartamentos</div>';
    });
}

function loadVehicles() {
    const vehiclesContainer = document.getElementById('vehicles-container');
    const vehiclesTable = document.getElementById('vehicles-table');

    fetch(`https://${GetParentResourceName()}/getPlayerVehicles`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    })
    .then(resp => resp.json())
    .then(response => {
        const tableBody = vehiclesTable.querySelector('tbody');
        tableBody.innerHTML = '';

        if (response.vehicles && response.vehicles.length > 0) {
            response.vehicles.forEach(vehicle => {
                const row = document.createElement('tr');

                const model = document.createElement('td');
                model.textContent = vehicle.vehicle || 'Desconocido';

                const plate = document.createElement('td');
                plate.textContent = vehicle.plate || 'Desconocido';

                const garage = document.createElement('td');
                garage.textContent = vehicle.garage || 'Fuera';

                row.appendChild(model);
                row.appendChild(plate);
                row.appendChild(garage);
                tableBody.appendChild(row);
            });

            vehiclesTable.style.display = 'table';
            document.querySelector('#vehicles-container .loading').style.display = 'none';
        } else {
            vehiclesContainer.innerHTML = '<div class="empty-message">No tienes vehículos</div>';
        }
    })
    .catch(error => {
        console.error('Error al cargar vehículos:', error);
        vehiclesContainer.innerHTML = '<div class="empty-message">Error al cargar vehículos</div>';
    });
}




document.addEventListener('DOMContentLoaded', function () {
    loadTab('ciudadano');
});


document.addEventListener("keydown", function (event) {
    const isMenuVisible = document.getElementById("jobcenter-box").style.display === "flex";
    if (event.key === "Escape" && isMenuVisible) {
        document.getElementById("jobcenter-box").style.display = "none";
        fetch(`https://${GetParentResourceName()}/closeUI`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        });
    }
});
