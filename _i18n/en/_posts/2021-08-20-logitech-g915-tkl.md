---
excerpt: >
  I bought a **Logitech G915 TKL keyboard**
  at a beginning of the 2021 year.
  This keyboard works pretty well on Windows
  and Logitech G Hub software.
  There is a ton of ways to customize it.
  It can be fun.
  The problem comes when you cannot normally install
  G Hub software on your system, like on Ubuntu.
  Since I use the Logitech G915 TKL keyboard
  for a while with my Ubuntu,
  I would like to share what
  I already know about customizing it on Linux.
layout: post
photo: /images/logitech-g915-tkl/logitech-g915-tkl
title: Logitech G915 TKL with Ubuntu
description: How to configure Logitech G915 TKL on Linux?
headline: Premature optimization is the root of all evil.
categories: [tools]
tags: [keyboard]
imagefeature: logitech-g915-tkl/og_image-logitech-g915-tkl.png
lang: en
last_modified_at: 2021-10-06 15:00:00 +0200
---

I bought a **Logitech G915 TKL keyboard** at a beginning of the 2021 year. This keyboard works pretty well on Windows and Logitech G Hub software. There is a ton of ways to customize it. It can be fun. The problem comes when you cannot normally install G Hub software on your system, like on Ubuntu. Since I use the Logitech G915 TKL keyboard for a while with my Ubuntu, I would like to share what I already know about customizing it on Linux.

First of all, this article is not a review of the Logitech G915 TKL keyboard. I won't talk about features, advantages or disadvantages. The only thing I will tell is that the Logitech G915 TKL keyboard is a lightspeed, wireless, RGB, mechanical, gaming keyboard with low profile switches. I choose the linear type of switches. One more note, I did not have any problem with media buttons, game mode, or volume control on Ubuntu. Everything works fine. The main problem was with the lighting theme. It was annoying for me. That's all. Now let's move to the core of this article - the customization.

## Default settings

The keyboard comes with a default preset RGB theme - a breathing rainbow theme - how I call it. It's awesome for the first 15 minutes, but when I tried to do some programming, it was pretty distracting. So, I start the search for other possibilities. By default, the G915 TKL keyboard has 10 themes. Here you can find the way how to use it:

- `☀` (brightness button) - cycles through brightness levels
- `☀ + 1` - the lightning effect: Colorwave (left to right)
- `☀ + 2` - the lightning effect: Colorwave (right to left)
- `☀ + 3` - the lightning effect: Colorwave (center out)
- `☀ + 4` - the lightning effect: Colorwave (bottom up)
- `☀ + 5` - the lightning effect: Color cycle
- `☀ + 6` - the lightning effect: Ripple
- `☀ + 7` - the lightning effect: Breathing
- `☀ + 8` - the lightning effect: User-stored lighting
- `☀ + 9` - the lightning effect: User-stored lighting
- `☀ + 0` - the lightning effect: Cyan blue
- `☀ + -` - Decreases effect speed
- `☀ + +` - Increased effect speed

Unfortunately, when you set one of these themes and you do not use the keyboard for a while, it will come back to the breathing rainbow theme.

## G Hub software

G Hub software looks nice, and you can set almost every small detail of your customization there, especially for the RGB keyboard lighting. I read that using G Hub you can sore your custom setups on the keyboard and use them even the keyboard is not connected to G Hub. That's not true, at least for me. Each time I created my custom lighting, and of course, it was visible on the keyboard after disconnected from G Hub and switch back to Ubuntu, all my setups were gone.

## Libratbag and Ratbagctl

When the easiest solutions failed, I tried to search for some open source projects. I looked for something that will give me the possibility to configure my keyboard, at least from the terminal level. And I found **Libratbag**. It provides **Ratbagd**, a DBus daemon to configure input devices, mainly gaming mice. Luckily it supports not only mice but also keyboards, including the Logitech G915 TKL keyboard. In the case of my keyboard, I wasn't able to use a graphical tool, but the CLI (command line interface) works just fine.

To use Ratbagctl, I installed a specific package for my Ubuntu (all links on the bottom of this article). Then I connected my keyboard using wire to my laptop. I turn on the keyboard and start to use the `ratbagctl` command.

To display a list of devices, use:

```bash
$ ratbagctl list
warbling-mara:       Logitech G915 TKL LIGHTSPEED Wireless RGB Mechanical Gaming Keyboard
```

