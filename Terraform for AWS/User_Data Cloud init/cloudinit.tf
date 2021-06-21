# inside this file we will use the init.cfg file as a template 

data "template_file" "install-apache" {
    template = file("init.cfg") # File name 
}

data "template_cloudinit_config" "install-apache-config" {
    gzip          = false
    base64_encode = false

    part {
        filename     = "init.cfg"  # file name 
        content_type = "text/cloud-config"  # content type 
        content      = data.template_file.install-apache.rendered
    }
}