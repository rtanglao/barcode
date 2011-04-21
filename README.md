# ruby & html5 scripts to generate movie like barcodes
## Inspirations:
* [http://www.darrenbarefoot.com/archives/2011/03/distilling-the-atmosphere-of-movies.html](http://www.darrenbarefoot.com/archives/2011/03/distilling-the-atmosphere-of-movies.html)
* [http://wordpress.mrreid.org/moviebarcode/](http://wordpress.mrreid.org/moviebarcode/)
* [http://bromito.perso.info.unicaen.fr/wiki/index.php/wiki/page/barcodes](http://bromito.perso.info.unicaen.fr/wiki/index.php/wiki/page/barcodes#source)

## Pre-Requisites

* ruby 1.8.x installed with curb and other gems as needed 
* ImageMagick installed
* [free flickr api key](http://www.flickr.com/services/apps/create/apply)

## Method

1. How to get the metadata of all the pm photo on flickr (need to create a file called flickr.conf with your flickr api key )
    
        cat flickr.conf
        flickr.conf has one line: 
        api_key = a3decafbadbeefbeef

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
        mkdir BARCODE1PX ; cp *.jpg BARCODE1PX ; cd BARCODE1PX

3. Rename 1 pixel images with zeroes padded in the front so ImageMagick will get them in chronologicaly created order

        ../../numberFiles.rb
4. Since ImageMagick (at least the Mac OS X pre-compiled version I downloaded: ImageMagick 6.6.7-5 2011-02-06 Q16) can't handle 4616 images, split up into files of 1000 images each and then combine into 1 jpg

        ls -1 *.jpg > all.jpgs.txt
        split all.jpgs.txt 1000jpgs
        first1000=`cat 1000jpgsaa`
        second1000=`cat 1000jpgsab`
        third1000=`cat 1000jpgsac`
        fourth1000=`cat 1000jpgsad`
        last616=`cat 1000jpgsae`

        montage -geometry +0+0 -tile x1 $first1000  pmbarcode1000.png 
        montage -geometry +0+0 -tile x1 $second1000  pmbarcode2000.png
        montage -geometry +0+0 -tile x1 $third1000  pmbarcode3000.png
        montage -geometry +0+0 -tile x1 $fourth1000  pmbarcode4000.png
        montage -geometry +0+0 -tile x1 $last616  pmbarcode5000.png

5. the culmination: pmbarcode2.png

        montage -geometry +0+0 -tile x1 pmbarcode1000.png pmbarcode2000.png pmbarcode3000.png pmbarcode4000.png pmbarcode5000.png  pmbarcode2.png
