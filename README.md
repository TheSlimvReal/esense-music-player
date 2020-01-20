# eSense powered Music Player

This music player is build for the [eSense Earables](https://www.esense.io/).
It uses their gyro sensor to enable gesture control.
Currently there are three supported gestures.

1. Nodding down pauses or resumes the current song
2. Moving head down to the right shoulder and back up again skips to the next song
3. Moving head down to the left shoulder and back up against returns to previous song.

Because flutter does not come with a good plugin of the device intern music player, I created a own one.
The downside of this is, that you have to put your own music into the assets folder and also enter the name of each 
mp3 in the [MusicPlayer](https://github.com/TheSlimvReal/esense-music-player/blob/master/lib/music/MusicPlayer.dart).

After doing that you have to enable bluetooth and location service on your phone.
The phone needs have Bluetooth Low Energy support.

When all this is done, you can deploy the app to your phone and connect it to you Earables.
By pushing the button of the left speaker it start/stops the gesture controll.

Have fun and start contributing.
