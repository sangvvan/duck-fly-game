# Duck Fly Game - Project Structure & File Guide

## 📁 Root Directory

```
DuckFlyGame/
├── Package.swift                          # Swift Package Manager configuration
├── REQUIREMENTS.md                        # Complete game specifications
├── IMPROVEMENTS_LOG.md                    # All improvements documented
├── PROJECT_STRUCTURE.md                   # This file
├── .gitignore                             # Git ignore rules
├── DuckFlyGame.xcodeproj/                # Xcode project (for IDE)
└── Sources/
    └── DuckFlyGame/                       # Main app source code
```

---

## 📂 Source Code Structure

### `/Sources/DuckFlyGame/` - Main Application

```
Sources/DuckFlyGame/
│
├── 🎮 CORE GAME ENGINE
│   ├── DuckFlyGame.swift                  # Main app entry point + GameManager
│   │   └── Contains: @main, ContentView, GameView, GameManager class
│   │   └── Key Classes: GameManager (physics, food spawning, collision)
│   │
│   ├── GameState.swift                    # Game state enums
│   │   └── GameScreenState, GameDifficulty
│   │
│   ├── GameHUD.swift                      # Score and combo display
│   │   └── Displays: Score, combo meter, progress
│   │
│   └── GameOverView.swift                 # Game over screen
│
├── 🏃 PHYSICS & MOVEMENT
│   ├── DuckCharacter.swift                # Duck visual and animation
│   ├── DuckAnimations.swift               # Duck animation sequences
│   └── BackgroundScenery.swift            # Background visual effects
│
├── 🍎 FOOD SYSTEM
│   ├── FoodDesign.swift                   # Food types (corn, berries, seeds)
│   │   └── FoodType enum with: points, speedModifier, spawnWeight, visuals
│   └── PointPopup.swift                   # Floating point indicators
│
├── 👹 BOSS SYSTEM (/Boss/)
│   ├── BossRound.swift                    # Boss themes and configurations
│   ├── BossState.swift                    # Boss state management
│   ├── DuckStats.swift                    # Player character stats
│   ├── DuckCosmetic.swift                 # Cosmetic unlocks
│   ├── RoundProgressionManager.swift      # Level progression tracking
│   │
│   └── Views/
│       ├── BossArenaView.swift            # Main boss fight UI ⭐
│       │   └── Contains: Boss movement, projectiles, dodge mechanics
│       ├── BossRoundIntroView.swift       # Level intro screen
│       ├── BossDeathView.swift            # Game over for boss defeat
│       └── RoundCompleteView.swift        # Victory screen
│
├── 👥 MULTIPLAYER (/Multiplayer/)
│   ├── GameMode.swift                     # Game mode definitions
│   ├── GameSimulation.swift               # Multiplayer game logic
│   ├── MultiplayerGameManager.swift       # Multiplayer state manager
│   ├── MultiplayerFlowCoordinator.swift   # Multiplayer flow orchestration
│   ├── PlayerState.swift                  # Individual player state
│   └── TeamState.swift                    # Team state management
│
├── 🎮 SOLO PROGRESSION (/Solo/)
│   ├── LevelConfig.swift                  # Level configuration
│   ├── LevelProgressManager.swift         # Progress persistence
│   │   └── Handles: UserDefaults, level unlocks
│   │
│   └── Views/
│       └── LevelMapView.swift             # Level selection map
│
├── 💪 POWER-UPS (/PowerUps/)
│   ├── PowerUpType.swift                  # Power-up definitions
│   ├── PowerUpFoodView.swift              # Power-up visuals
│   ├── PowerUpCollectionEffect.swift      # Collection animations
│   └── TeamSynergy.swift                  # Team bonus effects
│
├── 🎨 UI COMPONENTS (/Components/)
│   ├── ButtonStyles.swift                 # Reusable button styles ⭐
│   │   └── PrimaryButtonStyle, SecondaryButtonStyle, AttackButtonStyle
│   │
│   └── CardView.swift                     # Reusable card component ⭐
│       └── Generic card with styling
│
├── ⚙️ CONSTANTS & CONFIG (/Constants/)
│   └── GameConstants.swift                # Centralized configuration ⭐
│       ├── Physics constants
│       ├── Gameplay timers & speeds
│       ├── UI dimensions & padding
│       ├── Color schemes
│       └── Audio & boss settings
│
├── 🔧 UTILITIES (/Utils/)
│   ├── AudioManager.swift                 # Sound system ⭐
│   │   └── Audio effects for jump, food, combo, attacks
│   │
│   ├── ScreenUtils.swift                  # Screen dimension helpers
│   │
│   └── DeviceSizeOptimization.swift       # Device-specific sizing
│
├── 🎨 VISUAL & EFFECTS
│   ├── ColorTheme.swift                   # Color palette & themes
│   │   └── WCAG AA+ accessible colors
│   │
│   ├── ParticleEffects.swift              # Particle system
│   ├── Effects/
│   │   └── ParticleEffectSystem.swift     # Advanced particle effects
│   │
│   ├── DuckAnimations.swift               # Animation definitions
│   └── AccessibilityFeatures.swift        # Accessibility & haptics
│
├── 👁️ CHARACTERS (/Characters/)
│   ├── AnimalCharacter.swift              # Character definitions
│   ├── CharacterRenderer.swift            # Character visuals
│   ├── CharacterAbilities.swift           # Character abilities
│   └── CharacterStats.swift               # Character statistics
│
└── 📺 VIEWS (/Views/)
    ├── MainMenuView.swift                 # Main menu screen
    ├── ModeSelectionView.swift            # Solo vs Multiplayer
    ├── CharacterSelectionView.swift       # Character picker
    ├── TeamLobbyView.swift                # Team setup screen
    ├── PlayerZoneView.swift               # Individual player play area
    ├── MultiplayerGameView.swift          # Multiplayer game arena
    ├── MultiplayerHUDView.swift           # Multiplayer HUD
    ├── MultiplayerGameOverView.swift      # Multiplayer results
    ├── PowerUpIndicatorView.swift         # Power-up status display
    ├── TeamColorTheme.swift               # Team color styling
    └── VictoryParade.swift                # Victory animation
```

