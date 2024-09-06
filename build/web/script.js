
// Toggle navigation menu on mobile
document.getElementById('menu-toggle').addEventListener('click', function() {
    document.querySelector('.navbar').classList.toggle('active');
});
// Initialize Google Map
function initMap() {
    // Set the location coordinates (latitude, longitude)
    const clinicLocation = { lat: 40.73061, lng: -73.935242 }; // Example coordinates (replace with actual location)

    // Create the map
    const map = new google.maps.Map(document.getElementById('map'), {
        zoom: 14,
        center: clinicLocation,
    });

    // Add a marker at the location
    new google.maps.Marker({
        position: clinicLocation,
        map: map,
        title: 'Our Clinic',
    });
}

// Handle form submission (you can customize this part to send data to a server)
document.getElementById('contact-form').addEventListener('submit', function (e) {
    e.preventDefault();
    alert('Your message has been sent successfully!');
    // Here, you can implement form data submission via AJAX or any backend processing
});

document.addEventListener("DOMContentLoaded", () => {
    let appointments = [
        { name: "John Doe", email: "john@example.com", date: "2024-09-03", time: "10:00 AM", status: "upcoming" },
        { name: "Jane Smith", email: "jane@example.com", date: "2024-09-04", time: "11:00 AM", status: "upcoming" },
        { name: "Alice Brown", email: "alice@example.com", date: "2024-09-01", time: "09:00 AM", status: "completed" },
    ];

    const today = new Date().toISOString().split('T')[0];
    
    const todayAppointments = document.getElementById("todayAppointments");
    const upcomingAppointments = document.getElementById("upcomingAppointments");
    const previousAppointments = document.getElementById("previousAppointments");
    const appointmentForm = document.getElementById("appointmentForm");
    const appointmentModal = new bootstrap.Modal(document.getElementById('appointmentModal'));
    let currentEditIndex = null;

    function renderAppointments() {
        todayAppointments.innerHTML = "";
        upcomingAppointments.innerHTML = "";
        previousAppointments.innerHTML = "";

        appointments.forEach((appointment, index) => {
            const appointmentDate = appointment.date;
            const row = document.createElement("tr");
            row.innerHTML = `
                <td>${index + 1}</td>
                <td>${appointment.name}</td>
                <td>${appointment.email}</td>
                <td>${appointment.date}</td>
                <td>${appointment.time}</td>
                <td id="status-${index}">
                    ${appointmentDate === today || appointmentDate > today ? renderStatusButtons(index, appointment.status) : renderStatusText(appointment.status)}
                </td>
                ${appointmentDate === today || appointmentDate > today ? 
                    `<td>
                        <button class="btn btn-sm btn-primary" onclick="editAppointment(${index})">Edit</button>
                        <button class="btn btn-sm btn-danger" onclick="deleteAppointment(${index})">Delete</button>
                    </td>` 
                    : ''}
            `;

            if (appointmentDate === today) {
                todayAppointments.appendChild(row);
            } else if (appointmentDate > today) {
                upcomingAppointments.appendChild(row);
            } else {
                previousAppointments.appendChild(row);
            }
        });
    }

    function renderStatusButtons(index, status) {
        return `
            <button class="btn btn-sm btn-success ${status === 'completed' ? 'active' : ''}" 
                    onclick="updateStatus(${index}, 'completed')">Completed</button>
            <button class="btn btn-sm btn-danger ${status === 'cancelled' ? 'active' : ''}" 
                    onclick="updateStatus(${index}, 'cancelled')">Cancelled</button>
        `;
    }

    function renderStatusText(status) {
        return `<span class="${status === 'completed' ? 'text-success' : status === 'cancelled' ? 'text-danger' : ''}">
            ${capitalize(status)}
        </span>`;
    }

    function capitalize(word) {
        return word.charAt(0).toUpperCase() + word.slice(1);
    }

    window.updateStatus = function(index, status) {
        appointments[index].status = status;
        const statusCell = document.getElementById(`status-${index}`);
        statusCell.innerHTML = renderStatusText(status);
    };

    window.editAppointment = function(index) {
        currentEditIndex = index;
        const appointment = appointments[index];

        // Populate the modal form with existing appointment data
        document.getElementById("modalName").value = appointment.name;
        document.getElementById("modalEmail").value = appointment.email;
        document.getElementById("modalDate").value = appointment.date;
        document.getElementById("modalTime").value = appointment.time;
        document.getElementById("modalStatus").value = appointment.status;

        // Show the modal for editing
        appointmentModal.show();
    };

    window.deleteAppointment = function(index) {
        appointments.splice(index, 1);
        renderAppointments();
    };

    // Handle new or edited appointment submission
    appointmentForm.addEventListener("submit", function(e) {
        e.preventDefault();

        const appointmentData = {
            name: document.getElementById("modalName").value,
            email: document.getElementById("modalEmail").value,
            date: document.getElementById("modalDate").value,
            time: document.getElementById("modalTime").value,
            status: document.getElementById("modalStatus").value
        };

        if (currentEditIndex === null) {
            // Add new appointment
            appointments.push(appointmentData);
        } else {
            // Update existing appointment
            appointments[currentEditIndex] = appointmentData;
        }

        renderAppointments();
        appointmentForm.reset();
        appointmentModal.hide();
        currentEditIndex = null; // Reset the index after editing
    });

    renderAppointments();
});