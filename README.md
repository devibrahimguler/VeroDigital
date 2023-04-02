# VeroDigitalApp

This application is a mobile app that allows you to share and save your data using QR codes. The app works on iOS devices.

## Installation

This project is developed using SwiftUI. 
To run the project, CodeScanner needs to be installed first.
Follow the steps below to install CodeScanner:

1. Clone this repo.
2. Open xCode.
3. Add Packages.
4. Write "https://github.com/twostraws/CodeScanner" in search bar.

## Usage

After the app is launched, the app logs in to the database and retrieves the data. The data is displayed on a ScrollView, and it can be retrieved from the database by using the pull-2-refresh feature. After selecting the desired data, a detail page opens up. The detail page displays the data on a ScrollView, and at the bottom of the data, there is a QR code specific to that data. This QR code can be scanned to transfer the data to other users.

There is also a search bar on the main page. You can search for data by using the titles. Beside the search bar, there is a QR code reader that can be used to access data from other users. The data retrieved by scanning the QR code can be viewed under the "From The QR Code" option.
