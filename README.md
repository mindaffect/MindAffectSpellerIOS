# The MindAffect Speller for iOS

Originally this app was developed by MindAffect to perform a pilot with locked-in patients. The aim of this pilot was to get a better understanding which subset of locked-in patients could be helped by MindAffect's noise tagging technology. 

At MindAffect we currently focus on our development kit, which makes it possible for *anyone* to build their own brain-controlled applications. You can use this project as a starting point for enabling locked-in patients to communicate, further its development, and adjust it to specific needs. Or you can use this project as an example, in order to learn more about how to build iOS apps that work with the MindAffect Decoder. 

By the way, this Speller app is also available on the App Store! 


# The NoiseTagging Framework

This app is build on top of the NoiseTagging framework for iOS. This framework is part of the project, so you can directly build and run, but for the framework's full documentation and more sample code, check out this repo: [MindAffectSDKiOS](https://github.com/mindaffect/MindAffectSDKiOS). 


# Project Structure

The structure of this project is pretty straightforward. The main complexities are hidden inside the NoiseTaggging framework. One point of attention: for localization we make use of BartyCrouch and Swiftgen. 

If you add or make changes to user-facing strings, please check out how this works: [github.com/Flinesoft/BartyCrouch](https://github.com/Flinesoft/BartyCrouch). 