Now, we know the name of our device:

```bash
Logitech G915 TKL LIGHTSPEED Wireless RGB Mechanical Gaming Keyboard
```

We can use it in the next commands. Let's display information about our device:

```bash
$ ratbagctl "Logitech G915 TKL LIGHTSPEED Wireless RGB Mechanical Gaming Keyboard" info
warbling-mara - Logitech G915 TKL LIGHTSPEED Wireless RGB Mechanical Gaming Keyboard
             Model: usb:046d:c343:0
 Number of Buttons: 15
    Number of Leds: 2
Number of Profiles: 3
Profile 0: (active)
  Name: n/a
  Report Rate: 1000Hz
  Button: 0 is mapped to macro '↕F1'
  Button: 1 is mapped to macro '↕F2'
  Button: 2 is mapped to macro '↕F3'
  Button: 3 is mapped to macro '↕F4'
  Button: 4 is mapped to macro '↕F5'
  Button: 5 is mapped to macro '↕F6'
  Button: 6 is mapped to macro '↕F7'
  Button: 7 is mapped to macro '↕F8'
  Button: 8 is mapped to macro '↕F9'
  Button: 9 is mapped to macro '↕F10'
  Button: 10 is mapped to macro '↕F11'
  Button: 11 is mapped to macro '↕F12'
  Button: 12 is mapped to 'unknown'
  Button: 13 is mapped to 'unknown'
  Button: 14 is mapped to 'unknown'
  LED: 0, depth: rgb, mode: on, color: 0000ff
  LED: 1, depth: rgb, mode: on, color: 0000ff
Profile 1:
  Name: n/a
  Report Rate: 1000Hz
  Button: 0 is mapped to macro '↕F1'
  Button: 1 is mapped to macro '↕F2'
  Button: 2 is mapped to macro '↕F3'
  Button: 3 is mapped to macro '↕F4'
  Button: 4 is mapped to macro '↕F5'
  Button: 5 is mapped to macro '↕F6'
  Button: 6 is mapped to macro '↕F7'
  Button: 7 is mapped to macro '↕F8'
  Button: 8 is mapped to macro '↕F9'
  Button: 9 is mapped to macro '↕F10'
  Button: 10 is mapped to macro '↕F11'
  Button: 11 is mapped to macro '↕F12'
  Button: 12 is mapped to 'unknown'
  Button: 13 is mapped to 'unknown'
  Button: 14 is mapped to 'unknown'
  LED: 0, depth: rgb, mode: breathing, color: 00dcff, duration: 3000, brightness: 255
  LED: 1, depth: rgb, mode: breathing, color: 00dcff, duration: 3000, brightness: 255
Profile 2:
  Name: n/a
  Report Rate: 1000Hz
  Button: 0 is mapped to macro '↕F1'
  Button: 1 is mapped to macro '↕F2'
  Button: 2 is mapped to macro '↕F3'
  Button: 3 is mapped to macro '↕F4'
  Button: 4 is mapped to macro '↕F5'
  Button: 5 is mapped to macro '↕F6'
  Button: 6 is mapped to macro '↕F7'
  Button: 7 is mapped to macro '↕F8'
  Button: 8 is mapped to macro '↕F9'
  Button: 9 is mapped to macro '↕F10'
  Button: 10 is mapped to macro '↕F11'
  Button: 11 is mapped to macro '↕F12'
  Button: 12 is mapped to 'unknown'
  Button: 13 is mapped to 'unknown'
  Button: 14 is mapped to 'unknown'
  LED: 0, depth: rgb, mode: cycle, duration: 3000, brightness: 255
  LED: 1, depth: rgb, mode: off
```

We see here that we have two sections of LEDs: one for the G logo and one for the rest of the keyboard LEDs. It's not the best situation because we can only set one colorization for all keys, but it's better than nothing. We also have 3 profiles where we can set our macros. I don't use them so I won't focus on that topic. I just mention that to switch between those profiles you need to use `fn + F1-3` (functional key with one of `F1`, `F2`, `F3`).

Let's focus now on setups for colorization. To check your current setups, you can use:

```bash
$ ratbagctl "Logitech G915 TKL LIGHTSPEED Wireless RGB Mechanical Gaming Keyboard" led get
LED: 0, depth: rgb, mode: on, color: 0000ff
LED: 1, depth: rgb, mode: on, color: 0000ff
```

To change lighting mode:

