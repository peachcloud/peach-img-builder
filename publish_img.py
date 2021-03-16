import os
import subprocess
import jinja2
import json
import argparse
from datetime import date


PROJECT_PATH = os.path.dirname(os.path.realpath(__file__))

# load jinja templates
template_path = os.path.join(PROJECT_PATH, 'templates')
template_loader = jinja2.FileSystemLoader(searchpath=template_path)
template_env = jinja2.Environment(loader=template_loader, keep_trailing_newline=True)


def render_template(src, dest, template_vars=None):
    """
    helper function fo rendering jinja template
    :param src: relative string path to jinja template file
    :param dest: absolute string path of output destination file
    :param template_vars: variables to render template with
    :return: None
    """
    template = template_env.get_template(src)
    if not template_vars:
        template_vars= {}
    output_text = template.render(**template_vars)
    if os.path.exists(dest):
        os.remove(dest)
    with open(dest, 'w') as f:
        f.write(output_text)


def build_img(build=True, publish=True):
    """
    if build=True,
        builds a new PeachCloud image,
        compresses the image,
        creates a manifest for what was included in that image
        and a log for the build of the image

    if publish=True
        copies the following files to release dir with the current date
        - log of build
        - compressed img file
        - manifest for that image
        rebuilds releases.peachcloud.org to point to the release

    running with both flags as true is standard usage,
    but building and publishing separately can be useful for testing
    """

    # these are the three files created by the build
    img_path = os.path.join(PROJECT_PATH, 'raspi_3.img')
    log_path = os.path.join(PROJECT_PATH, 'raspi_3.log')
    manifest_path = os.path.join(PROJECT_PATH, 'peach-img-manifest.log')

    # if build=True, then remove old files and re-build
    if build:
        # remove old files
        if os.path.exists(img_path):
            os.remove(img_path)
        if os.path.exists(log_path):
            os.remove(log_path)
        if os.path.exists(manifest_path):
            os.remove(manifest_path)

        # build img
        subprocess.check_call(['make', 'raspi_3.img'])

    if publish:
        # create release dir for this release
        today = date.today()
        today_str = "{}{}{}".format(today.year, today.month, today.day)
        release_dir = "/var/www/releases.peachcloud.org/html/peach-imgs/{}".format(today_str)
        os.makedirs(release_dir)

        # copy image, log and manifest to release dir
        print("++ successful image build, copying output to {}", release_dir)
        img_release_name = "{}_peach_raspi3.img".format(today_str)
        release_log_name = "{}_peach_raspi3.log".format(today_str)
        manifest_name = "{}_peach_manifest.log".format(today_str)
        img_release_path = os.path.join(release_dir, img_release_name)
        log_release_path = os.path.join(release_dir, release_log_name)
        manifest_release_path = os.path.join(release_dir, manifest_name)
        subprocess.check_call(['cp',  img_path, img_release_path])
        subprocess.check_call(['cp',  log_path, log_release_path])
        subprocess.check_call(['cp',  manifest_path, manifest_release_path])

        # rebuild index.html to point to the new release
        release_index_path = "/var/www/releases.peachcloud.org/html/index.html"
        release_img_url = img_path.replace('/var/www/releases.peachcloud.org/html/', '/')
        with open(manifest_path, 'r') as f:
            manifest = json.loads(f.read())
        for k, v in manifest.items():
            print("{}: {}".format(k, v))
        packages = manifest['packages']
        render_template(
            src="release_index.html",
            dest=release_index_path,
            template_vars={
                "release_img_url": release_img_url,
                "release_img_name": img_release_name,
                "packages": packages
            }
        )


if __name__ == '__main__':
    build_img(build=True, publish=True)