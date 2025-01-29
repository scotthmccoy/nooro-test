Thank you for reviewing my submission! 

- I tried very hard to match the fonts and colors in Figma (see [CustomFont.swift](https://github.com/scotthmccoy/nooro-test/blob/main/Weather/View/Fonts/CustomFont.swift) and [Color.swift](https://github.com/scotthmccoy/nooro-test/blob/main/Weather/View/Color.swift)). 
- I realized I could better match the quality of the image by downloading the 128x128 version instead of the 64x64 version returned by the API - see [CurrentWeatherDataObject.swift](https://github.com/scotthmccoy/nooro-test/blob/main/Weather/Model/DataObjects/CurrentWeatherDataObject.swift#L28) for details.
- I implemented API debouncing and a nice data/domain object split. I ran out of time to implement proper unit/UI testing, which is dissapointing as I am very passionate about testing. I would have loved to have shown of the testing cocoapods I've published [Scooty's Unit Testing](https://cocoapods.org/pods/Scootys-Unit-Testing) and [Scooty's UI Testing](https://cocoapods.org/pods/Scootys-UI-Testing).

No need to update pods, just open in Xcode and run on a device or simulator! 