```bash
$ ratbagctl "Logitech G915 TKL LIGHTSPEED Wireless RGB Mechanical Gaming Keyboard" led 1 set mode breathing
$ ratbagctl "Logitech G915 TKL LIGHTSPEED Wireless RGB Mechanical Gaming Keyboard" led 1 set duration 3000
```

As you can tell, to see the breathing effect, you need to set the duration too. For the Logitech G915 TKL keyboard, we have 4 modes:

```bash
$ ratbagctl "Logitech G915 TKL LIGHTSPEED Wireless RGB Mechanical Gaming Keyboard" led 1 capabilities
Modes: breathing, cycle, off, on
```

Try yourself which mode is the best for you. I like `on` where one color is set for all time.

```bash
$ ratbagctl "Logitech G915 TKL LIGHTSPEED Wireless RGB Mechanical Gaming Keyboard" led 1 set mode on
$ ratbagctl "Logitech G915 TKL LIGHTSPEED Wireless RGB Mechanical Gaming Keyboard" led 1 set color 0000FF
```

To discover all possible commands, I recommend you to read the manual. In my case, it can be found here: `ratbagctl "Logitech G915 TKL LIGHTSPEED Wireless RGB Mechanical Gaming Keyboard" --help`. There is a possibility to configure profiles or create your macros too.

