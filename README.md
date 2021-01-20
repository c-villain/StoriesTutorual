# Instagram Story - Using Blueprint & OpenCombine

**Declaratively UI** constructed popular Instagram Scrolling Photos with some improvements for iOS, written in Swift.

## About
This tutorial demonstrates **two ways** of showing stories:

- **_simple_**:
<p align="center">
<img src="images/short_story.gif" alt="Example without labels" height="160">
</p>

- **_customized_ (with labels and buttons on each slide)**:

<p align="center">
<img src="images/long_story.gif" alt="Example with labels" height="480">
</p>

## Architecture

Based on [Blueprint](https://github.com/square/Blueprint) and [OpenCombine](https://github.com/OpenCombine/OpenCombine) with MVVM architecture. 

## Features

* You can add labels and tappable buttons to each slide
* Supports all orientations on iPhone and iPad
* Long press pause and play
* Left tap and Right-tap gestures to switch between slides
* Closing story by swiping down
* If there is no user interruption, it will automatically move to the next slide
* It will automatically close story after the progress bar completes
* Progress bar is very smooth

## Requirements

- iOS 11 or later

## Special thanks

This app uses [Blueprint](https://github.com/square/Blueprint) by [Square team](https://github.com/square) and [OpenCombine](https://github.com/OpenCombine/OpenCombine) by [OpenCombine team](https://github.com/OpenCombine).

Thx to [Jean-Marc Boullianne](https://github.com/jboullianne) for inspriration with his [SwiftUI tutorial of stories](https://github.com/jboullianne/InstagramStoryTutorial-SwiftUI).
