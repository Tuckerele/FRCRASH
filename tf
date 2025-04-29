<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Front to Rear Crash Narrative Generator</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 900px;
            margin: 20px auto;
            padding: 0 20px;
            background-color: #f9f9f9;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        select, button, input, textarea {
            padding: 8px;
            margin: 5px;
            font-size: 16px;
            border-radius: 4px;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }
        select, input[type="number"], input[type="text"] {
            width: 200px;
        }
        #results {
            margin-top: 20px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            min-height: 100px;
            background-color: #fff;
            white-space: pre-wrap;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        label {
            display: inline-block;
            width: 250px;
            font-weight: bold;
        }
        button {
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            padding: 10px 20px;
            margin: 5px;
            transition: background-color 0.3s;
        }
        button:hover {
            background-color: #218838;
        }
        #copy-button {
            background-color: #007bff;
        }
        #copy-button:hover {
            background-color: #0056b3;
        }
        #reset-button {
            background-color: #dc3545;
        }
        #reset-button:hover {
            background-color: #c82333;
        }
        .form-group {
            margin-bottom: 10px;
        }
        .error {
            color: red;
            font-size: 14px;
            margin-left: 5px;
        }
        .vehicle-section {
            border: 1px solid #ddd;
            padding: 15px;
            margin-bottom: 15px;
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        #copy-feedback {
            margin-left: 10px;
            color: green;
            font-size: 14px;
            display: none;
        }
        .relocated-group {
            display: none;
        }
    </style>
