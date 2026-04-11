# Duck Fly Game - Requirements & Specifications

## Project Overview
iOS 2D mini-game where a duck flies to collect falling food and earn points.

## Current Phase
**Phase 1: Core Gameplay** (In Progress)

## Core Requirements

### Gameplay Mechanics
- ✅ Duck character that follows user input (touch/cursor)
- ✅ Falling food items spawn randomly from top
- ✅ Collision detection when duck touches food
- ✅ Score increases by 10 points per food collected
- ✅ Game runs at 60fps with CADisplayLink

### Target Platform
- iOS (SwiftUI)
- Minimum iOS 15+
- iPhone & iPad support

### Game Balance
- Food spawn rate: Currently 1 food at a time
- Difficulty: Static (will add progression in Phase 3)
- Target play session: 5-10 minutes

## Feature Priorities

### Phase 1 (Current - CORE)
- [x] Basic duck movement
- [x] Food falling mechanics
- [x] Collision detection
- [x] Score tracking
- [ ] Game over condition (when to end game?)

### Phase 2 (VISUAL POLISH)
- [ ] Custom duck animation/sprite
- [ ] Different food types (corn, berries, seeds)
- [ ] Background scenery (sky, clouds)
- [ ] Particle effects on collision
- [ ] Sound effects & background music

### Phase 3 (GAME PROGRESSION)
- [ ] Game over screen
- [ ] Start menu
- [ ] Difficulty levels (speed increases)
- [ ] High score persistence (UserDefaults)
- [ ] Power-ups

### Phase 4+ (ADVANCED)
- [ ] Multiple levels/stages
- [ ] Obstacles to avoid
- [ ] Leaderboards
- [ ] Haptic feedback

## Known Issues to Address
- No game over condition yet (game runs forever)
- Food spawning could be more balanced
- Duck movement could feel smoother

## Questions for Agents
1. **Game Developer**: Is the game loop optimal? Any performance concerns with current mechanics?
2. **UI/UX Designer**: Is the interface intuitive? Should we add a menu screen?
3. **Tester**: What edge cases should we test? What scenarios break the game?
4. **Code Reviewer**: Is the code clean? Any refactoring needed before Phase 2?

## Success Criteria
- Game runs smoothly at 60fps on real devices
- No crashes or memory leaks
- Intuitive controls
- Enjoyable gameplay loop (catching food feels satisfying)
- Clean, maintainable code for future features
