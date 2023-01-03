# Utility Meters

This is my first  self made application for iOS.
In it I realized a helper for calculate price for utility. It consist of three View Controllers, coordinating by coordinator.

1. First ViewController is for add tariff of utility types: gas, water and electricity with date when it started. Values stored at UserDefaults.
2. Second ViewController is TableView for display all tariffs grouped by type.
3. Next ViewController is a TableView with meter values and prices calculated date-to-date. All meter readings stores at CoreData. For fetch meters at TableView I used FetchedResultController.
4. Last screen - ViewController for add new meter values at date.

Don't be exacting, it my first experience in iOS development.

In plans:
- [x] Add button for share report of month. I send meters my landlord by telegram app.
- [ ] ~~Add functionality for recognize meter value from photo of metering device by captcha service. Excess functionality for my requirements, but good practice for working with Net~~. Realized in separate test project https://github.com/evgenvanzhukov/RucaptchaProject, don't see necessary add it to this project. Feature for feature sake
