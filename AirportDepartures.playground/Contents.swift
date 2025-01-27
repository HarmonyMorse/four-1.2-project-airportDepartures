import UIKit


//: ## 1. Create custom types to represent an Airport Departures display
//: ![Airport Departures](matthew-smith-5934-unsplash.jpg)
//: Look at data from [Departures at JFK Airport in NYC](https://www.airport-jfk.com/departures.php) for reference.
//:
//: a. Use an `enum` type for the FlightStatus (En Route, Scheduled, Canceled, Delayed, etc.)
//:
//: b. Use a struct to represent an `Airport` (Destination or Arrival)
//:
//: c. Use a struct to represent a `Flight`.
//:
//: d. Use a `Date?` for the departure time since it may be canceled.
//:
//: e. Use a `String?` for the Terminal, since it may not be set yet (i.e.: waiting to arrive on time)
//:
//: f. Use a class to represent a `DepartureBoard` with a list of departure flights, and the current airport

enum FlightStatus: String {
    case enRoute
    case scheduled
    case delayed
    case canceled
}

struct Airport {
    var country: String
    var city: String
    var code: String
}

struct Flight {
    var destination: Airport
    var departureTime: Date?
    var airline: String
    var terminal: String?
    var status: FlightStatus
    var code: String
}

class DepartureBoard {
    var departures: [Flight]
    var currentAirport: Airport
    
    init(departures: [Flight], currentAirport: Airport) {
        self.departures = departures
        self.currentAirport = currentAirport
    }
}

//: ## 2. Create 3 flights and add them to a departure board
//: a. For the departure time, use `Date()` for the current time
//:
//: b. Use the Array `append()` method to add `Flight`'s
//:
//: c. Make one of the flights `.canceled` with a `nil` departure time
//:
//: d. Make one of the flights have a `nil` terminal because it has not been decided yet.
//:
//: e. Stretch: Look at the API for [`DateComponents`](https://developer.apple.com/documentation/foundation/datecomponents?language=objc) for creating a specific time

let newYork = Airport(country: "USA", city: "New York", code: "JFK")
let cairo = Airport(country: "Egypt", city: "Cairo", code: "CAI")
let london = Airport(country: "England", city: "London", code: "LGW")
let seattle = Airport(country: "USA", city: "Seattle", code: "SEA")

let flight1 = Flight(destination: cairo, departureTime: Date(), airline: "EgyptAir", terminal: "1", status: .enRoute, code: "MS986")
let flight2 = Flight(destination: london, departureTime: nil, airline: "JetBlue Airways", terminal: "5", status: .canceled, code: "B62143")
let flight3 = Flight(destination: seattle, departureTime: Date(), airline: "American Airlines", terminal: nil, status: .scheduled, code: "AA9167")

let depBoard = DepartureBoard(departures: [], currentAirport: newYork)

depBoard.departures.append(flight1)
depBoard.departures.append(flight2)
depBoard.departures.append(flight3)

//: ## 3. Create a free-standing function that can print the flight information from the `DepartureBoard`
//: a. Use the function signature: `printDepartures(departureBoard:)`
//:
//: b. Use a `for in` loop to iterate over each departure
//:
//: c. Make your `FlightStatus` enum conform to `String` so you can print the `rawValue` String values from the `enum`. See the [enum documentation](https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html).
//:
//: d. Print out the current DepartureBoard you created using the function

func printDepartures(departureBoard: DepartureBoard) {
    for departure in departureBoard.departures {
        print("Flight \(departure.code) to \(departure.destination.city), \(departure.destination.country) (\(departure.destination.code))")
        print("""
Status: \(departure.status)
Airline: \(departure.airline)
""")
        if let time = departure.departureTime {
            print("Departure time: \(time)")
        }
        if let terminal = departure.terminal {
            print("Terminal: \(terminal)")
        }
        print("___________________________")
    }
}

printDepartures(departureBoard: depBoard)

//: ## 4. Make a second function to print print an empty string if the `departureTime` is nil
//: a. Createa new `printDepartures2(departureBoard:)` or modify the previous function
//:
//: b. Use optional binding to unwrap any optional values, use string interpolation to turn a non-optional date into a String
//:
//: c. Call the new or udpated function. It should not print `Optional(2019-05-30 17:09:20 +0000)` for departureTime or for the Terminal.
//:
//: d. Stretch: Format the time string so it displays only the time using a [`DateFormatter`](https://developer.apple.com/documentation/foundation/dateformatter) look at the `dateStyle` (none), `timeStyle` (short) and the `string(from:)` method
//:
//: e. Your output should look like:
//:
//:     Destination: Los Angeles Airline: Delta Air Lines Flight: KL 6966 Departure Time:  Terminal: 4 Status: Canceled
//:     Destination: Rochester Airline: Jet Blue Airways Flight: B6 586 Departure Time: 1:26 PM Terminal:  Status: Scheduled
//:     Destination: Boston Airline: KLM Flight: KL 6966 Departure Time: 1:26 PM Terminal: 4 Status: Scheduled

