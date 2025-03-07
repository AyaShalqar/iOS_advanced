# HeroRandomizer App

This is an iOS application that displays random superheroes using the [Superhero API](https://akabab.github.io/superhero-api/). The app is built using UIKit with SwiftUI integration and fetches superhero data dynamically.

## Features
- Fetches and displays a random superhero.
- Shows at least 10 superhero attributes.
- Uses SwiftUI inside a UIKit project with `UIHostingController`.
- Handles loading and error states.

## Screenshots
![App Screenshot](https://github.com/diasyerlan/iosAdvanced/blob/main/lab3/lab3/1.png?raw=true)
![App Screenshot](https://github.com/diasyerlan/iosAdvanced/blob/main/lab3/lab3/2.png?raw=true)


## Setup & Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/HeroRandomizer.git
   ```
2. Open the project in Xcode.
3. Run the app on a simulator or a physical device.

## API Used
- **Base URL:** [https://akabab.github.io/superhero-api/](https://akabab.github.io/superhero-api/)
- **Endpoint:** [https://akabab.github.io/superhero-api/api/all.json](https://akabab.github.io/superhero-api/api/all.json)

## Technologies Used
- Swift
- UIKit
- SwiftUI
- URLSession

## How It Works
1. When the app launches, it fetches a list of superheroes from the API.
2. A random superhero is displayed along with their attributes.
3. Pressing the "Get Random Hero" button fetches another random hero.

## Future Enhancements
- Add a favorites system to save preferred heroes.
- Implement a search feature to find heroes by name.
- Improve UI animations for better user experience.

## License
This project is licensed under the MIT License.
