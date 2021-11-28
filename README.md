<h1 align="center">
  <img src="https://user-images.githubusercontent.com/88666686/143453803-54a76b2c-c164-4058-8262-32f34d0d2edc.png" width="200px"/></br>
  CameraApp</br>
  <img src="https://img.shields.io/badge/iOS-14.0+-00ADD8?style=for-the-badge&logo=apple"/>
</h1>

# Description
This is a basic photo camera that is built with modularization in mind.

**The app supports rotations!** It imitates the rotation logic from the standard iOS Camera app (thanks to [Rotations framework](https://github.com/ANameBehindTheNickname/Rotations-iOS)). It also works when the device orientation is locked from Control Center.

# Note about the architecture
<img src="https://user-images.githubusercontent.com/88666686/143453835-10af7854-3c49-4adc-9168-b3944eb87295.png" width="300px"/></br>
Camera control is a thing that has multiple states (grid on/off, camera back/front, flash on/off/auto etc.). I use State Machine to help me dealing with all possible combinations.
View sends an Event to ViewModel, which in turn updates the State Machine, eventually leading to View updates.

# Features
- [x] 📷 Front and back camera support
- [x] <img src="https://user-images.githubusercontent.com/88666686/143453898-b64a9bfb-dc87-4d7a-a394-b169fc472dfd.png" width="20px"/> HD photo
- [x] ⚡️Flash

# Screenshots
Note: CameraApp look may differ on a real iPhone 13 device.</br></br>
<img src="https://user-images.githubusercontent.com/88666686/143490656-e8a71da8-6fb1-49e0-af91-5d7d3c03be1a.png" width="280px"/>
<img src="https://user-images.githubusercontent.com/88666686/143574987-8e7679f7-b10a-4def-b85b-001d33233105.png" width="575px"/>

# Images in screenshots
["European hare, Lepus europaeus, Zając szarak"](https://arturrydzewski.com/wp-content/uploads/2019/11/European-hare-Lepus-europaeus-Zając-szarak-AR3_4104-1030x687.jpg), by [Artur Rydzewski](https://arturrydzewski.com), [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)</br>
["Tree reflection"](https://arturrydzewski.com/wp-content/uploads/2017/11/Tree-reflection-DSC_0591.jpg), by [Artur Rydzewski](https://arturrydzewski.com), [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)</br>
I also made slight modifications (crop).

# How to install
<ul>
  <li>git clone / download a zip</li>
  <li>build and run</li>
</ul>

It has an external dependency ([Rotations framework](https://github.com/ANameBehindTheNickname/Rotations-iOS)), but it is included in the project. No need to download anything.</br>

# License
This project is licensed under BSD-3-Clause License. See [LICENSE](LICENSE) for details.
