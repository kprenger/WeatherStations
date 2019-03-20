#  Weather Stations

This is a simple app that connects to the [National Weather Service's API](https://www.weather.gov/documentation/services-web-api#/) to grab the available station information that it has. It then displays minimal information of each station.

The intent of this project isn't to display an extensive amount of weather information, but rather to show how various components can be properly unit tested.

I plan to also show how fastlane can be used to build the application, run tests, and archive an application. But that is forthcoming.

## Unit Testing

Both the `Station` and `Coordinates` models are tested for their intializations. The `StationsTableViewController` is tested to ensure that the correct number of sections and rows are returned in various cases. It also tests the ordering of the cells and contents of those cells after data is fetched.

There is some room for improvement in these tests to make them even easier to implement. For example, if we extract the TableView DataSource and Delegate methods into separate classes, they could be instantiated and set in the TableViewController as expected. That would allow us to easily test the DataSource or Delegate classes without the need of instantiating the TableViewController. It would also allow us to mock the DataSource or Delegate of the TableViewController if we were testing other methods that relied on specific outputs from the DataSource or Delegate classes. 

In general, testing is easiest when your code is modularized. That makes it easy to test specific functionality without having to instantiate a lot of scaffolding, and it makes it much easier to plug-and-play mocks to support the specific tests you are trying to run.
