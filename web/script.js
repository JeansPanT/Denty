
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
