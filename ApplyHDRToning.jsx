// Photoshop JavaScript to apply HDR Toning, convert to JPEG, and save in a specific directory

#target photoshop
app.bringToFront();

// Function to apply HDR Toning
function applyHDRToning() {
    var idHdrt = charIDToTypeID("Hdrt");
    var desc2 = new ActionDescriptor();
    executeAction(idHdrt, desc2, DialogModes.NO); // DialogModes.NO ensures no dialog box is shown
}

// Function to save as JPEG
function saveAsJPEG(fullPath) {
    var jpegFile = new File(fullPath);
    var jpegOptions = new JPEGSaveOptions();
    jpegOptions.quality = 8; // Set JPEG quality (0-12)
    activeDocument.saveAs(jpegFile, jpegOptions, true, Extension.LOWERCASE);
}

// Main processing function
function processFiles() {
    var sourceFolder = Folder(app.activeDocument.path + '/../eqs_orig');
    var files = sourceFolder.getFiles("*.png");

    for (var i = 0; i < files.length; i++) {
        var file = files[i];
        open(file);

        // Apply HDR Toning and convert to 16 bit
        activeDocument.changeMode(ChangeMode.SIXTEEN);
        applyHDRToning();

        // Save as JPEG
        var savePath = app.activeDocument.path + '/../eqs_hdr/' + activeDocument.name.replace(/\.[^\.]+$/, '.jpg');
        saveAsJPEG(savePath);

        // Close the document without saving
        activeDocument.close(SaveOptions.DONOTSAVECHANGES);
    }
}

// Run the processing function
processFiles();
alert("HDR Toning applied and files saved in 'eqs_hdr' directory.");

