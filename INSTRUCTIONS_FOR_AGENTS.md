# Instructions for Agent Team

**Read this before each review!** These instructions guide what each agent should focus on.

---

## 📋 For All Agents

1. Read `REQUIREMENTS.md` to understand the project goals
2. Read `CURRENT_FOCUS.md` to see what's being worked on now
3. Review the game code in `DuckFlyGame.swift`
4. Check the appropriate feedback file for your role
5. **Write your feedback to your assigned file** (see below)

---

## 🤖 Game Developer Agent Instructions

**File**: `FEEDBACK_GAME_DEVELOPER.md`

### Review These Aspects:

1. **Game Loop Performance**
   - Is the 60fps target being met?
   - Check CADisplayLink implementation
   - Any frame rate drops?

2. **Collision Detection**
   - Accuracy of distance-based collision
   - Are false positives/negatives happening?
   - Should we use different collision method?

3. **Food Spawning**
   - Is food spawning smooth and balanced?
   - Appropriate spawn rate?
   - Good distribution across screen?

4. **Memory Management**
   - Any memory leaks?
   - Object cleanup proper?
   - Would object pooling help?

5. **Code Architecture**
   - Are GameManager responsibilities clear?
   - Should we split into more components?
   - Proper separation of concerns?

6. **Performance Optimization**
   - Any obvious optimization opportunities?
   - Is the physics calculation efficient?
   - Could we improve rendering?

**Output Format**: Create a "Review #N" section with findings and recommendations.

---

## 🎨 UI/UX Designer Agent Instructions

**File**: `FEEDBACK_UI_UX.md`

### Review These Aspects:

1. **iOS Design Compliance**
   - Following Apple's Human Interface Guidelines?
   - Proper spacing and typography?
   - Color scheme appropriate?

2. **Current Design (Emoji-based)**
   - Are emoji graphics clear and recognizable?
   - Good visual hierarchy?
   - Readable on different screen sizes?

3. **User Experience**
   - Is gameplay intuitive?
   - Clear feedback for actions?
   - Score display prominent?
   - Touch/cursor response satisfying?

4. **Visual Polish**
   - Any jarring transitions?
   - Animations smooth (if any)?
   - Overall polish level for prototype?

5. **Phase 2 Recommendations**
   - What visual improvements would help most?
   - Sprite/animation suggestions?
   - Color scheme improvements?
   - UI component additions needed?

6. **Accessibility**
   - Font sizes readable?
   - Color contrast sufficient?
   - Any a11y concerns?

**Output Format**: Create a "Design Review #N" section with observations and suggestions.

---

## 🧪 Tester Agent Instructions

**File**: `FEEDBACK_TESTER.md`

### Create Test Cases For:

1. **Basic Gameplay**
   - Duck moves correctly with input
   - Food falls from top
   - Collisions detected properly
   - Score increases correctly

2. **Edge Cases**
   - Duck at screen edges
   - Rapid food collection
   - Multiple foods on screen
   - Long play sessions (memory)

3. **Boundary Conditions**
   - Game with no food
   - Game with many foods
   - Extreme screen sizes
   - Rapid input events

4. **Performance Testing**
   - Frame rate consistency
   - Memory usage over time
   - CPU usage under load
   - No crashes after extended play

5. **Bug Hunting**
   - Try to break the game
   - Find any crash scenarios
   - Look for logical errors
   - Test on different iOS sizes

**Output Format**: Create a "Test Plan #N" with:
- Test case name
- Steps to reproduce
- Expected result
- Any bugs found

---

## 👀 Code Reviewer Agent Instructions

**File**: `FEEDBACK_CODE_REVIEWER.md`

### Review These Aspects:

1. **Code Style**
   - Follows Swift conventions?
   - Consistent formatting?
   - Good naming (variables, functions)?

2. **Architecture**
   - Design patterns appropriate?
   - Clean separation of concerns?
   - Maintainability good?

3. **Best Practices**
   - SwiftUI best practices?
   - iOS development patterns?
   - Modern Swift idioms?

4. **Error Handling**
   - Proper edge case handling?
   - No silent failures?
   - Good error messages?

5. **Performance**
   - Any performance anti-patterns?
   - Optimization opportunities?
   - Unnecessary allocations?

6. **Security**
   - Any security vulnerabilities?
   - Input validation?
   - Data protection concerns?

7. **Maintainability**
   - Code easy to understand?
   - Complex sections documented?
   - Refactoring needed?

8. **Technical Debt**
   - Any TODO comments?
   - Temporary hacks?
   - Areas for improvement?

**Output Format**: Create a "Code Review #N" section with:
- Issues found (by severity)
- Recommendations
- Approved changes

---

## 📌 How to Write Feedback

### Template for All Agents:

```markdown
## Review #1 - [Date]
**Status**: Complete
**Key Findings**:
- Finding 1
- Finding 2
- Finding 3

**Recommendations**:
1. [Actionable suggestion]
2. [Actionable suggestion]
3. [Actionable suggestion]

**Questions/Notes**:
- Any open questions?
- Notes for leader?
```

---

## 🎯 Important Notes

- **Be specific**: Include line numbers and code references
- **Be actionable**: Give specific recommendations
- **Be constructive**: Suggest improvements, not just problems
- **Be thorough**: Don't rush the review
- **Be current**: Check git history for recent changes

---

## 📞 Questions?

If you need clarification on requirements or focus areas, include it in your feedback as a question for the leader.

**Remember**: You're helping the leader build a great game! Focus on quality and clarity in your reviews.
