# ruby & html5 scripts to generate movie like barcodes
## Inspirations:
* http://www.darrenbarefoot.com/archives/2011/03/distilling-the-atmosphere-of-movies.html
* http://wordpress.mrreid.org/moviebarcode/

## Observations
1. How to get the metadata
    ./getpmPhotos.rb 1>pm.photos.16.april2011.stdout 2>pm.photos.16.april2011.stderr

1. How many photos with height >=720 ?
    ./get720.rb <  pm.photos.16.april2011.stdout | sort -g --key=2.1 | wc -l
    4622
ANSWER: 4622 photos with height >= 720 (i.e. HD resolution or greater)
