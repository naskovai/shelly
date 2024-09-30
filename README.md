# Shelly: Write Terminal Commands in English

Shelly is a powerful tool that translates English into commands that can be seamlessly executed in your terminal. You won't have to remember exact commands anymore.

## How It Works

Upon calling shelly with an instruction, it opens an editor like nano/vim in the terminal with the proposed command. Saving executes the final version.

Shelly uses AI to interpret plain English and translate it into accurate terminal commands. In particular, shelly uses OpenAI's GPT-4, so you'll need an OpenAI API Key.

## Usage Examples

```bash
shelly 'git last 5 commits'
  $ "git log -5"

shelly 'check size of files in this directory but format it with gb/mb, etc'
  $ "du -sh *"

shelly 'find "class" in files in this directory without the .venv dir'
  $ grep -r --exclude-dir=.venv "class" .
```

## Installation

Install Shelly via Homebrew:

```bash
brew untap naskovai/shelly
brew tap naskovai/shelly https://github.com/naskovai/shelly
brew install shelly
```

Enjoy using Shelly!
