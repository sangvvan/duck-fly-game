# Quick Start - Running Your Agent Team

## 🎮 Your Development Setup

You're the **Leader** with 4 AI agents to review your game:

---

## Automatic Agent (No Action Needed)

### 🤖 Game Developer Agent
Runs **automatically every Monday at 9am UTC**

Your laptop can be closed. The agent will:
- Review game code
- Check performance
- Suggest improvements
- Write to `FEEDBACK_GAME_DEVELOPER.md`

---

## Manual Agents (Run When You Want)

### 🎨 UI/UX Designer Agent
**Run it when**: You want design feedback

```
Ask Claude Code: "Please run the UI/UX Designer agent for the Duck Fly Game"
```

The agent will:
- Review iOS design compliance
- Check user experience
- Suggest visual improvements
- Write to `FEEDBACK_UI_UX.md`

---

### 🧪 Tester Agent
**Run it when**: Before major updates or releases

```
Ask Claude Code: "Please run the Tester agent for the Duck Fly Game"
```

The agent will:
- Create test cases
- Identify potential bugs
- Check edge cases
- Write to `FEEDBACK_TESTER.md`

---

### 👀 Code Reviewer Agent
**Run it when**: Before commits or after major changes

```
Ask Claude Code: "Please run the Code Reviewer agent for the Duck Fly Game"
```

The agent will:
- Review code quality
- Check best practices
- Security review
- Write to `FEEDBACK_CODE_REVIEWER.md`

---

## How It Works

1. **You ask Claude Code** to run an agent
2. **Agent starts in cloud** (your laptop doesn't need to do anything)
3. **Agent reviews your code** (takes a few minutes)
4. **Results are saved** to feedback file
5. **You review feedback** and decide what to implement

---

## Checking Feedback

After each agent runs, check its feedback file:

```
FEEDBACK_GAME_DEVELOPER.md  ← Automatic every Monday
FEEDBACK_UI_UX.md           ← Run when you want design help
FEEDBACK_TESTER.md          ← Run before releases
FEEDBACK_CODE_REVIEWER.md   ← Run before major changes
```

---

## Example Workflow

**Monday**: Game Developer agent runs automatically → Check feedback

**Wednesday**: You make changes → Ask for Code Reviewer feedback → Integrate suggestions

**Friday**: Ready to release? → Run Tester agent → Run UI/UX agent → Review feedback → Finalize

---

## Notes

- ✅ Agents run in cloud (24/7, no laptop needed)
- ✅ You have unlimited manual triggers
- ✅ Each agent focuses on their specialty
- ✅ All feedback goes to dedicated files for easy tracking

---

**Questions?** Ask Claude Code anytime about running specific agents!
