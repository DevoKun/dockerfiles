## Build
* Based on the ubuntu:14.04.1 container.

### Built using the **Dockerfile**
```
docker build -t awsmaine/dec2014 .
```

## Run
```
docker run -ti -v $(pwd)/:/site -p 4000:4000 awsmaine:dec2014
```

## Create a Jekyll site and test-serve it from the container
```
cd /site
jekyll new blog
cd blog
```
### Change the syntax highligher used by jekyll to **rouge** instead of **pygments** *(default)*
```
echo "highlighter: rouge" >> _config.yml
```
### Set the jekyll bind-to-host to be 0.0.0.0 so it doesn't bind to localhost *(127.0.0.1)*
```
jekyll serve -H 0.0.0.0
```

## Browse test served site
### If using boot2docker, get the boot2docker VM's IP
```
BOOT2DOCKERIP=$(boot2docker ip)
```
### Then browse to the boot2docker IP in the browser:
```
$BOOT2DOCKERIP:4000
```

## Configure s3_website and upload website
### Generate new config
```
s3_website cfg create
```

### **FILE:**  s3_website.yml:
```
s3_id:     AKIxxxxxxxxxxxxxx
s3_secret: xxxxxxxxxxxxxxxxxxxxxx
s3_bucket: my-s3-bucket
gzip:
  - .html
  - .css
  - .md
gzip_zopfli: false
cloudfront_distribution_id: E2xxxxxxxxxxxx
```
### Build site and push to s3
```
s3_website cfg apply
s3_website push
```