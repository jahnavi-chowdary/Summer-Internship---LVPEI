## PUPIL+ Machine Learning
# Machine learning for automated classification of potential pupillary problems

Given a video file of the reaction of the the right and left pupil to external light stimulus along with the timestamps of both the videos , plot the area of the right and left pupil at each instant of the given timestamps.

This Branch includes the module which computes the areas of the pupils real time right when the test is being performed on a person. It makes the system better in a way that now none of the videos or timestamps need to be stored as the areas and timestamps are being calculated simultaneous to the capturing of the video and these newly computed areas on the new patient are being appended to the existing data.

After the test is completed (Test comprises of 4 times blinking of the LEDs each in the right and left pupils alternately i.e a total of 8) , the areas wrt time of both the right and left pupils are plotted. 
