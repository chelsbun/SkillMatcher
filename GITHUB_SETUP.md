# GitHub Setup Instructions

## Prerequisites

1. GitHub account
2. Git installed on your Mac
3. Xcode command line tools

## Step-by-Step Upload

### 1. Initialize Git Repository

```bash
cd /Users/chelseabonyata/Desktop/SkillMatcher
git init
```

### 2. Add Files to Repository

```bash
git add .
```

### 3. Create Initial Commit

```bash
git commit -m "Initial commit: SkillMatcher iOS app

- SwiftUI job search application
- JSearch API integration
- Skill-based job matching
- Modern animations and UI"
```

### 4. Create GitHub Repository

1. Go to [GitHub.com](https://github.com)
2. Click "New repository" (green button)
3. Name: `SkillMatcher`
4. Description: `iOS job search app with SwiftUI and JSearch API`
5. Set to **Public** (for portfolio visibility)
6. **DO NOT** initialize with README (we already have one)
7. Click "Create repository"

### 5. Connect Local to GitHub

```bash
git remote add origin https://github.com/chelsbun/SkillMatcher.git
git branch -M main
git push -u origin main
```

### 6. Verify Upload

1. Refresh your GitHub repository page
2. Confirm all files are visible
3. Check README displays properly

## Important Notes

- **API Key Security**: The current API key in `Config.swift` should be replaced before public use
- **License**: Consider adding a LICENSE file
- **Portfolio Ready**: Repository is now ready for job applications and portfolio display

## Repository Structure

Your uploaded repository will contain:

```
SkillMatcher/
├── .gitignore
├── README.md
├── SkillMatcher/
│   ├── SkillMatcher.xcodeproj/
│   └── SkillMatcher/
│       ├── SkillMatcherApp.swift
│       ├── ContentView.swift
│       ├── JobMatchingView.swift
│       ├── JobService.swift
│       ├── Config.swift
│       └── Assets.xcassets/
```

## Next Steps

1. Update README with your GitHub username
2. Consider adding screenshots
3. Add to your resume/portfolio
4. Share with your Apple contact!