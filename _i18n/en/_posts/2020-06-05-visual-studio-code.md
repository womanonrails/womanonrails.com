---
layout: post
photo: /images/visual-studio-code/visual-studio-code
title: Visual Studio Code
description: My favourite shortcuts
headline: Premature optimization is the root of all evil.
categories: [tools, keyboard shortcuts]
tags: [IDE, text editor, keyboard shortcuts]
imagefeature: visual-studio-code/og_image-visual-studio-code.png
lang: en
---

Some time ago, I was using <a href="{{ site.baseurl }}/sublime" title="Sublime Text editor - useful functionality">Sublime Text Editor</a> for my programming work. For a very long time, I was satisfied with this text editor. But after some time, Sublime Text didn't fit me as well as at the beginning anymore. So, I started research on something new. I found **Visual Studio Code** - free, built on an open-source text editor. Today, I will tell you more about this tool.

## Why I don't use Sublime Text anymore?

As I told you in the beginning, I liked Sublime Text. But after some time, when my projects started to grow and everything was running in the Docker containers, something changed. I notice one small thing, which irritates me a lot. From time to time Sublime Text just freeze. I was not able to do anything. Because the situation was repeating over and over again, even more often and this freezing completely crashed my flow, I decided to search for something new. Something that can handle my project without freezing. I found the Visual Studio Code.

## What I like about VS Code?

When I was looking for a new tool, a new text editor, I search for something like Sublime Text. I wanted to have similar functionality, but faster than Sublime Text. Visual Studio Code is exactly that kind of tool. Let's check it:

1. **I can split my editor to as many panels as I need** - this is a pretty cool feature. For me, two panels at the same time are enough. One is for code and one is for tests. This gives me the boost of productivity in my <a href="{{ site.baseurl }}/tdd-basic" title="How to work using TDD?">TDD flow</a>.

2. **VS Code in command line** - VS Code has its command-line interface (CLI), which allows you to customize how the editor is launched. You can have different VS Code workspaces prepared for different folders. Each time you work on a specific project, you have setups adjusted to what you do (open files, chosen language, explorer sidebar). This is something that allows me to save me time when I switch between projects. My favourites commands are:

    - `code .` - open code with current directory
    - `code --diff <file1> <file2>` - open diff editor
    - `code --goto package.json:10:5` - open file at specific line and column `<file:line[:character]>`
3. **Everything is customizable** - if you want to change your settings just use `Ctrl + ,` you will see commonly used settings in one place. You can adjust them to a specific workspace or for your user.

4. **Adding new extensions** - VS Code has many functionalities built in. Like Emmet, Terminal, Debugger, or Git usage. But if you need something more, you can always search for an extension. Those are some of my extensions:

    - **Code Spell Checker** - A basic spell checker that works well with camelCase code.
    - **Spell Right** - Multiple languages spell checker.
    - **GitLens - Git supercharged** - Additional support for git in VS Code. For example, show git history in line.
    - **JSON Tools** - Tools to manipulate JSON. You can pretty/minify JSON with this extension.
    - **Markdown Preview Enhanced** - Allow you to see a preview of your markdown files in real-time.
    - **ruby-rubocop** - Rubocop linter for VS Code. This is a linter for Ruby programming language.
    - **Slim** - Support for Slim.
    - **Sort lines** - Extension for sorting lines.

5. **Keyboard Shortcuts** - ❤️ I love keyboard shortcuts. They allow me to focus on what I'm doing and completely forget about how to do it. I don't need to go back and forward from the keyboard to the mouse. I can do my flow. Before I will go to some of the shortcuts, I would like to mention two more things. First, **keymaps**. If you get used to shortcuts from another text editor, you can install a Keymap, which brings you all your favourite shortcuts to VS Code. Second, you can customize your keyboard shortcuts by using `Ctrl + K Ctrl + S`.

### Keyboard shortcuts list

I decided to learn default VS Code shortcuts. Here are my favourites:

