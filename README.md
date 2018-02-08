# Packer & Terraform series

This repository is a collection of all of of the files related to the Packer and Terraform series on the [Joyent blog](https://www.joyent.com/blog).

## Prerequisites

1. Sign up for a [Triton account](https://lpage.joyent.com/Triton-Free-Trial.html).
   + [Be sure to finish setting up your account](https://docs.joyent.com/public-cloud/getting-started)
1. Download [Packer](https://www.packer.io/downloads.html).
1. Download [Terraform](https://www.terraform.io/).

To use the environment variables, you must be in the Triton environment before building the Packer image or initializing Terraform.

```
$ eval "$(triton env)"
```

## Blog series

+ [Create images with Packer](https://www.joyent.com/blog/video-create-images-with-packer)
   + For the Happy Randomizer, there is an alternative JSON file, `thumbsup.json`, which uses only thumbs up GIFs. To create version 1.1 of this image, use that JSON file.
      + Edit `main.js` so that the url is equal to `./resources/thumbsup.json`.
      + Edit the Packer configuration to change the `image_version` to `1.1.0`.
      + Repeat the [instructions for building an image]((https://www.joyent.com/blog/create-images-with-packer))
+ [Infrastructure management with Terraform](https://www.joyent.com/blog/simple-app-with-terraform)
+ [Blue-green deploys with Terraform](https://www.joyent.com/blog/blue-green-deploys-with-terraform)
   + You will need both version 1.0 and 1.1 of the Happy Randomizer
+ [Multi-data center deployment with Terraform](https://www.joyent.com/blog/multiple-data-centers-with-terraform)
   + You will need both version 1.0 and 1.1 of the Happy Randomizer on all of the data centers upon wish you want to deploy the application. 

## Troubleshooting

If you receive an error similar to:

```sh
* provider.triton: Error Creating SSH Agent Signer: No key in the SSH Agent matches fingerprint: <ssh fingerprint>
```

Use `ssh-add` to fix it:

```sh
ssh-add <path to ssh key>
```

## Additional resources

+ [Triton Terraform provider docs](https://github.com/terraform-providers/terraform-provider-triton)
+ [Triton CLI and CloudAPI documentation](https://docs.joyent.com/public-cloud/api-access/cloudapi)
+ Read more tutorials on the [Joyent blog](https://www.joyent.com/blog)