let dateFormatter = DateFormatter()
dateFormatter.dateStyle = .none
dateFormatter.timeStyle = .short

func printDepartures2(departureBoard: DepartureBoard) {
    for departure in departureBoard.departures {
        print("Flight \(departure.code) to \(departure.destination.city), \(departure.destination.country) (\(departure.destination.code))")
        print("""
Status: \(departure.status)
Airline: \(departure.airline)
""")
        if let time = departure.departureTime {
            print("Departure time: \(dateFormatter.string(from: time))")
        }
        if let terminal = departure.terminal {
            print("Terminal: \(terminal)")
        }
        print("___________________________")
    }
}

printDepartures2(departureBoard: depBoard)

//: ## 5. Add an instance method to your `DepatureBoard` class (above) that can send an alert message to all passengers about their upcoming flight. Loop through the flights and use a `switch` on the flight status variable.
//: a. If the flight is canceled print out: "We're sorry your flight to \(city) was canceled, here is a $500 voucher"
//:
//: b. If the flight is scheduled print out: "Your flight to \(city) is scheduled to depart at \(time) from terminal: \(terminal)"
//:
//: c. If their flight is boarding print out: "Your flight is boarding, please head to terminal: \(terminal) immediately. The doors are closing soon."
//:
//: d. If the `departureTime` or `terminal` are optional, use "TBD" instead of a blank String
//:
//: e. If you have any other cases to handle please print out appropriate messages
//:
//: d. Call the `alertPassengers()` function on your `DepartureBoard` object below
//:
//: f. Stretch: Display a custom message if the `terminal` is `nil`, tell the traveler to see the nearest information desk for more details.

func alertPassengers(depBoard: DepartureBoard) {
    for flight in depBoard.departures {
        switch flight.status {
        case .enRoute:
            if let terminal = flight.terminal {
                print("Your flight to \(flight.destination.city), \(flight.destination.country) is en route. Please go to terminal \(terminal).")
            } else {
                print("Your flight to \(flight.destination.city), \(flight.destination.country) is en route. We will update you when the terminal is decided.")
            }
        case .scheduled:
            guard let time = flight.departureTime else { return }
            if let terminal = flight.terminal {
                print("Your flight to \(flight.destination.city), \(flight.destination.country) is scheduled for \(dateFormatter.string(from: time)). Please go to terminal \(terminal) to board.")
            } else {
                print("Your flight to \(flight.destination.city), \(flight.destination.country) is scheduled for \(dateFormatter.string(from: time)). We will update you when the terminal is decided.")
            }
        case .canceled:
            print("Your flight to \(flight.destination.city), \(flight.destination.country) is canceled. Here is a $500,000,000 voucher.")
        case .delayed:
            guard let time = flight.departureTime else { return }
            if let terminal = flight.terminal {
                print("Your flight to \(flight.destination.city), \(flight.destination.country) is delayed. It is now coming at \(dateFormatter.string(from: time)). Please go to terminal \(terminal) to board.")
            } else {
                print("Your flight to \(flight.destination.city), \(flight.destination.country) is delayed. It is now coming at \(dateFormatter.string(from: time)). We will update you when the terminal is decided.")
            }
        }
    }
}

alertPassengers(depBoard: depBoard)

//: ## 6. Create a free-standing function to calculate your total airfair for checked bags and destination
//: Use the method signature, and return the airfare as a `Double`
//:
//:     func calculateAirfare(checkedBags: Int, distance: Int, travelers: Int) -> Double {
//:     }
//:
//: a. Each bag costs $25
//:
//: b. Each mile costs $0.10
//:
//: c. Multiply the ticket cost by the number of travelers
//:
//: d. Call the function with a variety of inputs (2 bags, 2000 miles, 3 travelers = $750)
//:
//: e. Make sure to cast the numbers to the appropriate types so you calculate the correct airfare
//:
//: f. Stretch: Use a [`NumberFormatter`](https://developer.apple.com/documentation/foundation/numberformatter) with the `currencyStyle` to format the amount in US dollars.

func calculateAirfare(checkedBags: Int, distance: Int, travelers: Int) -> Double {
    return Double(travelers)*(Double(checkedBags)*25+Double(distance)*0.1)
}

print("$\(calculateAirfare(checkedBags: 2, distance: 2000, travelers: 3))")
