# ruby & html5 scripts to generate movie like barcodes
## Inspirations:
* (http://www.darrenbarefoot.com/archives/2011/03/distilling-the-atmosphere-of-movies.html)
* (http://wordpress.mrreid.org/moviebarcode/)

## Pre-Requisites

* ruby 1.8.x installed with curb and other gems as needed 
* ImageMagick installed
* [free flickr api key](http://www.flickr.com/services/apps/create/apply)

## Method

1. How to get the metadata of all the pm photo on flickr (need to create a file called flickr.conf with your flickr api key )
    
        cat flickr.conf
        flickr.conf has one line: api_key = a3decafbadbeefbeef

        ./getpmPhotos.rb 1>pm.photos.16.april2011.stdout 2>pm.photos.16.april2011.stderr

1. How many photos with height >=720 ?

        ./get720.rb <  pm.photos.16.april2011.stdout | sort -g --key=2.1 | wc -l
        4622

ANSWER: 4622 photos with height >= 720 (i.e. HD resolution or greater)

2. How to retrieve the 4622 photos with height >= 720

        mkdir HD_PICS; cd HD_PICS
        ./download720.rb < ../pm.photos.16.april2011.stdout 2>download720.16april2011.stderr

3. Resize images to be 1pixel wide 720 high (for some reason, bug, this converted only 4616 images)

        convert *.jpg -resize 1x720\! pmbarcode.jpg
        mkdir BARCODE1PX ; cp *.jpg BARCODE1PX

4. Since ImageMagick can't handle 4616 images, split up into files of 1000 images each and then combine into 1 jpg

        ls -1 *.jpg >alljpgs.txt
        mkdir 1000 2000 3000 4000
        (vi and emacs magic to create shell scripts: 1st1000jpgs.txt, 2nd1000jpgs.txt, 3rd1000jpgs.txt, last1616.txt that simply 
        copy images to subdirectories from left as an exercise to the reader)
        sh 1st1000jpgs.txt
        sh 2nd1000jpgs.txt
        sh 3rd1000jpgs.txt 
        sh last1616.txt 
        cd 1000
        montage -geometry +0+0 -tile x1 *.jpg pmbarcode1.png
        cd ../2000
        montage -geometry +0+0 -tile x1 *.jpg pmbarcode2.png
        cd ../3000
        montage -geometry +0+0 -tile x1 *.jpg pmbarcode3.png
        cd ../4000
        montage -geometry +0+0 -tile x1 *.jpg pmbarcode4.png
        cd ..

5. the culmination: pmbarcode.png

    montage -geometry +0+0 -tile x1 1000/pmbarcode1.png 2000/pmbarcode2.png 3000/pmbarcode3.png 4000/pmbarcode4.png pmbarcode.png
