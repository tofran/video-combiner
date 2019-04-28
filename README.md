# video-combiner

Automatically combine multipart videos

Great for combinng dash cam / helment cam videos, beacause these cameras usually split videos in small parts.

## Requirements

Uses [MEncoder](http://www.mplayerhq.hu/design7/news.html) because currently it is hardcoded for `avi` files.

Can be easily adapted to use `ffmpeg` for `mp4`.


## Real world example

Here I have 22 files from my dash cam, I want to group them by "trip".
The desired result are 4 files (trips).

| Filename     | Date             | Duration | Trip |
|--------------|------------------|----------|------|
| MOVI0011.avi | 1029/04/16@21:05 | 180s     | A    |
| MOVI0012.avi | 1029/04/16@21:08 | 180s     | A    |
| MOVI0013.avi | 1029/04/16@21:11 | 180s     | A    |
| MOVI0014.avi | 1029/04/16@21:14 | 180s     | A    |
| MOVI0015.avi | 1029/04/16@21:17 | 180s     | A    |
| MOVI0016.avi | 1029/04/16@21:20 | 180s     | A    |
| MOVI0017.avi | 1029/04/16@21:24 | 180s     | A    |
| MOVI0018.avi | 1029/04/16@21:27 | 180s     | A    |
| MOVI0019.avi | 1029/04/16@21:27 | 32s      | A    |
| MOVI0020.avi | 1029/04/22@10:42 | 180s     | B    |
| MOVI0021.avi | 1029/04/22@10:45 | 180s     | B    |
| MOVI0022.avi | 1029/04/22@10:48 | 180s     | B    |
| MOVI0023.avi | 1029/04/22@10:51 | 180s     | B    |
| MOVI0024.avi | 1029/04/22@10:54 | 180s     | B    |
| MOVI0025.avi | 1029/04/22@10:57 | 180s     | B    |
| MOVI0026.avi | 1029/04/22@11:00 | 180s     | B    |
| MOVI0027.avi | 1029/04/22@11:03 | 180s     | B    |
| MOVI0028.avi | 1029/04/22@11:04 | 39s      | B    |
| MOVI0030.avi | 1029/04/22@17:37 | 180s     | C    |
| MOVI0031.avi | 1029/04/22@17:40 | 180s     | C    |
| MOVI0032.avi | 1029/04/22@17:43 | 180s     | C    |
| MOVI0033.avi | 1029/04/22@17:44 | 74s      | C    |

The script in actioon:

```bash
$ video-combiner.sh my_videos/*

2019-04-16_20-02.avi will be created from ALL/MOVI0011.avi ALL/MOVI0012.avi ALL/MOVI0013.avi ALL/MOVI0014.avi ALL/MOVI0015.avi ALL/MOVI0016.avi ALL/MOVI0017.avi ALL/MOVI0018.avi ALL/MOVI0019.avi
Press enter to contune...
2019-04-22_09-39.avi will be created from ALL/MOVI0020.avi ALL/MOVI0021.avi ALL/MOVI0022.avi ALL/MOVI0023.avi ALL/MOVI0024.avi ALL/MOVI0025.avi ALL/MOVI0026.avi ALL/MOVI0027.avi ALL/MOVI0028.avi
Press enter to contune...
2019-04-22_16-34.avi will be created from ALL/MOVI0030.avi ALL/MOVI0031.avi ALL/MOVI0032.avi ALL/MOVI0033.avi
Press enter to contune...

```

Now I have a full video of every trip :)


## License

Feel free to [do whatever you want with this code](LICENSE).
