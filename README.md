# SkillMatcher

A SwiftUI iOS app that helps users find job opportunities based on their skills and location using the JSearch API.

## Features

- Add and manage multiple skills with animated skill pills
- Location-based job search
- Configurable result pagination (1-5 pages)
- Real-time job listings with company details
- Direct application links
- Modern UI with smooth animations
- Pull-to-refresh functionality

## Requirements

- iOS 17.2+
- Xcode 15.0+
- Swift 5.0+
- RapidAPI account

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/chelsbun/SkillMatcher.git
   cd SkillMatcher
   ```

2. Open the project:
   ```bash
   open SkillMatcher.xcodeproj
   ```

3. Configure API access:
   - Sign up at [RapidAPI](https://rapidapi.com/)
   - Subscribe to [JSearch API](https://rapidapi.com/letscrape-6bRBa3QguO5/api/jsearch)
   - Update `Config.swift` with your API key

4. Build and run in Xcode

## Usage

1. Enter skills or job titles using the input field
2. Specify your location (city, state)
3. Select number of result pages
4. Tap "Find Job Matches" to search
5. Browse results and apply directly

## Architecture

- **SwiftUI** for declarative UI
- **URLSession** for API networking
- **Codable** for JSON parsing
- **@State** for reactive state management
- **MVVM pattern** with view models

## API Integration

Uses JSearch API for job data:
- Real-time job listings
- Company information
- Location filtering
- Application links

## Project Structure

```
SkillMatcher/
├── SkillMatcher/
│   ├── SkillMatcherApp.swift
│   ├── ContentView.swift
│   ├── JobMatchingView.swift
│   ├── JobService.swift
│   ├── Config.swift
│   └── Assets.xcassets/
├── SkillMatcherTests/
├── SkillMatcherUITests/
└── README.md
```

## License

MIT License - see LICENSE file for details

## Author

**Chelsea Bonyata**
- GitHub: [@chelsbun](https://github.com/chelsbun)
- LinkedIn: [Chelsea Bonyata](https://www.linkedin.com/in/chelsea-bonyata-477236152/)
- Email: chelseabonyata@gmail.com