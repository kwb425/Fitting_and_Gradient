# Table of Contents <a name="anchor_main"></a>
---
1. [Release ver 1.7.](#anchor_1) <br></br>
2. [fitting\_joint\_gradient.m](#anchor\_2) <br></br>
3. [References](#anchor_ref) <br></br>

## Release ver 1.7. <a name="anchor_1"></a> [top](#anchor_main)
* Please download the fitting\_joint\_gradient.m file. Below will cover contents of it.

## fitting\_joint\_gradient.m <a name="anchor_2"></a> [top](#anchor_main)
If you click all CHECKBOXES, then it will be AUTOMATIC.

* Fitting parameters: 

1. Samples: more than 30 will slowdown the program.
2. Factor 1 lambda: higher than 0.0001 will blow up the gradient steps.
3. Factor 2 lambda: higher than 0.0001 will blow up the gradient steps.
4. Max iteration: how many steps you want to go down
5. Tolerance: minimum threshold of our gradient (that is, derivations, slopes) must change, otherwise escape.
6. Y function: your ground truth function handler

* Joint parameters:

1. Length 1: length of stick from origin (0, 0) to joint
2. Length 2: length of stick from the joint to end of the arm
3. Angle 1: angle (acute one) between Length 1 and x axis 
4. Angle 2: angle (acute one) betwen Length 2 and a line parallel to the x axis which is attached to the joint 
5. Length lambda: higher than 0.01 will blow up the gradient steps.
6. Angle lambda: higher than 0.0001 will blow up the gradient steps.
7. Max iteration: how many steps you want to go down
8. Tolerance: minimum threshold of our gradient (that is, derivations, slopes) must change, otherwise escape.

## References <a name="anchor_ref"></a> [top](#anchor_main)
Please check Git repo for [latest update][1]

Please send any questions to: <kwb425@icloud.com>

<!--Links to addresses, reference Markdowns-->
[1]: https://github.com/kwb425/Fitting_and_Gradient.git
<!--Links to images, reference Markdowns-->