**Tip from [@yawor](https://github.com/yawor "@yawor GitHub page")**, who is the person responsible for Logitech G915 pull request on g810-leds (more about that below):

> You should be careful with ratbag. When you set LED from ratbagctl, it writes that configuration to onboard flash. Basically, it overwrites the stored profile (you can even select which of the 3 profiles you want to write to). I've had some issues when I tried to set some colours. I've also noticed that it messed up power saving settings, and the keyboard backlight doesn't timeout at all (only the G logo blinks for a moment after ~ 30 seconds of inactivity).

## G810-led

Another project which tries to support Logitech keyboards on Linux is **G810-led**. It supports keyboards like Logitech G213, G410, G413, G512, G513, G610, G810, G815, G910, and GPRO. During I'm writing this article, there is a pull request including changes for Logitech G915. The Logitech G915 TKL keyboard should be 100% compatible with the full G915. When I tried this PR for the first time, I couldn't connect with my keyboard. After all the command which works:

```bash
$ sudo g810-led -dv 046d -dp c545 -tuk 5 -a 0000ff
```

It sets all keys to one color. Unfortunately, from time to time, only part of the keys get the right color. It looks like PR is not fully working with Logitech G915 TLK. The problem can be fixed by using the same command twice or by setting a specific key or group of keys additionally.

To set one key (in this case `w` key):

```bash
$ sudo g810-led -dv 046d -dp c545 -tuk 5 -k w ff0000
```

To set group of keys (all `F1-F12` keys):

```bash
$ sudo g810-led -dv 046d -dp c545 -tuk 5 -g fkeys ff00ff
```

If you want to know the name of a specific key, use the `--help-keys` command.

```bash
$ sudo g810-led -dv 046d -dp c545 -tuk 5 --help-keys
```

I won't show you all possibilities. Instead of that, I recommend you to check out the main page of the g810-led project.

Now, I would like to shortly talk about the `-c` parameter, which I misunderstood at the beginning. In Logitech's HID API, setting LED colors is a two steps process. First, you send colors for individual keys. This step has no visible effect on the keyboard. It only stores setups in the keyboard's RAM. The second step is to commit all your color changes. It outputs colors stored in RAM onto physical LEDs. `-c` parameter is responsible for committing all changes.

For g810-led switches parameters `-a`, `-g` and `-k` always sends commit automatically. There are `-an`, `-gn`, and `-kn` variants of these switches, which don't send commit. If you use them, you won't see any difference on the keyboard unless you call `g810-leds -c` after that.

**Important!** All commands above are working only in the wireless mode. The wire connection is not supported for now.

One more note. I was not able to save the selected setups. Each time when the keyboard turns the lighting off, the lighting effect goes back to keyboard defaults. It's because g810-led don't mess with the onboard flash. Similar to the keyleds tool described below. They only change a runtime configuration. That's why there is an issue with that. The LED configuration resets after the keyboard wakes up from the power save function. Unfortunately, non of the current software implements detecting the wake-up to reapply the configuration. Nevertheless, I had a lot of fun using this project.

**Tip from [@yawor](https://github.com/yawor "@yawor GitHub page")**, who is the person responsible for Logitech G915 pull request on g810-leds:

> There's a workaround for this. You can switch the keyboard into software mode, which disables onboard features like power-saving, backlight control, etc, and then control everything from the software. After that, the keyboard immediately will go dark (but it's still working - only the backlight turns off). Then you can set whatever colors you like using g810-led. But remember that the power saving is disabled in this mode. It is the software that should control dimming the keyboard, but there's no software for Linux right now that does that. Also, the mode is back to "board" mode after you power cycle the keyboard.

The command for this looks like that:

```bash
$ sudo g810-led -dv 046d -dp c545 -tuk 5 --on-board-mode software
```

## Keyleds

There is one more project worth mentioning - the **Keyleds**. The main project doesn't support G915, but there is a fork with the G915 branch in progress. When I compiled it locally, I was able to see my keyboard using a command line. For now, the functionality is not impressive, but maybe in the future, there will be full support for the Logitech G915 TKL keyboard.

To run it:

```bash
$ killall keyledsd
$ keyledsd --verbose
```

To see information about the keyboard (in my case, I have only one device):

```bash
$ keyledsctl info
Name:           G915 TKL LIGHTSPEED Wireless RGB Mechanical Gaming Keyboard
Type:           keyboard
Model:          b35f408ec343
Serial:         ede0b9c9
Firmware[0000]: bootloader BL1 v112.0.17
Firmware[0000]: (null)  v100.0.a9
Firmware[c343]: application MPK v114.0.17 [active]
Firmware[0000]: (null)  v100.0.0
Firmware[0000]: (null)  v100.0.0
Features:       [0001, 0003, 0005, 1d4b, 0020, 1001, 1814, 1815, 8071, 8081, 1b04, 1bc0, 4100, 4522, 4540, 8010, 8020, 8030, 8040, 8100, 8060, 00c2, 00d0, 1802, 1803, 1806, 1813, 1805, 1830, 1890, 1891, 18a1, 1e00, 1eb0, 1861, 18b0]
Known features: feature version name gamemode layout2 gkeys mkeys mrkeys reportrate
G-keys: 12
Report rates:   [1ms] 2ms 4ms 8ms
```

If you have more than one device, use the `keyledsctl list` command. Then choose the specific device.

Right now, the only thing you can do using this project is setting up game mode:

```bash
$ keyledsctl gamemode h
$ keyledsctl gamemode
```

## Thanks

I would like to thanks [@yawor](https://github.com/yawor "@yawor GitHub page"), who read this article and add some addtional thoughts.

## Links
- [Logitech user manual for Logitech G915 TKL keyboard](https://www.logitech.com/assets/65920/g915-g913-tkl-qsg.pdf "Logitech user manual for G915 TKL")
- [Reddit thread about Logitech G915 TKL keyboard](https://www.reddit.com/r/linuxhardware/comments/k76ruy/remarks_on_the_logitech_g915_with_ubuntu_2004/ "Remarks on the Logitech G915 with Ubuntu 20.04")
- [Ask Ubuntu thread about Logitech G915 TKL keyboard](https://askubuntu.com/questions/1300455/how-to-control-logitech-g915-tkl-keyboard-lightning-in-linux-ubuntu "How to control Logitech G915 TKL keyboard lightning in Linux Ubuntu?")
- [Manual and installation proces for Ratbagctl](https://github.com/libratbag/libratbag/wiki/ratbagctl "Short manual for Ratbagctl")
- [Github thread about gaming keyboard and possible solutions](https://github.com/libratbag/libratbag/issues/172 "Add support in libratbag for a subset of gaming keyboards")
- [G810-led project](https://github.com/MatMoul/g810-led "G810-led project")
- [G810-led issue about Logitech G915 keyboard](https://github.com/MatMoul/g810-led/issues/198 "G810-led issue about Logitech G915 keyboard")
- [G810-led pull request for Logitech G915 keyboard support](https://github.com/MatMoul/g810-led/pull/267 "G810-led pull request for Logitech G915 keyboard support")
- [Keyleds project](https://github.com/keyleds/keyleds "Keyleds project")
- [Manual for Keyleds project](https://github.com/keyleds/keyleds/wiki/Installing "How to install Keyleds project?")
- [Logitech G915 TKL fork of Keyleds project](https://github.com/yawor/keyleds/tree/g915 "G915 fork of Keyleds project")