---

## 🗂️ File Organization by Feature

### Game Flow
1. **Entry Point**: `DuckFlyGame.swift` (@main struct)
2. **Menu**: `Views/MainMenuView.swift`
3. **Solo Play**: `DuckFlyGame.swift:SoloGameView`
4. **Level Selection**: `Solo/Views/LevelMapView.swift`
5. **Food Collection**: `DuckFlyGame.swift:GameView`
6. **Boss Fight**: `Boss/Views/BossArenaView.swift`
7. **Game Over**: `Boss/Views/BossDeathView.swift` or `GameOverView.swift`

### Game Systems
- **Physics**: `DuckFlyGame.swift:GameManager` (lines 296-436)
- **Food Spawning**: `DuckFlyGame.swift:GameManager.generateFood()`
- **Collision Detection**: `DuckFlyGame.swift:GameManager.update()`
- **Audio**: `Utils/AudioManager.swift` (all sound effects)
- **Progression**: `Solo/LevelProgressManager.swift` (saves to UserDefaults)
- **Boss AI**: `Boss/Views/BossArenaView.swift` (timer-based attacks)

### Configuration
- **Constants**: `Constants/GameConstants.swift` (all magic numbers)
- **Colors**: `ColorTheme.swift` (all colors)
- **Physics**: `GameConstants.swift:Physics` enum
- **Gameplay**: `GameConstants.swift:Gameplay` enum
- **UI**: `GameConstants.swift:UI` enum

---

## 🔑 Key Files to Edit

### To Adjust Game Feel
- **Physics**: Edit `GameConstants.swift:Physics`
- **Spawn Rates**: Edit `FoodDesign.swift:spawnWeight`
- **Speed**: Edit `GameConstants.swift:baseGameSpeed`
- **Difficulty**: Edit `GameState.swift:GameDifficulty`

### To Modify Visuals
- **Colors**: Edit `ColorTheme.swift`
- **Buttons**: Edit `Components/ButtonStyles.swift`
- **Cards**: Edit `Components/CardView.swift`
- **Food Graphics**: Edit `FoodDesign.swift:FoodItemView`
- **Boss Graphics**: Edit `Boss/Views/BossArenaView.swift`

### To Change Sounds
- **Audio System**: Edit `Utils/AudioManager.swift`
- **Sound Mapping**: Edit `AudioManager.playSound()`
- **Toggle Audio**: `GameConstants.Audio` static methods

