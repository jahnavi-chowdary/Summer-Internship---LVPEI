## PUPIL+ Machine Learning
# Machine learning for automated classification of potential pupillary problems

 Given a video file of the reaction of the the right and left pupil to external light stimulus along with the timestamps of both the videos , plot the area of the right and left pupil at each instant of the given timestamps.
 
* The main_file reads and processes all the videos one by one from a folder named Videos which contains all the Left,Right videos and timestamps.
* The area_of_pupil returns the area of the pupil of both the right and left eye wrt their respective timestamps.

How to arrange your folders:

1. Keep all the Right, Left Videos and Timestamp text files in a single folder named 'Videos'
2. Create empty folders 'CSV' and 'Plots'. Go to Properties of the folder 'Plots' and disable the 'Read-Only' option -> Apply-> Ok
3. Run the main_file_allvideos.m 
4. It computes Area,  and the Time and saves them as a 2 column vector(in the order as specified 'Area' 'Time') with the rows corresponding to each frame in the video, in a CSV file for each of the Right and Left Videos. The name of the CSV file is same as that of the video. All these files get saved in the CSV folder
5. It also saves the plots with the name same as that of the video with a .jpg extension in the Plots folder. In the Plot </br> X -axis : Time and Y-axis : Area of the pupil </br> Red Color : Area of Right Pupil wrt time </br> Blue Color : Area of Left Pupil wrt time </br> 