#### Managing workspaces, panels and sidebars
- `Ctrl + B` - toggle sidebar (you can find there explorer, searchbox or extensions sidebar)
- `Ctrl + Shift + X` - search for new extensions and list of installed extensions
- `Ctrl + Shift + E` - show Explorer with list of your files and folders
- `Crtl + J` - toggle panel (you can find there problems, terminal, output or debug console panel)
- `Ctrl + Shift + M` - shows panel with errors and warnings available for current context
- `F8` - go to next error (when errors panel is open)
- `Shift + F8` - go to previous error (when errors panel is open)
- <code class='language-plaintext highlighter-rouge'>Ctrl + `</code> - integrated Terminal
- `Ctrl + 0` - focus on sidebar (you can use arrows to navigate between folders and files, press `enter ↩` to open selected file and move the focus to this file)
- `Ctrl + 1,2,3,4` - move focus between open panels/groups (it depends layout you choose)
- `Ctrl + PgUp, PgDn` - go to previous/next open tab/file
- `Ctrl + Shift + T` - open last closed tab (just like in your browser)
- `Ctrl + \` - split one workspace to side by side edition
- `Ctrl + N` - open new tab/file
- `Ctrl + O` - open existing file
- `Ctrl + Shift + N` - open new workspace/window
- `Ctrl + W` - close current file/tab
- `Ctrl + K Ctrl + ←` - focus into previous editor group
- `Ctrl + K Ctrl + →` - focus into next editor group
- `Ctrl + Shift + PgUp` - move editor left
- `Ctrl + Shift + PgDn` - move editor right
- `Ctrl + K ←, →` - move active editor group left/right
- `Ctrl + K ↑, ↓` - move active editor group top/bottom

#### Navigation
- `Ctrl + G` - go to line in current file
- `Ctrl + R` - navigate between recently opened folders and workspaces
- `Ctrl + P` - quick-open files by name in your project (you can even search by first letters of each part of file name example: searching by `mnf`, and VS Code will find `my_new_file.txt`), when you use `→` you can open multiple files
- `Ctrl + T` - go to Symbol the in workspace
- `Ctrl + Shift + O` - go to Symbol in File, you can group the symbols by kind by adding a colon, `@:`

#### History navigation
- `Ctrl + Tab` - navigate entire history, choose next file from current panel
- `Ctrl + Shift + Tab` - navigate entire history, choose previous file from current panel
- `Ctrl + Alt + -` - navigate back
- `Ctrl + Shift + -` - navigate forward

#### JSON
- `Ctrl + Alt + M` - pretty JSON power by JSON Tools
- `Alt + M` - minify JSON power by JSON Tools
- `Ctrl + Shift + I` - pretty JSON included directly in VS Code, to use this JSON formatting you need to set JSON file extension or select JSON language mode

#### Markdown (Markdown Preview Enhanced extension)
- `Ctrl + Shift + V` - open Markdown preview
- `Ctrl + K V` - open side by side Markdown edit and preview
- `Ctrl + Shift + S` - sync preview / sync source

#### Multi lines cursor
- `Shift + Alt + ↑, ↓` - add cursor to line above or below current line
- `Ctrl + Shift + ↑, ↓` - add cursor to line above or below current line
- `Ctrl + Shift + L` - add additional cursors to all occurrences of the current selection
- `Ctrl + U` - undo last cursor operation
- `Shift + Alt + I` - insert cursor at end of each selected line
- `Ctrl + ←, →` - go to word beginning/ending

#### Multi selection
- `Ctrl + D` - select word (repeat selection of others occurrences in context for multiple editing)
- `Ctrl + F2` - select all occurrences of current word
- `Ctrl + A` - select a whole file
- `Ctrl + L` - select a whole line
- `Shift + Alt` - select column/box while drag a mouse
- `Ctrl + Shift + ←, →` - select previous/next word

#### Indentation
- `Ctrl + ]` - indent current line(s)
- `Ctrl + [` - outdent current line(s)
- `Tab` - when cursor is on the beginning of a line indent current line(s)
- `Tab + Shift` - when cursor is on the beginning of a line outdent current line(s)
- `Ctrl + Shift + I` - formatting any file based on language rules

#### Edition tricks
- `F9` - do alphabetical order of selected lines power by Sort lines
- `Alt + ↑, ↓` - move line up and down
- `Ctrl + ↩` - insert line after
- `Ctrl + Shift + D` - duplicate line(s), (this is shortcut I added to my VS Code), when you use operation system different then Ubuntu you should be able to use default VS Code keyboard shortcut `Ctrl + Shift + Alt + ↑, ↓`, on Ubuntu this is Ubuntu shortcut for moving windows between virtual desktops
- `Ctrl + C` - copy selected text to clipboard or when you have cursor in line without selected text copy whole line to clipboard
- `Ctrl + V` - paste selected text or whole line from clipboard
- `Ctrl + X` - cut selected text or whole line (when text is not selected) to clipboard
- `Ctrl + Z` - undo your last change
- `Ctrl + Shift + Z` - redo your last change
- `Ctrl + Y` - redo your last change
- `Ctrl + Backspace` - remove previous word (without adding to clipboard)
- `Ctrl + Delete` - remove next word (without adding to clipboard)
- `Ctrl + Shift + K` - delete line (without adding to clipboard)
- `Ctrl + K Ctrl + X` - trim trailing whitespaces

#### Code tricks
- `Crtl + /` - comment/un-comment line (it depends selected programming language)
- `Ctrl + K  Ctrl + L` - open/close selected section in code
- `Ctrl + Shift + \` - jump to matching bracket

#### Search & Replace
- `Ctrl + F` - search in the current file
- `F3` - next searched phrase
- `F3 + Shift` - previous searched phrase
- `Ctrl + H` - replace one phrase to another in the current file
- `Ctrl + Shift + F` - search in whole workspace
- `Ctrl + Shift + H` - replace one phrase to another in whole workspace

#### Others
- `Ctrl + ↑,↓` - move file up/down by one line (like scroll)
- `Ctrl + S` -  save file
- `Ctrl + K M` - change programming language mode
- `Ctrl + K P` - copy path of active file
- `F2` -  rename Symbol (file name, class name, method name)
- `Ctrl + Shift + P` - Command Palette, access to all available commands based on your current context