### To Add Features
- **New Game States**: Add to `GameScreenState` in `GameState.swift`
- **New Food Types**: Add to `FoodType` in `FoodDesign.swift`
- **New Bosses**: Add to `BossRound` in `Boss/BossRound.swift`
- **New Characters**: Add to character arrays in `Characters/AnimalCharacter.swift`

---

## 📊 File Statistics

| Category | Count | Examples |
|----------|-------|----------|
| Views | 15+ | MainMenuView, BossArenaView, etc. |
| Logic/Managers | 10+ | GameManager, MultiplayerGameManager, etc. |
| Utilities | 4 | AudioManager, ScreenUtils, etc. |
| Constants/Config | 2 | GameConstants, ColorTheme |
| Components | 2 | ButtonStyles, CardView |
| Effects/Visuals | 5+ | ParticleEffects, DuckAnimations, etc. |
| Characters | 4 | AnimalCharacter, CharacterStats, etc. |
| **Total Swift Files** | **50+** | |

---

## 🔗 Important Import Chains

### To Use Audio:
```swift
import AudioManager
AudioManager.shared.playSoundIfEnabled("jump")
```

### To Use Constants:
```swift
import GameConstants
let gravity = GameConstants.Physics.gravity
let padding = GameConstants.UI.standardPadding
```

### To Use Button Styles:
```swift
Button("Attack") { ... }
    .attackButtonStyle(isEnabled: true, icon: "💥")
```

### To Use Card Component:
```swift
CardView {
    VStack { ... }
}
```

### To Access Game State:
```swift
@State private var gameState: GameScreenState = .mainMenu
```

---

## 📝 Documentation Files

| File | Purpose |
|------|---------|
| `REQUIREMENTS.md` | Complete game specifications |
| `IMPROVEMENTS_LOG.md` | Changelog & improvements made |
| `PROJECT_STRUCTURE.md` | This file - project overview |
| `Package.swift` | SPM configuration |

---

## 🚀 Build & Run

```bash
# Build
swift build

# Run (requires Xcode or Xcode Command Line Tools)
xcodebuild -scheme DuckFlyGame -destination 'generic/platform=iOS Simulator'

# Open in Xcode
open DuckFlyGame.xcodeproj
```

---

## 💾 Data Persistence

Saved to `UserDefaults` with keys:
- `duck_game_highest_unlocked_level` - Highest level reached
- `duck_game_completed_levels` - Completed level IDs
- `duck_game_unlocked_cosmetics` - Unlocked cosmetics
- `soundEnabled` - Audio toggle setting

---

## 🔍 Quick Navigation Tips

### Find by Responsibility
| Need to... | File to Edit |
|-----------|-------------|
| Change gravity feel | `GameConstants.swift` |
| Add new button type | `Components/ButtonStyles.swift` |
| Add new food type | `FoodDesign.swift` |
| Add new boss | `Boss/BossRound.swift` |
| Fix physics | `DuckFlyGame.swift:GameManager` |
| Change colors | `ColorTheme.swift` |
| Add sound | `Utils/AudioManager.swift` |

### Find by Feature
| Feature | Main Files |
|---------|------------|
| Solo Mode | `DuckFlyGame.swift`, `Solo/LevelProgressManager.swift` |
| Multiplayer | `Multiplayer/MultiplayerGameManager.swift` |
| Boss Fights | `Boss/Views/BossArenaView.swift` |
| Characters | `Characters/*` |
| Power-ups | `PowerUps/*` |

---

## ✨ File Highlights (Recently Improved)

⭐ **Newly Created Files:**
- `Constants/GameConstants.swift` - Centralized configuration
- `Components/ButtonStyles.swift` - Reusable button styles
- `Components/CardView.swift` - Reusable card component
- `Utils/AudioManager.swift` - Audio system

⭐ **Recently Enhanced:**
- `DuckFlyGame.swift` - Physics tuning, UI improvements
- `Boss/Views/BossArenaView.swift` - Projectiles, dodge mechanics, visual feedback

---

**Last Updated**: April 15, 2026  
**Total Lines of Swift Code**: 5000+  
**Platforms Supported**: iOS 15+  
**Project Type**: Swift Package Manager + Xcode Project
