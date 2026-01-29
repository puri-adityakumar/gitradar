# GitRadar Demo Video Plan

Create a demo video using [Remotion](https://remotion.dev) for hackathon submission.

## Video Specs

| Property | Value |
|----------|-------|
| Duration | 60-90 seconds |
| Resolution | 1920x1080 (1080p) |
| Frame Rate | 30 fps |
| Format | MP4 (H.264) |

## Storyboard

### Scene 1: Hook (0-5s)
**Visual:** Animated logo reveal with tagline
```
GitRadar
"Never miss a GitHub update"
```
**Audio:** Subtle tech sound effect

### Scene 2: Problem Statement (5-15s)
**Visual:** Split screen showing:
- Left: Overflowing GitHub notification inbox
- Right: Developer looking frustrated

**Text overlay:**
```
"Managing multiple repos?"
"Drowning in notifications?"
"Missing critical updates?"
```

### Scene 3: Solution Introduction (15-20s)
**Visual:** GitRadar app reveal with clean interface

**Text overlay:**
```
"Introducing GitRadar"
"Your unified GitHub command center"
```

### Scene 4: Feature Demo - Login (20-25s)
**Visual:** Screen recording of login flow
- Show PAT input
- Show "Continue as Guest" option
- Transition to main app

**Text overlay:** "Easy GitHub authentication"

### Scene 5: Feature Demo - Repositories (25-35s)
**Visual:** Screen recording showing:
- Repository list with notification toggles
- Adding a new repository (flutter/flutter)
- Swipe to delete gesture
- Quick sync button

**Text overlay:**
```
"Track up to 10 repositories"
"Per-repo notification settings"
"Manual sync on demand"
```

### Scene 6: Feature Demo - Activity Feed (35-45s)
**Visual:** Screen recording showing:
- PR tab with filter chips
- Issue tab with badges
- Repository filter selection
- Tap to open in GitHub

**Text overlay:**
```
"Unified activity feed"
"Filter by repository"
"Direct GitHub links"
```

### Scene 7: Feature Demo - Notifications (45-50s)
**Visual:** Screen recording showing:
- Notification list with unread indicators
- Badge on bottom nav
- Mark all as read action

**Text overlay:** "In-app notification center"

### Scene 8: Feature Demo - Settings (50-55s)
**Visual:** Screen recording showing:
- Theme toggle (light → dark transition)
- Account info display

**Text overlay:** "Light & dark themes"

### Scene 9: Tech Stack (55-65s)
**Visual:** Animated tech logos appearing
```
┌─────────────────────────────────────┐
│  Flutter  │  Serverpod  │  PostgreSQL  │
└─────────────────────────────────────┘
```

**Text overlay:**
```
"Built with Serverpod 3"
"Flutter cross-platform"
"PostgreSQL database"
```

### Scene 10: Call to Action (65-75s)
**Visual:** App screenshots with GitHub link

**Text overlay:**
```
"Try GitRadar today"
"github.com/anthropics/gitradar"

Built for Serverpod 3 Global Hackathon
```

### Scene 11: Credits (75-90s)
**Visual:** Simple credits screen

**Text:**
```
GitRadar
by [Your Name]

github.com/anthropics/gitradar
MIT License
```

## Assets Required

### Screenshots (from agent-browser captures)
- [ ] Login screen (light)
- [ ] Repositories screen with repos
- [ ] Activity screen - PRs tab
- [ ] Activity screen - Issues tab
- [ ] Notifications screen
- [ ] Settings screen (light)
- [ ] Settings screen (dark)

### Screen Recordings
- [ ] Login flow (guest mode)
- [ ] Add repository flow
- [ ] Sync repositories
- [ ] Switch between tabs
- [ ] Filter by repository
- [ ] Mark notifications read
- [ ] Theme toggle

### Graphics
- [ ] GitRadar logo (SVG)
- [ ] Tech stack logos (Flutter, Serverpod, PostgreSQL)
- [ ] GitHub logo
- [ ] Problem illustration (optional)

## Remotion Setup

```bash
# Create Remotion project
npx create-video@latest gitradar-video

cd gitradar-video

# Install dependencies
npm install

# Start development
npm start

# Render final video
npx remotion render src/index.tsx Demo out/gitradar-demo.mp4
```

## Remotion Composition Structure

```
src/
├── Root.tsx                 # Main composition
├── sequences/
│   ├── HookSequence.tsx     # Scene 1
│   ├── ProblemSequence.tsx  # Scene 2
│   ├── SolutionSequence.tsx # Scene 3
│   ├── LoginDemo.tsx        # Scene 4
│   ├── ReposDemo.tsx        # Scene 5
│   ├── ActivityDemo.tsx     # Scene 6
│   ├── NotificationsDemo.tsx # Scene 7
│   ├── SettingsDemo.tsx     # Scene 8
│   ├── TechStackSequence.tsx # Scene 9
│   ├── CTASequence.tsx      # Scene 10
│   └── CreditsSequence.tsx  # Scene 11
├── components/
│   ├── Logo.tsx
│   ├── PhoneMockup.tsx
│   ├── TextReveal.tsx
│   └── ScreenRecording.tsx
└── assets/
    ├── screenshots/
    ├── recordings/
    └── graphics/
```

## Animation Guidelines

- Use `spring()` for natural motion
- Fade transitions between scenes (15-20 frames)
- Text reveals with `interpolate()` for smooth entrance
- Phone mockup frame for app screenshots
- Consistent timing: 30fps, 1 second = 30 frames

## Audio (Optional)

- Background music: Upbeat, tech-focused, royalty-free
- Suggested sources:
  - Epidemic Sound
  - Artlist
  - YouTube Audio Library (free)
- Keep volume low, video should work without sound