</head>
<body>
    <h1>Front to Rear Crash Narrative Generator</h1>

    <div id="front_to_rear">
        <form id="front_to_rear-form">
            <div id="front_to_rear-vehicles-container">
                <!-- Vehicle 01 -->
                <div class="vehicle-section" data-vehicle="1">
                    <h3>Vehicle 01 <span style="color: red;">(At-Fault Vehicle)</span></h3>
                    <div class="form-group">
                        <label>Vehicle 01 Direction of Travel:</label>
                        <select name="v1_direction" required>
                            <option value="northbound">Northbound</option>
                            <option value="southbound">Southbound</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Vehicle 01 Lane of Travel:</label>
                        <input type="text" name="v1_lane" list="lane-options" onchange="toggleExitRamp()" required>
                        <datalist id="lane-options">
                            <option value="inside travel lane">Inside Travel Lane</option>
                            <option value="outside travel lane">Outside Travel Lane</option>
                            <option value="center travel lane">Center Travel Lane</option>
                            <option value="acceleration lane">Acceleration Lane</option>
                            <option value="deceleration lane">Deceleration Lane</option>
                        </datalist>
                    </div>
                    <div class="form-group">
                        <label>Relocated:</label>
                        <select name="v1_relocated" onchange="toggleRelocatedOptions(1)" required>
                            <option value="yes">Yes</option>
                            <option value="no">No</option>
                        </select>
                    </div>
                    <div class="form-group relocated-group" id="v1_relocated_options">
                        <label>Relocated To:</label>
                        <select name="v1_relocated_to" required>
                            <option value="paved median">Paved Median</option>
                            <option value="paved shoulder">Paved Shoulder</option>
                        </select>
                    </div>
                </div>
                <!-- Vehicle 02 -->
                <div class="vehicle-section" data-vehicle="2">
                    <h3>Vehicle 02</h3>
                    <div class="form-group">
                        <label>Vehicle 02 State:</label>
                        <select name="v2_state" required>
                            <option value="traveling">Traveling</option>
                            <option value="stopped">Stopped</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Vehicle 02 Lane of Travel:</label>
                        <input type="text" name="v2_lane" list="lane-options" onchange="toggleExitRamp()" required>
                        <datalist id="lane-options">
                            <option value="inside travel lane">Inside Travel Lane</option>
                            <option value="outside travel lane">Outside Travel Lane</option>
                            <option value="center travel lane">Center Travel Lane</option>
                            <option value="acceleration lane">Acceleration Lane</option>
                            <option value="deceleration lane">Deceleration Lane</option>
                        </datalist>
                    </div>
                    <div class="form-group">
                        <label>Relocated:</label>
                        <select name="v2_relocated" onchange="toggleRelocatedOptions(2)" required>
                            <option value="yes">Yes</option>
                            <option value="no">No</option>
                        </select>
                    </div>
                    <div class="form-group relocated-group" id="v2_relocated_options">
                        <label>Relocated To:</label>
                        <select name="v2_relocated_to" required>
                            <option value="paved median">Paved Median</option>
                            <option value="paved shoulder">Paved Shoulder</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <button type="button" onclick="addVehicle()">Add Vehicle</button>
                <button type="button" onclick="removeVehicle()">Remove Vehicle</button>
            </div>
            <div class="form-group">
                <label>Mile Marker (73-117):</label>
                <input type="number" name="mile_marker" min="73" max="117" step="1" oninput="validateMileMarker(); updateExitRamp(); updateCrossStreetDropdown()" required>
                <span class="error" id="front_to_rear-mile-marker-error" style="display: none;">Mile Marker must be between 73 and 117.</span>
            </div>
            <div class="form-group" id="front_to_rear-exit-ramp-group" style="display: none;">
                <label>Exit Ramp:</label>
                <input type="text" name="exit_ramp" id="front_to_rear-exit_ramp" required>
            </div>
            <div class="form-group">
                <label>Cross Street:</label>
                <select name="cross_street" id="front_to_rear-cross-street" required>
                    <option value="">Select Cross Street</option>
                </select>
            </div>
            <div style="text-align: center;">
                <button type="submit">Generate Narrative</button>
                <button id="copy-button" onclick="copyToClipboard()" style="display: none;">Copy to Clipboard</button>
                <span id="copy-feedback">Copied to clipboard!</span>
            </div>
        </form>
    </div>

    <div id="results"></div>
    <div style="text-align: center; margin-top: 10px;">
        <button id="reset-button" onclick="resetForm()">Reset Form</button>
    </div>

    <script>
        // State roads data for State Road-91 (Florida Turnpike) in Palm Beach County
        const stateRoadsData = {
            "State Road-91": [
                { mileMarker: 75, crossStreet: "Glades Road (Boca Raton)", direction: "North", stateRoad: "State Road 808" },
                { mileMarker: 75, crossStreet: "Glades Road (Boca Raton)", direction: "South", stateRoad: "State Road 808" },
                { mileMarker: 81, crossStreet: "Atlantic Ave (Delray)", direction: "North", stateRoad: "State Road 806" },
                { mileMarker: 81, crossStreet: "Atlantic Ave (Delray)", direction: "South", stateRoad: "State Road 806" },
                { mileMarker: 86, crossStreet: "Boynton Beach Blvd.", direction: "North", stateRoad: "State Road 804" },
                { mileMarker: 86, crossStreet: "Boynton Beach Blvd.", direction: "South", stateRoad: "State Road 804" },
                { mileMarker: 93, crossStreet: "Lake Worth Rd.", direction: "North", stateRoad: "State Road 802" },
                { mileMarker: 93, crossStreet: "Lake Worth Rd.", direction: "South", stateRoad: "State Road 802" },
                { mileMarker: 97, crossStreet: "Southern Blvd.", direction: "North", stateRoad: "State Road 80" },
                { mileMarker: 97, crossStreet: "Southern Blvd.", direction: "South", stateRoad: "State Road 80" },
                { mileMarker: 98, crossStreet: "Jog Road (SunPass Only)", direction: "North", stateRoad: "" },
                { mileMarker: 98, crossStreet: "Jog Road (SunPass Only)", direction: "South", stateRoad: "" },
                { mileMarker: 99, crossStreet: "Okeechobee Blvd (West Palm Beach)", direction: "North", stateRoad: "State Road 704" },
                { mileMarker: 99, crossStreet: "Okeechobee Blvd (West Palm Beach)", direction: "South", stateRoad: "State Road 704" },
                { mileMarker: 107, crossStreet: "Beeline Hwy.", direction: "North", stateRoad: "State Road 710" },
                { mileMarker: 107, crossStreet: "Beeline Hwy.", direction: "South", stateRoad: "State Road 710" },
                { mileMarker: 109, crossStreet: "PGA Blvd (Palm Beach Gardens)", direction: "North", stateRoad: "State Road 786" },
                { mileMarker: 109, crossStreet: "PGA Blvd (Palm Beach Gardens)", direction: "South", stateRoad: "State Road 786" },
                { mileMarker: 116, crossStreet: "Indiantown Rd. (Jupiter)", direction: "North", stateRoad: "State Road 706" },
                { mileMarker: 116, crossStreet: "Indiantown Rd. (Jupiter)", direction: "South", stateRoad: "State Road 706" }
            ]
        };

        function validateMileMarker() {
            const form = document.getElementById("front_to_rear-form");
            const mileMarkerInput = form.querySelector("[name='mile_marker']");
            const mileMarkerError = document.getElementById("front_to_rear-mile-marker-error");
            const mileMarker = parseInt(mileMarkerInput.value);

            if (mileMarker < 73 || mileMarker > 117 || isNaN(mileMarker)) {
                mileMarkerError.style.display = "inline";
                mileMarkerInput.setCustomValidity("Mile Marker must be between 73 and 117.");
            } else {
                mileMarkerError.style.display = "none";
                mileMarkerInput.setCustomValidity("");
            }
        }

        function updateExitRamp() {
            const form = document.getElementById("front_to_rear-form");
            const mileMarkerInput = form.querySelector("[name='mile_marker']");
            const exitRampInput = form.querySelector("#front_to_rear-exit_ramp");
            const mileMarker = mileMarkerInput.value;
            if (exitRampInput && mileMarker) {
                exitRampInput.value = `Mile Marker ${mileMarker} exit ramp`;
            }
        }

        function toggleExitRamp() {
            const form = document.getElementById("front_to_rear-form");
            const vehicles = form.querySelectorAll(".vehicle-section");
            const exitRampGroup = document.getElementById("front_to_rear-exit-ramp-group");
            let showExitRamp = false;

            vehicles.forEach(vehicle => {
                const lane = vehicle.querySelector(`[name='v${vehicle.dataset.vehicle}_lane']`).value;
                if (lane.toLowerCase().includes("ramp")) {
                    showExitRamp = true;
                }
            });

            exitRampGroup.style.display = showExitRamp ? "block" : "none";
            if (showExitRamp) {
                updateExitRamp();
            }
        }

        function toggleRelocatedOptions(vehicleNum) {
            const vehicleSection = document.querySelector(`.vehicle-section[data-vehicle="${vehicleNum}"]`);
            const relocatedSelect = vehicleSection.querySelector(`[name='v${vehicleNum}_relocated']`);
            const relocatedOptions = vehicleSection.querySelector(`#v${vehicleNum}_relocated_options`);
            const relocatedToSelect = vehicleSection.querySelector(`[name='v${vehicleNum}_relocated_to']`);

            if (relocatedSelect.value === "yes") {
                relocatedOptions.style.display = "block";
                relocatedToSelect.setAttribute("required", "required");
            } else {
                relocatedOptions.style.display = "none";
                relocatedToSelect.removeAttribute("required");
            }
        }

        function updateCrossStreetDropdown() {
            const form = document.getElementById("front_to_rear-form");
            const mileMarkerInput = form.querySelector("[name='mile_marker']");
            const crossStreetSelect = form.querySelector("#front_to_rear-cross-street");
            const mileMarker = parseInt(mileMarkerInput.value);

            crossStreetSelect.innerHTML = '<option value="">Select Cross Street</option>';

            if (!isNaN(mileMarker) && stateRoadsData["State Road-91"]) {
                const nearbyStreets = stateRoadsData["State Road-91"].filter(
                    road => Math.abs(road.mileMarker - mileMarker) <= 2
                );

                nearbyStreets.forEach(road => {
                    const option = document.createElement("option");
                    option.value = `${road.stateRoad ? road.stateRoad + ' ' : ''}(${road.crossStreet}) ${road.direction}`;
                    option.text = `${road.crossStreet} (${road.direction})`;
                    crossStreetSelect.appendChild(option);
                });
            }
        }

        function addVehicle() {
            const vehiclesContainer = document.getElementById("front_to_rear-vehicles-container");
            const vehicleCount = vehiclesContainer.querySelectorAll(".vehicle-section").length;

            if (vehicleCount >= 6) {
                alert("Maximum of 6 vehicles allowed.");
                return;
            }

            const vehicleNum = vehicleCount + 1;
            const vehicleSection = document.createElement("div");
            vehicleSection.className = "vehicle-section";
            vehicleSection.dataset.vehicle = vehicleNum;
            vehicleSection.innerHTML = `
                <h3>Vehicle 0${vehicleNum}</h3>
                <div class="form-group">
                    <label>Vehicle 0${vehicleNum} State:</label>
                    <select name="v${vehicleNum}_state" required>
                        <option value="traveling">Traveling</option>
                        <option value="stopped">Stopped</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Vehicle 0${vehicleNum} Lane of Travel:</label>
                    <input type="text" name="v${vehicleNum}_lane" list="lane-options" onchange="toggleExitRamp()" required>
                    <datalist id="lane-options">
                        <option value="inside travel lane">Inside Travel Lane</option>
                        <option value="outside travel lane">Outside Travel Lane</option>
                        <option value="center travel lane">Center Travel Lane</option>
                        <option value="acceleration lane">Acceleration Lane</option>
                        <option value="deceleration lane">Deceleration Lane</option>
                    </datalist>
                </div>
                <div class="form-group">
                    <label>Relocated:</label>
                    <select name="v${vehicleNum}_relocated" onchange="toggleRelocatedOptions(${vehicleNum})" required>
                        <option value="yes">Yes</option>
                        <option value="no">No</option>
                    </select>
                </div>
                <div class="form-group relocated-group" id="v${vehicleNum}_relocated_options">
                    <label>Relocated To:</label>
                    <select name="v${vehicleNum}_relocated_to" required>
                        <option value="paved median">Paved Median</option>
                        <option value="paved shoulder">Paved Shoulder</option>
                    </select>
                </div>
            `;
            vehiclesContainer.appendChild(vehicleSection);
            toggleRelocatedOptions(vehicleNum);
        }

        function removeVehicle() {
            const vehiclesContainer = document.getElementById("front_to_rear-vehicles-container");
            const vehicleSections = vehiclesContainer.querySelectorAll(".vehicle-section");
            const vehicleCount = vehicleSections.length;

            if (vehicleCount <= 2) {
                alert("Cannot remove Vehicle 01 or Vehicle 02. At least two vehicles are required.");
                return;
            }

            vehiclesContainer.removeChild(vehicleSections[vehicleCount - 1]);
            toggleExitRamp();
        }

        function resetForm() {
            const form = document.getElementById("front_to_rear-form");
            const vehiclesContainer = document.getElementById("front_to_rear-vehicles-container");
            const results = document.getElementById("results");
            const copyButton = document.getElementById("copy-button");

            // Reset Vehicle 01
            const v1Section = vehiclesContainer.querySelector(".vehicle-section[data-vehicle='1']");
            v1Section.querySelector("[name='v1_direction']").value = "northbound";
            v1Section.querySelector("[name='v1_lane']").value = "inside travel lane";
            v1Section.querySelector("[name='v1_relocated']").value = "yes";
            v1Section.querySelector("[name='v1_relocated_to']").value = "paved median";
            toggleRelocatedOptions(1);

            // Reset Vehicle 02
            const v2Section = vehiclesContainer.querySelector(".vehicle-section[data-vehicle='2']");
            v2Section.querySelector("[name='v2_state']").value = "traveling";
            v2Section.querySelector("[name='v2_lane']").value = "inside travel lane";
            v2Section.querySelector("[name='v2_relocated']").value = "yes";
            v2Section.querySelector("[name='v2_relocated_to']").value = "paved median";
            toggleRelocatedOptions(2);

            // Remove additional vehicles (Vehicle 03 and beyond)
            const vehicleSections = vehiclesContainer.querySelectorAll(".vehicle-section");
            for (let i = vehicleSections.length - 1; i >= 2; i--) {
                vehiclesContainer.removeChild(vehicleSections[i]);
            }

            // Reset other fields
            form.querySelector("[name='mile_marker']").value = "";
            const crossStreetSelect = form.querySelector("#front_to_rear-cross-street");
            crossStreetSelect.innerHTML = '<option value="">Select Cross Street</option>';
            const exitRampGroup = document.getElementById("front_to_rear-exit-ramp-group");
            exitRampGroup.style.display = "none";

            // Clear results and hide copy button
            results.innerHTML = "";
            copyButton.style.display = "none";
        }

        // Helper function to format a list of vehicles with proper commas and "and"
        function formatVehicleList(vehicles) {
            if (vehicles.length === 0) return "";
            if (vehicles.length === 1) return vehicles[0];
            if (vehicles.length === 2) return `${vehicles[0]} and ${vehicles[1]}`;
            return `${vehicles.slice(0, -1).join(", ")}, and ${vehicles[vehicles.length - 1]}`;
        }

        function generateNarrative(formData) {
            const mile_marker = formData.mile_marker;
            const cross_street = formData.cross_street;
            let exit_ramp = formData.exit_ramp;

            // Check if any vehicle is in a ramp lane
            let isRampLaneSelected = false;
            for (let i = 1; i <= 6; i++) {
                if (formData[`v${i}_lane`] && formData[`v${i}_lane`].toLowerCase().includes("ramp")) {
                    isRampLaneSelected = true;
                    break;
                }
            }
            if (!isRampLaneSelected) {
                exit_ramp = null;
            }

            // Parse cross street
            const crossStreetParts = cross_street.match(/^(.*?) \((.*?)\) (\w+)$/);
            if (!crossStreetParts) {
                alert("Please select a valid Cross Street.");
                return "";
            }
            const crossStreetDirection = crossStreetParts[3].toLowerCase();
            const crossStreetName = crossStreetParts[2];
            const stateRoad = crossStreetParts[1] || "";

            let narrative = "";
            const vehicles = [];

            // Get Vehicle 01's direction to use for all vehicles
            const v1Direction = formData.v1_direction.toLowerCase();

            // Collect vehicle data
            for (let i = 1; i <= 6; i++) {
                if (formData[`v${i}_lane`]) {
                    const vehicle = {
                        number: `0${i}`,
                        state: formData[`v${i}_state`] ? formData[`v${i}_state`].toLowerCase() : "traveling",
                        direction: v1Direction,
                        lane: formData[`v${i}_lane`].toLowerCase(),
                        relocated: formData[`v${i}_relocated`].toLowerCase(),
                        relocatedTo: formData[`v${i}_relocated_to`].toLowerCase()
                    };
                    vehicles.push(vehicle);
                }
            }

            if (vehicles.length < 2) {
                alert("At least two vehicles are required for this crash type.");
                return "";
            }

            // Generate vehicle descriptions with updated state phrasing and lowercase lane
            vehicles.forEach((vehicle, index) => {
                let stateText;
                if (vehicle.state === "stopped") {
                    stateText = `was stopped, facing ${vehicle.direction}`;
                } else {
                    stateText = `was traveling ${vehicle.direction}`;
                }
                const positionText = index > 0 ? `, directly in front of Vehicle 0${index}` : "";
                const locationText = exit_ramp ? `at ${exit_ramp} on State Road-91 (Florida’s Turnpike) ${crossStreetDirection} of ${stateRoad} (${crossStreetName})` : `at Mile Marker ${mile_marker} on State Road-91 (Florida’s Turnpike) ${crossStreetDirection} of ${stateRoad} (${crossStreetName})`;
                narrative += `Vehicle ${vehicle.number} ${stateText} in the ${vehicle.lane} ${locationText}.\n\n`;
            });

            // Crash Description: Reflect the chain of vehicles
            let crashDescription = "";
            if (vehicles.length === 2) {
                // Only Vehicle 01 and Vehicle 02
                const v2State = vehicles[1].state;
                if (v2State === "stopped") {
                    crashDescription = `Vehicle 02 was stopped for traffic, Vehicle 01 failed to stop. Vehicle 01’s front collided with Vehicle 02’s rear at the area of collision.`;
                } else {
                    crashDescription = `Vehicle 02 slowed for traffic, Vehicle 01 failed to stop. Vehicle 01’s front collided with Vehicle 02’s rear at the area of collision.`;
                }
            } else {
                // More than two vehicles: describe the chain
                const frontmostVehicle = vehicles[vehicles.length - 1]; // e.g., Vehicle 05 if there are 5 vehicles
                const frontmostAction = frontmostVehicle.state === "stopped" ? "was stopped" : "slowed";
                crashDescription = `Vehicle ${frontmostVehicle.number} ${frontmostAction} for traffic`;

                // Describe each vehicle from frontmost-1 down to Vehicle 02
                for (let i = vehicles.length - 2; i >= 1; i--) { // Start from second-to-last vehicle down to Vehicle 02
                    const currentVehicle = vehicles[i];
                    const action = currentVehicle.state === "stopped" ? "stop" : "slow";
                    crashDescription += `, causing Vehicle ${currentVehicle.number} to ${action}`;
                }

                // Add Vehicle 01's failure to stop and the collision
                crashDescription += `. Vehicle 01 failed to stop. Vehicle 01’s front collided with Vehicle 02’s rear at the area of collision.`;
            }
            narrative += `${crashDescription}\n\n`;

            // Group vehicles by relocation status
            const relocatedVehicles = vehicles.filter(v => v.relocated === "yes");
            const notRelocatedVehicles = vehicles.filter(v => v.relocated === "no");

            // Handle relocation statements
            narrative += "Prior to my arrival, ";
            const relocationStatements = [];

            // Group relocated vehicles by their relocation destination
            const relocatedToMedian = relocatedVehicles.filter(v => v.relocatedTo === "paved median");
            const relocatedToShoulder = relocatedVehicles.filter(v => v.relocatedTo === "paved shoulder");

            if (relocatedToMedian.length > 0) {
                const vehicleList = formatVehicleList(relocatedToMedian.map(v => `Vehicle ${v.number}`));
                relocationStatements.push(`${vehicleList} ${relocatedToMedian.length > 1 ? "were" : "was"} moved to a controlled rest on the paved median of State Road-91 (Florida’s Turnpike)`);
            }
            if (relocatedToShoulder.length > 0) {
                const vehicleList = formatVehicleList(relocatedToShoulder.map(v => `Vehicle ${v.number}`));
                relocationStatements.push(`${vehicleList} ${relocatedToShoulder.length > 1 ? "were" : "was"} moved to a controlled rest on the paved shoulder of State Road-91 (Florida’s Turnpike)`);
            }
            if (notRelocatedVehicles.length > 0) {
                const vehicleList = formatVehicleList(notRelocatedVehicles.map(v => `Vehicle ${v.number}`));
                relocationStatements.push(`${vehicleList} ${notRelocatedVehicles.length > 1 ? "remained" : "remained"} at final rest`);
            }

            if (relocationStatements.length > 0) {
                narrative += `${relocationStatements.join(", ")}.`;
            } else {
                narrative += "no vehicles were relocated.";
            }

            return narrative;
        }

        function copyToClipboard() {
            const results = document.getElementById("results");
            const text = results.innerText;
            if (text) {
                navigator.clipboard.writeText(text).then(() => {
                    const feedback = document.getElementById("copy-feedback");
                    feedback.style.display = "inline";
                    setTimeout(() => {
                        feedback.style.display = "none";
                    }, 2000);
                }).catch(err => {
                    alert("Failed to copy text: " + err);
                });
            }
        }

        document.addEventListener("DOMContentLoaded", () => {
            const form = document.getElementById("front_to_rear-form");
            form.addEventListener("submit", (e) => {
                e.preventDefault();
                const mileMarkerInput = form.querySelector("[name='mile_marker']");
                const mileMarker = parseInt(mileMarkerInput.value);
                if (mileMarker < 73 || mileMarker > 117 || isNaN(mileMarker)) {
                    alert("Mile Marker must be between 73 and 117.");
                    return;
                }
                if (!form.querySelector("[name='cross_street']").value) {
                    alert("Please select a Cross Street.");
                    return;
                }
                const formData = Object.fromEntries(new FormData(form));
                const narrative = generateNarrative(formData);
                if (narrative) {
                    const results = document.getElementById("results");
                    results.innerHTML = narrative;
                    const copyButton = document.getElementById("copy-button");
                    copyButton.style.display = "inline-block";
                }
            });
            // Initialize relocated options for Vehicle 01 and Vehicle 02
            toggleRelocatedOptions(1);
            toggleRelocatedOptions(2);
        });
    </script>
</body>
</html>