#Utility Meters#

This is my first  self made application for iOS.
In it I realized a helper for calculate price for utility. It consist of three View Controllers, coordinating by coordinator.

1. First ViewController is for set tariff of utility types: gas, water and electricity. Settings stored at UserDefaults and may be changed any time.

2. Second ViewController is a tableView with meter values and prices calculated date-to-date. All meter readings stored at CoreData. For fetch meters at TableView I used FetchedResultController.

3. Third ViewController is for add new meter values at date.

Don't be exacting, it my first experience in iOS development.

In plans:
* Add button for share report of month. I send meters my landlord by telegram app.
* Add functionality for recognize meter value from photo of metering device by captcha service. It is excess functionality for me, but good practice for working with Net.