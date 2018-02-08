## How to use this file

The `happy-image.json` file contained here can be used to deploy your application to every data center on Triton. Modify to remove as many as you wish.

The instructions to deploy the Happy Randomizer image on multiple data centers are similar to those available on the [Joyent blog](https://www.joyent.com/blog/video-create-images-with-packer). This image does not use the environment CloudAPI URL, optioning instead to create connection URLs with the various data center names.