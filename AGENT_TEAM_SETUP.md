# Duck Fly Game - Agent Team Setup

## Team Agents Configuration

Your development team consists of 4 specialized agents that review different aspects of the game.

---

## ✅ Agent #1: Game Developer Review
**Status**: ✅ ACTIVE (Automatic Schedule)
- **Role**: Game Logic & Mechanics Development
- **Schedule**: Every Monday at 9:00 AM UTC
- **Trigger ID**: `trig_01Uk7xixoxpoWaMY4YPpLM4D`
- **Dashboard**: https://claude.ai/code/scheduled/trig_01Uk7xixoxpoWaMY4YPpLM4D
- **Auto-Reviews**: Game loop, collisions, performance, architecture
- **Output**: `FEEDBACK_GAME_DEVELOPER.md`

**What it does automatically:**
- Analyzes game mechanics and logic
- Checks performance and memory usage
- Reviews code architecture
- Provides optimization suggestions

---

## 📋 Agent #2: UI/UX Designer Review
**Status**: MANUAL TRIGGER (On-Demand)
- **Role**: iOS User Interface & Experience Design
- **When to run**: When you want design feedback
- **Reviews**: iOS guidelines, visual design, user experience
- **Output**: `FEEDBACK_UI_UX.md`

**How to trigger manually:**
1. Go to https://claude.ai/code/scheduled
2. Click "Create New Trigger" or ask Claude Code: "Run UI/UX Designer agent"
3. Agent reviews in the cloud (laptop can be closed)

---

## 🧪 Agent #3: Tester Review
**Status**: MANUAL TRIGGER (On-Demand)
- **Role**: Quality Assurance & Testing
- **When to run**: Before releases, after major changes
- **Reviews**: Test cases, edge cases, bugs, performance
- **Output**: `FEEDBACK_TESTER.md`

**How to trigger manually:**
1. Ask Claude Code: "Run the Tester agent"
2. Agent creates test plans and identifies issues
3. Results saved to feedback file

---

## 👀 Agent #4: Code Reviewer
**Status**: MANUAL TRIGGER (On-Demand)
- **Role**: Code Quality & Standards
- **When to run**: Before major commits/merges
- **Reviews**: Code quality, best practices, security, maintainability
- **Output**: `FEEDBACK_CODE_REVIEWER.md`

**How to trigger manually:**
1. Ask Claude Code: "Run the Code Reviewer agent"
2. Agent performs thorough code review
3. Results saved to feedback file

---

## Workflow Summary

### Daily Development:
1. **You (Leader)** write/modify game code
2. **Game Developer Agent** reviews automatically every Monday
3. **You** decide on improvements

### When You Need Feedback:
1. **You** ask Claude Code to run specific agent
2. **Agent runs in cloud** (no laptop needed)
3. **Agent writes feedback** to appropriate file
4. **You** review and integrate feedback

### Before Release:
1. Run **Tester Agent** for test cases
2. Run **Code Reviewer Agent** for quality check
3. Run **UI/UX Designer Agent** for final polish
4. **You** integrate all feedback
5. Release!

---

## Subscription Note

Your plan includes:
- ✅ 1 automatic daily agent (Game Developer)
- ✅ Unlimited manual triggers for other agents
- ✅ All agents run in cloud (24/7, no laptop needed)

---

## Next Steps

1. ✅ Game Developer agent is running
2. ⏳ When ready, ask Claude Code to set up the other 3 agents
3. 📝 Check feedback files regularly
4. 🔄 Iterate based on agent feedback
